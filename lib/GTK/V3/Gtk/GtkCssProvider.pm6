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
submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  return unless self.^name eq 'GTK::V3::Gtk::GtkCssProvider';

  if ? %options<empty> {
    self.native-gobject(gtk_css_provider_new());
  }

  elsif ? %options<widget> {
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
  try { $s = &::("gtk_css_provider_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s
}
