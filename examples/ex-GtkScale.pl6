#!/usr/bin/env perl6

use v6;

my $t0 = now;

use GTK::V3::Gtk::GtkEnums;
use GTK::V3::Gtk::GtkMain;
use GTK::V3::Gtk::GtkWindow;
use GTK::V3::Gtk::GtkGrid;
use GTK::V3::Gtk::GtkButton;
use GTK::V3::Gtk::GtkToggleButton;
use GTK::V3::Gtk::GtkTextView;
use GTK::V3::Gtk::GtkTextBuffer;
use GTK::V3::Gtk::GtkScale;

# Instantiate main module for UI control
my GTK::V3::Gtk::GtkMain $m .= new;

# Class to handle signals
class AppSignalHandlers {

  has GTK::V3::Gtk::GtkScale $!scale;
  has GTK::V3::Gtk::GtkTextView $!text-view;
  has GTK::V3::Gtk::GtkToggleButton $!inverted-button;
  has Num $!min;
  has Num $!max;
  has Num $!step;

  submethod BUILD (
    :$!scale, :$!text-view, :$!inverted-button, :$!min, :$!max, :$!step
  ) {
    self!update-status;
  }

  # increment level bar
  method inc-scale ( ) {
    my Num $v = $!scale.get-value;
    $!scale.set-value(min( $v + $!step, $!max));
    self!update-status;
  }

  # decrement level bar
  method dec-scale ( ) {
    my Num $v = $!scale.get-value;
    $!scale.set-value(max( $v - $!step, $!min));
    self!update-status;
  }

  method invert-scale ( ) {
    $!scale.set-inverted($!inverted-button.get-active());
    self!update-status;
  }

  method exit-program ( ) {
#    note "exit program";
    $m.gtk-main-quit;
  }

  method !update-status {
    my Str $text = sprintf(
      "value=%3.2f, min=%3.2f, max=%3.2f, inverted=%s",
      $!scale.get-value, $!min, $!max,
      ?$!scale.get-inverted ?? 'True' !! 'False'
    );

    my GTK::V3::Gtk::GtkTextBuffer $text-buffer .= new(
      :widget($!text-view.get-buffer)
    );

    $text-buffer.set-text( $text, $text.chars);
  }
}

# Create a top level window and set a title
my GTK::V3::Gtk::GtkWindow $top-window .= new(:empty);

$top-window.set-title('Scale Demo');
$top-window.set-border-width(20);

# Create a grid and add it to the window
my GTK::V3::Gtk::GtkGrid $grid .= new(:empty);
$top-window.gtk-container-add($grid);

# Create the other widgets and add them to the grid
my GTK::V3::Gtk::GtkButton $inc-button .= new(:label("+"));
$grid.gtk-grid-attach( $inc-button, 0, 0, 1, 1);

my GTK::V3::Gtk::GtkButton $dec-button .= new(:label("-"));
$grid.gtk-grid-attach( $dec-button, 1, 0, 1, 1);

my GTK::V3::Gtk::GtkToggleButton $inverted-button .= new(:label("Inverted"));
$grid.gtk-grid-attach( $inverted-button, 2, 0, 1, 1);

my GTK::V3::Gtk::GtkScale $scale .= new(:empty);
# Set min and max of scale.
$scale.set-range( -2e0, .2e2);
# Step (keys left/right) and page (mouse scroll on scale).
$scale.set-increments( .2e0, 5e0);
$scale.set-value-pos(GTK_POS_BOTTOM);
$scale.set-digits(2);
$scale.add-mark( 0e0, GTK_POS_BOTTOM, 'Nil');
$scale.add-mark( 5e0, GTK_POS_BOTTOM, 'Five');
$scale.add-mark( 10e0, GTK_POS_BOTTOM, 'Ten');
$scale.add-mark( 15e0, GTK_POS_BOTTOM, 'Fifteen');
$scale.add-mark( 20e0, GTK_POS_BOTTOM, 'Twenty');
$grid.gtk-grid-attach( $scale, 0, 1, 3, 1);

my GTK::V3::Gtk::GtkTextView $text-view .= new(:empty);
$grid.gtk-grid-attach( $text-view, 0, 2, 3, 1);

#$grid.debug(:on);

# Instantiate the event handler class and register signals
my AppSignalHandlers $ash .= new(
  :$scale, :$text-view, :$inverted-button, :min(-2e0), :max(.2e2), :step(.2e0)
);
$inc-button.register-signal( $ash, 'inc-scale', 'clicked');
$dec-button.register-signal( $ash, 'dec-scale', 'clicked');
$inverted-button.register-signal( $ash, 'invert-scale', 'toggled');

$top-window.register-signal( $ash, 'exit-program', 'delete-event');

# Show everything and activate all
$top-window.show-all;

note "Set up time: ", now - $t0;
$m.gtk-main;
