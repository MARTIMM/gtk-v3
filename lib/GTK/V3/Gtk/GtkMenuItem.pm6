use v6;
use NativeCall;

use GTK::V3::X;
use GTK::V3::N::NativeLib;
use GTK::V3::Glib::GObject;
use GTK::V3::Gtk::GtkBin;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkmenuitem.h
# https://developer.gnome.org/gtk3/stable/GtkMenuItem.html
unit class GTK::V3::Gtk::GtkMenuItem:auth<github:MARTIMM>
  is GTK::V3::Gtk::GtkBin;

#-------------------------------------------------------------------------------
sub gtk_menu_item_new ( )
  returns N-GObject
  is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name, 
    :signal<activate activate-item deselect select >,
    :int<toggle-size-allocate>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'GTK::V3::Gtk::GtkMenuItem';

  if ? %options<empty> {
    self.native-gobject(gtk_menu_item_new());
  }

  elsif ? %options<widget> || %options<build-id> {
    # provided in GObject
  }

  elsif %options.keys.elems {
    die X::GTK::V3.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }
}

#-------------------------------------------------------------------------------
method fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_menu_item_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s;
}
