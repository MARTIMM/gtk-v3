use v6;
use NativeCall;
use Test;

use GTK::V3::Gui;
use GTK::V3::Glib::GList;
use GTK::V3::Gtk::GtkMain;
use GTK::V3::Gtk::GtkWidget;
use GTK::V3::Gtk::GtkContainer;
use GTK::V3::Gtk::GtkGrid;
use GTK::V3::Gtk::GtkButton;
use GTK::V3::Gtk::GtkLabel;

diag "\n";


# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
subtest 'Initialize error', {
  my GTK::V3::Gtk::GtkGrid $grid;
  throws-like
    { $grid .= new; },
    X::Gui, "forget to initialize",
    :message("GTK is not initialized");
}

#-------------------------------------------------------------------------------
subtest 'Grid create', {

  # initialize
  my GTK::V3::Gtk::GtkMain $main .= new;

  my GTK::V3::Gtk::GtkButton $button .= new(:text('press here'));
  my GTK::V3::Gtk::GtkLabel $label .= new(:text('note'));

  my GTK::V3::Gtk::GtkGrid $grid .= new;
  $grid.attach( $button(), 0, 0, 1, 1);
  $grid.attach( $label(), 0, 1, 1, 1);

  my GTK::V3::Gtk::GtkLabel $label-widget .= new;
  $label-widget($grid.get-child-at( 0, 1));
  is $label-widget.get-text, 'note', 'text from label';

  my GTK::V3::Glib::GList $gl .= new;
  $gl($grid.get-children);
  is $gl.length, 2, 'two list items';

#note $gl.nth-data(1);
  $label-widget($gl.nth-data(0));
  is $label-widget.get-text, 'note', 'text from label';

  $gl.free;
  $gl = GTK::V3::Glib::GList;

#  $grid(@widgets[0]);
#  $label-widget($grid.get-child-at( 0, 1));
#  is $label-widget.get-text, 'note', 'text from label';
}

#-------------------------------------------------------------------------------
done-testing;
