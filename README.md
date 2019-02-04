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

The other reason I want to start a new project is that after some time working with the native call interface. I came to the conclusion that Perl6 is not yet capable to return a proper message when mistakes are made by me e.g. spelling errors or using wrong types. Most of them end up in **MoarVM panic: Internal error: Unwound entire stack and missed handler**. Other times it ends in just a plain crash. I am very confident that this will be improved later but for the time being I had to improve the maintainability of this project by hiding the native stuff as much as possible. Although this may be improved, some of the crashes are caused from within GTK and cannot be captured by Perl6. One of those moments are the use of GTK calls without initializing GTK with `gtk_init`. This can also be covered by setting a init-flag which should be checked by almost every other module.

There are some points I noticed in the `GTK::Simple` modules.
* The `GTK::Simple::Raw` module where all the native subs are defined is quite large. Only a few subs can be found elsewhere. The file is also growing with each additional declaration. Using that module is always a parsing impact despite the several import selection switches one can use.
* I would like to follow the GTK interface more closely when it comes to the native subs. What I want therefore is a class per gtk include file as much as possible. For example there is this file `gtklabel.h` for which I would like to make the class `GtkLabel` in perl6. In a similar module in `GTK::Simple` named `Label`, there is a `text` method while I want to have `gtk_label_get_text` and `gtk_label_set_text` modules as in the [documentation of GTK][gtklabel] is specified.
* There is no inheritance. A kind of a central role is made which most widget classes use. I would like to have inheritance where for example `GtkLabel` inherits from `GtkWidget`. Then the methods from `GtkWidget` will also be available in `GtkLabel`.
* I want the native subs out of reach of the user. So the `is export` trait is removed. This is important to prevent LTA messages mentioned above.
* When callbacks are defined in GTK, they can accept most of the time some user data to do something with it in the callback. GTK::Simple gives them the OpaquePointer type which renders them useless. Most of the time small Routines are used in place of the handler entry. The code used there can close over the variables you want to use and in that situation there is no problem. This changes when the Routines are defined in a separate sub because of the length or complexity of the code. The data can only be handed over to the Routine using the call interface. What type should I take then. I found out that all kinds can be used so I decided to take `CArray[Str]` to have the most flexible choice.
* defined original `g_signal_connect_object` instead of changed name `g_signal_connect_wd`.

This will present some problems
* How to store the native widget. This is a central object representing the widget for the class wherein it is created. It is used where widgets like labels, dialogs, frames, listboxes etc are used. Because it is just a pointer to a C object we do not need to build inheritance around this. Like in `GTK::Simple` I used a role for that, only not named after a GTK like class.
* Do I have to write a method for each native sub introduced? Fortunately, that is not necessary. I used the **FALLBACK** mechanism for that. When not found, the search is handed over to the parent. In this process it is possible to accept other names as well which end up finding the same native sub. To let this mechanism work the `FALLBACK` method is defined in the role module. This method will then call the method `fallback` in the modules using the role. When nothing found, `fallback` must call the parents fallback with `callsame`. The subs in some classes all start with some prefix which can be left out too, provided that the fallback functions also test with an added prefix. So e.g. a sub `gtk_label_get_text` defined in class `GtkLabel` can be called like `$label.gtk_label_get_text()` or `$label.get_text()`. As an extra feature dashes can be used instead of underscores, so `$label.gtk-label-get-text()` or `$label.get-text()` works too.
* Is the sub accessible when removing the `is export` trait? No, not directly but because the `fallback` method will search in their own name space, they can get hold of the sub reference which is returned to the callers `FALLBACK`. The call then is made with the given arguments prefixed with the native widgets address stored in the role. This way the native call is shielded off and perl6 is able to return proper messages when mistakes are made in spelling or type mismatches.
**TODO: not all calls have the widget on their first argument**

Not all of the GTK, GDK or Glib libraries will be covered because not everything is needed, partly because a lot can be designed by the `Glade` user interface designer tool which is the base point of this package. Other reasons are that classes and many subs are deprecated. This package will support the 3.* version of GTK. There is already a 4.* version out but that is food for later thoughts. The root of the library will be GTK::V3 and can be separated later into a another package.

# Documentation

## Glade engine

## Gtk library

* GTK::V3::Gtk::GtkBin is GTK::V3::Gtk::GtkContainer

* GTK::V3::Gtk::GtkBuilder
  * `new ( )`
  * `new ( Str:D :$filename! )`
  * `new ( Str:D :$string! )`
  * `add-gui ( Str:D :$filename! )`
  * `add-gui ( Str:D :$$string! )`
  * `gtk_builder_get_object ( Str $object-id --> N-GtkWidget )`
  * `gtk_builder_get_type_from_name ( Str $type_name --> int32 )`

* GTK::V3::Gtk::GtkButton is GTK::V3::Gtk::GtkBin
  * `new ( Str :$text? )`
  * `gtk_button_get_label ( --> Str )`
  * `gtk_button_set_label ( Str $label )`

* GTK::V3::Gtk::GtkContainer is GTK::V3::Gtk::GtkWidget
  * `gtk_container_add ( N-GtkWidget $widget )`
  * `gtk_container_get_border_width ( --> int32 )`
  * `gtk_container_get_children ( --> CArray[N-GtkWidget] )`
  * `gtk_container_set_border_width ( Int $border_width )`

* GTK::V3::Gtk::GtkLabel is GTK::V3::Gtk::GtkWidget
* GTK::V3::Gtk::GtkMain
* GTK::V3::Gtk::GtkWidget

## Gdk library

* GTK::V3::Gdk::GdkDisplay
* GTK::V3::Gdk::GdkScreen
* GTK::V3::Gdk::GdkWindow

## Glib library

* GTK::V3::Glib::GMain
* GTK::V3::Glib::GSignal

### Notes
  1) `N-GtkWidget` is a native widget which is held internally in most of the classes. Sometimes they need to be handed over in a call. The `CALL-ME` method is coded in such a way that this object can be set or retrieved easily. E.g.

      ```
      my GTK::V3::Gtk::GtkLabel $label .= new(:text('my label'));
      my GTK::V3::Gtk::GtkGrid $grid .= new;
      $grid.gtk_grid_attach( $label(), 0, 0, 1, 1);
      ```

      Notice how the native widget is retrieved with `$label()`.

  2) Each method can at least be called with perl6 like dashes in the method name. E.g. `gtk_container_add` can be written as `gtk-container-add`.

  3) In some cases the calls can be shortened too. E.g. `gtk_button_get_label` can also be called like `get_label` or `get-label`. Sometimes, when shortened, calls can end up with a call using the wrong native widget. When in doubt use the complete method call.

## Miscellaneous
* [Release notes][release]

# TODO

# Versions of involved software

* Program is tested against the latest version of **perl6** on **rakudo** en **moarvm**.
* Generated user interface file is for **Gtk >= 3.10**


# Installation of GTK::Glade

`zef install GTK::V3`


# Author

Name: **Marcel Timmerman**
Github account name: Github account MARTIMM


<!---- [refs] ----------------------------------------------------------------->
[release]: https://github.com/MARTIMM/gtk-glade/blob/master/doc/CHANGES.md
[logo]: doc/gtk-logo-100.png
[gtklabel]: https://developer.gnome.org/gtk3/stable/GtkLabel.html#gtk-label-set-text
<!--
[todo]: https://github.com/MARTIMM/Library/blob/master/doc/TODO.md
[man]: https://github.com/MARTIMM/Library/blob/master/doc/manual.pdf
[requir]: https://github.com/MARTIMM/Library/blob/master/doc/requirements.pdf
-->