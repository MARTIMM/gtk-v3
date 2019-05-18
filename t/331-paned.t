use v6;
use NativeCall;
use Test;

use GTK::V3::N::N-GObject;
use GTK::V3::Gtk::GtkEnums;
use GTK::V3::Gtk::GtkPaned;
use GTK::V3::Gtk::GtkListBox;

diag "\n";

#-------------------------------------------------------------------------------
subtest 'Create paned windows', {
  my GTK::V3::Gtk::GtkListBox $lb-left .= new(:empty);
  $lb-left.set-name('leftListbox');
  my GTK::V3::Gtk::GtkListBox $lb-right .= new(:empty);
  $lb-right.set-name('rightListbox');
  my GTK::V3::Gtk::GtkPaned $p .= new(:orientation(GTK_ORIENTATION_HORIZONTAL));
  $p.gtk-paned-add1($lb-left);
  $p.gtk-paned-add2($lb-right);

  # when retrieved, native widget addresses are changed. cannot compare with
  # native object using $lb-left(). so only test its type.
  isa-ok $p.get-child1, N-GObject;
  isa-ok $p.get-child2, N-GObject;

  # testing the set names is more accurate.
  my GTK::V3::Gtk::GtkListBox $lb .= new(:widget($p.get-child1));
  is $lb.get-name, 'leftListbox', 'left listbox found';
  $lb .= new(:widget($p.get-child2));
  is $lb.get-name, 'rightListbox', 'right listbox found';
}

#-------------------------------------------------------------------------------
done-testing;
