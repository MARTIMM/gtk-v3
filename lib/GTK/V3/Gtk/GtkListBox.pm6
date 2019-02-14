use v6;
use NativeCall;

use GTK::V3::X;
use GTK::V3::N::NativeLib;
use GTK::V3::Glib::GObject;
use GTK::V3::Gtk::GtkContainer;
#use GTK::V3::Gtk::GtkWidget;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtklistbox.h
# https://developer.gnome.org/gtk3/stable/GtkListBox.html
unit class GTK::V3::Gtk::GtkListBox:auth<github:MARTIMM>
  is GTK::V3::Gtk::GtkContainer;

#-------------------------------------------------------------------------------
sub gtk_list_box_insert ( N-GtkWidget $box, N-GtkWidget $child, int32 $position)
    is native(&gtk-lib)
    { * }

# The widget in the argument list is a GtkListBox
# returned widget is a GtkListBoxRow
sub gtk_list_box_get_row_at_index ( N-GtkWidget $box, int32 $index)
    returns N-GtkWidget
    is native(&gtk-lib)
    { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
#submethod BUILD ( ) {
#  self.setWidget(gtk_entry_new);
#}

#-------------------------------------------------------------------------------
method fallback ( $native-sub is copy --> Callable ) {

  $native-sub ~~ s:g/ '-' /_/ if $native-sub.index('-');

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_list_box_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s;
}
