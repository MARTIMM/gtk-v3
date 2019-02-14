use v6;
use NativeCall;

use GTK::V3::X;
use GTK::V3::Glib::GObject;
use GTK::V3::N::NativeLib;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gdk/gdkscreen.h
unit class GTK::V3::Gdk::GdkScreen:auth<github:MARTIMM>
  is GTK::V3::Glib::GObject;

#`{{
#-------------------------------------------------------------------------------
class N-GObject
  is repr('CPointer')
  is export
  { }
}}
#-------------------------------------------------------------------------------
sub gdk_screen_get_default ( )
  returns N-GObject
  is native(&gdk-lib)
#    is export
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
#has N-GObject $!gdk-screen;

#-------------------------------------------------------------------------------
submethod BUILD (  ) {
  self.setWidget(gdk_screen_get_default());
}

#`{{
#-------------------------------------------------------------------------------
method CALL-ME ( --> N-GObject ) {
  $!gdk-screen
}

#-------------------------------------------------------------------------------
method FALLBACK ( $native-sub is copy, |c ) {

  $native-sub ~~ s:g/ '-' /_/ if $native-sub.index('-');

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gdk_screen_$native-sub"); } unless ?$s;

  CATCH { test-catch-exception( $_, $native-sub); }

  &$s( $!gdk-screen, |c)
}
}}

#-------------------------------------------------------------------------------
method fallback ( $native-sub is copy --> Callable ) {

  $native-sub ~~ s:g/ '-' /_/ if $native-sub.index('-');

  my Callable $s;
#note "w s0: $native-sub, ", $s;
  try { $s = &::($native-sub); }
#note "w s1: gtk_widget_$native-sub, ", $s unless ?$s;
  try { $s = &::("gdk_screen_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s
}
