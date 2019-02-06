use v6;
use NativeCall;

use GTK::V3::X;
use GTK::V3::Gui;
use GTK::V3::N::NativeLib;

#-------------------------------------------------------------------------------
# See /usr/include/glib-2.0/gobject/gsignal.h
# /usr/include/glib-2.0/gobject/gobject.h
# https://developer.gnome.org/gobject/stable/gobject-Signals.html
unit class GTK::V3::Glib::GSignal:auth<github:MARTIMM>;

#-------------------------------------------------------------------------------
enum GConnectFlags is export (
  G_CONNECT_AFTER	        => 1,
  G_CONNECT_SWAPPED	      => 1 +< 1
);

#-------------------------------------------------------------------------------
# Helper subs using the native calls
#
# original handler signature:
#   &handler ( N-GtkWidget $h_widget, OpaquePointer $h_data )
# widget is inserted when second call to method is made and data is only
# definable as an OpaquePointer so it can not give any data. This is also
# inserted in second call. See GtkWidget.
sub g_signal_connect (
  N-GtkWidget $widget, Str $signal, &handler ( ), OpaquePointer
) {
  g_signal_connect_data(
    $widget, $signal, &handler, OpaquePointer, Any, 0
  );
}

sub g_signal_connect_after (
  N-GtkWidget $widget, Str $signal, &handler ( ), OpaquePointer
) {
  g_signal_connect_data(
    $widget, $signal, &handler, OpaquePointer, Any, G_CONNECT_AFTER
  );
}

sub g_signal_connect_swapped (
  N-GtkWidget $widget, Str $signal, &handler ( ), OpaquePointer
) {
  g_signal_connect_data(
    $widget, $signal, &handler, OpaquePointer, Any, G_CONNECT_SWAPPED
  );
}

#-------------------------------------------------------------------------------
# safe in threaded programs
sub g_signal_connect_data(
  N-GtkWidget $widget, Str $signal, &handler ( ), OpaquePointer,
  OpaquePointer $destroy_data, int32 $connect_flags
) returns int32
  is native(&gobject-lib)
  { * }

# unsafe in threaded programs
sub g_signal_connect_object(
  N-GtkWidget $widget, Str $signal, &handler ( ),
  OpaquePointer, int32 $connect_flags
) returns uint32
  is native(&gobject-lib)
  { * }

# a GQuark is a guint32, $detail is a quark
# See https://developer.gnome.org/glib/stable/glib-Quarks.html
sub g_signal_emit (
  N-GtkWidget $instance, uint32 $signal_id, uint32 $detail,
  N-GtkWidget $widget, Str $data, Str $return-value is rw
) is native(&gobject-lib)
  { * }

# Handlers above provided to the signal connect calls are having 2 arguments
# a widget and data. So the provided extra arguments are then those 2
# plus a return value
sub g_signal_emit_by_name (
  N-GtkWidget $instance, Str $detailed_signal,
  N-GtkWidget $widget, Str $data, Str $return-value is rw
) is native(&gobject-lib)
  { * }

sub g_signal_handler_disconnect( N-GtkWidget $widget, int32 $handler_id)
  is native(&gobject-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
method fallback ( $native-sub is copy --> Callable ) {

  $native-sub ~~ s:g/ '-' /_/ if $native-sub.index('-');

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("g_signal_$native-sub"); } unless ?$s;

  #$s = callsame unless ?$s;

  $s
}
