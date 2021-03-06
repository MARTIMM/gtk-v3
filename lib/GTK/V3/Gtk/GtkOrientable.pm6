use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE GTK::V3::Gtk::GtkOrientable

=SUBTITLE GtkOrientable — An interface for flippable widgets

  unit class GTK::V3::Gtk::GtkOrientable;
  also is GTK::V3::Glib::GInterface;

=head1 Synopsis

  my GTK::V3::Gtk::GtkLevelBar $level-bar .= new(:empty);
  my GTK::V3::Gtk::GtkOrientable $o .= new(:widget($level-bar));
  $o.set-orientation(GTK_ORIENTATION_VERTICAL);

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

  multi method new ( :$widget )

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

Sets the orientation of the orientable. This is a GtkOrientation enum type defined in GtkEnums.

=end pod

sub gtk_orientable_set_orientation ( N-GObject $orientable, int32 $orientation )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_orientable_] get_orientation

  method gtk_orientable_get_orientation ( --> GtkOrientation $orientation )

Set the orientation of the orientable. This is a GtkOrientation enum type defined in GtkEnums.

=end pod

sub gtk_orientable_get_orientation ( N-GObject $orientable )
  is native(&gtk-lib)
  { * }
