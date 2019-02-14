use v6;
use NativeCall;

use GTK::V3::X;
use GTK::V3::N::NativeLib;
use GTK::V3::Glib::GObject;
use GTK::V3::Gtk::GtkToggleButton;
#use GTK::V3::Gtk::GtkWidget;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkcheckbutton.h
# https://developer.gnome.org/gtk3/stable/GtkCheckButton.html
unit class GTK::V3::Gtk::GtkCheckButton:auth<github:MARTIMM>
  is GTK::V3::Gtk::GtkToggleButton;

#-------------------------------------------------------------------------------
sub gtk_check_button_new ( )
  returns N-GtkWidget
  is native(&gtk-lib)
  { * }

sub gtk_check_button_new_with_label ( Str $label )
  returns N-GtkWidget
  is native(&gtk-lib)
  { * }

sub gtk_check_button_new_with_mnemonic ( Str $label )
  returns N-GtkWidget
  is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
#submethod BUILD ( Str :$text = '' ) {
submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  return unless self.^name eq 'GTK::V3::Gtk::GtkCheckButton';
note "CB: ", %options;
#  self.setWidget(gtk_check_button_new_with_label($text));
#note "CB: '$text'";

  if ? %options<text> {
    self.setWidget(gtk_check_button_new_with_label(%options<text>));
  }

  else {
    self.setWidget(gtk_check_button_new());
  }
}

#-------------------------------------------------------------------------------
method fallback ( $native-sub is copy --> Callable ) {

  $native-sub ~~ s:g/ '-' /_/ if $native-sub.index('-');

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_check_button_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s;
}
