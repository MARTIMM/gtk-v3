use v6;
use NativeCall;

use GTK::V3::N::NativeLib;
use GTK::V3::Glib::GObject;
#use GTK::V3::Gtk::GtkWidget;
use GTK::V3::Gtk::GtkBin;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkbutton.h
# https://developer.gnome.org/gtk3/stable/GtkButton.html
unit class GTK::V3::Gtk::GtkButton:auth<github:MARTIMM>
  is GTK::V3::Gtk::GtkBin;

#-------------------------------------------------------------------------------
sub gtk_button_get_label ( N-GtkWidget $widget )
  returns Str
  is native(&gtk-lib)
  { * }

sub gtk_button_new ( )
  returns N-GtkWidget
  is native(&gtk-lib)
  { * }

sub gtk_button_new_with_label ( Str $label )
  returns N-GtkWidget
  is native(&gtk-lib)
  { * }

sub gtk_button_set_label ( N-GtkWidget $widget, Str $label )
  is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  return unless self.^name eq 'GTK::V3::Gtk::GtkButton';
note "B: ", %options;

  if ? %options<text> {
    self.setWidget(gtk_button_new_with_label(%options<text>));
  }

  else {
    self.setWidget(gtk_button_new());
  }
}

#-------------------------------------------------------------------------------
method fallback ( $native-sub is copy --> Callable ) {

  $native-sub ~~ s:g/ '-' /_/ if $native-sub.index('-');

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_button_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s
}
