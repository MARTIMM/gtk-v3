use v6;
use NativeCall;

use GTK::V3::X;
use GTK::V3::N::NativeLib;
use GTK::V3::Glib::GObject;
use GTK::V3::Gtk::GtkTextTagTable;
use GTK::V3::Gtk::GtkTextIter;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtktextbuffer.h
# https://developer.gnome.org/gtk3/stable/GtkTextBuffer.html
# https://developer.gnome.org/gtk3/stable/TextWidget.html
unit class GTK::V3::Gtk::GtkTextBuffer:auth<github:MARTIMM>
  is GTK::V3::Glib::GObject;

#-------------------------------------------------------------------------------
sub gtk_text_buffer_new ( N-GObject $text-tag-table )
  returns N-GObject       # GtkTextBuffer
  is native(&gtk-lib)
  { * }

sub gtk_text_buffer_get_start_iter ( N-GObject $buffer, N-GTextIter $i )
  is native(&gtk-lib)
  { * }

sub gtk_text_buffer_get_end_iter( N-GObject $buffer, N-GTextIter $i )
  is native(&gtk-lib)
  { * }

sub gtk_text_buffer_set_text( N-GObject $buffer, Str $text, int32 $len )
  is native(&gtk-lib)
  { * }

sub gtk_text_buffer_get_text (
  N-GObject $buffer, N-GTextIter $start, N-GTextIter $end,
  int32 $include_hidden_chars
) returns Str
  is native(&gtk-lib)
  { * }

sub gtk_text_buffer_insert(
  N-GObject $buffer, CArray[int32] $start,
  Str $text, int32 $len
) is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  $signals-added = self.add-signal-types( $?CLASS.^name, 
    :signal<begin-user-action changed end-user-action modified-changed>,
    :nativewidget<mark-deleted paste-done>,
    :tagiter2<apply-tag remove-tag>,
    :iter2<delete-range>,
    :iteranchor<insert-child-anchor>,
    :iterpix<insert-pixbuf>,
    :iterstrint<insert-text>,
    :itermark<mark-set>,
  ) unless $signals-added;

  return unless self.^name eq 'GTK::V3::Gtk::GtkTextBuffer';

  if ? %options<empty> {
    my GTK::V3::Gtk::GtkTextTagTable $tag-table .= new(:empty);
    self.native-gobject(gtk_text_buffer_new($tag-table()));
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
  try { $s = &::("gtk_text_buffer_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s
}
