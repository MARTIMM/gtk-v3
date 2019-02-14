use v6;
use NativeCall;

use GTK::V3::X;
use GTK::V3::N::NativeLib;
use GTK::V3::Glib::GObject;
use GTK::V3::Gdk::GdkScreen;
use GTK::V3::Gtk::GtkMain;
#use GTK::V3::Gtk::GtkWidget;
use GTK::V3::Glib::GError;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkbuilder.h
# https://developer.gnome.org/gtk3/stable/GtkBuilder.html
unit class GTK::V3::Gtk::GtkBuilder:auth<github:MARTIMM>;

#-------------------------------------------------------------------------------
#?? #define G_TYPE_FUNDAMENTAL(type)	(g_type_fundamental (type))

#define	G_TYPE_FUNDAMENTAL_SHIFT (2)
constant G_TYPE_FUNDAMENTAL_SHIFT = 2;

#define	G_TYPE_MAKE_FUNDAMENTAL(x) ((GType) ((x) << G_TYPE_FUNDAMENTAL_SHIFT))
#sub G_TYPE_MAKE_FUNDAMENTAL ( int32 $x --> int32) {
#  $x +< G_TYPE_FUNDAMENTAL_SHIFT;
#}

#define	G_TYPE_FUNDAMENTAL_MAX		(255 << G_TYPE_FUNDAMENTAL_SHIFT)
sub G_TYPE_MAKE_FUNDAMENTAL_MAX ( --> int32) {
  255 +< G_TYPE_FUNDAMENTAL_SHIFT;
}

#define G_TYPE_INVALID G_TYPE_MAKE_FUNDAMENTAL (0)
constant G_TYPE_INVALID = 0 +< G_TYPE_FUNDAMENTAL_SHIFT;

#define G_TYPE_NONE G_TYPE_MAKE_FUNDAMENTAL (1)
constant G_TYPE_NONE = 1 +< G_TYPE_FUNDAMENTAL_SHIFT;

#define G_TYPE_INTERFACE G_TYPE_MAKE_FUNDAMENTAL (2)
constant G_TYPE_INTERFACE = 2 +< G_TYPE_FUNDAMENTAL_SHIFT;

#define G_TYPE_CHAR G_TYPE_MAKE_FUNDAMENTAL (3)
constant G_TYPE_CHAR = 3 +< G_TYPE_FUNDAMENTAL_SHIFT;

#define G_TYPE_UCHAR G_TYPE_MAKE_FUNDAMENTAL (4)
constant G_TYPE_UCHAR = 4 +< G_TYPE_FUNDAMENTAL_SHIFT;

#define G_TYPE_BOOLEAN G_TYPE_MAKE_FUNDAMENTAL (5)
constant G_TYPE_BOOLEAN = 5 +< G_TYPE_FUNDAMENTAL_SHIFT;

#define G_TYPE_INT G_TYPE_MAKE_FUNDAMENTAL (6)
constant G_TYPE_INT = 6 +< G_TYPE_FUNDAMENTAL_SHIFT;

#define G_TYPE_UINT G_TYPE_MAKE_FUNDAMENTAL (7)
constant G_TYPE_UINT = 7 +< G_TYPE_FUNDAMENTAL_SHIFT;

#define G_TYPE_LONG G_TYPE_MAKE_FUNDAMENTAL (8)
constant G_TYPE_LONG = 8 +< G_TYPE_FUNDAMENTAL_SHIFT;

#define G_TYPE_ULONG G_TYPE_MAKE_FUNDAMENTAL (9)
constant G_TYPE_ULONG = 9 +< G_TYPE_FUNDAMENTAL_SHIFT;

#define G_TYPE_INT64 G_TYPE_MAKE_FUNDAMENTAL (10)
constant G_TYPE_INT64 = 10 +< G_TYPE_FUNDAMENTAL_SHIFT;

#define G_TYPE_UINT64 G_TYPE_MAKE_FUNDAMENTAL (11)
constant G_TYPE_UINT64 = 11 +< G_TYPE_FUNDAMENTAL_SHIFT;

#define G_TYPE_ENUM G_TYPE_MAKE_FUNDAMENTAL (12)
constant G_TYPE_ENUM = 12 +< G_TYPE_FUNDAMENTAL_SHIFT;

#define G_TYPE_FLAGS G_TYPE_MAKE_FUNDAMENTAL (13)
constant G_TYPE_FLAGS = 13 +< G_TYPE_FUNDAMENTAL_SHIFT;

#define G_TYPE_FLOAT G_TYPE_MAKE_FUNDAMENTAL (14)
constant G_TYPE_FLOAT = 14 +< G_TYPE_FUNDAMENTAL_SHIFT;

#define G_TYPE_DOUBLE G_TYPE_MAKE_FUNDAMENTAL (15)
constant G_TYPE_DOUBLE = 15 +< G_TYPE_FUNDAMENTAL_SHIFT;

#define G_TYPE_STRING G_TYPE_MAKE_FUNDAMENTAL (16)
constant G_TYPE_STRING = 16 +< G_TYPE_FUNDAMENTAL_SHIFT;

#define G_TYPE_POINTER G_TYPE_MAKE_FUNDAMENTAL (17)
constant G_TYPE_POINTER = 17 +< G_TYPE_FUNDAMENTAL_SHIFT;

#define G_TYPE_BOXED G_TYPE_MAKE_FUNDAMENTAL (18)
constant G_TYPE_BOXED = 18 +< G_TYPE_FUNDAMENTAL_SHIFT;

#define G_TYPE_PARAM G_TYPE_MAKE_FUNDAMENTAL (19)
constant G_TYPE_PARAM = 19 +< G_TYPE_FUNDAMENTAL_SHIFT;

#define G_TYPE_OBJECT G_TYPE_MAKE_FUNDAMENTAL (20)
constant G_TYPE_OBJECT = 20 +< G_TYPE_FUNDAMENTAL_SHIFT;

#define	G_TYPE_VARIANT G_TYPE_MAKE_FUNDAMENTAL (21)
constant G_TYPE_VARIANT = 21 +< G_TYPE_FUNDAMENTAL_SHIFT;

#-------------------------------------------------------------------------------
class N-GtkBuilder is repr('CPointer') is export { }
#class N-GtkCssSection is repr('CPointer') is export { }
#class N-GtkCssProvider is repr('CPointer') is export { }

# GtkBuilder *gtk_builder_new (void);
sub gtk_builder_new ()
  returns N-GtkBuilder
  is native(&gtk-lib)
  { * }

# GtkBuilder *gtk_builder_new_from_string (const gchar *string, gssize length);
sub gtk_builder_new_from_file ( Str $glade-ui )
  returns N-GtkBuilder
  is native(&gtk-lib)
  { * }

# GtkBuilder *gtk_builder_new_from_string (const gchar *string, gssize length);
sub gtk_builder_new_from_string ( Str $glade-ui, uint32 $length)
  returns N-GtkBuilder
  is native(&gtk-lib)
  { * }

sub gtk_builder_add_from_file (
  N-GtkBuilder $builder, Str $glade-ui, N-GError $error is rw
) returns int32         # 0 or 1, 1 = ok, 0 look into GError
  is native(&gtk-lib)
    { * }

sub gtk_builder_add_from_string (
  N-GtkBuilder $builder, Str $glade-ui, uint32 $size, N-GError $error is rw
) returns int32         # 0 or 1, 1 = ok, 0 look into GError
  is native(&gtk-lib)
  { * }

sub gtk_builder_get_object (
  N-GtkBuilder $builder, Str $object-id
) returns N-GtkWidget   # is GObject
  is native(&gtk-lib)
  { * }

sub gtk_builder_get_type_from_name ( N-GtkBuilder $builder, Str $type_name )
  returns int32         # is GType
  is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
has N-GtkBuilder $!gtk-builder;

multi submethod BUILD ( Str:D :$filename! ) {
  die X::Gui.new(:message('GTK is not initialized'))
      unless $GTK::V3::Gtk::GtkMain::gui-initialized;
  $!gtk-builder = gtk_builder_new_from_file($filename);
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
multi submethod BUILD ( Str:D :$string! ) {
  die X::Gui.new(:message('GTK is not initialized'))
      unless $GTK::V3::Gtk::GtkMain::gui-initialized;
  $!gtk-builder = gtk_builder_new_from_string( $string, $string.chars);
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
multi submethod BUILD ( ) {
  die X::Gui.new(:message('GTK is not initialized'))
      unless $GTK::V3::Gtk::GtkMain::gui-initialized;
  $!gtk-builder = gtk_builder_new;
}

#-------------------------------------------------------------------------------
method CALL-ME ( N-GtkBuilder $builder? --> N-GtkBuilder ) {

  $!gtk-builder = $builder if ?$builder;
  $!gtk-builder
}

#-------------------------------------------------------------------------------
method FALLBACK ( $native-sub is copy, |c ) {

  CATCH { test-catch-exception( $_, $native-sub); }

  $native-sub ~~ s:g/ '-' /_/ if $native-sub.index('-');

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_builder_$native-sub"); }

  test-call( &$s, $!gtk-builder, |c)
}

#-------------------------------------------------------------------------------
multi method add-gui ( Str:D :$filename! ) {

  if ?$!gtk-builder {
#    my N-GError $g-error;
    my Int $e-code = gtk_builder_add_from_file(
      $!gtk-builder, $filename, Any #$g-error
    );
#note "BE: $g-error";

    die X::Gui.new(:message("Error adding file '$filename' to the Gui"))
        if $e-code == 0;
#    die X::Gui.new(:message("Error: " ~ $g-error().message)) if $e-code == 0;
  }

  else {
    $!gtk-builder = gtk_builder_new_from_file($filename);
  }
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
multi method add-gui ( Str:D :$string! ) {

  if ?$!gtk-builder {
    my Int $e-code = gtk_builder_add_from_string(
      $!gtk-builder, $string, $string.chars, Any
    );

    die X::Gui.new(:message("Error adding xml text to the Gui"))
        if $e-code == 0;
  }

  else {
    $!gtk-builder = gtk_builder_new_from_string( $string, $string.chars);
  }
}
