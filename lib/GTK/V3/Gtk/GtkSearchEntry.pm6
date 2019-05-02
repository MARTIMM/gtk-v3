use v6;

use NativeCall;

use GTK::V3::X;
use GTK::V3::N::NativeLib;
use GTK::V3::Glib::GObject;
use GTK::V3::Gtk::GtkEntry;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtksearchentry.h
# https://developer.gnome.org/gtk3/stable/GtkSearchEntry.html
unit class GTK::V3::Gtk::GtkSearchEntry:auth<github:MARTIMM>;
also is GTK::V3::Gtk::GtkEntry;

# ==============================================================================
sub gtk_search_entry_new ( )
  returns N-GObject       # GtkWidget
  is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  return unless self.^name eq 'GTK::V3::Gtk::GtkSearchEntry';

  if ? %options<empty> {
    self.native-gobject(gtk_search_entry_new());
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
  try { $s = &::("gtk_search_entry_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s;
}
