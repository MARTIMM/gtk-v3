use v6;
use NativeCall;
use Test;

use GTK::V3::Gui;
use GTK::V3::Glib::GList;
use GTK::V3::Gtk::GtkMain;
use GTK::V3::Gtk::GtkWidget;
use GTK::V3::Gtk::GtkBin;
use GTK::V3::Gtk::GtkButton;
use GTK::V3::Gtk::GtkContainer;
use GTK::V3::Gtk::GtkLabel;

diag "\n";


#-------------------------------------------------------------------------------
subtest 'Initialize error', {
  my GTK::V3::Gtk::GtkButton $button;
  throws-like
    { $button .= new(:text('text')); },
    X::Gui, "forget to initialize GTK",
    :message("GTK is not initialized");
}

#-------------------------------------------------------------------------------
subtest 'Button create', {

  # initialize
  my GTK::V3::Gtk::GtkMain $main .= new;

  my GTK::V3::Gtk::GtkButton $button1 .= new(:text('abc def'));
  isa-ok $button1, GTK::V3::Gtk::GtkButton;
  isa-ok $button1, GTK::V3::Gtk::GtkBin;
  isa-ok $button1, GTK::V3::Gtk::GtkContainer;
  isa-ok $button1, GTK::V3::Gtk::GtkWidget;
  does-ok $button1, GTK::V3::Gui;
  isa-ok $button1(), N-GtkWidget;

  throws-like
    { $button1.get-label('xyz'); },
    X::Gui, "wrong arguments",
    :message('Calling gtk_button_get_label(N-GtkWidget, Str) will never work with declared signature (N-GtkWidget $widget --> Str)');

  is $button1.get-label, 'abc def', 'text on button ok';
  $button1.set-label('xyz');
  is $button1.get-label, 'xyz', 'text on button changed ok';
}

#-------------------------------------------------------------------------------
subtest 'Button as container', {
  my GTK::V3::Gtk::GtkButton $button1 .= new(:text('xyz'));
  my GTK::V3::Gtk::GtkLabel $l .= new(:text(''));

  my GTK::V3::Glib::GList $gl .= new;
  $gl($button1.get-children);
  $l($gl.nth-data(0));
  is $l.get-text, 'xyz', 'text label from button 1';

  my GTK::V3::Gtk::GtkLabel $label .= new(:text('pqr'));
  my GTK::V3::Gtk::GtkButton $button2 .= new;
  $button2.add($label());

  $l($button2.get-child);
  is $l.get-text, 'pqr', 'text label from button 2';

  # Next statement is not able to get the text directly
  # when gtk-container-add is used.
  is $button2.get-label, Str, 'text cannot be returned like this anymore';

  $gl.free;
  $gl = GTK::V3::Glib::GList;
}

#-------------------------------------------------------------------------------
subtest 'Button set sinal', {
  my GTK::V3::Gtk::GtkButton $button .= new(:text('xyz'));
  my CArray[Str] $data .= new;
  $data[0] = 'str 1';
  $data[1] = 'str 2';
  $button.handle-click( &click-handler, $data, 0);
}

#-------------------------------------------------------------------------------
sub click-handler ( N-GtkWidget $widget, CArray[Str] $data ) {
  note "Click handler says: $data[0] and $data[1]";
}

#-------------------------------------------------------------------------------
done-testing;
