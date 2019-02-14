use v6;
use NativeCall;

use GTK::V3::N::NativeLib;
use GTK::V3::Glib::GObject;
use GTK::V3::Gtk::GtkMain;
use GTK::V3::Gtk::GtkWidget;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtklabel.h
# https://developer.gnome.org/gtk3/stable/GtkLabel.html
unit class GTK::V3::Gtk::GtkLabel:auth<github:MARTIMM>
  is GTK::V3::Gtk::GtkWidget;

#-------------------------------------------------------------------------------
sub gtk_label_new ( Str $text )
  returns N-GtkWidget
  is native(&gtk-lib)
  { * }

sub gtk_label_get_text ( N-GtkWidget $label )
  returns Str
  is native(&gtk-lib)
  { * }

sub gtk_label_set_text ( N-GtkWidget $label, Str $str )
  is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
submethod BUILD ( Str :$text = '' ) {

  #$!gtk-widget = gtk_label_new($text) unless ?$!gtk-widget;
  self.setWidget(gtk_label_new($text));
}

#-------------------------------------------------------------------------------
method fallback ( $native-sub is copy --> Callable ) {

  $native-sub ~~ s:g/ '-' /_/ if $native-sub.index('-');

  my Callable $s;

  try { $s = &::($native-sub); }
  try { $s = &::("gtk_label_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s
}
