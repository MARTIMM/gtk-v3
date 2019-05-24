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
use GTK::V3::Gtk::GtkLevelBar;
use GTK::V3::Gtk::GtkOrientable;

# Instantiate main module for UI control
my GTK::V3::Gtk::GtkMain $m .= new;

# Class to handle signals
class AppSignalHandlers {

  has GTK::V3::Gtk::GtkLevelBar $!level-bar;
  has GTK::V3::Gtk::GtkTextView $!text-view;
  has GTK::V3::Gtk::GtkToggleButton $!inverted-button;

  submethod BUILD ( :$!level-bar, :$!text-view, :$!inverted-button) {
    self!update-status;
  }

  # increment level bar
  method inc-level-bar ( ) {
    my Num $v = $!level-bar.get-value;
    my Num $vmx = $!level-bar.get-max-value;
    $!level-bar.set-value(min( $v + 0.1, $vmx));
    self!update-status;
  }

  # decrement level bar
  method dec-level-bar ( ) {
    my Num $v = $!level-bar.get-value;
    my Num $vmn = $!level-bar.get-min-value;
    $!level-bar.set-value(max( $v - 0.1, $vmn));
    self!update-status;
  }

  method invert-level-bar ( ) {
    $!level-bar.set-inverted($!inverted-button.get-active());
    self!update-status;
  }

  method exit-program ( ) {
    $m.gtk-main-quit;
  }

  method !update-status {
    my Str $text = sprintf( "value=%3.2f", $!level-bar.get-value);

    my GTK::V3::Gtk::GtkTextBuffer $text-buffer .= new(
      :widget($!text-view.get-buffer)
    );

    $text-buffer.set-text( $text, $text.chars);
  }
}

# Create a top level window and set a title
my GTK::V3::Gtk::GtkWindow $top-window .= new(:empty);

$top-window.set-title('Level Bar Demo');
$top-window.set-border-width(20);

# Create a grid and add it to the window
my GTK::V3::Gtk::GtkGrid $grid .= new(:empty);
$top-window.gtk-container-add($grid);

# Create the other widgets and add them to the grid
my GTK::V3::Gtk::GtkButton $inc-button .= new(:label("+"));
$grid.gtk-grid-attach( $inc-button, 1, 0, 1, 1);

my GTK::V3::Gtk::GtkButton $dec-button .= new(:label("-"));
$grid.gtk-grid-attach( $dec-button, 1, 1, 1, 1);

my GTK::V3::Gtk::GtkToggleButton $inverted-button .= new(:label("Inverted"));
$grid.gtk-grid-attach( $inverted-button, 1, 2, 1, 1);

my GTK::V3::Gtk::GtkLevelBar $level-bar .= new(:empty);
my GTK::V3::Gtk::GtkOrientable $o .= new(:widget($level-bar));
$o.set-orientation(GTK_ORIENTATION_VERTICAL);
$grid.gtk-grid-attach( $level-bar, 0, 0, 1, 3);

my GTK::V3::Gtk::GtkTextView $text-view .= new(:empty);
$grid.gtk-grid-attach( $text-view, 0, 4, 3, 1);

#$grid.debug(:on);

# Instantiate the event handler class and register signals
my AppSignalHandlers $ash .= new( :$level-bar, :$text-view, :$inverted-button);
$inc-button.register-signal( $ash, 'inc-level-bar', 'clicked');
$dec-button.register-signal( $ash, 'dec-level-bar', 'clicked');
$inverted-button.register-signal( $ash, 'invert-level-bar', 'toggled');

$top-window.register-signal( $ash, 'exit-program', 'delete-event');

# Show everything and activate all
$top-window.show-all;

note "Set up time: ", now - $t0;
$m.gtk-main;
