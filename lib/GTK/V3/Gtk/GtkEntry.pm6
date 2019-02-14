use v6;
use NativeCall;

use GTK::V3::X;
use GTK::V3::N::NativeLib;
use GTK::V3::Glib::GObject;
#use GTK::V3::Gtk::GtkWidget;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkentry.h
# https://developer.gnome.org/gtk3/stable/GtkEntry.html
unit class GTK::V3::Gtk::GtkEntry:auth<github:MARTIMM>
  is GTK::V3::Gtk::GtkWidget;

#-------------------------------------------------------------------------------
sub gtk_entry_new ( )
  returns N-GtkWidget
  is native(&gtk-lib)
  { * }

sub gtk_entry_get_text ( N-GtkWidget $entry )
  returns Str
  is native(&gtk-lib)
  { * }

sub gtk_entry_set_text ( N-GtkWidget $entry, Str $text )
  is native(&gtk-lib)
  { * }

sub gtk_entry_set_visibility ( N-GtkWidget $entry, Bool $visible )
  is native(&gtk-lib)
  { * }

# hints is an enum with type GtkInputHints -> int
# The values are defined in Enums.pm6
sub gtk_entry_set_input_hints ( N-GtkWidget $entry, uint32 $hints )
  is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
submethod BUILD ( ) {
  self.setWidget(gtk_entry_new);
}

#-------------------------------------------------------------------------------
method fallback ( $native-sub is copy --> Callable ) {

  $native-sub ~~ s:g/ '-' /_/ if $native-sub.index('-');

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_entry_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s;
}
