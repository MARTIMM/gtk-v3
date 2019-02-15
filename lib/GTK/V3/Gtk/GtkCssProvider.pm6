use v6;
use NativeCall;

use GTK::V3::X;
use GTK::V3::N::NativeLib;
use GTK::V3::Glib::GObject;
use GTK::V3::Gdk::GdkScreen;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkcssprovider.h
# https://developer.gnome.org/gtk3/stable/GtkCssProvider.html
unit class GTK::V3::Gtk::GtkCssProvider:auth<github:MARTIMM>
  is GTK::V3::Glib::GObject;

#-------------------------------------------------------------------------------
#`{{
class N-GtkCssProvider
  is repr('CPointer')
  is export
  { }
}}

enum GtkStyleProviderPriority is export (
  GTK_STYLE_PROVIDER_PRIORITY_FALLBACK => 1,
  GTK_STYLE_PROVIDER_PRIORITY_THEME => 200,
  GTK_STYLE_PROVIDER_PRIORITY_SETTINGS => 400,
  GTK_STYLE_PROVIDER_PRIORITY_APPLICATION => 600,
  GTK_STYLE_PROVIDER_PRIORITY_USER => 800,
);

#-------------------------------------------------------------------------------
sub gtk_css_provider_new ( )
  returns N-GObject       # GtkCssProvider
  is native(&gtk-lib)
  { * }

sub gtk_css_provider_get_named ( Str $name, Str $variant )
  returns N-GObject
  is native(&gtk-lib)
  { * }

sub gtk_css_provider_load_from_path (
  N-GObject $css_provider, Str $css-file, OpaquePointer
) is native(&gtk-lib)
  { * }

sub gtk_style_context_add_provider_for_screen (
  N-GObject $screen, int32 $provider, int32 $priority
) is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
#has N-GtkCssProvider $!gtk-css-provider;

#-------------------------------------------------------------------------------
submethod BUILD ( ) {
  self.setWidget(gtk_css_provider_new());
}

#-------------------------------------------------------------------------------
#`{{
method CALL-ME ( --> N-GtkCssProvider ) {
  $!gtk-css-provider
}

#-------------------------------------------------------------------------------
method FALLBACK ( $native-sub is copy, |c ) {

  $native-sub ~~ s:g/ '-' /_/ if $native-sub.index('-');

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_css_provider_$native-sub"); } unless ?$s;

  CATCH { test-catch-exception( $_, $native-sub); }

  if $native-sub eq 'gtk_style_context_add_provider_for_screen' {
    &$s(|c)
  }

  else {
    &$s( $!gtk-css-provider, |c)
  }
}
}}

#-------------------------------------------------------------------------------
method fallback ( $native-sub is copy --> Callable ) {

  $native-sub ~~ s:g/ '-' /_/ if $native-sub.index('-');

  my Callable $s;
#note "w s0: $native-sub, ", $s;
  try { $s = &::($native-sub); }
#note "w s1: gtk_widget_$native-sub, ", $s unless ?$s;
  try { $s = &::("gtk_css_provider_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s
}
