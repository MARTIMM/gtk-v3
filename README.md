![gtk logo][logo]

# GTK::V3 - Accessing Gtk version 3.*
<!--
[![Build Status](https://travis-ci.org/MARTIMM/gtk-glade.svg?branch=master)](https://travis-ci.org/MARTIMM/gtk-glade) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/6yaqqq9lgbq6nqot?svg=true&branch=master&passingText=Windows%20-%20OK&failingText=Windows%20-%20FAIL&pendingText=Windows%20-%20pending)](https://ci.appveyor.com/project/MARTIMM/gtk-glade/branch/master)
-->
[![License](http://martimm.github.io/label/License-label.svg)](http://www.perlfoundation.org/artistic_license_2_0)

# Description

# Synopsis

# Motivation
I perhaps should have used parts of `GTK::Simple` but I wanted to study the native call interface which I am now encountering more seriously. Therefore I started a new project with likewise objects as can be found in `GTK::Simple`.

The other reason I want to start a new project is that after some time working with the native call interface. I came to the conclusion that Perl6 is not yet capable to return a proper message when mistakes are made by me e.g. spelling errors or using wrong types. Most of them end up in **MoarVM panic: Internal error: Unwound entire stack and missed handler**. Other times it ends in just a plain crash. I am very confident that this will be improved later but for the time being I had to improve the maintainability of this project by hiding the native stuff as much as possible. Although the error messages may be improved, some of the crashes are happening within GTK and cannot be captured by Perl6. One of those moments are the use of GTK calls without initializing GTK with `gtk_init`. This can also be covered by setting an init-flag which should be checked by almost every other module.

There are some points I noticed in the `GTK::Simple` modules.
* The `GTK::Simple::Raw` module where all the native subs are defined is quite large. Only a few subs can be found elsewhere. The file is also growing with each additional declaration. Using that module is always a parsing impact despite the several import selection switches one can use.
* I would like to follow the GTK interface more closely when it comes to the native subs. What I want therefore is a class per gtk include file as much as possible. For example, there is this file `gtklabel.h` for which I would like to make the class `GtkLabel` in perl6. In a similar module in `GTK::Simple` named `Label`, there is a `text` method while I want to have `gtk_label_get_text` and `gtk_label_set_text` modules as in the [documentation of GTK][gtklabel] is specified. This makes it more legitimate to just refer to the GTK documentation instead of having my own docs.
<!--
* There is no inheritance in `GTK::Simple`. A kind of a central role is made which most widget classes use. I would like to have inheritance where for example `GtkLabel` inherits from `GtkWidget`. Then the methods from `GtkWidget` will also be available in `GtkLabel`.
* I want the native subs out of reach of the user. So the `is export` trait is removed. This is important to prevent LTA messages mentioned above.
-->
<!--
* When callbacks are defined in GTK, they can accept most of the time some user data to do something with it in the callback. GTK::Simple gives them the OpaquePointer type which renders them useless. Most of the time small Routines are used in place of the handler entry. The code used there can close over the variables you want to use and in that situation there is no problem. This changes when the Routines are defined in a separate sub because of the length or complexity of the code. The data can only be handed over to the Routine using the call interface. What type should I take then. I found out that all kinds can be used so I decided to take `CArray[Str]` to have the most flexible choice.
-->
* Next thought of mine is wrong: **Define original `g_signal_connect_object` function instead of changing the name into `g_signal_connect_wd`.** The problem is that in Perl6 the handlers signature is fixed when defining a callback for signals and that there are several types of callbacks possible in GTK widgets. Most of the handlers are having the same signature for a handler. E.g. a `clicked` event handler receives a widget and data. That's why the sub is called like that: `g_signal_connect_wd`. There are other signals using a different signature such as the gtk container `add` event. That one has 2 widgets and then data. So I added `g_signal_connect_wwd` to handle that one. Similar setups may follow.

These arguments will present some problems
* How to store the native widget. This is a central object representing the widget for the class wherein it is created. It is used where widgets like labels, dialogs, frames, listboxes etc are used. Because it is just a pointer to a C object we do not need to build inheritance around this. Like in `GTK::Simple` I used a role for that, only not named after a GTK like class.
* Do I have to write a method for each native sub introduced? Fortunately, that is not necessary. I used the **FALLBACK** mechanism for that. When not found, the search is handed over to the parent. In this process it is possible to accept other names as well which end up finding the same native sub. To let this mechanism work the `FALLBACK` method is defined in the role module. This method will then call the method `fallback` in the modules using the role. When nothing found, `fallback` must call the parents fallback with `callsame`. The subs in some classes all start with some prefix which can be left out too, provided that the fallback functions also test with an added prefix. So e.g. a sub `gtk_label_get_text` defined in class `GtkLabel` can be called like `$label.gtk_label_get_text()` or `$label.get_text()`. As an extra feature dashes can be used instead of underscores, so `$label.gtk-label-get-text()` or `$label.get-text()` works too.
* Is the sub accessible when removing the `is export` trait? No, not directly but because the `fallback` method will search in their own name space, they can get hold of the sub reference which is returned to the callers `FALLBACK`. The call then is made with the given arguments prefixed with the native widgets address stored in the role. This way the native call is shielded off and perl6 is able to return proper messages when mistakes are made in spelling or type mismatches.
* Not all calls have the widget on their first argument. That is solved by investigating the subroutines signature of which the first argument is a N-GObject or not.

Not all of the GTK, GDK or Glib subroutines from the libraries will be covered because not everything is needed. Other reasons are that classes and many subs are deprecated. This package will support the 3.* version of GTK. There is already a 4.* version out but that is food for later thoughts. The root of the library will be GTK::V3 and can be separated later into a another package.

# Documentation

## Glade engine

## Gtk library

* **GTK::V3::X**
  is **Exception**
  * `test-catch-exception ( Exception $e, Str $native-sub )`
  * `test-call ( $handler, $gobject, |c )`

* [GTK::V3::Gtk::GtkBin][gtkbin]
    is **GTK::V3::Gtk::GtkContainer**
    does **GTK::V3::Gui**
  * `gtk_bin_get_child ( --> N-GObject )` [3][4][5]

* [GTK::V3::Gtk::GtkBuilder][gtkbuilder]
  * `new ( )`
  * `new ( Str:D :$filename! )`
  * `new ( Str:D :$string! )`
  * `add-gui ( Str:D :$filename! )`
  * `add-gui ( Str:D :$$string! )`
  * `gtk_builder_get_object ( Str $object-id --> N-GObject )`
  * `gtk_builder_get_type_from_name ( Str $type_name --> Int )`

* [GTK::V3::Gtk::GtkButton][gtkbutton]
  is **GTK::V3::Gtk::GtkBin**
  does **GTK::V3::Gui**
  * `new ( Str :$text? )`
  <!--* `new ( N-GObject $button )`-->
  * `gtk_button_get_label ( --> Str )`
  * `gtk_button_set_label ( Str $label )`

* [GTK::V3::Gtk::GtkContainer][gtkcontainer]
  is **GTK::V3::Gtk::GtkWidget**
  does **GTK::V3::Gui**
  * `gtk_container_add ( N-GObject $widget )`
  * `gtk_container_get_border_width ( --> Int )`
  * `gtk_container_get_children ( --> N-GList )`
  * `gtk_container_set_border_width ( Int $border_width )`

* [GTK::V3::Gtk::GtkGrid][gtkgrid]
  is **GTK::V3::Gtk::GtkContainer**
  does **GTK::V3::Gui**
  * `new ( )`
  <!--* `new ( N-GObject $grid )`-->
  * `gtk_grid_attach ( N-GObject $child, Int $x, Int $y, Int $w, Int $h)`
  * `gtk_grid_insert_row ( Int $position )`
  * `gtk_grid_insert_column ( Int $position )`
  * `gtk_grid_get_child_at ( UInt $left, UInt $top --> N-GObject )`
  * `gtk_grid_set_row_spacing ( UInt $spacing )`

* [GTK::V3::Gtk::GtkLabel][gtklabel]
  is **GTK::V3::Gtk::GtkWidget**
  does **GTK::V3::Gui**
  * `new ( Str :$text? )`
  <!--* `new ( N-GObject $grid )`-->
  * `gtk_label_get_text ( --> Str )`
  * `gtk_label_set_text ( Str $str )`

* GTK::V3::Gtk::GtkMain

* GTK::V3::Gtk::GtkWidget
  * `class N-GObject`
  * `CALL-ME ( N-GObject $widget? --> N-GObject )` [1]
  * `FALLBACK ( $native-sub, |c )` [2]
  * `new ( N-GObject :$widget )`
  * `setWidget ( N-GObject $widget )`

## Gdk library

* GTK::V3::Gdk::GdkDisplay
* GTK::V3::Gdk::GdkScreen
* GTK::V3::Gdk::GdkWindow

## Glib library

* GTK::V3::Glib::GMain

### Notes
  1) The `CALL-ME` method is coded in such a way that an object can be set or retrieved easily. E.g.
      ```
      my GTK::V3::Gtk::GtkLabel $label .= new(:text('my label'));
      my GTK::V3::Gtk::GtkGrid $grid .= new;
      $grid.gtk_grid_attach( $label(), 0, 0, 1, 1);
      ```
      Notice how the native widget is retrieved with `$label()`.
  2) The `FALLBACK` method is used to test for the defined native functions as if the functions where methods. It calls the `fallback` methods in the class which in turn call the parent fallback using `callsame`. The resulting function addres is returned and processed with the `test-call` functions from **GTK::V3::X**. Thrown exceptions are handled by the function `test-catch-exception` from the same module.
  3) `N-GObject` is a native widget which is held internally in most of the classes. Sometimes they need to be handed over in a call.
  4) Each method can at least be called with perl6 like dashes in the method name. E.g. `gtk_container_add` can be written as `gtk-container-add`.
  5) In some cases the calls can be shortened too. E.g. `gtk_button_get_label` can also be called like `get_label` or `get-label`. Sometimes, when shortened, calls can end up with a call using the wrong native widget. When in doubt use the complete method call.

## Miscellaneous
* [Release notes][release]

# TODO

# Versions of involved software

* Program is tested against the latest version of **perl6** on **rakudo** en **moarvm**.
* Generated user interface file is for **Gtk >= 3.10**


# Installation of GTK::V3

`zef install GTK::V3`


# Author

Name: **Marcel Timmerman**
Github account name: Github account MARTIMM


<!---- [refs] ----------------------------------------------------------------->
[release]: https://github.com/MARTIMM/gtk-glade/blob/master/doc/CHANGES.md
[logo]: doc/gtk-logo-100.png

[gtkbin]: https://developer.gnome.org/gtk3/stable/GtkBin.html
[gtkbuilder]: https://developer.gnome.org/gtk3/stable/GtkBuilder.html
[gtkbutton]: https://developer.gnome.org/gtk3/stable/GtkButton.html
[gtkcontainer]: https://developer.gnome.org/gtk3/stable/GtkContainer.html
[gtkgrid]: https://developer.gnome.org/gtk3/stable/GtkGrid.html
[gtklabel]: https://developer.gnome.org/gtk3/stable/GtkLabel.html

<!--
[todo]: https://github.com/MARTIMM/Library/blob/master/doc/TODO.md
[man]: https://github.com/MARTIMM/Library/blob/master/doc/manual.pdf
[requir]: https://github.com/MARTIMM/Library/blob/master/doc/requirements.pdf
-->
