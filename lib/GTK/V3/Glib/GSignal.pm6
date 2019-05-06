use v6;
# ==============================================================================
=begin pod

=TITLE class GTK::V3::Glib::GSignal

=SUBTITLE

  unit class GTK::V3::Glib::GSignal;

=head2 GSignal — A means for customization of object behaviour and a general purpose notification mechanism

=head1 Synopsis

  # define method
  method mouse-event ( :widget($w), :event($e)) { ... }

  # get the window object
  my GTK::V3::Gtk::GtkWindow $w .= new( ... );

  # define proper handler. you must study the GTK develper guides. you will
  # then notice that C<connect-object> is a bit different than the real mcCoy.
  my Callable $handler;
  $handler = -> N-GObject $ignore-w, GdkEvent $e, OpaquePointer $ignore-d {
    self.mouse-event( :widget($w), :event($e) );
  }

  # connect signal to the handler
  $w.connect-object( 'button-press-event', $handler);

It will be easier to use the register-signal method

  # define method
  method mouse-event ( :widget($w), :event($e)) { ... }

  # get the window object
  my GTK::V3::Gtk::GtkWindow $w .= new( ... );

  # then register
  $w.register-signal( self, 'mouse-event', 'button-press-event', :time(now));

=end pod
# ==============================================================================
use NativeCall;

use GTK::V3::X;
use GTK::V3::N::NativeLib;
use GTK::V3::N::N-GObject;
use GTK::V3::Gdk::GdkEventTypes;

#-------------------------------------------------------------------------------
# See /usr/include/glib-2.0/gobject/gsignal.h
# /usr/include/glib-2.0/gobject/gobject.h
# https://developer.gnome.org/gobject/stable/gobject-Signals.html
unit class GTK::V3::Glib::GSignal:auth<github:MARTIMM>;

#-------------------------------------------------------------------------------
# signal-type: widget, data
my Signature $signal-type = :( N-GObject, OpaquePointer );
# other-signal-type: widget, OpaquePointer, data
my Signature $nativewidget-type = :( N-GObject, OpaquePointer, OpaquePointer );
# event-type: widget, event, data
my Signature $event-type = :( N-GObject, GdkEvent, OpaquePointer );

#-------------------------------------------------------------------------------
=begin pod
=head1 Enumerations
=head2 GConnectFlags
=item G_CONNECT_AFTER; whether the handler should be called before or after the default handler of the signal.
=item G_CONNECT_SWAPPED; whether the instance and data should be swapped when calling the handler; see g_signal_connect_swapped() for an example.
=end pod

enum GConnectFlags is export (
  G_CONNECT_AFTER	        => 1,
  G_CONNECT_SWAPPED	      => 1 +< 1
);

#-------------------------------------------------------------------------------
=begin pod
=head1 Methods

=head2 g_signal_connect_object

  method g_signal_connect_object(
    Str $signal, Callable $handler, int32 $connect_flags = 0
    --> uint64
  }

This is similar to C<g_signal_connect_data()>, but uses a closure which ensures that the gobject stays alive during the call to c_handler by temporarily adding a reference count to gobject .

When the gobject is destroyed the signal handler will be automatically disconnected. Note that this is not currently threadsafe (ie: emitting a signal while gobject is being destroyed in another thread is not safe).

=item $signal; a string of the form C<signal-name::detail>.
=item $handler; the callback to connect.
=item $connect_flags; a combination of GConnectFlags.

=end pod
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
sub g_signal_connect_object(
  N-GObject $widget, Str $signal, Callable $handler, int32 $connect_flags = 0
  --> uint64
) {

  my @args = $widget, $signal, $handler, OpaquePointer, $connect_flags;

  given $handler.signature {
    when $signal-type { _g_signal_connect_object_signal(|@args) }
    when $event-type { _g_signal_connect_object_event(|@args) }
    when $nativewidget-type { _g_signal_connect_object_nativewidget(|@args) }

    default {
      die X::GTK::V3.new(:message('Handler doesn\'t have proper signature'));
    }
  }
}

sub _g_signal_connect_object_signal(
  N-GObject $widget, Str $signal,
  Callable $handler ( N-GObject, OpaquePointer ),
  OpaquePointer $data, int32 $connect_flags
) returns uint64
  is native(&gobject-lib)
  is symbol('g_signal_connect_object')
  { * }

sub _g_signal_connect_object_event(
  N-GObject $widget, Str $signal,
  Callable $handler ( N-GObject, GdkEvent, OpaquePointer ),
  OpaquePointer $data, int32 $connect_flags
) returns uint64
  is native(&gobject-lib)
  is symbol('g_signal_connect_object')
  { * }

sub _g_signal_connect_object_nativewidget(
  N-GObject $widget, Str $signal,
  Callable $handler ( N-GObject, OpaquePointer, OpaquePointer ),
  OpaquePointer $data, int32 $connect_flags
) returns uint64
  is native(&gobject-lib)
  is symbol('g_signal_connect_object')
  { * }

#-------------------------------------------------------------------------------
=begin pod
=head2 g_signal_connect

  sub g_signal_connect ( Str $signal, Callable $handler --> uint64 )

Connects a callback function to a signal for a particular object.

=item $signal; a string of the form "signal-name::detail".
=item $handler; callback function to connect.

=end pod
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
sub g_signal_connect (
  N-GObject $widget, Str $signal, Callable $handler
  --> uint64
) {
  g_signal_connect_data( $widget, $signal, $handler, OpaquePointer, Callable, 0)
}

#-------------------------------------------------------------------------------
# can be called the same as g_signal_connect because of its defaults
sub g_signal_connect_data(
  N-GObject $widget, Str $signal, Callable $handler,
  OpaquePointer $d, Callable $destroy_data, int32 $connect_flags = 0
  --> uint64
) {

  my @args = $widget, $signal, $handler, $d, $destroy_data, $connect_flags;

  given $handler.signature {
    when $signal-type { _g_signal_connect_data_signal(|@args) }
    when $event-type { _g_signal_connect_data_event(|@args) }
    when $nativewidget-type { _g_signal_connect_data_nativewidget(|@args) }

    default {
      die X::GTK::V3.new(:message('Handler doesn\'t have proper signature'));
    }
  }
}

sub _g_signal_connect_data_signal (
  N-GObject $widget, Str $signal,
  Callable $handler ( N-GObject, OpaquePointer ), OpaquePointer $data,
  Callable $destroy_data ( OpaquePointer, OpaquePointer ),
  int32 $connect_flags = 0
) returns int64
  is native(&gobject-lib)
  { * }

sub _g_signal_connect_data_event (
  N-GObject $widget, Str $signal,
  Callable $handler ( N-GObject, GdkEvent, OpaquePointer ),
  OpaquePointer $data,
  Callable $destroy_data ( OpaquePointer, OpaquePointer ),
  int32 $connect_flags = 0
) returns int64
  is native(&gobject-lib)
  { * }

sub _g_signal_connect_data_nativewidget (
  N-GObject $widget, Str $signal,
  Callable $handler ( N-GObject, OpaquePointer, OpaquePointer ),
  OpaquePointer $data,
  Callable $destroy_data ( OpaquePointer, OpaquePointer ),
  int32 $connect_flags = 0
) returns int64
  is native(&gobject-lib)
  { * }

#-------------------------------------------------------------------------------
sub g_signal_connect_after (
  N-GObject $widget, Str $signal, Callable $handler, OpaquePointer
) {
  g_signal_connect_data(
    $widget, $signal, $handler, OpaquePointer, Any, G_CONNECT_AFTER
  );
}

#-------------------------------------------------------------------------------
sub g_signal_connect_swapped (
  N-GObject $widget, Str $signal, Callable $handler, OpaquePointer
) {
  g_signal_connect_data(
    $widget, $signal, $handler, OpaquePointer, Any, G_CONNECT_SWAPPED
  );
}

#-------------------------------------------------------------------------------
#`{{
# a GQuark is a guint32, $detail is a quark
# See https://developer.gnome.org/glib/stable/glib-Quarks.html
sub g_signal_emit (
  N-GObject $instance, uint32 $signal_id, uint32 $detail,
  N-GObject $widget, Str $data, Str $return-value is rw
) is native(&gobject-lib)
  { * }
}}

#-------------------------------------------------------------------------------
# Handlers above provided to the signal connect calls are having 2 arguments
# a widget and data. So the provided extra arguments are then those 2
# plus a return value
sub g_signal_emit_by_name (
  # first two are obligatory by definition
  N-GObject $instance, Str $detailed_signal,
  # The rest depends on the handler defined when connecting
  # There is no return value from the handler
  N-GObject $widget, OpaquePointer
) is native(&gobject-lib)
  { * }

#-------------------------------------------------------------------------------
sub g_signal_handler_disconnect( N-GObject $widget, int32 $handler_id)
  is native(&gobject-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
has N-GObject $!g-object;

#-------------------------------------------------------------------------------
# Native object is handed over by GObject object
submethod BUILD ( N-GObject:D :$!g-object ) { }

#-------------------------------------------------------------------------------
method FALLBACK ( $native-sub is copy, Bool :$return-sub-only = False, |c ) {

  CATCH { test-catch-exception( $_, $native-sub); }

  $native-sub ~~ s:g/ '-' /_/ if $native-sub.index('-');
  die X::GTK::V3.new(:message(
      "Native sub name '$native-sub' made too short. Keep at least one '-' or '_'."
    )
  ) unless $native-sub.index('_') >= 0;

  my Callable $s;
#note "s s0: $native-sub, ", $s;
  try { $s = &::($native-sub); }
#note "s s1: g_signal_$native-sub, ", $s unless ?$s;
  try { $s = &::("g_signal_$native-sub"); } unless ?$s;
#note "s s2: ==> ", $s;

  #test-call( $s, Any, |c)
  $return-sub-only ?? $s !! $s( $!g-object, |c)
}
