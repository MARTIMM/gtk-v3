use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE GTK::V3::Gtk::GtkOrientable

=SUBTITLE

  unit class GTK::V3::Gtk::GtkOrientable;
  also is GTK::V3::Glib::GInterface;

=head1 Synopsis


=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use GTK::V3::X;
use GTK::V3::N::NativeLib;
use GTK::V3::Glib::GObject;
use GTK::V3::Glib::GInterface;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkorientable.h
# https://developer.gnome.org/gtk3/stable/gtk3-Orientable.html
unit class GTK::V3::Gtk::GtkOrientable:auth<github:MARTIMM>;
also is GTK::V3::Glib::GInterface;

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

Create an orientable object.

  multi submethod BUILD ( :$widget )

Create an orientable object using a native object from elsewhere. See also Gtk::V3::Glib::GObject.

=end pod

submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  return unless self.^name eq 'GTK::V3::Gtk::GtkOrientable';

  if ? %options<widget> {
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
  try { $s = &::("gtk_orientable_$native-sub"); } unless ?$s;

#note "ad $native-sub: ", $s;
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_orientable_] set_orientation

  method gtk_orientable_get_orientation ( GtkOrientation )

Sets the orientation of the orientable.

=end pod

sub gtk_orientable_set_orientation ( N-GObject $orientable, int32 $orintation )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_orientable_] get_orientation

  method gtk_orientable_get_orientation ( --> GtkOrientation $orientation )

Set the orientation of the orientable.

=end pod

sub gtk_orientable_get_orientation ( N-GObject $orientable )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=head2 GtkOrientation

The orientation of the orientable.

=item GTK_ORIENTATION_HORIZONTAL; horizontal orientation.
=item GTK_ORIENTATION_VERTICAL; vertical orientation.

=end pod

enum GtkOrientation is export <
  GTK_ORIENTATION_HORIZONTAL GTK_ORIENTATION_VERTICAL
>
