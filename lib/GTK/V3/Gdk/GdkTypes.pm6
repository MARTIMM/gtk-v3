use v6;
use NativeCall;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gdk/gdktypes.h
unit class GTK::V3::Gdk::GdkTypes:auth<github:MARTIMM>;

#-------------------------------------------------------------------------------
=begin pod
=head2 GdkRectangle

Defines the position and size of a rectangle.

=item $.x
=item $.y
=item $.width
=item $.height

=end pod

class GdkRectangle is repr('CStruct') is export {
  has int32 $.x;
  has int32 $.y;
  has int32 $.width;
  has int32 $.height;
};

#-------------------------------------------------------------------------------
=begin pod
=head2 GdkModifierType

A set of bit-flags to indicate the state of modifier keys and mouse buttons in various event types. Typical modifier keys are Shift, Control, Meta, Super, Hyper, Alt, Compose, Apple, CapsLock or ShiftLock.

Like the X Window System, GDK supports 8 modifier keys and 5 mouse buttons.

Since 2.10, GDK recognizes which of the Meta, Super or Hyper keys are mapped to Mod2 - Mod5, and indicates this by setting C<GDK_SUPER_MASK>, C<GDK_HYPER_MASK> or C<GDK_META_MASK> in the state field of key events.

Note that GDK may add internal values to events which include reserved values such as C<GDK_MODIFIER_RESERVED_13_MASK>. Your code should preserve and ignore them.  You can use C<GDK_MODIFIER_MASK> to remove all reserved values.

Also note that the GDK X backend interprets button press events for button 4-7 as scroll events, so C<GDK_BUTTON4_MASK> and C<GDK_BUTTON5_MASK> will never be set.

=item GDK_SHIFT_MASK: the Shift key.
=item GDK_LOCK_MASK: a Lock key (depending on the modifier mapping of the X server this may either be CapsLock or ShiftLock).
=item GDK_CONTROL_MASK: the Control key.
=item GDK_MOD1_MASK: the fourth modifier key (it depends on the modifier mapping of the X server which key is interpreted as this modifier, but normally it is the Alt key).
=item GDK_MOD2_MASK: the fifth modifier key (it depends on the modifier mapping of the X server which key is interpreted as this modifier).
=item GDK_MOD3_MASK: the sixth modifier key (it depends on the modifier mapping of the X server which key is interpreted as this modifier).
=item GDK_MOD4_MASK: the seventh modifier key (it depends on the modifier mapping of the X server which key is interpreted as this modifier).
=item GDK_MOD5_MASK: the eighth modifier key (it depends on the modifier mapping of the X server which key is interpreted as this modifier).
=item GDK_BUTTON1_MASK: the first mouse button.
=item GDK_BUTTON2_MASK: the second mouse button.
=item GDK_BUTTON3_MASK: the third mouse button.
=item GDK_BUTTON4_MASK: the fourth mouse button.
=item GDK_BUTTON5_MASK: the fifth mouse button.
=item GDK_MODIFIER_RESERVED_13_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_14_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_15_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_16_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_17_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_18_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_19_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_20_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_21_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_22_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_23_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_24_MASK: A reserved bit flag; do not use in your own code
=item GDK_MODIFIER_RESERVED_25_MASK: A reserved bit flag; do not use in your own code
=item GDK_SUPER_MASK: the Super modifier. Since 2.10
=item GDK_HYPER_MASK: the Hyper modifier. Since 2.10
=item GDK_META_MASK: the Meta modifier. Since 2.10
=item GDK_MODIFIER_RESERVED_29_MASK: A reserved bit flag; do not use in your own code
=item GDK_RELEASE_MASK: not used in GDK itself. GTK+ uses it to differentiate between (keyval, modifiers) pairs from key press and release events.
=item GDK_MODIFIER_MASK: a mask covering all modifier types.
=end pod

enum GdkModifierType is export (
  GDK_SHIFT_MASK    => 1 +< 0,
  GDK_LOCK_MASK     => 1 +< 1,
  GDK_CONTROL_MASK  => 1 +< 2,
  GDK_MOD1_MASK     => 1 +< 3,
  GDK_MOD2_MASK     => 1 +< 4,
  GDK_MOD3_MASK     => 1 +< 5,
  GDK_MOD4_MASK     => 1 +< 6,
  GDK_MOD5_MASK     => 1 +< 7,
  GDK_BUTTON1_MASK  => 1 +< 8,
  GDK_BUTTON2_MASK  => 1 +< 9,
  GDK_BUTTON3_MASK  => 1 +< 10,
  GDK_BUTTON4_MASK  => 1 +< 11,
  GDK_BUTTON5_MASK  => 1 +< 12,

  GDK_MODIFIER_RESERVED_13_MASK  => 1 +< 13,
  GDK_MODIFIER_RESERVED_14_MASK  => 1 +< 14,
  GDK_MODIFIER_RESERVED_15_MASK  => 1 +< 15,
  GDK_MODIFIER_RESERVED_16_MASK  => 1 +< 16,
  GDK_MODIFIER_RESERVED_17_MASK  => 1 +< 17,
  GDK_MODIFIER_RESERVED_18_MASK  => 1 +< 18,
  GDK_MODIFIER_RESERVED_19_MASK  => 1 +< 19,
  GDK_MODIFIER_RESERVED_20_MASK  => 1 +< 20,
  GDK_MODIFIER_RESERVED_21_MASK  => 1 +< 21,
  GDK_MODIFIER_RESERVED_22_MASK  => 1 +< 22,
  GDK_MODIFIER_RESERVED_23_MASK  => 1 +< 23,
  GDK_MODIFIER_RESERVED_24_MASK  => 1 +< 24,
  GDK_MODIFIER_RESERVED_25_MASK  => 1 +< 25,

  #`{{ The next few modifiers are used by XKB, so we skip to the end.
    Bits 15 - 25 are currently unused. Bit 29 is used internally.
 }}

  GDK_SUPER_MASK    => 1 +< 26,
  GDK_HYPER_MASK    => 1 +< 27,
  GDK_META_MASK     => 1 +< 28,

  GDK_MODIFIER_RESERVED_29_MASK  => 1 +< 29,

  GDK_RELEASE_MASK  => 1 +< 30,

  # Combination of GDK_SHIFT_MASK..GDK_BUTTON5_MASK + GDK_SUPER_MASK
  #   + GDK_HYPER_MASK + GDK_META_MASK + GDK_RELEASE_MASK */
  GDK_MODIFIER_MASK => 0x5c001fff
);

enum GdkWindowTypeHint is export <
  GDK_WINDOW_TYPE_HINT_NORMAL
  GDK_WINDOW_TYPE_HINT_DIALOG
  GDK_WINDOW_TYPE_HINT_MENU
  GDK_WINDOW_TYPE_HINT_TOOLBAR
  GDK_WINDOW_TYPE_HINT_SPLASHSCREEN
  GDK_WINDOW_TYPE_HINT_UTILITY
  GDK_WINDOW_TYPE_HINT_DOCK
  GDK_WINDOW_TYPE_HINT_DESKTOP
  GDK_WINDOW_TYPE_HINT_DROPDOWN_MENU
  GDK_WINDOW_TYPE_HINT_POPUP_MENU
  GDK_WINDOW_TYPE_HINT_TOOLTIP
  GDK_WINDOW_TYPE_HINT_NOTIFICATION
  GDK_WINDOW_TYPE_HINT_COMBO
  GDK_WINDOW_TYPE_HINT_DND
>;
