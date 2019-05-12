use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE GTK::V3::LIBRARY::MODULE

=SUBTITLE

  unit class GTK::V3::LIBRARY::MODULE;
  also is GTK::V3::LIBRARY::PARENT;

=head1 Synopsis


=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use GTK::V3::X;
use GTK::V3::N::NativeLib;
#use GTK::V3::Glib::GObject;
use GTK::V3::LIBRARY::PARENT;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/INCLUDE
# See /usr/include/glib-2.0/gobject/INCLUDE
# https://developer.gnome.org/WWW
unit class GTK::V3::LIBRARY::MODULE:auth<github:MARTIMM>;
also is GTK::V3::LIBRARY::PARENT;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

...

  multi submethod BUILD ( :$widget! )

Create an object using a native object from elsewhere. See also Gtk::V3::Glib::GObject.

  multi submethod BUILD ( Str :$build-id! )

Create an object using a native object from a builder. See also Gtk::V3::Glib::GObject.

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
# no pod. user does not have to know about it.
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
=head2 gtk_..._new

Creates a new native ...

  method gtk__new ( --> N-GObject )

Returns a native widget. Can be used to initialize another object using :widget. This is very cumbersome when you know that a oneliner does the job for you: `my GTK::V3::LIBRARY::MODULE $m .= new(:empty);

  my GTK::V3::LIBRARY::MODULE $m;
  $m .= :new(:widget($m.gtk__new());

=end pod

sub gtk_..._new ( )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2

  method  (  -->  )

=item

Returns

=end pod

#`{{
sub  (  )
  returns
  is native(&gtk-lib)
  { * }

  is symbol('')
  is native(&gdk-lib)
  is native(&gobject-lib)
}}

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=head2

=item

=end pod

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

=head2 Supported signals
=head3


=head2 Unsupported signals
=head3


=head2 Not yet supported signals
=head3


=end pod
