use v6;
use NativeCall;

#use GTK::V3::Gui;
use GTK::V3::X;
use GTK::V3::N::NativeLib;
#use GTK::V3::Glib::GSignal;
use GTK::V3::Gtk::GtkMain;
use GTK::V3::Gdk::GdkScreen;
use GTK::V3::Gdk::GdkDisplay;
use GTK::V3::Gdk::GdkWindow;

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
unit class GTK::V3::Gtk::GtkWidget:auth<github:MARTIMM>
;#  is GTK::V3::Glib::GSignal
;#  does GTK::V3::Gui;

#-------------------------------------------------------------------------------
class N-GtkWidget
  is repr('CPointer')
  is export
  { }

#-------------------------------------------------------------------------------
enum GConnectFlags is export (
  G_CONNECT_AFTER	        => 1,
  G_CONNECT_SWAPPED	      => 1 +< 1
);

#-------------------------------------------------------------------------------
# GSignal
# Helper subs using the native calls
#
#`{{
# original handler signature:
#   &handler ( N-GtkWidget $h_widget, OpaquePointer $h_data )
# widget is inserted when second call to method is made and data is only
# definable as an OpaquePointer so it can not give any data. This is also
# inserted in second call. See GtkWidget.
sub g_signal_connect_wd (
  N-GtkWidget $widget, Str $signal,
  &handler ( N-GtkWidget, OpaquePointer ), OpaquePointer
) {
  g_signal_connect_data_wd(
    $widget, $signal, &handler, OpaquePointer, Any, 0
  );
}

sub g_signal_connect_after_wd (
  N-GtkWidget $widget, Str $signal,
  &handler ( N-GtkWidget, OpaquePointer ), OpaquePointer
) {
  g_signal_connect_data_wd(
    $widget, $signal, &handler, OpaquePointer, Any, G_CONNECT_AFTER
  );
}

sub g_signal_connect_swapped_wd (
  N-GtkWidget $widget, Str $signal,
  &handler ( N-GtkWidget, OpaquePointer ), OpaquePointer
) {
  g_signal_connect_data_wd(
    $widget, $signal, &handler, OpaquePointer, Any, G_CONNECT_SWAPPED
  );
}

#-------------------------------------------------------------------------------
# safe in threaded programs
sub g_signal_connect_data_wd(
  N-GtkWidget $widget, Str $signal,
  &handler ( N-GtkWidget, OpaquePointer ), OpaquePointer $data,
  OpaquePointer $destroy_data, int32 $connect_flags
) returns int32
  is native(&gobject-lib)
  { * }

sub g_signal_connect_data_wwd(
  N-GtkWidget $widget, Str $signal,
  &handler ( N-GtkWidget, N-GtkWidget, OpaquePointer ), OpaquePointer $data,
  OpaquePointer $destroy_data, int32 $connect_flags
) returns int32
  is native(&gobject-lib)
  { * }
}}

# unsafe in threaded programs
#sub g_signal_connect_object(
#  N-GtkWidget $widget, Str $signal, &handler ( N-GtkWidget, OpaquePointer ),
#  OpaquePointer, int32 $connect_flags
#) returns uint32
#  is native(&gobject-lib)
#  { * }

# unsafe in threaded programs
sub g_signal_connect_object_wd(
  N-GtkWidget $widget, Str $signal, &handler ( N-GtkWidget, OpaquePointer ),
  OpaquePointer $data, int32 $connect_flags
) returns uint32
  is native(&gobject-lib)
  is symbol('g_signal_connect_object')
  { * }

sub g_signal_connect_object_wwd(
  N-GtkWidget $widget, Str $signal, &handler (
    N-GtkWidget, N-GtkWidget, OpaquePointer
  ),
  OpaquePointer, int32 $connect_flags
) returns uint32
  is native(&gobject-lib)
  is symbol('g_signal_connect_object')
  { * }

#`{{
# a GQuark is a guint32, $detail is a quark
# See https://developer.gnome.org/glib/stable/glib-Quarks.html
sub g_signal_emit (
  N-GtkWidget $instance, uint32 $signal_id, uint32 $detail,
  N-GtkWidget $widget, Str $data, Str $return-value is rw
) is native(&gobject-lib)
  { * }
}}

# Handlers above provided to the signal connect calls are having 2 arguments
# a widget and data. So the provided extra arguments are then those 2
# plus a return value
sub g_signal_emit_by_name_wd (
  # first two are obligatory by definition
  N-GtkWidget $instance, Str $detailed_signal,
  # The rest depends on the handler defined when connecting
  # There is no return value from the handler
  N-GtkWidget $widget, Str $data
) is native(&gobject-lib)
  is symbol('g_signal_emit_by_name')
  { * }

sub g_signal_emit_by_name_wwd (
  # first two are obligatory by definition
  N-GtkWidget $instance, Str $detailed_signal,
  # The rest depends on the handler defined when connecting
  # There is no return value from the handler
  N-GtkWidget $widget1, N-GtkWidget $widget2, Str $data
) is native(&gobject-lib)
  is symbol('g_signal_emit_by_name')
  { * }

sub g_signal_handler_disconnect( N-GtkWidget $widget, int32 $handler_id)
  is native(&gobject-lib)
  { * }

#-------------------------------------------------------------------------------
# GtkWidget
sub gtk_widget_get_display ( N-GtkWidget $widget )
  returns N-GdkDisplay
  is native(&gtk-lib)
  { * }

sub gtk_widget_get_no_show_all ( N-GtkWidget $widgetw )
  returns int32
  is native(&gtk-lib)
  { * }

sub gtk_widget_get_visible ( N-GtkWidget $widget )
  returns int32       # Bool 1=true
  is native(&gtk-lib)
  { * }

sub gtk_widget_hide ( N-GtkWidget $widgetw )
  is native(&gtk-lib)
  { * }

sub gtk_widget_set_no_show_all ( N-GtkWidget $widgetw, int32 $no_show_all )
  is native(&gtk-lib)
  { * }

sub gtk_widget_show ( N-GtkWidget $widgetw )
  is native(&gtk-lib)
  { * }

sub gtk_widget_show_all ( N-GtkWidget $widgetw )
  is native(&gtk-lib)
  { * }

sub gtk_widget_destroy ( N-GtkWidget $widget )
  is native(&gtk-lib)
  { * }

sub gtk_widget_set_sensitive ( N-GtkWidget $widget, int32 $sensitive )
  is native(&gtk-lib)
  { * }

sub gtk_widget_get_sensitive ( N-GtkWidget $widget )
  returns int32
  is native(&gtk-lib)
  { * }

sub gtk_widget_set_size_request ( N-GtkWidget $widget, int32 $w, int32 $h )
  is native(&gtk-lib)
  { * }

sub gtk_widget_get_allocated_height ( N-GtkWidget $widget )
  returns int32
  is native(&gtk-lib)
  { * }

sub gtk_widget_get_allocated_width ( N-GtkWidget $widget )
  returns int32
  is native(&gtk-lib)
  { * }

sub gtk_widget_queue_draw ( N-GtkWidget $widget )
  is native(&gtk-lib)
  { * }

sub gtk_widget_get_tooltip_text ( N-GtkWidget $widget )
  returns Str
  is native(&gtk-lib)
  { * }

sub gtk_widget_set_tooltip_text ( N-GtkWidget $widget, Str $text )
  is native(&gtk-lib)
  { * }

# void gtk_widget_set_name ( N-GtkWidget *widget, const gchar *name );
sub gtk_widget_set_name ( N-GtkWidget $widget, Str $name )
  is native(&gtk-lib)
  { * }

# const gchar *gtk_widget_get_name ( N-GtkWidget *widget );
sub gtk_widget_get_name ( N-GtkWidget $widget )
  returns Str
  is native(&gtk-lib)
  { * }

sub gtk_widget_get_window ( N-GtkWidget $widget )
  returns N-GdkWindow
  is native(&gtk-lib)
  { * }

sub gtk_widget_set_visible ( N-GtkWidget $widget, Bool $visible)
  is native(&gtk-lib)
  { * }

sub gtk_widget_get_has_window ( N-GtkWidget $window )
  returns Bool
  is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
has N-GtkWidget $!gtk-widget;

#-----------------------------------------------------------------------------
method CALL-ME ( N-GtkWidget $widget? --> N-GtkWidget ) {

  if ?$widget {
    #if GdkWindow::GDK_WINDOW_TOPLEVEL
    #$!gtk-widget = N-GtkWidget;
    $!gtk-widget = $widget;
  }

  $!gtk-widget
}

#-----------------------------------------------------------------------------
# Fallback method to find the native subs which then can be called as if it
# were a method. Each class must provide their own 'fallback' method which,
# when nothing found, must call the parents fallback with 'callsame'.
# The subs in some class all start with some prefix which can be left out too
# provided that the fallback functions must also test with an added prefix.
# So e.g. a sub 'gtk_label_get_text' defined in class GtlLabel can be called
# like '$label.gtk_label_get_text()' or '$label.get_text()'. As an extra
# feature dashes can be used instead of underscores, so '$label.get-text()'
# works too.
method FALLBACK ( $native-sub, |c ) {

  CATCH { test-catch-exception( $_, $native-sub); }

  # call the fallback functions of the role user
  my Callable $s = self.fallback($native-sub);

note "test-call ", $s.gist;
  test-call( $s, $!gtk-widget, |c)
}

#-------------------------------------------------------------------------------
method fallback ( $native-sub is copy --> Callable ) {

  $native-sub ~~ s:g/ '-' /_/ if $native-sub.index('-');

  my Callable $s;
note "w s0: $native-sub, ", $s;
  try { $s = &::($native-sub); }
note "w s1: gtk_widget_$native-sub, ", $s unless ?$s;
  try { $s = &::("gtk_widget_$native-sub"); } unless ?$s;
note "w s2: g_signal_$native-sub, ", $s unless ?$s;
  try { $s = &::("g_signal_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s
}

#-------------------------------------------------------------------------------
submethod BUILD ( |c ) {

  die X::Gui.new(:message('GTK is not initialized'))
      unless $GTK::V3::Gtk::GtkMain::gui-initialized;

  for c.kv -> $k, $v {
    if $k eq 'widget' {
#note "KV: {$k//'-'}, {$v//'-'}";
      if ?$v and $v ~~ N-GtkWidget {
        self.setWidget($v);
      }

      else {
        die X::Gui.new(
          :message('Wrong type or undefined widget, must be type N-GtkWidget')
        );
      }

      last;
    }
  }
}

#-------------------------------------------------------------------------------
method setWidget ( N-GtkWidget $widget, Bool :$force = False ) {
  $!gtk-widget = $widget if ( $force or not ?$!gtk-widget );
}

#-------------------------------------------------------------------------------
method register-signal (
  $handler-object, Str $handler-name, $data, Int $connect-flags = 0,
  Str :$target-widget-name, Str :$handler-type where * ~~ any(<wd wwd>) = 'wd'
) {

  if ?$handler-object and $handler-object.^can($handler-name) {
    if $handler-type eq 'wd' {
      self.g-signal-connect-object-wd(
        'clicked',
        -> $w, $d {
          if $handler-object.^can($handler-name) {
note "in callback, calling $handler-name ($handler-type)";
            $handler-object."$handler-name"(
              :widget($w), :$data, :$target-widget-name
            );
          }
        },
        OpaquePointer, $connect-flags
      );
    }

    else {
      self.g-signal-connect-object-wwd(
        'clicked',
        -> $w1, $w2, $d {
          if $handler-object.^can($handler-name) {
note "in callback, calling $handler-name ($handler-type)";
            $handler-object."$handler-name"(
              :widget1($w1), :widget2($w2), :$data, :$target-widget-name
            );
          }
        },
        OpaquePointer, $connect-flags
      );
    }
  }

  elsif ?$handler-object {
    #note "Handler $handler-name on $id object using $signal-name event not defined";
    note "Handler $handler-name not defined in {$handler-object.^name}";
  }

  else {
    note "Handler object is not defined";
#    self.connect-object( 'clicked', $handler, OpaquePointer, $connect_flags);
  }
}
