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
#use GTK::V3::N::N-GObject;
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
    # ... self.native-gobject(gtk__dialog_new());
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
  # ... try { $s = &::("gtk__dialog_$native-sub"); } unless ?$s;

#note "ad $native-sub: ", $s;
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
=begin pod
=head2 gtk__new

Creates a new native ...

  method gtk__new ( --> N-GObject )

Returns a native widget. It is not advised to use it. The new()/BUILD() method can handle this better and easier.

=end pod

sub gtk__new ( )
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

sub  ( N-GObject   )
  returns
  is native(&gtk-lib)
  { * }

#`{{
sub  ( N-GObject )
  returns
  is native(&gdk-lib)
  { * }

sub  ( N-GObject )
  returns
  is native(&g-lib)
  { * }



  is symbol('')
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
