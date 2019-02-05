use v6;
use NativeCall;

use GTK::V3::Gui;
use GTK::V3::N::NativeLib;
#use GTK::V3::Gtk::GtkMain;
use GTK::V3::Gtk::GtkWidget;
use GTK::V3::Gtk::GtkBin;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkbutton.h
# https://developer.gnome.org/gtk3/stable/GtkButton.html
unit class GTK::V3::Gtk::GtkButton:auth<github:MARTIMM>
  is GTK::V3::Gtk::GtkBin
  does GTK::V3::Gui;

#-------------------------------------------------------------------------------
sub gtk_button_get_label ( N-GtkWidget $widget )
  returns Str
  is native(&gtk-lib)
  { * }

sub gtk_button_new ( )
  returns N-GtkWidget
  is native(&gtk-lib)
  { * }

sub gtk_button_new_with_label ( Str $label )
  returns N-GtkWidget
  is native(&gtk-lib)
  { * }

sub gtk_button_set_label ( N-GtkWidget $widget, Str $label )
  is native(&gtk-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
multi submethod BUILD ( ) {

  $!gtk-widget = gtk_button_new;
}

#-------------------------------------------------------------------------------
multi submethod BUILD ( Str:D :$text! ) {

  $!gtk-widget = gtk_button_new_with_label($text);
}

#-------------------------------------------------------------------------------
method fallback ( $native-sub is copy --> Callable ) {

  $native-sub ~~ s:g/ '-' /_/ if $native-sub.index('-');

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_button_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s
}

#-------------------------------------------------------------------------------
method handle-click ( $handler, CArray[Str] $data, Int $connect_flags ) {
  #TODO check signature of handler
  self.g-signal-connect-object( 'clicked', $handler, $data, $connect_flags);
}
