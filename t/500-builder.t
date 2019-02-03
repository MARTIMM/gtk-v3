use v6;

use GTK::V3::Gtk::GtkMain;
use GTK::V3::Glib::GError;
#use GTK::V3::Gtk::GtkButton;
use GTK::V3::Gtk::GtkBuilder;

use Test;

#diag "\n";

#-------------------------------------------------------------------------------
my $dir = 't/ui';
mkdir $dir unless $dir.IO ~~ :e;

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
my Str $ui-file = "$dir/ui.xml";
$ui-file.IO.spurt(Q:q:to/EOXML/);
  <?xml version="1.0" encoding="UTF-8"?>
  <!-- Generated with glade 3.22.1 -->
  <interface>
    <requires lib="gtk+" version="3.20"/>
    <object class="GtkWindow" id="window">
      <property name="can_focus">False</property>
      <child>
        <placeholder/>
      </child>
      <child>
        <object class="GtkButton" id="button">
          <property name="label" translatable="yes">button</property>
          <property name="visible">True</property>
          <property name="can_focus">True</property>
          <property name="receives_default">True</property>
        </object>
      </child>
    </object>
  </interface>
  EOXML


# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
subtest 'Initialize error', {
  my GTK::V3::Gtk::GtkBuilder $builder;
  throws-like
    { $builder .= new; },
    X::Gui, "forget to initialize",
    :message("GTK is not initialized");
}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
subtest 'Empty builder', {
  # initialize
  my GTK::V3::Gtk::GtkMain $main .= new;

  my GTK::V3::Gtk::GtkBuilder $builder .= new;
  isa-ok $builder, GTK::V3::Gtk::GtkBuilder;
  isa-ok $builder(), N-GtkBuilder;
}

#-------------------------------------------------------------------------------
subtest 'Add ui from file to builder', {
  my GTK::V3::Gtk::GtkBuilder $builder .= new;

  my Int $e-code = $builder.add-from-file( $ui-file, Any);
  is $e-code, 1, "ui file added ok";

  #my GTK::V3::Glib::GError $g-error .= new;
  #$e-code = $builder.add-from-file( 'x', $g-error());
#note "E: $e-code, ", $g-error().message;
  my Str $text = $ui-file.IO.slurp;
  my N-GtkBuilder $b = $builder.new-from-string( $text, $text.chars);
  ok ?$b, 'builder is set';

  $builder .= new;
  $builder.add-gui(:filename($ui-file));
  ok ?$builder(), 'builder is added';

  $builder .= new;
  throws-like
    { $builder.add-gui(:filename('x.glade')); },
    X::Gui, "non existent file added",
    :message("Error adding file 'x.glade' to the Gui");

  $builder .= new;
  # invalidate xml text
  $text ~~ s/ '<interface>' //;
  throws-like
    { $builder.add-gui(:string($text)); },
    X::Gui, "erronenous xml file added",
    :message("Error adding xml text to the Gui");
}

#-------------------------------------------------------------------------------
done-testing;

#unlink $ui-file;
#rmdir $dir;
