use v6;
#===============================================================================
=begin pod

=TITLE class GTK::V3::Gtk::GtkAboutDialog

=SUBTITLE

  unit class GTK::V3::Gtk::GtkAboutDialog;
  also is GTK::V3::Gtk::GtkDialog;

=head1 Synopsis

  use GTK::V3::Gtk::GtkAboutDialog $about .= new(:empty);
  $about.set-program-name('My-First-GTK-Program');

  # show the dialog
  $about.run;

  # when dialog buttons are pressed hide it again
  $about.hide

=head1 Methods

All methods can be written with dashes or shortened by cutting the C<gtk_about_dialog_> part. This cannot be done when e.g. C<new> is left after the shortening. That would become an entirely other method. See the synopsis above for an example. Below, this is shown with brackets in the headers.
=end pod
#===============================================================================

use NativeCall;

use GTK::V3::X;
use GTK::V3::N::NativeLib;
use GTK::V3::Glib::GObject;
use GTK::V3::Gtk::GtkDialog;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkaboutdialog.h
# https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html
unit class GTK::V3::Gtk::GtkAboutDialog:auth<github:MARTIMM>
  is GTK::V3::Gtk::GtkDialog;

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk_about_dialog_new

  method gtk_about_dialog_new ( --> N-GObject )

Creates a new empty about dialog widget. It returns a native object which must be stored in another object. Better, shorter and easier is to use C<.new(:empty)>. See info below.
=end pod
sub gtk_about_dialog_new ( )
  returns N-GObject       # GtkAboutDialog
  is native(&gtk-lib)
  { * }

=begin pod
=head2 [gtk_about_dialog_] get_program_name

  method gtk_about_dialog_get_program_name ( --> Str )

Get the program name from the dialog.
=end pod
sub gtk_about_dialog_get_program_name ( N-GObject $dialog )
  returns Str
  is native(&gtk-lib)
  { * }

=begin pod
=head2 [gtk_about_dialog_] set_program_name

  method gtk_about_dialog_set_program_name ( Str $pname )

Set the program name in the about dialog.
=end pod
sub gtk_about_dialog_set_program_name ( N-GObject $dialog, Str $pname )
  is native(&gtk-lib)
  { * }

=begin pod
=head2 [gtk_about_dialog_] get_version

  method gtk_about_dialog_get_version ( --> Str )

Get the version
=end pod
sub gtk_about_dialog_get_version ( N-GObject $dialog )
  returns Str
  is native(&gtk-lib)
  { * }

=begin pod
=head2 [gtk_about_dialog_] set_version

  method gtk_about_dialog_set_version ( Str $version )

Set version
=end pod
sub gtk_about_dialog_set_version ( N-GObject $dialog, Str $version )
  is native(&gtk-lib)
  { * }

#TODO some more subs

=begin pod
=head2 [gtk_about_dialog_] set_logo

  method gtk_about_dialog_set_logo ( OpaquePointer $logo-pixbuf )

Set the logo from a pixel buffer.
=end pod
sub gtk_about_dialog_set_logo ( N-GObject $dialog, OpaquePointer $logo-pixbuf )
  is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
=begin pod
=head2 new

  multi submethod BUILD (:empty!)

Create an empty about dialog

  multi submethod BUILD (:widget!)

Create an about dialog using a native object from elsewhere. See also Gtk::V3::Glib::GObject.

  multi submethod BUILD (:build-id!)

Create an about dialog using a native object from a builder. See also Gtk::V3::Glib::GObject.

=end pod
submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  return unless self.^name eq 'GTK::V3::Gtk::GtkAboutDialog';

  if ? %options<empty> {
    self.native-gobject(gtk_about_dialog_new());
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
  try { $s = &::("gtk_about_dialog_$native-sub"); } unless ?$s;

note "ad $native-sub: ", $s;
  $s = callsame unless ?$s;

  $s;
}
