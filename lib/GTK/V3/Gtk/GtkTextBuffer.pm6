use v6;
use NativeCall;

use GTK::V3::X;
use GTK::V3::N::NativeLib;
use GTK::V3::Glib::GObject;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtktextbuffer.h
# https://developer.gnome.org/gtk3/stable/GtkTextBuffer.html
unit class GTK::V3::Gtk::GtkTextBuffer:auth<github:MARTIMM>
  is GTK::V3::Glib::GObject;

#-------------------------------------------------------------------------------
#class N-GtkTextBuffer
#  is repr('CPointer')
#  is export
#  { }

#-------------------------------------------------------------------------------
sub gtk_text_buffer_get_text (
  OpaquePointer $buffer, CArray[int32] $start,
  CArray[int32] $end, int32 $show_hidden
) is native(&gtk-lib)
  returns Str
  { * }

sub gtk_text_buffer_get_start_iter ( OpaquePointer $buffer, CArray[int32] $i )
  is native(&gtk-lib)
  { * }

sub gtk_text_buffer_get_end_iter(OpaquePointer $buffer, CArray[int32] $i)
  is native(&gtk-lib)
  { * }

sub gtk_text_buffer_set_text(OpaquePointer $buffer, Str $text, int32 $len)
  is native(&gtk-lib)
  { * }

sub gtk_text_buffer_insert(
  OpaquePointer $buffer, CArray[int32] $start,
  Str $text, int32 $len
) is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
has OpaquePointer $!gtk-text-buffer;

#-------------------------------------------------------------------------------
#submethod BUILD ( ) {
#  $!gtk-text-buffer = ...
#}

#-------------------------------------------------------------------------------
method CALL-ME ( OpaquePointer $text-buffer? --> OpaquePointer ) {
  $!gtk-text-buffer = $text-buffer if ?$text-buffer;
  $!gtk-text-buffer
}

#-------------------------------------------------------------------------------
method FALLBACK ( $native-sub is copy, |c ) {

  $native-sub ~~ s:g/ '-' /_/ if $native-sub.index('-');

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_text_buffer_$native-sub"); } unless ?$s;

  CATCH { test-catch-exception( $_, $native-sub); }

  &$s( $!gtk-text-buffer, |c)
}
