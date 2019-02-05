use v6;
use NativeCall;

use GTK::V3::X;
use GTK::V3::Gui;
use GTK::V3::N::NativeLib;
use GTK::V3::Gtk::GtkMain;
use GTK::V3::Gtk::GtkWidget;
use GTK::V3::Gtk::GtkContainer;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtklabel.h
# https://developer.gnome.org/gtk3/stable/GtkGrid.html
unit class GTK::V3::Gtk::GtkGrid:auth<github:MARTIMM>
  is GTK::V3::Gtk::GtkContainer
  does GTK::V3::Gui;

#-------------------------------------------------------------------------------
sub gtk_grid_new()
  returns N-GtkWidget
  is native(&gtk-lib)
  is export
  { * }

sub gtk_grid_attach ( N-GtkWidget $grid, N-GtkWidget $child, int32 $x, int32 $y,
  int32 $w, int32 $h
) is native(&gtk-lib)
  is export
  { * }

sub gtk_grid_insert_row ( N-GtkWidget $grid, int32 $position)
  is native(&gtk-lib)
  is export
  { * }

sub gtk_grid_insert_column ( N-GtkWidget $grid, int32 $position)
  is native(&gtk-lib)
  is export
  { * }

sub gtk_grid_get_child_at ( N-GtkWidget $grid, uint32 $left, uint32 $top)
  returns N-GtkWidget
  is native(&gtk-lib)
  is export
  { * }

sub gtk_grid_set_row_spacing ( N-GtkWidget $grid, uint32 $spacing)
  is native(&gtk-lib)
  is export
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
multi submethod BUILD ( ) {

  $!gtk-widget = gtk_grid_new;
}

#-------------------------------------------------------------------------------
multi submethod BUILD ( N-GtkWidget $widget ) {

  $!gtk-widget = $widget;
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
