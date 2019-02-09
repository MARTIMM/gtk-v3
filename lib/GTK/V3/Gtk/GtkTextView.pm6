use v6;
use NativeCall;

use GTK::V3::X;
use GTK::V3::N::NativeLib;
use GTK::V3::Gtk::GtkWidget;
use GTK::V3::Gtk::GtkContainer;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtktextview.h
# https://developer.gnome.org/gtk3/stable/GtkTextView.html
unit class GTK::V3::Gtk::GtkTextView:auth<github:MARTIMM>
  is GTK::V3::Gtk::GtkContainer;

#-------------------------------------------------------------------------------
sub gtk_text_view_new()
  is native(&gtk-lib)
  is export(:text-view)
  returns N-GtkWidget
  { * }

sub gtk_text_view_get_buffer ( N-GtkWidget $view )
  is native(&gtk-lib)
  is export(:text-view)
  returns OpaquePointer
  { * }

sub gtk_text_view_set_editable(N-GtkWidget $widget, int32 $setting)
  is native(&gtk-lib)
  is export
  { * }

sub gtk_text_view_get_editable(N-GtkWidget $widget)
  is native(&gtk-lib)
  is export
  returns int32
  { * }

sub gtk_text_view_set_cursor_visible(N-GtkWidget $widget, int32 $setting)
  is native(&gtk-lib)
  is export
  { * }

sub gtk_text_view_get_cursor_visible(N-GtkWidget $widget)
  is native(&gtk-lib)
  is export
  returns int32
  { * }

sub gtk_text_view_get_monospace(N-GtkWidget $widget)
  is native(&gtk-lib)
  is export
  returns int32
  { * }

sub gtk_text_view_set_monospace(N-GtkWidget $widget, int32 $setting)
  is native(&gtk-lib)
  is export
  { * }

#-------------------------------------------------------------------------------
method fallback ( $native-sub is copy --> Callable ) {

  $native-sub ~~ s:g/ '-' /_/ if $native-sub.index('-');

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_text_view_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s;
}