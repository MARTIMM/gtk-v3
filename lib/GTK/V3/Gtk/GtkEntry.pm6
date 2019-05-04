use v6;
use NativeCall;

use GTK::V3::X;
use GTK::V3::N::NativeLib;
use GTK::V3::Glib::GObject;
use GTK::V3::Gtk::GtkMisc;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkentry.h
# https://developer.gnome.org/gtk3/stable/GtkEntry.html
unit class GTK::V3::Gtk::GtkEntry:auth<github:MARTIMM>
  is GTK::V3::Gtk::GtkMisc;

#-------------------------------------------------------------------------------
sub gtk_entry_new ( )
  returns N-GObject
  is native(&gtk-lib)
  { * }

sub gtk_entry_get_text ( N-GObject $entry )
  returns Str
  is native(&gtk-lib)
  { * }

sub gtk_entry_set_text ( N-GObject $entry, Str $text )
  is native(&gtk-lib)
  { * }

sub gtk_entry_set_visibility ( N-GObject $entry, int32 $visible )
  is native(&gtk-lib)
  { * }

# hints is an enum with type GtkInputHints -> int
# The values are defined in Enums.pm6
sub gtk_entry_set_input_hints ( N-GObject $entry, uint32 $hints )
  is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
#submethod BUILD ( ) {
#  self.native-gobject(gtk_entry_new);
#}
submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  return unless self.^name eq 'GTK::V3::Gtk::GtkEntry';

  $signals-added = self.add-signal-types(
    :signal<activate backspace copy-clipboard cut-clipboard insert-emoji
            paste-clipboard toggle-overwrite
           >,
    :nativewidget<populate-popup>,
    :GtkDeleteType<delete-from-cursor>,
    :iconEvent<icon-press icon-release>,
    :str<insert-at-cursor preedit-changed>,
    :intbool<move-cursor>,
  ) unless $signals-added;

  if ? %options<empty> {
    self.native-gobject(gtk_entry_new());
  }

  elsif ? %options<widget> || ? %options<build-id> {
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
  try { $s = &::("gtk_entry_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s;
}
