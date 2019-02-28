use v6;
use NativeCall;
use Test;

use GTK::V3::X;
use GTK::V3::Glib::GObject;
use GTK::V3::Glib::GValue;
use GTK::V3::Glib::GType;
use GTK::V3::Gtk::GtkLabel;

diag "\n";

#-------------------------------------------------------------------------------
subtest 'properties of label', {

  diag 'Initialize a gvalue';
  my GTK::V3::Glib::GType $gt .= new;
  my GTK::V3::Glib::GValue $gv .= new(:init(G_TYPE_STRING));
  is $gt.g-type-check-value($gv()), 1, 'value init ok';

  diag 'Initialize a label widget';
  my GTK::V3::Gtk::GtkLabel $label1 .= new(:label('abc def'));
  is $label1.gtk-label-get-text, 'abc def', 'label text modified ok';

  diag 'Get its label property and compare';
  $label1.g-object-get-property( 'label', $gv);
  is $gv.g-value-get-string, 'abc def', 'label property match';

  diag 'Set this property and compare';
  $gv.g-value-set-string('pqr xyz');
  $label1.g-object-set-property( 'label', $gv);
  is $label1.gtk-label-get-text, 'pqr xyz', 'label text modified ok';

  $gv.g-value-unset;

  diag "Test 'lines' property";
  $gv .= new(:init(G_TYPE_INT));
  $label1.get-property( 'lines', $gv);
  is $gv.get-int, -1, 'default lines setting of -1';

  $gv.g-value-unset;
}

#-------------------------------------------------------------------------------
done-testing;
