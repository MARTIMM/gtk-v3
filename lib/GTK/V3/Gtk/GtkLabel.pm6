use v6;
use NativeCall;

use GTK::V3::Gui;
use GTK::V3::N::NativeLib;
use GTK::V3::Gtk::GtkMain;
use GTK::V3::Gtk::GtkWidget;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtklabel.h
# https://developer.gnome.org/gtk3/stable/GtkLabel.html
unit class GTK::V3::Gtk::GtkLabel:auth<github:MARTIMM>
  is GTK::V3::Gtk::GtkWidget
  does GTK::V3::Gui;

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

  die X::Gui.new(:message('GTK is not initialized'))
      unless $GTK::V3::Gtk::GtkMain::gui-initialized;

  $!gtk-widget = gtk_label_new($text);
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
