use v6;
use NativeCall;

use GTK::V3::X;
use GTK::V3::N::NativeLib;
use GTK::V3::Gtk::GtkToggleButton;
use GTK::V3::Gtk::GtkWidget;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkcheckbutton.h
# https://developer.gnome.org/gtk3/stable/GtkCheckButton.html
unit class GTK::V3::Gtk::GtkCheckButton:auth<github:MARTIMM>
  is GTK::V3::Gtk::GtkToggleButton;

#-------------------------------------------------------------------------------
sub gtk_check_button_new_with_label ( Str $label )
  returns N-GtkWidget
  is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
submethod BUILD ( Str :$text = '' ) {

  #$!gtk-widget = gtk_label_new($text) unless ?$!gtk-widget;
  self.setWidget(gtk_check_button_new_with_label($text));
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
