use v6;
use NativeCall;

use GTK::V3::X;
use GTK::V3::N::NativeLib;
use GTK::V3::Glib::GObject;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gdk/gdkwindow.h
unit class GTK::V3::Gdk::GdkWindow:auth<github:MARTIMM>
  is GTK::V3::Glib::GObject;

#-------------------------------------------------------------------------------
#class N-GtkWidget
#  is repr('CPointer')
#  is export
#  { }

#-------------------------------------------------------------------------------
enum GdkWindowType <
  GDK_WINDOW_ROOT
  GDK_WINDOW_TOPLEVEL
  GDK_WINDOW_CHILD
  GDK_WINDOW_TEMP
  GDK_WINDOW_FOREIGN
  GDK_WINDOW_OFFSCREEN
  GDK_WINDOW_SUBSURFACE
>;

#-------------------------------------------------------------------------------
sub gdk_window_get_origin (
  N-GtkWidget $window, int32 $x is rw, int32 $y is rw
  ) returns int32
    is native(&gdk-lib)
    is export
    { * }

sub gdk_window_destroy ( N-GtkWidget $window )
  is native(&gdk-lib)
  is export
  { * }

sub gdk_window_get_window_type ( N-GtkWidget $window )
  returns int32 #GdkWindowType
  is native(&gdk-lib)
  is export
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
#has N-GtkWidget $!gdk-window;

#-------------------------------------------------------------------------------
#submethod BUILD ( GTK::V3::Gdk::GdkWindow :$parent ) {
#  $!gdk-window = $parent() if ?$parent;
#}
#`{{
#-------------------------------------------------------------------------------
submethod DESTROY ( ) {

  if ?$!gdk-window {
    gdk_window_destroy($!gdk-window);
    $!gdk-window = N-GtkWidget;
  }
}


#-------------------------------------------------------------------------------
method CALL-ME ( --> N-GtkWidget ) {
  $!gdk-window
}

#-------------------------------------------------------------------------------
method FALLBACK ( $native-sub is copy, |c ) {

  $native-sub ~~ s:g/ '-' /_/ if $native-sub.index('-');

  my Callable $s;
  try { $s = &::($native-sub); }

  CATCH { test-catch-exception( $_, $native-sub); }

  test-call( $s, $!gdk-window, |c)
}
}}

#-------------------------------------------------------------------------------
method fallback ( $native-sub is copy --> Callable ) {

  $native-sub ~~ s:g/ '-' /_/ if $native-sub.index('-');

  my Callable $s;
#note "w s0: $native-sub, ", $s;
  try { $s = &::($native-sub); }
#note "w s1: gtk_widget_$native-sub, ", $s unless ?$s;
  try { $s = &::("gdk_window_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s
}
