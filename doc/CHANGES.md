## Release notes

* 2019-06-01 0.13.2
  * Renamed Gtk project into `Gnome::Gtk3`. This branch is not continued

* 2019-05-26 0.13.1
  * Documentation additions and changes.
  * GtkWindow can be initialized with :$title to new(). Also added and changed some pod documentation.

* 2019-05-24 0.13.0
  * Added GtkRange add GtkScale.
  * Additions to GtkEnum

* 2019-05-17 0.12.0
  * GdkEvents extended.
  * GtkPaned widget added.
  * GtkEnums for standard enumerations added.

* 2019-05-10 0.11.0
  * New modules GTK::V3::Gtk::GtkLevelBar, GTK::V3::Gtk::GtkOrientable.

* 2019-05-09 0.10.6
  * Documentation
  * Added `start-thread()` to GObject and tests.

* 2019-05-05 0.10.5
  * GtkButton signal documentation added
  * GObject has new methods
  * GSignal start of pod doc

* 2019-05-05 0.10.4
  * Added signal name/signal type registration to cope with other types of callback handlers. For the moment simple signals and events are possible, next to handlers of which the 2nd argument is a native widget. Modules must be documented yet to show what handlers the user must provide to handle a particular signal.
  * Changed the way registration of a signal handler is processed. This is transparent to the user.

* 2019-04-26 0.10.3
  * Added file for keyboard symbols. Please look into the file `lib/GTK/V3/Gdk/GdkKeysyms.pm6` for information about which keys are defined.
  * Added module GtkSearchEntry.

* 2019-04-26 0.10.2
  * Bugfix; gtk_widget-destroy was implemented wrong.
  * Improved register-signal() from GObject. It accepts handlers for signals as well as events. The latter is recognized to have a **named argument** with the name **$event** in its signature.

* 2019-04-25 0.10.1
  * Pod doc changes
  * Readme changes

* 2019-04-18 0.10.0
  * Add `GTK::V3::Gdk::GdkDevice`.
  * Add `GTK::V3::Gdk::GdkEventTypes`.
  * Native sub `g_signal_connect_object_wd()` from `GTK::V3::Glib::GSignal` changed into `g_signal_connect_object()` as is found in the GTK documentation.

* 2019-04-17 0.9.2
  * Native sub `g_signal_emit_by_name_wd()` from `GTK::V3::Glib::GSignal` modified into `g_signal_emit_by_name()` as is found in the GTK documentation.
  * Native sub `g_signal_emit_by_name_wwd()` from `GTK::V3::Glib::GSignal` removed.

* 2019-04-15 0.9.1
  * Some subs are added to GOBject.
  * Pod doc added for GObject, GtkBuilder, GtkButton, GtkCheckButton, GtkToggleButton, GtkWidget, GtkWindow.
  * Remove GTK::V3::Glib::GFile. There was no direct use from other classes and in perl6 there are better ways to do IO.

* 2019-03-10 0.9.0
  * Added GtkTextIter to get rid of trickery from GTK::Simple.
  * Added GBoxed to gather methods used in child classes. At the moment GValue and GtkTextIter.
  * Added GtkMisc for hierarchy completeness.

* 2019-02-06 0.8.3
  * Bug fixes

* 2019-03-07 0.8.2
  * The method register-signal() in class GOBject now returns a boolean. True when successful.

* 2019-03-06 0.8.1
  * Readme not completely right for display on internet

* 2019-03-06 0.8.0
  * Added GtkComboBox and GtkComboBoxText and documentation.
  * improved debugging messages.

* 2019-03-02 0.7.3
  * Documentation added and README changed

* 2019-03-02 0.7.2
  * Documentation added and README changed
  * Native subs added

* 2019-03-01 0.7.1
  * Bugfixes.

* 2019-02-28 0.7.0
  * Added GValue and some subs to GObject to handle objects properties.
  * Changes caused by 'at least one underscore' policy. E.g. `gtk-grid-attach()` cannot be shortened to `attach()`. This is done because a class inherits always from `Any` and `Mu` and there are many methods defined there which might clash with a shortened one. A good example is `gtk-button-new()`. A shortened version would be `new()` of which we all know what the purpose is in perl6. The only thing where I'm thinking about is chopping the `g-`, `gdk-` or `gtk-` prefixes. So the last example would become `button-new()`.
  * Added documentation to GtkBin

* 2019-02-25 0.6.2
  * Bugfixes
  * Added documentation to GtkAboutDialog

* 2019-02-23 0.6.1
  * Modified `g_slist_nth_data` into `g_slist_nth_data_str`and `g_slist_nth_data_gobject` because the list can hold several types of data.
  * TODO do same for GList and also more for other types if needed.

* 2019-02-21 0.6.0
  * Added GInitiallyUnowned to make hierarchy better.
  * Added GtkFileChooserDialog, GtkFileChooser, GtkFileFilter and GFile.
  * Added GInterface to hook GtkFileChooser.
  * Added more subs to GtkAboutDialog

* 2019-02-20 0.5.0
  * Added GSList and GtkRadioButton
  * Documented GtkAboutDialog. Docs are available as pdf in the doc directory.

* 2019-02-18 0.4.3
  * Bugfixes

* 2019-02-16 0.4.2
  * Improve of widget creation
  * Added :build-id option to widget creation. Can only be used when a builder is created with a gui description. Then, a widget can be searched in this description.

* 2019-02-15 0.4.1
  * Bugfixes
  * Module GdkTypes for use in other classes

* 2019-02-14 0.4.0
  * Module GObject placed at the top of the foodchain.
  * Automatic initialization of GTK before first access of a native sub.

* 2019-02-11 0.3.0
  * New modules GtkDialog, GtkAboutDialog, GtkImage, GtkEntry, GtkCheckButton, GtkToggleButton, GtkListBox, GtkWindow, GtkMenuItem, GtkImageMenuItem

* 2019-02-08 0.2.0
  * Connecting signals
  * New modules GtkCssProvider, GtkTextBuffer, GtkTextView

* 2019-02-04 0.1.0
  * New modules GtkGrid and GList

* 2019-01-24 0.0.1
  * Start of project which is separated from GTK::Glade
