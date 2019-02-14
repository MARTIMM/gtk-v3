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
unit class GTK::V3::Glib::GObject:auth<github:MARTIMM>;

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

sub g_signal_connect_object_wsd(
  N-GtkWidget $widget, Str $signal, &handler (
    N-GtkWidget, Str, OpaquePointer
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
  N-GtkWidget $widget, OpaquePointer
) is native(&gobject-lib)
  is symbol('g_signal_emit_by_name')
  { * }

sub g_signal_emit_by_name_wwd (
  # first two are obligatory by definition
  N-GtkWidget $instance, Str $detailed_signal,
  # The rest depends on the handler defined when connecting
  # There is no return value from the handler
  N-GtkWidget $widget1, N-GtkWidget $widget2, OpaquePointer
) is native(&gobject-lib)
  is symbol('g_signal_emit_by_name')
  { * }

sub g_signal_handler_disconnect( N-GtkWidget $widget, int32 $handler_id)
  is native(&gobject-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
has N-GtkWidget $!gtk-widget;

#-----------------------------------------------------------------------------
#TODO destroy when overwritten?
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

#note "test-call ", $s.gist;
  test-call( $s, $!gtk-widget, |c)
}

#-------------------------------------------------------------------------------
method fallback ( $native-sub is copy --> Callable ) {

  $native-sub ~~ s:g/ '-' /_/ if $native-sub.index('-');

  my Callable $s;
#note "w s0: $native-sub, ", $s;
  try { $s = &::($native-sub); }
#note "w s1: gtk_widget_$native-sub, ", $s unless ?$s;
#  try { $s = &::("gtk_widget_$native-sub"); } unless ?$s;
#note "w s2: g_signal_$native-sub, ", $s unless ?$s;
  try { $s = &::("g_signal_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s
}

#-------------------------------------------------------------------------------
submethod BUILD ( *%options ) {

  die X::Gui.new(:message('GTK is not initialized'))
      unless $GTK::V3::Gtk::GtkMain::gui-initialized;

note "GO: {self}, ", %options;

  if ? %options<widget> {
    if %options<widget> ~~ N-GtkWidget {
      self.setWidget(%options<widget>);
    }

    else {
      die X::Gui.new(
        :message('Wrong type or undefined widget, must be type N-GtkWidget')
      );
    }
  }
}

#-------------------------------------------------------------------------------
#TODO destroy when overwritten?
method setWidget ( N-GtkWidget $widget, Bool :$force = False ) {
  $!gtk-widget = $widget if ( $force or not ?$!gtk-widget );
note "set widget: ", $!gtk-widget;
}

#-------------------------------------------------------------------------------
method register-signal (
  $handler-object, Str:D $handler-name, Str:D $signal-name,
  Int :$connect-flags = 0, Str :$target-widget-name,
  Str :$handler-type where * ~~ any(<wd wwd wsd>) = 'wd',
  *%user-options
) {

#TODO use a hash to set all handler attributes in one go
#note $handler-object.^methods;

  if ?$handler-object and $handler-object.^can($handler-name) {

    my %options = :widget(self), |%user-options;
    %options<target-widget-name> = $target-widget-name if $target-widget-name;

    if $handler-type eq 'wd' {
note "set $handler-name ($handler-type), options: %user-options";
      self.g-signal-connect-object-wd(
        $signal-name,
        -> $w, $d {
#          if $handler-object.^can($handler-name) {
note "in callback, calling $handler-name ($handler-type), ", $handler-object;
note "widget: ", self;
            $handler-object."$handler-name"( |%options, |%user-options);
#          }
        },
        OpaquePointer, $connect-flags
      );
    }

    elsif $handler-type eq 'wwd' {
      self.g-signal-connect-object-wwd(
        $signal-name,
        -> $w1, $w2, $d {
#          if $handler-object.^can($handler-name) {
#note "in callback, calling $handler-name ($handler-type), ", $handler-object;
            $handler-object."$handler-name"(
             :widget2($w2), |%options, |%user-options
            );
#          }
        },
        OpaquePointer, $connect-flags
      );
    }

    else {
      self.g-signal-connect-object-wsd(
        $signal-name,
        -> $w, $s, $d {
#          if $handler-object.^can($handler-name) {
#note "in callback, calling $handler-name ($handler-type), ", $handler-object;
            $handler-object."$handler-name"(
             :string($s), |%options, |%user-options
            );
#          }
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