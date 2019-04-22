use v6;
use NativeCall;

use GTK::V3::X;
use GTK::V3::N::NativeLib;
use GTK::V3::Glib::GObject;
#use GTK::V3::Gdk::GdkTypes;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gdk/gdkdevice.h
# https://developer.gnome.org/gdk3/stable/GdkDevice.html
unit class GTK::V3::Gdk::GdkDevice:auth<github:MARTIMM>;
also is GTK::V3::Glib::GObject;

#-------------------------------------------------------------------------------
sub gdk_device_get_name ( N-GObject $device )
  returns Str
  is native(&gdk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
submethod BUILD ( *%options ) {

  # prevent creating wrong widgets
  return unless self.^name eq 'GTK::V3::Gdk::GdkDevice';

  if ? %options<widget> || ? %options<build-id> {
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
  try { $s = &::("gdk_device_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s
}
