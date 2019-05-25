
![gtk logo][logo]

# GTK::V3 - Accessing Gtk version 3.*
[![License](http://martimm.github.io/label/License-label.svg)](http://www.perlfoundation.org/artistic_license_2_0)

# Description
First of all, I would like to thank the developers of the `GTK::Simple` project because of the information I got while reading the code. Also because one of the files is copied unaltered for which I did not had to think about to get that right. The examples in that project are also useful to compare code with each other and to see what is or is not possible.

The purpose of this project is to create an interface to the **GTK** version 3 library. Previously I had this library in the GTK::Glade project but because of its growth I decided to create a separate project.

# Example

This example does the same as the example from `GTK::Simple` to show you the differences between the implementations. What immediately is clear is that this example is somewhat longer. To sum up;
### Pros
  * The defaults of GTK are kept. Therefore the buttons are in the proper size compared to GTK::Simple.
  * Separation of callbacks from other code. Closures are not needed to get data into the callback code. Data can be provided with named arguments to the `register-signal()` method.
  * The package is designed with the usage of glade interface designer in mind. So to build the interface by hand like below, is not necessary. Use of `GTK::Glade` is preferable when building larger user interfaces.
  * No fancy stuff like tapping into channels.
  * There is a registration of callback methods to process signals like button clicks as well as events like keyboard input and mouse clicks.. This is not available in `GTK::Simple`. The provided way to handle a signal there, is fixed into a method. E.g. the button has a 'clicked' method and the container has none while an observer might want to know if an object is inserted into a grid using the 'add' signal.
  * There is also a registration of events to handle e.g. keyboard input and mouse clicks.

### Cons
  * The code is larger.
  * Code is somewhat slower.
  * Not all types of signals are supported yet.
  * Not all documentation is written.
  * Not all classes and/or methods are supplied.

A screenshot of the example ![this screenshot][screenshot 1]. The code can be found at `examples/01-hello-world.pl6`.
```
use v6;

use GTK::V3::Gtk::GtkMain;
use GTK::V3::Gtk::GtkWindow;
use GTK::V3::Gtk::GtkGrid;
use GTK::V3::Gtk::GtkButton;

# Instantiate main module for UI control
my GTK::V3::Gtk::GtkMain $m .= new;

# Class to handle signals
class AppSignalHandlers {

  # Handle 'Hello World' button click
  method first-button-click ( :widget($b1), :other-button($b2) ) {
    $b1.set-sensitive(False);
    $b2.set-sensitive(True);
  }

  # Handle 'Goodbye' button click
  method second-button-click ( ) {
    $m.gtk-main-quit;
  }
}

# Create a top level window and set a title
my GTK::V3::Gtk::GtkWindow $top-window .= new(:empty);
$top-window.set-title('Hello GTK!');
$top-window.set-border-width(20);

# Create a grid and add it to the window
my GTK::V3::Gtk::GtkGrid $grid .= new(:empty);
$top-window.gtk-container-add($grid);

# Create buttons and disable the second one
my GTK::V3::Gtk::GtkButton $button .= new(:label('Hello World'));
my GTK::V3::Gtk::GtkButton $second .= new(:label('Goodbye'));
$second.set-sensitive(False);

# Add buttons to the grid
$grid.gtk-grid-attach( $button, 0, 0, 1, 1);
$grid.gtk-grid-attach( $second, 0, 1, 1, 1);

# Instantiate the event handler class and register signals
my AppSignalHandlers $ash .= new;
$button.register-signal(
  $ash, 'first-button-click', 'clicked',  :other-button($second)
);
$second.register-signal( $ash, 'second-button-click', 'clicked');

# Show everything and activate all
$top-window.show-all;
$m.gtk-main;
```

# Design

I want to follow the interface of the classes in **Gtk**, **Gdk** and **Glib** as closely as possible by keeping the names of the native functions the same as provided with the following exceptions;
* The native subroutines are defined in their classes. They are setup in such a way that they have become methods in those classes. Many subs also have as their first argument the native object. This object is held in the class and is automatically inserted when needed. E.g. a definition like the following in the GtkButton class
```
sub gtk_button_set_label ( N-GObject $widget, Str $label )
  is native(&gtk-lib)
  { * }
```
  can be used as
```
my GTK::V3::Gtk::GtkButton $button .= new(:empty);
$button.gtk_button_set_label('Start Program');
```

* Classes can use the methods of inherited classes. E.g. The GtkButton class inherits GtkBin and GtkBin inherits GtkContainer etcetera. Therefore a method like `gtk_widget_set_tooltip_text` from `GtkWidget` can be used.
```
$button.gtk_widget_set_tooltip_text('When pressed, program will start');
```

* The names are sometimes long and prefixed with words which are also used in the class name. Therefore, those names can be shortened by removing those prefixes. An example method in the `GtkButton` class is `gtk_button_get_label()`. This can be shortened to `get_label()`.
```
my Str $button-label = $button.get_label;
```
  In the documentation this will be shown with brackets around the part that can be left out. In this case is is shown as `[gtk_button_] get_label`.

* Names can not be shortened too much. E.g. `gtk_button_new` and `gtk_label_new` yield `new` which is a perl method from class `Mu`. I am thinking about chopping off the `g_`, `gdk_` and `gtk_` prefixes.

* All the method names are written with an underscore. Following a perl6 tradition, dashed versions is also possible.
```
my Str $button-label = $button.gtk-button-get-label;
```
  or
```
my Str $button-label = $button.get-label;
```

* Sometimes I had to stray away from the native function names because of the way one has to define it in perl6. This is caused by the possibility of returning or specifying different types of values depending on how the function is used. E.g. `g_slist_nth_data()` can return several types of data. This is solved using several subs linking to the same native sub. In this library, the methods `g_slist_nth_data_str()` and `g_slist_nth_data_gobject()` are created. This can be extended for integers, reals and other types.

```
sub g_slist_nth_data_str ( N-GSList $list, uint32 $n --> Str )
  is native(&gtk-lib)
  is symbol('g_slist_nth_data')
  { * }

sub g_slist_nth_data_gobject ( N-GSList $list, uint32 $n --> N-GObject )
  is native(&gtk-lib)
  is symbol('g_slist_nth_data')
  { * }
```
  Other causes are variable argument lists where I had to choose for the extra arguments. E.g. in the `GtkFileChooserDialog` the native sub `gtk_file_chooser_dialog_new` has a way to extend it with a number of buttons on the dialog. I had to fix that list to a known number of arguments and renamed the sub `gtk_file_chooser_dialog_new_two_buttons`.

* Not all native subs or even classes will be implemented or implemented much later because of the following reasons;
  * Many subs and some classes are obsolete.
  * The original idea was to have the interface build by the glade interface designer. This lib was in the GTK::Glade project before re-factoring. Therefore a GtkButton does not have to have all subs to create a button. On the other hand a GtkListBox is a widget which is changed dynamically most of the time and therefore need more subs to manipulate the widget and its contents.
  * The need to implement classes like GtkAssistant, GtkAlignment or GtkScrolledWindow is on a low priority because these can all be instantiated by `GtkBuilder` using your Glade design.

* There are native subroutines which need a native object as an argument. The `gtk_grid_attach` in `GtkGrid` is an example of such a routine. It is possible to provide the perl6 object in that place. The signature of the native sub is checked and will automatically retrieve the native object from that class if needed.

  The definition of the native sub;
```
sub gtk_grid_attach (
  N-GObject $grid, N-GObject $child,
  int32 $x, int32 $y,
  int32 $width, int32 $height
) is native(&gtk-lib)
  { * }
```
  And its use;
```
my GTK::V3::Gtk::GtkGrid $grid .= new(:empty);
my GTK::V3::Gtk::GtkLabel $label .= new(:label('server name'));
$grid.gtk-grid-attach( $label, 0, 0, 1, 1);
```

# Errors and crashes

I came to the conclusion that Perl6 is not (yet) capable to return a proper message when mistakes are made by me e.g. spelling errors or using wrong types when using the native call interface. Most of them end up in **MoarVM panic: Internal error: Unwound entire stack and missed handler**. Other times it ends in just a plain crash. Some of the crashes are happening within GTK and cannot be captured by Perl6. One of those moments are the use of GTK calls without initializing GTK with `gtk_init`. The panic mentioned above mostly happens when perl6 code is called from C as a callback. The stack might not be interpreted completely at that moment hence the message.

A few measures are implemented to help a bit preventing problems;

  * The failure to initialize GTK on time is solved by using an initialization flag which is checked in the `GtkMain` module. The module is referred to by `GObject` which almost all modules inherit from. GObject calls a method in GtkMain to check for this flag and initialize if needed. Therefore the user never has to initialize GTK.
  * Throwing an exception while in Perl6 code called from C (in a callback), Perl6 will crash with the '*internal error*' message mentioned above without being able to process the exception.

    To at least show why it happens, all messages which are set in the exception are printed first before calling `die()` which will perl6 force to wander off aimlessly.
    To control this behaviour, a debug flag in `GObject` can be set to show these messages which might help solving your problems.

# Documentation

## Gtk library

| Pdf from pod | Link to Gnome Developer |
|-------|--------------|
| [GTK::V3::Gtk::GtkAboutDialog][GTK::V3::Gtk::GtkAboutDialog pdf] | [GtkAboutDialog.html][gtkaboutdialog]
| [GTK::V3::Gtk::GtkBin][GTK::V3::Gtk::GtkBin pdf] | [GtkBin.html][gtkbin]
| [GTK::V3::Gtk::GtkBuilder][GTK::V3::Gtk::GtkBuilder pdf] |  [GtkBuilder.html][gtkbuilder]
| [GTK::V3::Gtk::GtkButton][GTK::V3::Gtk::GtkButton pdf] |  [GtkButton.html][gtkbutton]
| [GTK::V3::Gtk::GtkCheckButton][GTK::V3::Gtk::GtkCheckButton pdf] |  [GtkCheckButton.html][gtkcheckbutton]
| [GTK::V3::Gtk::GtkComboBox][GTK::V3::Gtk::GtkComboBox pdf] |  [GtkComboBox.html][GtkComboBox]
| [GTK::V3::Gtk::GtkComboBoxText][GTK::V3::Gtk::GtkComboBoxText pdf] |  [GtkComboBoxText.html][GtkComboBoxText]
| GTK::V3::Gtk::GtkContainer |  [GtkContainer.html][gtkcontainer]
| GTK::V3::Gtk::GtkCssProvider |  [GtkCssProvider.html][gtkcssprovider]
| GTK::V3::Gtk::GtkStyleContext |  [GtkStyleContext.html][gtkstylecontext]
| [GTK::V3::Gtk::GtkDialog][GTK::V3::Gtk::GtkDialog pdf] |  [GtkDialog.html][gtkdialog]
| GTK::V3::Gtk::GtkEntry |  [GtkEntry.html][gtkentry]
| GTK::V3::Gtk::GtkFileChooser |  [GtkFileChooser.html][GtkFileChooser]
| [GTK::V3::Gtk::GtkFileChooserDialog][GTK::V3::Gtk::GtkFileChooserDialog pdf] |  [GtkFileChooserDialog.html][GtkFileChooserDialog]
| GTK::V3::Gtk::GtkFileFilter |  [GtkFileFilter.html][GtkFileFilter]
| GTK::V3::Gtk::GtkGrid |  [GtkGrid.html][gtkgrid]
| GTK::V3::Gtk::GtkImage |  [GtkImage.html][gtkimage]
| GTK::V3::Gtk::GtkImageMenuItem |  [GtkImageMenuItem.html][gtkimagemenuitem]
| GTK::V3::Gtk::GtkLabel |  [GtkLabel.html][gtklabel]
| [ GTK::V3::Gtk::GtkLevelBar ][ GTK::V3::Gtk::GtkLevelBar pdf] |  [GtkLevelBar.html][GtkLevelBar]
| GTK::V3::Gtk::GtkListBox |  [GtkListBox.html][gtklistbox]
| [GTK::V3::Gtk::GtkMain][GTK::V3::Gtk::GtkMain pdf] |  [GtkMain.html][gtkmain]
| GTK::V3::Gtk::GtkMenuItem |  [GtkMenuItem.html][gtkmenuitem]
| [GTK::V3::Gtk::GtkOrientable][GTK::V3::Gtk::GtkOrientable pdf] |  [GtkOrientable.html][gtkmenuitem]
| [GTK::V3::Gtk::GtkPaned][GTK::V3::Gtk::GtkPaned pdf] |  [GtkPaned.html][GtkPaned]
| GTK::V3::Gtk::GtkRadioButton |  [GtkRadioButton.html][gtkradiobutton]
| [GTK::V3::Gtk::GtkRange][GTK::V3::Gtk::GtkRange pdf] |  [GtkRange.html][GtkRange]
| [GTK::V3::Gtk::GtkScale][GTK::V3::Gtk::GtkScale pdf] |  [GtkScale.html][GtkScale]
| GTK::V3::Gtk::GtkStyleContext |  [GtkStyleContext.html][GtkStyleContext]
| GTK::V3::Gtk::GtkTextBuffer |  [GtkTextBuffer.html][gtktextbuffer]
| GTK::V3::Gtk::GtkTextTagTable |  [GtkTextTagTable.html][gtktexttagtable] |
| GTK::V3::Gtk::GtkTextView |  [GtkTextView.html][gtktextview]
| [GTK::V3::Gtk::GtkToggleButton][GTK::V3::Gtk::GtkToggleButton pdf] |  [GtkToggleButton.html][gtktogglebutton]
| [GTK::V3::Gtk::GtkWidget][GTK::V3::Gtk::GtkWidget pdf] |  [GtkWidget.html][gtkwidget]
| [GTK::V3::Gtk::GtkWindow][GTK::V3::Gtk::GtkWindow pdf] |  [GtkWindow.html][gtkwindow]

## Gdk library

| Pdf from pod | Link to Gnome Developer |
|-------|--------------|
| GTK::V3::Gdk::GdkDisplay |  [Controls a set of GdkScreens and their associated input devices][GdkDisplay]
| [GTK::V3::Gdk::GdkEventTypes][GTK::V3::Gdk::GdkEventTypes pdf] |  [Device events][GdkEventTypes]
| GTK::V3::Gdk::GdkScreen |  [Object representing a physical screen][GdkScreen]
| GTK::V3::Gdk::GdkTypes |
| GTK::V3::Gdk::GdkWindow |  [Windows][GdkWindow]

## Glib library

| Pdf from pod | Link to Gnome Developer |
|-------|--------------|
| GTK::V3::Glib::GError |
| GTK::V3::Glib::GInitiallyUnowned |
| GTK::V3::Glib::GInterface |
| GTK::V3::Glib::GList |  [Doubly-Linked Lists][glist]
| GTK::V3::Glib::GMain |  [The Main Event Loop][gmain]
| [GTK::V3::Glib::GObject][GTK::V3::Glib::GObject pdf] | [The base object type][GObject]
| [GTK::V3::Glib::GSignal][GTK::V3::Glib::GSignal pdf]  | [Signal handling][GSignal]
| GTK::V3::Glib::GSList |  [Singly-Linked Lists][gslist]
| GTK::V3::Glib::GType |  [1) Type Information][GType1], [2) Basic Types][GType2]
| GTK::V3::Glib::GValue |  [1) Generic values][GValue1], [2) Parameters and Values][GValue2]

## Miscellaneous

* class **X::GTK::V3** (use GTK::V3::X) is **Exception**
  * `test-catch-exception ( Exception $e, Str $native-sub )`
  * `test-call ( $handler, $gobject, |c )`

## Release notes
* [Release notes][release]

# Notes
  1) The `CALL-ME` method is coded in such a way that a native widget can be set or retrieved easily. E.g.
```
my GTK::V3::Gtk::GtkLabel $label .= new(:label('my label'));
my GTK::V3::Gtk::GtkGrid $grid .= new;
$grid.gtk_grid_attach( $label(), 0, 0, 1, 1);
```
  Notice how the native widget is retrieved with `$label()`. However this method is mostly internally only. See also [9].

  2) The `FALLBACK` method is used to test for the defined native functions as if the functions where methods. It calls the `fallback` methods in the class which in turn call the parent fallback using `callsame`. The resulting function addres is returned and processed with the `test-call` functions from **GTK::V3::X**. Thrown exceptions are handled by the function `test-catch-exception` from the same module.

  3) `N-GObject` is a native widget which is held internally in most of the classes. Sometimes they need to be handed over in a call or stored when it is returned.

  4) Each method can at least be called with perl6 like dashes in the method name. E.g. `gtk_container_add` can be written as `gtk-container-add`.

  5) In some cases the calls can be shortened too. E.g. `gtk_button_get_label` can also be called like `get_label` or `get-label`. Sometimes, when shortened, calls can end up with a call using the wrong native widget. When in doubt use the complete method name.

  6) Also a sub like `gtk_button_new` cannot be shortened because it will call the perl6 init method `new()`. These methods are used when initializing classes, in this case to initialize a `GTK::V3::Gtk::GtkButton` class. In the documentation, the use of brackets **[ ]** show which part can be chopped. E.g. `[gtk_button_] get_label`.

  7) All classes deriving from `GTK::V3::Glib::GObject` know about the `:widget(…)` named attribute when instantiating a widget class. This is used when the result of another native sub returns a N-GObject. E.g. cleaning a list box;
```
my GTK::V3::Gtk::GtkListBox $list-box .= new(:build-id<someListBox>);
loop {
  # Keep the index 0, entries will shift up after removal
  my $nw = $list-box.get-row-at-index(0);
  last unless $nw.defined;

  # Instantiate a container object using the :widget argument
  my GTK::V3::Gtk::GtkBin $lb-row .= new(:widget($nw));
  $lb-row.gtk-widget-destroy;
}
```

  8) The named argument `:build-id(…)` is used to get a N-GObject from a `GTK::V3::Gtk::GtkBuilder` object. It does something like `$builder.gtk_builder_get_object(…)`. A builder must be initialized and loaded with a GUI description before to be useful. For this, see also `GTK::Glade`. This option works for all child classes too if those classes are managed by `GtkBuilder`. E.g.
```
my GTK::V3::Gtk::GtkLabel $label .= new(:build-id<inputLabel>);
```

  9) Sometimes a `N-GObject` must be given as a parameter. As mentioned above in [1] the CALL-ME method helps to return that object. To prevent mistakes (forgetting the '()' after the object), the parameters to the call are checked for the use of a `GTK::V3::Glib::GObject` instead of the native object. When encountered, the parameters are automatically converted. E.g.
```
my GTK::V3::Gtk::GtkButton $button .= new(:label('press here'));
my GTK::V3::Gtk::GtkLabel $label .= new(:label('note'));

my GTK::V3::Gtk::GtkGrid $grid .= new(:empty);
$grid.attach( $button, 0, 0, 1, 1);
$grid.attach( $label, 0, 1, 1, 1);
```
Here in the call to `gtk_grid_attach` \$button and \$label is used instead of \$button() and \$label().

  10) The C functions can only return simple values like int32, num64 etc. When a structure must be returned, it is returned in a value given in the argument list. Mostly this is implemented by using a pointer to the structure. Perl users are used to be able to return all sorts of types. To provide this behavior, the native sub is wrapped in another sub which can return the result and directly assigned to some variable. **_This is not yet implemented!_**
    The following line where a GTK::V3::Gdk::GdkRectangle is returned;
```
my GTK::V3::Gdk::GdkRectangle $rectangle;
$range.get-range-rect($rectangle);
```
could then be rewritten as;
```
my GTK::V3::Gdk::GdkRectangle $rectangle = $range.get-range-rect();
```

  11) There is no Boolean type in C. All Booleans are integers and only 0 (False) or 1 (True) is used. Also here to use Perl6 Booleans, the native sub must be wrapped into another sub to transform the variables. **_This is not yet implemented!_**

## Miscellaneous
* [Release notes][release]

# TODO

# Versions of involved software

* Program is tested against the latest version of **perl6** on **rakudo** en **moarvm**.
* Gtk library used **Gtk >= 3.24**


# Installation of GTK::V3

`zef install GTK::V3`


# Author

Name: **Marcel Timmerman**
Github account name: **MARTIMM**

# Issues

There are always some problems! If you find one please help by filing an issue at [my github project](https://github.com/MARTIMM/gtk-v3/issues).

# Documentation

Documentation is generated with
`pod-render.pl6 --pdf --style=pod6 --g=github.com/MARTIMM/gtk-v3 lib`

# Attribution
* The inventors of Perl6 of course and the writers of the documentation which help me out every time again and again.
* The builders of the GTK+ library and the documentation.
* Other helpful modules for their insight and use.

[//]: # (---- [refs] ----------------------------------------------------------)
[release]: https://github.com/MARTIMM/gtk-glade/blob/master/doc/CHANGES.md
[logo]: https://github.com/MARTIMM/gtk-v3/blob/master/doc/Design-docs/gtk-logo-100.png



[screenshot 1]: https://github.com/MARTIMM/gtk-v3/blob/master/doc/Design-docs/01-hello-world.png
[screenshot 2]: https://github.com/MARTIMM/gtk-v3/blob/master/doc/Design-docs/16a-level-bar.png
[screenshot 3]: https://github.com/MARTIMM/gtk-v3/blob/master/doc/Design-docs/16b-level-bar.png
[screenshot 4]: https://github.com/MARTIMM/gtk-v3/blob/master/doc/Design-docs/ex-GtkScale.png



[gtkaboutdialog]: https://developer.gnome.org/gtk3/stable/GtkAboutDialog.html
[gtkbin]: https://developer.gnome.org/gtk3/stable/GtkBin.html
[gtkbuilder]: https://developer.gnome.org/gtk3/stable/GtkBuilder.html
[gtkbutton]: https://developer.gnome.org/gtk3/stable/GtkButton.html
[gtkcheckbutton]: https://developer.gnome.org/gtk3/stable/GtkCheckButton.html
[GtkComboBox]: https://developer.gnome.org/gtk3/stable/GtkComboBox.html
[GtkComboBoxText]: https://developer.gnome.org/gtk3/stable/GtkComboBoxText.html#gtk-combo-box-text-append
[gtkcontainer]: https://developer.gnome.org/gtk3/stable/GtkContainer.html
[gtkcssprovider]: https://developer.gnome.org/gtk3/stable/GtkCssProvider.html
[gtkdialog]: https://developer.gnome.org/gtk3/stable/GtkDialog.html
[gtkentry]: https://developer.gnome.org/gtk3/stable/GtkEntry.html
[GtkFileChooser]: https://developer.gnome.org/gtk3/stable/GtkFileChooser.html
[GtkFileChooserDialog]: https://developer.gnome.org/gtk3/stable/GtkFileChooserDialog.html
[GtkFileFilter]: https://developer.gnome.org/gtk3/stable/GtkFileFilter.html
[gtkgrid]: https://developer.gnome.org/gtk3/stable/GtkGrid.html
[gtkimage]: https://developer.gnome.org/gtk3/stable/GtkImage.html
[gtkimagemenuitem]: https://developer.gnome.org/gtk3/stable/GtkImageMenuItem.html
[gtklabel]: https://developer.gnome.org/gtk3/stable/GtkLabel.html
[GtkLevelBar]: https://developer.gnome.org/gtk3/stable/GtkLevelBar.html
[gtklistbox]: https://developer.gnome.org/gtk3/stable/GtkListBox.html
[gtkmain]: https://developer.gnome.org/gtk3/stable/GtkMain.html
[gtkmenuitem]: https://developer.gnome.org/gtk3/stable/GtkMenuItem.html
[GtkOrientable]: https://developer.gnome.org/gtk3/stable/gtk3-Orientable.html
[GtkPaned]: https://developer.gnome.org/gtk3/stable/GtkPaned.html
[gtkradiobutton]: https://developer.gnome.org/gtk3/stable/GtkRadioButton.html
[GtkRange]: https://developer.gnome.org/gtk3/stable/GtkRange.html
[GtkStyleContext]: https://developer.gnome.org/gtk3/stable/GtkStyleContext.html
[GtkScale]: https://developer.gnome.org/gtk3/stable/GtkScale.html
[gtktextbuffer]: https://developer.gnome.org/gtk3/stable/GtkTextBuffer.html
[gtktexttagtable]: https://developer.gnome.org/gtk3/stable/GtkTextTagTable.html
[gtktextview]: https://developer.gnome.org/gtk3/stable/GtkTextView.html
[gtktogglebutton]: https://developer.gnome.org/gtk3/stable/GtkToggleButton.html
[gtkwidget]: https://developer.gnome.org/gtk3/stable/GtkWidget.html
[gtkwindow]: https://developer.gnome.org/gtk3/stable/GtkWindow.html

[GdkDisplay]: https://developer.gnome.org/gdk3/stable/GdkDisplay.html
[GdkScreen]: https://developer.gnome.org/gdk3/stable/GdkScreen.html
[GdkWindow]: https://developer.gnome.org/gdk3/stable/gdk3-Windows.html

[gerror]: https://developer.gnome.org/glib/stable/glib-Error-Reporting.html
[GFile]: https://developer.gnome.org/gio/stable/GFile.html
[GInitiallyUnowned]: https://developer.gnome.org/gtk3/stable/ch02.html
[GInterface]: https://developer.gnome.org/gobject/stable/GTypeModule.html
[glist]: https://developer.gnome.org/glib/stable/glib-Doubly-Linked-Lists.html
[gmain]: https://developer.gnome.org/glib/stable/glib-The-Main-Event-Loop.html
[GObject]: https://developer.gnome.org/gobject/stable/gobject-The-Base-Object-Type.html
[GSignal]: https://developer.gnome.org/gobject/stable/gobject-Signals.html
[gslist]: https://developer.gnome.org/glib/stable/glib-Singly-Linked-Lists.html
[GType1]: https://developer.gnome.org/gobject/stable/gobject-Type-Information.html
[GType2]: https://developer.gnome.org/glib/stable/glib-Basic-Types.html
[GValue1]: https://developer.gnome.org/gobject/stable/gobject-Generic-values.html
[GValue2]: https://developer.gnome.org/gobject/stable/gobject-Standard-Parameter-and-Value-Types.html


[GdkEventTypes]: https://developer.gnome.org/gdk3/stable/gdk3-Event-Structures.html


[//]: # (https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GObject.pdf)
[//]: # (Pod documentation rendered with)
[//]: # (pod-render.pl6 --pdf --g=github.com/MARTIMM/gtk-v3 lib)

[GTK::V3::Gdk::GdkEventTypes html]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GdkEventTypes.html
[GTK::V3::Gdk::GdkEventTypes pdf]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GdkEventTypes.pdf
[GTK::V3::Glib::GObject html]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GObject.html
[GTK::V3::Glib::GObject pdf]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GObject.pdf
[GTK::V3::Glib::GSignal html]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GSignal.html
[GTK::V3::Glib::GSignal pdf]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GSignal.pdf
[GTK::V3::Gtk::GtkAboutDialog html]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GtkAboutDialog.html
[GTK::V3::Gtk::GtkAboutDialog pdf]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GtkAboutDialog.pdf
[GTK::V3::Gtk::GtkBin html]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GtkBin.html
[GTK::V3::Gtk::GtkBin pdf]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GtkBin.pdf
[GTK::V3::Gtk::GtkBuilder html]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GtkBuilder.html
[GTK::V3::Gtk::GtkBuilder pdf]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GtkBuilder.pdf
[GTK::V3::Gtk::GtkButton html]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GtkButton.html
[GTK::V3::Gtk::GtkButton pdf]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GtkButton.pdf
[GTK::V3::Gtk::GtkCheckButton html]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GtkCheckButton.html
[GTK::V3::Gtk::GtkCheckButton pdf]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GtkCheckButton.pdf
[GTK::V3::Gtk::GtkComboBox html]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GtkComboBox.html
[GTK::V3::Gtk::GtkComboBox pdf]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GtkComboBox.pdf
[GTK::V3::Gtk::GtkComboBoxText html]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GtkComboBoxText.html
[GTK::V3::Gtk::GtkComboBoxText pdf]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GtkComboBoxText.pdf
[GTK::V3::Gtk::GtkDialog html]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GtkDialog.html
[GTK::V3::Gtk::GtkDialog pdf]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GtkDialog.pdf
[GTK::V3::Gtk::GtkFileChooserDialog html]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GtkFileChooserDialog.html
[GTK::V3::Gtk::GtkFileChooserDialog pdf]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GtkFileChooserDialog.pdf
[GTK::V3::Gtk::GtkLevelBar pdf]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GtkLevelBar.pdf
[GTK::V3::Gtk::GtkMain html]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GtkMain.html
[GTK::V3::Gtk::GtkMain pdf]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GtkMain.pdf
[GTK::V3::Gtk::GtkOrientable pdf]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GtkOrientable.pdf
[GTK::V3::Gtk::GtkToggleButton html]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GtkToggleButton.html
[GTK::V3::Gtk::GtkToggleButton pdf]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GtkToggleButton.pdf
[GTK::V3::Gtk::GtkWidget html]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GtkWidget.html
[GTK::V3::Gtk::GtkWidget pdf]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GtkWidget.pdf
[GTK::V3::Gtk::GtkWindow html]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GtkWindow.html
[GTK::V3::Gtk::GtkWindow pdf]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GtkWindow.pdf
[GTK::V3::Gtk::GtkPaned html]: https://nbviewer.jupyter.org/github/MARTIM/gtk-v3/blob/master/doc/GtkPaned.html
[GTK::V3::Gtk::GtkPaned pdf]: https://nbviewer.jupyter.org/github/MARTIM/gtk-v3/blob/master/doc/GtkPaned.pdf
[GTK::V3::Gtk::GtkRange pdf]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GtkRange.pdf
[GTK::V3::Gtk::GtkScale html]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GtkScale.html
[GTK::V3::Gtk::GtkScale pdf]: https://nbviewer.jupyter.org/github/MARTIMM/gtk-v3/blob/master/doc/GtkScale.pdf
