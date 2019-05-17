use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE GTK::V3::Gtk::GtkLevelBar

=SUBTITLE GtkLevelBar — A bar that can used as a level indicator

  unit class GTK::V3::Gtk::GtkLevelBar;
  also is GTK::V3::Gtk::GtkWidget;

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
use GTK::V3::Gtk::GtkWidget;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/INCLUDE
# See /usr/include/glib-2.0/gobject/INCLUDE
# https://developer.gnome.org/WWW
unit class GTK::V3::Gtk::GtkLevelBar:auth<github:MARTIMM>;
also is GTK::V3::Gtk::GtkWidget;

#-------------------------------------------------------------------------------
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

  multi submethod BUILD ( Bool :$empty! )

Create a GtkLevelBar object.

  multi submethod BUILD ( Num :$min!, Num :$min! )

Create a new GtkLevelBar with a specified range.

  multi submethod BUILD ( :$widget! )

Create an object using a native object from elsewhere. See also Gtk::V3::Glib::GObject.

  multi submethod BUILD ( Str :$build-id! )

Create an object using a native object from a builder. See also Gtk::V3::Glib::GObject.

=end pod

submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :Str<offset-changed>
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'GTK::V3::Gtk::GtkLevelBar';

  if ? %options<empty> {
    self.native-gobject(gtk_level_bar_new());
  }

  elsif ? %options<min> and ? %options<max> {
    self.native-gobject(gtk_level_bar_new_for_interval(
      %options<min>, %options<max>)
    );
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
  try { $s = &::("gtk_level_bar_$native-sub"); } unless ?$s;

#note "ad $native-sub: ", $s;
  $s = callsame unless ?$s;

  $s;
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
sub gtk_level_bar_new ( )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
sub gtk_level_bar_new_for_interval ( num64 $min_value, num64 $max_value )
  returns N-GObject
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_level_bar_] set_mode

  method gtk_level_bar_set_mode ( GtkLevelBarMode $mode )

=item $mode; the way that increments are made visible.

=end pod

sub gtk_level_bar_set_mode ( N-GObject $levelbar, int32 $mode )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_level_bar_] get_mode

  method gtk_level_bar_get_mode ( --> GtkLevelBarMode )

Returns current mode.

=end pod

sub gtk_level_bar_get_mode ( N-GObject $levelbar )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_level_bar_] set_value

  method gtk_level_bar_set_value ( Num $value )

=item $value; set the level bar value.

=end pod

sub gtk_level_bar_set_value ( N-GObject $levelbar, num64 $value )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_level_bar_] get_value

  method gtk_level_bar_get_value ( --> Num )

Returns current value.

=end pod

sub gtk_level_bar_get_value ( N-GObject $levelbar )
  returns num64
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_level_bar_] set_min_value

  method gtk_level_bar_set_min_value ( Num $value )

=item $value; set the minimum value of the bar.

=end pod

sub gtk_level_bar_set_min_value ( N-GObject $levelbar, num64 $value )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_level_bar_] get_min_value

  method gtk_level_bar_get_min_value ( --> Num )

Returns the minimum value of the bar.

=end pod

sub gtk_level_bar_get_min_value ( N-GObject $levelbar )
  returns num64
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_level_bar_] set_max_value

  method gtk_level_bar_set_max_value ( Num $value )

=item $value; set the maximum value of the bar.

=end pod

sub gtk_level_bar_set_max_value ( N-GObject $levelbar, num64 $value )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_level_bar_] get_max_value

  method gtk_level_bar_get_max_value ( --> Num )

Returns the maximum value of the bar.

=end pod

sub gtk_level_bar_get_max_value ( N-GObject $levelbar )
  returns num64
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_level_bar_] set_inverted

  method gtk_level_bar_set_inverted ( Int $invert )

=item $invert; When 1, the bar is inverted. That is, right to left or bottom to top.

=end pod

sub gtk_level_bar_set_inverted ( N-GObject $levelbar, int32 $invert )
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_level_bar_] get_inverted

  method gtk_level_bar_get_inverted ( --> Int )

Returns invert mode; When 1, the bar is inverted. That is, right to left or bottom to top.

=end pod

sub gtk_level_bar_get_inverted ( N-GObject $levelbar )
  returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_level_bar_] add_offset_value

Adds a new offset marker on self at the position specified by value . When the bar value is in the interval topped by value (or between value and “max-value” in case the offset is the last one on the bar) a style class named level-name will be applied when rendering the level bar fill. If another offset marker named name exists, its value will be replaced by value .

  method gtk_level_bar_add_offset_value ( Str $name, Num $value )

=item $name; the name of the new offset.
=item $value; the value for the new offset.

=end pod

sub gtk_level_bar_add_offset_value (
  N-GObject $levelbar, Str $name, num64 $value
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_level_bar_] get_offset_value

Fetches the value specified for the offset marker name.

  method gtk_level_bar_get_offset_value ( Str $name, Num $value --> Int )

=item $name; the name of the new offset.
=item $value; the value of the offset is returned.

Returns Int where 1 means that name is found.

=end pod

sub gtk_level_bar_get_offset_value (
  N-GObject $levelbar, Str $name, num64 $value is rw
) returns int32
  is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 [gtk_level_bar_] remove_offset_value

Adds a new offset marker on self at the position specified by value . When the bar value is in the interval topped by value (or between value and “max-value” in case the offset is the last one on the bar) a style class named level-name will be applied when rendering the level bar fill. If another offset marker named name exists, its value will be replaced by value.
This offset name can be used to change color and view of the level bar after passing this offset by setting information in a css file. For example when name is C<my-offset> one can do the following.

  levelbar block.my-offset {
     background-color: magenta;
     border-style: solid;
     border-color: black;
     border-style: 1px;
  }

  method gtk_level_bar_remove_offset_value ( Str $name )

=item $name; the name of the offset.

=end pod

sub gtk_level_bar_remove_offset_value (
  N-GObject $levelbar, Str $name, num64 $value
) is native(&gtk-lib)
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head1 Types
=head2 GtkLevelBarMode

Describes how GtkLevelBar contents should be rendered. Note that this enumeration could be extended with additional modes in the future.

=item GTK_LEVEL_BAR_MODE_CONTINUOUS; the bar has a continuous mode.
=item GTK_LEVEL_BAR_MODE_DISCRETE; the bar has a discrete mode.

=end pod

enum GtkLevelBarMode is export <
  GTK_LEVEL_BAR_MODE_CONTINUOUS GTK_LEVEL_BAR_MODE_DISCRETE
>;

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

=head2 Not yet supported signals
=head3 offset-changed

Emitted when an offset specified on the bar changes value as an effect to C<gtk_level_bar_add_offset_value()> being called.

The signal supports detailed connections; you can connect to the detailed signal "changed::x" in order to only receive callbacks when the value of offset "x" changes.

=end pod
