use v6;
use NativeCall;

use GTK::V3::X;
use GTK::V3::N::NativeLib;
use GTK::V3::Glib::GObject;
use GTK::V3::Gtk::GtkMain;
#use GTK::V3::Gtk::GtkWidget;
use GTK::V3::Gtk::GtkContainer;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtklabel.h
# https://developer.gnome.org/gtk3/stable/GtkGrid.html
unit class GTK::V3::Gtk::GtkGrid:auth<github:MARTIMM>
  is GTK::V3::Gtk::GtkContainer;

#-------------------------------------------------------------------------------
sub gtk_grid_new()
  returns N-GObject
  is native(&gtk-lib)
  is export
  { * }

sub gtk_grid_attach ( N-GObject $grid, N-GObject $child, int32 $x, int32 $y,
  int32 $w, int32 $h
) is native(&gtk-lib)
  is export
  { * }

sub gtk_grid_insert_row ( N-GObject $grid, int32 $position)
  is native(&gtk-lib)
  is export
  { * }

sub gtk_grid_insert_column ( N-GObject $grid, int32 $position)
  is native(&gtk-lib)
  is export
  { * }

sub gtk_grid_get_child_at ( N-GObject $grid, uint32 $left, uint32 $top)
  returns N-GObject
  is native(&gtk-lib)
  is export
  { * }

sub gtk_grid_set_row_spacing ( N-GObject $grid, uint32 $spacing)
  is native(&gtk-lib)
  is export
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
submethod BUILD ( ) {

  self.setWidget(gtk_grid_new);
}

#-------------------------------------------------------------------------------
method fallback ( $native-sub is copy --> Callable ) {

  $native-sub ~~ s:g/ '-' /_/ if $native-sub.index('-');

  my Callable $s;

  try { $s = &::($native-sub); }
  try { $s = &::("gtk_grid_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s
}
