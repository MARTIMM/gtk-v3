use v6;
use NativeCall;

use GTK::V3::X;
use GTK::V3::N::NativeLib;

#-------------------------------------------------------------------------------
# See /usr/include/glib-2.0/gmain.h
unit class GTK::V3::Glib::GMain:auth<github:MARTIMM>;

#-------------------------------------------------------------------------------

# /usr/include/glib-2.0/glib/gmain.h
constant G_PRIORITY_HIGH is export          = -100;
constant G_PRIORITY_DEFAULT is export       = 0;
constant G_PRIORITY_HIGH_IDLE is export     = 100;
constant G_PRIORITY_DEFAULT_IDLE is export  = 200;
constant G_PRIORITY_LOW is export           = 300;

constant G_SOURCE_REMOVE is export          = 0; # ~~ False
constant G_SOURCE_CONTINUE is export        = 1; # ~~ True

#`{{
sub g_idle_add ( &Handler ( OpaquePointer $h_data), OpaquePointer $data )
  returns int32
  is native(&glib-lib)
  is export
  { * }
}}

sub g_idle_source_new ( )
  returns OpaquePointer   # GSource
  is native(&gtk-lib)
  { * }

sub g_main_context_default ( )
  returns OpaquePointer     # GMainContext
  is native(&gtk-lib)
  { * }

# $context ~~ GMainContext is an opaque pointer
sub g_main_context_get_thread_default ( )
  returns OpaquePointer     # GMainContext
  is native(&gtk-lib)
  { * }

sub g_main_context_invoke (
  OpaquePointer $context,
  &sourceFunction ( CArray[Str] $data_h is rw --> int32 ),
  CArray[Str] $data
  ) is native(&gtk-lib)
    { * }

# User data is set to CArray[Str] type
sub g_main_context_invoke_full (
  OpaquePointer $context,
  int32 $priority,
  &sourceFunction ( CArray[Str] $data_sf --> int32 ),
  CArray[Str] $data,
  &destroyNotify ( CArray[Str] $data_dn )
  ) is native(&gtk-lib)
    { * }

sub g_main_context_new ( )
  returns OpaquePointer     # GMainContext
  is native(&gtk-lib)
  { * }

sub g_main_context_pop_thread_default ( OpaquePointer $context )
  is native(&gtk-lib)
  { * }

sub g_main_context_push_thread_default ( OpaquePointer $context )
  is native(&gtk-lib)
  { * }

# GMainLoop is returned
sub g_main_loop_new ( OpaquePointer $context, int32 $is_running )
  returns OpaquePointer
  is native(&gtk-lib)
  { * }

sub g_main_loop_quit ( OpaquePointer $loop )
  is native(&gtk-lib)
  { * }

sub g_main_loop_run ( OpaquePointer $loop )
  is native(&gtk-lib)
  { * }

sub g_source_attach ( OpaquePointer $source, OpaquePointer $context )
  returns uint32
  is native(&gtk-lib)
  { * }

# remove when on other main loop
sub g_source_destroy ( OpaquePointer $source )
  is native(&gtk-lib)
  { * }

# remove when on default main loop
sub g_source_remove ( uint32 $tag )
  returns Bool
  is native(&gtk-lib)
  { * }

# User data is set to CArray[Str] type
sub g_timeout_add (
  int32 $interval, &Handler ( CArray[Str] $h_data, --> int32 ),
  CArray[Str] $data
  ) returns int32
    is native(&gtk-lib)
    { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
method FALLBACK ( $native-sub is copy, |c ) {

  $native-sub ~~ s:g/ '-' /_/ if $native-sub.index('-');

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("g_main_$native-sub"); } unless ?$s;

  CATCH { test-catch-exception( $_, $native-sub); }

  test-call( $s, Any, |c)
}