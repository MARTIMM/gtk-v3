use v6;
use NativeCall;

use GTK::V3::X;
use GTK::V3::N::NativeLib;
use GTK::V3::Glib::GObject;
use GTK::V3::Gdk::GdkScreen;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gdk/gdkscreen.h
unit class GTK::V3::Gdk::GdkDisplay:auth<github:MARTIMM>
  is GTK::V3::Glib::GObject;

#-------------------------------------------------------------------------------
#class N-GdkDisplay
#  is repr('CPointer')
#  is export
#  { }

#-------------------------------------------------------------------------------
sub gdk_display_warp_pointer (
  N-GtkWidget $display, N-GtkWidget $screen, int32 $x, int32 $y
) is native(&gdk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
#`{{
has N-GdkDisplay $!gdk-display;

#-------------------------------------------------------------------------------
submethod BUILD (  ) {
  $!gdk-display;
}

#-------------------------------------------------------------------------------
method CALL-ME ( --> N-GdkDisplay ) {
  $!gdk-display
}

#-------------------------------------------------------------------------------
method FALLBACK ( $native-sub is copy, |c ) {

  $native-sub ~~ s:g/ '-' /_/ if $native-sub.index('-');

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gdk_display_$native-sub"); } unless ?$s;

  CATCH { test-catch-exception( $_, $native-sub); }

  test-call( $s, $!gdk-display, |c)
}
}}

#-------------------------------------------------------------------------------
method fallback ( $native-sub is copy --> Callable ) {

  $native-sub ~~ s:g/ '-' /_/ if $native-sub.index('-');

  my Callable $s;
#note "w s0: $native-sub, ", $s;
  try { $s = &::($native-sub); }
#note "w s1: gtk_widget_$native-sub, ", $s unless ?$s;
  try { $s = &::("gdk_display_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s
}
