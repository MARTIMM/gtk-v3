use v6;
use NativeCall;

use GTK::V3::X;
use GTK::V3::N::NativeLib;
use GTK::V3::Glib::GObject;
use GTK::V3::Gtk::GtkMenuItem;
#use GTK::V3::Gtk::GtkWidget;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkimagemenuitem.h
# https://developer.gnome.org/gtk3/stable/GtkImageMenuItem.html
unit class GTK::V3::Gtk::GtkImageMenuItem:auth<github:MARTIMM>
  is GTK::V3::Gtk::GtkMenuItem;

#-------------------------------------------------------------------------------
sub gtk_image_menu_item_new ( )
  returns N-GObject
  is native(&gtk-lib)
  { * }


# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
submethod BUILD ( ) {
  self.setWidget(gtk_image_menu_item_new());
}

#-------------------------------------------------------------------------------
method fallback ( $native-sub is copy --> Callable ) {

  $native-sub ~~ s:g/ '-' /_/ if $native-sub.index('-');

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_image_menu_item_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s;
}
