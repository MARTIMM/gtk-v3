use v6;
# ==============================================================================
=begin pod

=TITLE GTK::V3::Gtk::GtkButton

=SUBTITLE

  unit class GTK::V3::Gtk::GtkButton;
  also is GTK::V3::Gtk::GtkBin;

=head2 GtkButton — A widget that emits a signal when clicked on

=head1 Synopsis

  my GTK::V3::Gtk::GtkButton $start-button .= new(:label<Start>);
=end pod
# ==============================================================================
use NativeCall;

use GTK::V3::N::NativeLib;
use GTK::V3::Glib::GObject;
use GTK::V3::Gtk::GtkBin;

#-------------------------------------------------------------------------------
# See /usr/include/gtk-3.0/gtk/gtkbutton.h
# https://developer.gnome.org/gtk3/stable/GtkButton.html
unit class GTK::V3::Gtk::GtkButton:auth<github:MARTIMM>;
also is GTK::V3::Gtk::GtkBin;

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
my Bool $signals-added = False;
#-------------------------------------------------------------------------------
=begin pod
=head1 Methods
=head2 new

  multi method new ( Bool :$empty! )

Create an empty button

  multi method new ( Str :$label! )

Creates a new button object with a label

  multi method new ( :$widget! )

Create a button using a native object from elsewhere. See also Gtk::V3::Glib::GObject.

  multi method new ( Str :$build-id! )

Create a button using a native object from a builder. See also Gtk::V3::Glib::GObject.
=end pod
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
submethod BUILD ( *%options ) {

  $signals-added = self.add-signal-types( $?CLASS.^name,
    :signal<clicked>,
    :notsupported<activate>,
    :deprecated<enter leave pressed released>,
  ) unless $signals-added;

  # prevent creating wrong widgets
  return unless self.^name eq 'GTK::V3::Gtk::GtkButton';

  if %options<label>.defined {
    self.native-gobject(gtk_button_new_with_label(%options<label>));
  }

  elsif ? %options<empty> {
    self.native-gobject(gtk_button_new());
  }

  elsif ? %options<widget> || %options<build-id> {
    # provided in GObject
  }

  elsif %options.keys.elems {
    die X::GTK::V3.new(
      :message('Unsupported options for ' ~ self.^name ~
               ': ' ~ %options.keys.join(', ')
              )
    );
  }
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method fallback ( $native-sub is copy --> Callable ) {

  my Callable $s;
  try { $s = &::($native-sub); }
  try { $s = &::("gtk_button_$native-sub"); } unless ?$s;

  $s = callsame unless ?$s;

  $s
}

# ==============================================================================
=begin pod
=head2 gtk_button_new

Creates a new native GtkButton

  method gtk_button_new ( --> N-GObject )

Returns a native widget. Can be used to initialize another object using :widget. This is very cumbersome when you know that a oneliner does the job for you: `my GTK::V3::Gtk::GtkButon $m .= new(:empty);

  my GTK::V3::Gtk::GtkButon $m;
  $m .= :new(:widget($m.gtk_button_new());

=end pod

sub gtk_button_new ( )
  returns N-GObject
  is native(&gtk-lib)
  { * }

# ==============================================================================
=begin pod
=head2 [gtk_button_] new_with_label

  method gtk_button_new_with_label ( Str $label --> N-GObject )

Creates a new native button object with a label
=end pod

sub gtk_button_new_with_label ( Str $label )
  returns N-GObject
  is native(&gtk-lib)
  { * }

# ==============================================================================
=begin pod
=head2 [gtk_button_] get_label

  method gtk_button_get_label ( --> Str )

Get text label of button
=end pod

sub gtk_button_get_label ( N-GObject $widget )
  returns Str
  is native(&gtk-lib)
  { * }

# ==============================================================================
=begin pod
=head2 [gtk_button_] set_label

  method gtk_button_set_label ( Str $label )

Set a label ob the button
=end pod

sub gtk_button_set_label ( N-GObject $widget, Str $label )
  is native(&gtk-lib)
  { * }

#TODO can add a few more subs

#-------------------------------------------------------------------------------
=begin pod
=head1 Signals

Registering example

  class MyHandlers {
    method my-click-handler ( :$widget, :$my-data ) { ... }
  }

  # elsewhere
  my MyHandlers $mh .= new;
  $button.register-signal( $mh, 'click-handler', 'clicked', :$my-data);

See also method C<register-signal> in GTK::V3::Glib::GObject.

=head2 Supported signals
=head3 clicked

Emitted when the button has been activated (pressed and released).

Handler signature;

=code handler ( instance: :$widget, :$user-option1, ..., :$user-optionN )

=head2 Unsupported signals
=head3 activated

Signal C<activated> is not supported because GTK advises against the use of it.

=head2 Deprecated signals
=head3 enter

Signal C<enter> has been deprecated since version 2.8 and should not be used in newly-written code. Use the “enter-notify-event” signal.

=head3 leave

Signal C<leave> has been deprecated since version 2.8 and should not be used in newly-written code. Use the C<leave-notify-event> signal.

=head3 pressed

Signal C<pressed> has been deprecated since version 2.8 and should not be used in newly-written code. Use the C<button-press-event> signal.

=head3 released

Signal C<released> has been deprecated since version 2.8 and should not be used in newly-written code. Use the C<button-release-event> signal.

=end pod
