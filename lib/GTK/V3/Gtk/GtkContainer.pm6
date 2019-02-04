use v6;
use NativeCall;

use GTK::V3::Gui;
use GTK::V3::N::NativeLib;
use GTK::V3::Glib::GList;
use GTK::V3::Gtk::GtkMain;
use GTK::V3::Gtk::GtkWidget;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkcontainer.h
# https://developer.gnome.org/gtk3/stable/GtkContainer.html
unit class GTK::V3::Gtk::GtkContainer:auth<github:MARTIMM>
  is GTK::V3::Gtk::GtkWidget
  does GTK::V3::Gui;

#-------------------------------------------------------------------------------
sub gtk_container_add ( N-GtkWidget $container, N-GtkWidget $widget )
  is native(&gtk-lib)
  { * }

sub gtk_container_get_border_width ( N-GtkWidget $container )
  returns int32
  is native(&gtk-lib)
  { * }

sub gtk_container_get_children ( N-GtkWidget $container )
  returns N-GList
  is native(&gtk-lib)
  { * }

sub gtk_container_set_border_width (
  N-GtkWidget $container, int32 $border_width
) is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
method fallback ( $native-sub is copy --> Callable ) {

  $native-sub ~~ s:g/ '-' /_/ if $native-sub.index('-');

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_container_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s
}

#-------------------------------------------------------------------------------
submethod BUILD ( N-GtkWidget $widget ) {

  die X::Gui.new(:message('GTK is not initialized'))
      unless $GTK::V3::Gtk::GtkMain::gui-initialized;

  $!gtk-widget = $widget;
}
