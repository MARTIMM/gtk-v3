use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE GTK::V3::Gtk::GtkEnums

=SUBTITLE Standard Enumerations — Public enumerated types used throughout GTK+

  unit class GTK::V3::Gtk::GtkEnums;

=end pod
#-------------------------------------------------------------------------------
use NativeCall;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtktypes.h
unit class GTK::V3::Gtk::GtkEnums:auth<github:MARTIMM>;

#-------------------------------------------------------------------------------
=begin pod
=head1 Enumerations
=end pod
#-------------------------------------------------------------------------------
=begin pod
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
=head2 GtkOrientation

The orientation of the orientable.

=item GTK_ORIENTATION_HORIZONTAL; horizontal orientation.
=item GTK_ORIENTATION_VERTICAL; vertical orientation.

=end pod

enum GtkOrientation is export <
  GTK_ORIENTATION_HORIZONTAL GTK_ORIENTATION_VERTICAL
>;

#-------------------------------------------------------------------------------
=begin pod
=head2 GtkTextDirection

Reading directions for text.

=item GTK_TEXT_DIR_NONE; No direction.
=item GTK_TEXT_DIR_LTR; Left to right text direction.
=item GTK_TEXT_DIR_RTL; Right to left text direction.

=end pod

enum GtkTextDirection is export <
  GTK_TEXT_DIR_NONE GTK_TEXT_DIR_LTR GTK_TEXT_DIR_RTL
>;
