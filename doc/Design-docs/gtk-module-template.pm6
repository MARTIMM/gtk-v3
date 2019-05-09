use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE GTK::V3::LIBRARY::MODULE

=SUBTITLE

  unit class GTK::V3::LIBRARY::MODULE;
  also is GTK::V3::LIBRARY::PARENTMODULE;

=head1 Synopsis


=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use GTK::V3::X;
use GTK::V3::N::NativeLib;
use GTK::V3::Glib::GObject;
use GTK::V3::Gtk::GtkDialog;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/INCLUDE
# See /usr/include/glib-2.0/gobject/INCLUDE
# https://developer.gnome.org/WWW
unit class GTK::V3::LIBRARY::MODULE:auth<github:MARTIMM>;
also is GTK::V3::LIBRARY::PARENTMODULE;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new


=end pod

submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    ... :type<signame>
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'GTK::V3::LIBRARY::MODULE';

  if ? %options<empty> {
    # ... self.native-gobject(gtk_about_dialog_new());
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
  # ... try { $s = &::("gtk_about_dialog_$native-sub"); } unless ?$s;

#note "ad $native-sub: ", $s;
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
=begin pod

=head2

  method ... ( ... --> ... )

=item ...; ...

Returns ...

=end pod

#`{{
sub ... ( ... )
  returns ...
  is symbol('...')
  is native(&gtk-lib)
  is native(&gdk-lib)
  is native(&gobject-lib)
  { * }
}}

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=head2 ...

...
=item ...

=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

=head2 Supported signals
=head3 ...
...

=head2 Unsupported signals
=head3 ...
...

=head2 Not yet supported signals
=head3 ...
...

=end pod
