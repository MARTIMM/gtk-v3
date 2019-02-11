use v6;
use NativeCall;

use GTK::V3::X;
use GTK::V3::N::NativeLib;
use GTK::V3::Gtk::GtkButton;
use GTK::V3::Gtk::GtkWidget;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtktogglebutton.h
# https://developer.gnome.org/gtk3/stable/GtkToggleButton.html
unit class GTK::V3::Gtk::GtkToggleButton:auth<github:MARTIMM>
  is GTK::V3::Gtk::GtkButton;

#-------------------------------------------------------------------------------
sub gtk_toggle_button_new_with_label ( Str $label )
    returns N-GtkWidget
    is native(&gtk-lib)
    is export
    { * }

sub gtk_toggle_button_get_active ( N-GtkWidget $w )
    returns int32
    is native(&gtk-lib)
    is export
    { * }

sub gtk_toggle_button_set_active ( N-GtkWidget $w, int32 $active )
    returns int32
    is native(&gtk-lib)
    is export
    { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
submethod BUILD ( Str :$text = '' ) {

  #$!gtk-widget = gtk_label_new($text) unless ?$!gtk-widget;
  self.setWidget(gtk_toggle_button_new_with_label($text));
}

#-------------------------------------------------------------------------------
method fallback ( $native-sub is copy --> Callable ) {

  $native-sub ~~ s:g/ '-' /_/ if $native-sub.index('-');

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_toggle_button_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s;
}
