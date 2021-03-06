use v6;
# ==============================================================================
=begin pod

=TITLE GTK::V3::Glib::GObject

=SUBTITLE GObject — The base object type

=head1 Synopsis

Top level class of almost all classes in the GTK, GDK and Glib libraries.

This object is almost never used directly. Most of the classes inherit from this class. The below example can be made much simpler by setting the label directly in the init of C<GtKLabel>. The purpose of this example, however, is that there are other properties which can only be set this way. Also not all types are covered yet by C<GValue> and C<GType>.

  use GTK::V3::Glib::GObject;
  use GTK::V3::Glib::GValue;
  use GTK::V3::Glib::GType;
  use GTK::V3::Gtk::GtkLabel;

  my GTK::V3::Glib::GType $gt .= new;
  my GTK::V3::Glib::GValue $gv .= new(:init(G_TYPE_STRING));

  my GTK::V3::Gtk::GtkLabel $label1 .= new(:label(''));
  $gv.g-value-set-string('label string');
  $label1.g-object-set-property( 'label', $gv);

=end pod
# ==============================================================================
use NativeCall;

use GTK::V3::X;
use GTK::V3::N::NativeLib;
use GTK::V3::N::N-GObject;

use GTK::V3::Gdk::GdkEventTypes;
use GTK::V3::Gtk::GtkMain;

use GTK::V3::Glib::GSignal;
use GTK::V3::Glib::GValue;
use GTK::V3::Glib::GMain;

sub EXPORT { {
    'N-GObject' => N-GObject,
  }
};

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
unit class GTK::V3::Glib::GObject:auth<github:MARTIMM>;

# ==============================================================================
# Increases the reference count of $object. The new() methods will increase the
# reference count of the native object automatically and when destroyed or
# overwritten decreased.

# no pod. user does not have to know about it.
sub g_object_ref ( N-GObject $object )
  returns N-GObject
  is native(&gobject-lib)
  { * }

# ==============================================================================
# Decreases the reference count of object. When its reference count drops to 0,
# the object is finalized (i.e. its memory is freed). The widget classes will
# automatically decrease the reference count to the native object when
# destroyed or when overwritten.

# no pod. user does not have to know about it.
sub g_object_unref ( N-GObject $object )
  is native(&gobject-lib)
  { * }

# ==============================================================================
# Increase the reference count of object , and possibly remove the floating
# reference. See also https://developer.gnome.org/gobject/unstable/gobject-The-Base-Object-Type.html#g-object-ref-sink.

# no pod. user does not have to know about it.
sub g_object_ref_sink ( N-GObject $object )
  is native(&gobject-lib)
  { * }

# ==============================================================================
# Clears a reference to a GObject. The reference count of the object is
# decreased and the pointer is set to NULL.

# no pod. user does not have to know about it.
sub g_clear_object ( N-GObject $object )
  is native(&gobject-lib)
  { * }

# ==============================================================================
# Checks whether object has a floating reference.

# no pod. user does not have to know about it.
sub g_object_is_floating ( N-GObject $object )
  returns int32
  is native(&gobject-lib)
  { * }

# ==============================================================================
# This function is intended for GObject implementations to re-enforce a
# floating object reference. Doing this is seldom required: all
# GInitiallyUnowneds are created with a floating reference which usually just
# needs to be sunken by calling g_object_ref_sink().

# no pod. user does not have to know about it.
sub g_object_force_floating ( N-GObject $object )
  is native(&gobject-lib)
  { * }

# ==============================================================================
=begin pod
=head2 [g_object_] set_property

  method g_object_set_property (
    Str $property_name, GTK::V3::Glib::GValue $value
  )

Sets a property on an object.

=item $property_name; the name of the property to set.
=item $value; the value.

=end pod
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
sub g_object_set_property (
  N-GObject $object, Str $property_name, N-GValue $value
) is native(&gobject-lib)
  { * }

# ==============================================================================
=begin pod
=head2 [g_object_] get_property

  method g_object_get_property (
    Str $property_name, GTK::V3::Glib::GValue $value is rw
  )

Gets a property of an object. value must have been initialized to the expected type of the property (or a type to which the expected type can be transformed) using g_value_init().

In general, a copy is made of the property contents and the caller is responsible for freeing the memory by calling g_value_unset().

=item $property_name; the name of the property to get.
=item $value; return location for the property value.

=end pod
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
sub g_object_get_property (
  N-GObject $object, Str $property_name, N-GValue $gvalue is rw
) is native(&gobject-lib)
  { * }

# ==============================================================================
=begin pod
=head2 g_object_notify

  method g_object_notify ( Str $property_name )

Emits a C<notify> signal for the property C<property_name> on object .

When possible, e.g. when signaling a property change from within the class that registered the property, you should use C<g_object_notify_by_pspec()>(not supported yet) instead.

Note that emission of the notify signal may be blocked with C<g_object_freeze_notify()>. In this case, the signal emissions are queued and will be emitted (in reverse order) when C<g_object_thaw_notify()> is called.

=item $property_name; the name of a property installed on the class of object.

=end pod
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
sub g_object_notify ( N-GObject $object, Str $property_name)
  is native(&gobject-lib)
  { * }

# ==============================================================================
=begin pod
=head2 [g_object_] freeze_notify

  method g_object_freeze_notify ( )

Increases the freeze count on object . If the freeze count is non-zero, the emission of C<notify> signals on object is stopped. The signals are queued until the freeze count is decreased to zero. Duplicate notifications are squashed so that at most one C<notify> signal is emitted for each property modified while the object is frozen.

This is necessary for accessors that modify multiple properties to prevent premature notification while the object is still being modified.

=end pod
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
sub g_object_freeze_notify ( N-GObject $object )
  is native(&gobject-lib)
  { * }

# ==============================================================================
=begin pod
=head2 [g_object_] thaw_notify

  method g_object_thaw_notify ( )

Reverts the effect of a previous call to C<g_object_freeze_notify()>. The freeze count is decreased on object and when it reaches zero, queued C<notify> signals are emitted.

Duplicate notifications for each property are squashed so that at most one C<notify> signal is emitted for each property, in the reverse order in which they have been queued.

It is an error to call this function when the freeze count is zero.
=end pod
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
sub g_object_thaw_notify ( N-GObject $object )
  is native(&gobject-lib)
  { * }

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
our $gobject-debug = False; # Type Bool;
my Hash $signal-types = {};
my Bool $signals-added = False;

has N-GObject $!g-object;
has GTK::V3::Glib::GSignal $!g-signal;

# type is GTK::V3::Gtk::GtkBuilder. Cannot load module because of circular dep.
# attribute is set by GtkBuilder via set-builder(). There might be more than one
my Array $builders = [];

#-------------------------------------------------------------------------------
#`{{
=begin pod
=head2 CALL-ME

  method CALL-ME ( N-GObject $widget? --> N-GObject )

This method is designed to set and retrieve the gtk object from a perl6 widget object. This is indirectly called by C<new> when the :widget option is used. On many occasions this is done automatically or indirect like explained above, that it is hardly used by the user directly.

  # Example only to show how things can be tranported between objects. Not
  # something you need to remember!
  my N-GObject $button = GTK::V3::Gtk::GtkButton.new(:label('Exit'))();
  my GTK::V3::Gtk::GtkButton $b .= new(:empty);
  $b($button);

See also L<native-gobject>.
=end pod
}}
#TODO destroy when overwritten? g_object_unref?
method CALL-ME ( N-GObject $widget? --> N-GObject ) {

  if ?$widget {
    # if native object exists it will be overwritten. unref object first.
    if ?$!g-object {
      #TODO self.g_object_unref();
    }
    $!g-object = $widget;
    #TODO self.g_object_ref();
  }

  $!g-object
}

#-------------------------------------------------------------------------------
# Fallback method to find the native subs which then can be called as if it
# were a method. Each class must provide their own 'fallback' method which,
# when nothing found, must call the parents fallback with 'callsame'.
# The subs in some class all start with some prefix which can be left out too
# provided that the fallback functions must also test with an added prefix.
# So e.g. a sub 'gtk_label_get_text' defined in class GtlLabel can be called
# like '$label.gtk_label_get_text()' or '$label.get_text()'. As an extra
# feature dashes can be used instead of underscores, so '$label.get-text()'
# works too.
method FALLBACK ( $native-sub is copy, |c ) {

  CATCH { test-catch-exception( $_, $native-sub); }

  # convert all dashes to underscores if there are any. then check if
  # name is not too short.
  $native-sub ~~ s:g/ '-' /_/ if $native-sub.index('-');
  die X::GTK::V3.new(:message(
      "Native sub name '$native-sub' made too short." ~
      " Keep at least one '-' or '_'."
    )
  ) unless $native-sub.index('_') >= 0;

  # check if there are underscores in the name. then the name is not too short.
  my Callable $s;

  # call the fallback functions of this classes children starting
  # at the bottom
  $s = self.fallback($native-sub);

  die X::GTK::V3.new(:message("Native sub '$native-sub' not found"))
      unless $s.defined;

  # User convenience substitutions to get a native object instead of
  # a GtkSomeThing or GlibSomeThing object
  my Array $params = [];
  for c.list -> $p {
    if $p.^name ~~ m/^ 'GTK::V3::' [ Gtk || Gdk || Glib ] '::' / {
      $params.push($p());
    }

    else {
      $params.push($p);
    }
  }

  test-call( $s, $!g-object, |$params)
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method fallback ( $native-sub --> Callable ) {

  my Callable $s;

  try { $s = &::($native-sub); }
  try { $s = &::("g_object_$native-sub"); } unless ?$s;

  # Try to solve sub names from the GSignal class
  unless ?$s {
    $!g-signal .= new(:$!g-object);
    note "GSignal look for $native-sub: ", $!g-signal if $gobject-debug;

    $s = $!g-signal.FALLBACK( $native-sub, :return-sub-only);
  }

  $s = callsame unless ?$s;

  $s
}

#-------------------------------------------------------------------------------
=begin pod
=head2 new

=head3  multi method new ( :$widget! )

Please note that this class is mostly not instantiated directly but is used indirectly when a child class is instantiated.

Create a Perl6 widget object using a native widget from elsewhere. $widget can be a N-GOBject or a Perl6 widget like C< GTK::V3::Gtk::GtkButton>.

  # some set of radio buttons grouped together
  my GTK::V3::Gtk::GtkRadioButton $rb1 .= new(:label('Download everything'));
  my GTK::V3::Gtk::GtkRadioButton $rb2 .= new(
    :group-from($rb1), :label('Download core only')
  );

  # get all radio buttons of group of button $rb2
  my GTK::V3::Glib::GSList $rb-list .= new(:gslist($rb2.get-group));
  loop ( Int $i = 0; $i < $rb-list.g_slist_length; $i++ ) {
    # get button from the list
    my GTK::V3::Gtk::GtkRadioButton $rb .= new(
      :widget($rb-list.nth-data-gobject($i))
    );

    if $rb.get-active == 1 {
      # execute task for this radio button

      last;
    }
  }

Another example is a difficult way to get a button.

  my GTK::V3::Gtk::GtkButton $start-button .= new(
    :widget(GTK::V3::Gtk::GtkButton.gtk_button_new_with_label('Start'))
  );

=head3  multi method new ( Str :$build-id! )

Create a Perl6 widg
#`{{
    if $setup-event-handler {
      $handler = -> N-GObject $w, GdkEvent $event, OpaquePointer $d {
        $handler-object."$handler-name"(
           :widget(self), :$event, |%user-options
        );
      }

      $!g-signal._g_signal_connect_object_event(
        $signal-name, $handler, OpaquePointer, $connect-flags
      );
    }

    elsif $setup-nativewidget-handler {
      $handler = -> N-GObject $w, OpaquePointer $d1, OpaquePointer $d2 {
        $handler-object."$handler-name"(
           :widget(self), :nativewidget($d1), |%user-options
        );
      }

      $!g-signal._g_signal_connect_object_nativewidget(
        $signal-name, $handler, OpaquePointer, $connect-flags
      );
    }

    else {
      $handler = -> N-GObject $w, OpaquePointer $d {
        $handler-object."$handler-name"( :widget(self), |%user-options);
      }

      $!g-signal._g_signal_connect_object_signal(
        $signal-name, $handler, OpaquePointer, $connect-flags
      );
    }
}}
et object using a C<GtkBuilder>. The C<GtkBuilder> class will handover its object address to the C<GObject> and can then be used to search for id's defined in the GUI glade design.

  my GTK::V3::Gtk::GtkBuilder $builder .= new(:filename<my-gui.glade>);
  my GTK::V3::Gtk::GtkButton $button .= new(:build-id<my-gui-button>);

=end pod
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
submethod BUILD ( *%options ) {

  # Test if GTK is initialized
  my GTK::V3::Gtk::GtkMain $main .= new;

  note "\ngobject: {self}, ", %options if $gobject-debug;

  unless $signals-added {
    $signals-added = self.add-signal-types( $?CLASS.^name, :GParamSpec<notify>);
  }

  if ? %options<widget> {
    note "gobject widget: ", %options<widget> if $gobject-debug;

    my $w = %options<widget>;
    if $w ~~ GTK::V3::Glib::GObject {
      $w = $w();
      note "gobject widget converted: ", $w if $gobject-debug;
    }

    if ?$w and $w ~~ N-GObject {
      $!g-object = $w;
      note "gobject widget stored" if $gobject-debug;
    }

    elsif ?$w and $w ~~ NativeCall::Types::Pointer {
      $!g-object = nativecast( N-GObject, $w);
      note "gobject widget cast to GObject" if $gobject-debug;
    }

    else {
      note "wrong type or undefined widget" if $gobject-debug;
      die X::GTK::V3.new(:message('Wrong type or undefined widget'));
    }
  }

  elsif ? %options<build-id> {
    my N-GObject $widget;
    note "gobject build-id: %options<build-id>" if $gobject-debug;
    for @$builders -> $builder {
      # this action does not increase object refcount, do it here.
      $widget = $builder.get-object(%options<build-id>);
      #TODO self.g_object_ref();
      last if ?$widget;
    }

    if ? $widget {
      note "store gobject widget: ", self.^name, ', ', $widget
        if $gobject-debug;
      $!g-object = $widget;
    }

    else {
      note "builder id '%options<build-id>' not found in any of the builders"
        if $gobject-debug;
      die X::GTK::V3.new(
        :message(
          "Builder id '%options<build-id>' not found in any of the builders"
        )
      );
    }
  }

  else {
    if %options.keys.elems == 0 {
      note 'No options used to create or set the native widget'
        if $gobject-debug;
      die X::GTK::V3.new(
        :message('No options used to create or set the native widget')
      );
    }
  }

  #TODO if %options<id> add id, %options<name> add name
  #cannot add id,seems to be a builder thing.
}

#-------------------------------------------------------------------------------
=begin pod
=head2 debug

  method debug ( Bool :$on )

There are many situations when exceptions are retrown within code of a callback method, Perl6 is not able to display the error properly (yet). In those cases you need another way to display errors and show extra messages leading up to it.
=end pod
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
method debug ( Bool :$on ) {
  $gobject-debug = $on;
  $X::GTK::V3::x-debug = $on;
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
#TODO destroy when overwritten?
method native-gobject (
  N-GObject $widget?, Bool :$force = False --> N-GObject
) {
  if ?$widget and ( $force or !?$!g-object ) {
    if ?$!g-object {
      #TODO self.g_object_unref();
    }
    $!g-object = $widget;
    #TODO self.g_object_ref();
  }

  $!g-object
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method set-builder ( $builder ) {
  $builders.push($builder);
}

#-------------------------------------------------------------------------------
=begin pod
=head2 register-signal

Register a handler to process a signal or an event. There are several types of callbacks which can be handled by this regstration. They can be controlled by using a named argument with a special name.

  method register-signal (
    $handler-object, Str:D $handler-name, Str:D $signal-name, *%user-options
    --> Bool
  )

=item $handler-object is the object wherein the handler is defined.
=item $handler-name is name of the method. Commonly used signatures for those handlers are

  handler ( object: :$widget, :$user-option1, ..., :$user-optionN )
  handler ( object: :$widget, :$event, :$user-option1, ..., :$user-optionN )
  handler ( object: :$widget, :$nativewidget, :$user-option1, ..., :$user-optionN )

Other forms are explained in the widget documentations when signals are provided.


=item $signal-name is the name of the event to be handled. Each gtk widget has its own series of signals, please look for it in the documentation of gtk.
=item %user-options. Any other user data in whatever type. These arguments are provided to the user handler when an event for the handler is fired. There will always be one named argument C<:$widget> which holds the class object on which the signal was registered. The name 'widget' is therefore reserved. An other reserved named argument is of course C<:$event>.


  # create a class holding a handler method to process a click event
  # of a button.
  class X {
    method click-handler ( :widget($button), Array :$user-data ) {
      say $user-data.join(' ');
    }
  }

  # create a button and some data to send with the signal
  my GTK::V3::Gtk::GtkButton $button .= new(:label('xyz'));
  my Array $data = [<Hello World>];

  # register button signal
  my X $x .= new(:empty);
  $button.register-signal( $x, 'click-handler', 'clicked', :user-data($data));

=end pod
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
method register-signal (
  $handler-object, Str:D $handler-name, Str:D $signal-name, *%user-options
  --> Bool
) {

  my %options = :widget(self), |%user-options;

  my Callable $handler;

  # don't register if handler is not available
  my Method $sh = $handler-object.^lookup($handler-name) // Method;
  if ? $sh {
    note "\nregister $handler-object, $handler-name, options: ", %user-options
       if $gobject-debug;

    # search for signal name defined by this class as well as its parent classes
    my Str $signal-type;
    my Str $module-name;
    my @module-names = self.^name, |(map( {.^name}, self.^parents));
    for @module-names -> $mn {
      note "  search in class: $mn, $signal-name" if $gobject-debug;
      if $signal-types{$mn}:exists and ?$signal-types{$mn}{$signal-name} {
        $signal-type = $signal-types{$mn}{$signal-name};
        $module-name = $mn;
        note "  found type $signal-type for $mn" if $gobject-debug;
        last;
      }
    }

    return False unless ?$signal-type;
    given $signal-type {
      when 'signal' {
        $handler = -> N-GObject $w, OpaquePointer $d {
          $handler-object."$handler-name"( :widget(self), |%user-options);
        }
      }

      when 'event' {
        $handler = -> N-GObject $w, GdkEvent $event, OpaquePointer $d {
          $handler-object."$handler-name"(
             :widget(self), :$event, |%user-options
          );
        }
      }

      when 'nativewidget' {
        $handler = -> N-GObject $w, OpaquePointer $d1, OpaquePointer $d2 {
          $handler-object."$handler-name"(
             :widget(self), :nativewidget($d1), |%user-options
          );
        }
      }

      when 'notsupported' {
        my Str $message = "Signal $signal-name used on $module-name" ~
          " is explicitly not supported by GTK or this package";
        note $message;
#        die X::GTK::V3.new(:$message);
        return False;
      }

      when 'deprecated' {
        my Str $message = "Signal $signal-name used on $module-name" ~
          " is explicitly deprecated by GTK";
        note $message;
#        die X::GTK::V3.new(:$message);
        return False;
      }

      default {
        my Str $message = "Signal $signal-name used on $module-name" ~
          " is not yet implemented";
        note $message;
        return False;
      }
    }

    $!g-signal .= new(:$!g-object);
    $!g-signal."_g_signal_connect_object_$signal-type"(
      $signal-name, $handler, OpaquePointer, 0
    );

    True
  }

  else {
    False
  }
}

#-------------------------------------------------------------------------------
=begin pod
=head2 start-thread

Start a thread in such a way that the function can modify the user interface in a save way and that these updates are automatically made visible without explicitly process events queued and waiting in the main loop.

  method start-thread (
    $handler-object, Str:D $handler-name, Int $priority = G_PRIORITY_DEFAULT,
    Bool :$new-context = False, *%user-options
    --> Promise
  )

=item $handler-object is the object wherein the handler is defined.
=item $handler-name is name of the method.
=item $priority; The priority to which the handler is started. The default is G_PRIORITY_DEFAULT. These are constants defined in C<GTK::V3::Glib::GMain>.
=item $new-context; Whether to run the handler in a new context or to run it in the context of the main loop. Default is to run in the main loop.
=item *%user-options; Any name not used above is provided to the handler

Returns a C<Promise> object. If the call fails, the object is undefined.

The handlers signature is at least C<:$widget> of the object on which the call was made. Furthermore all users named arguments to the call defined in C<*%user-options>. The handler may return any value which becomes the result of the C<Promise> returned from C<start-thread>.

=end pod

method start-thread (
  $handler-object, Str:D $handler-name, Int $priority = G_PRIORITY_DEFAULT,
  Bool :$new-context = False, *%user-options
  --> Promise
) {

  # don't start thread if handler is not available
  my Method $sh = $handler-object.^lookup($handler-name) // Method;
  return Promise unless ? $sh;

  my Promise $p = start {

    my GTK::V3::Glib::GMain $gmain .= new;

    # This part is important that it happens in the thread where the
    # function is invoked in that context!
    my $main-context;
    if $new-context {
      $main-context = $gmain.context-new;
      $gmain.context-push-thread-default($main-context);
    }

    else {
      $main-context = $gmain.context-get-thread-default;
    }

    my $return-value;
    $gmain.context-invoke-full(
      $main-context, $priority,
      -> OpaquePointer $d {
        $return-value = $handler-object."$handler-name"(
          :widget(self), |%user-options
        );

        G_SOURCE_REMOVE
      },
      OpaquePointer, OpaquePointer
    );

    if $new-context {
      $gmain.context-pop-thread-default($main-context);
    }

    $return-value
  }

  $p
}

#-------------------------------------------------------------------------------
# no pod. user does not have to know about it.
method add-signal-types ( Str $module-name, *%signal-descriptions --> Bool ) {

  # must store signal names under the class name because I found the use of
  # the same signal name with different handler signatures.
  #my Str $module-name = self.^name;
  $signal-types{$module-name} //= {};

  for %signal-descriptions.kv -> $signal-type, $signal-names {
    note "add $signal-type, $signal-names.perl()" if $gobject-debug;
    my @names = $signal-names ~~ List ?? @$signal-names !! ($signal-names,);
    for @names -> $signal-name {
      if $signal-type ~~ any(
        <notsupported deprecated signal event nativewidget>
      ) {
        note "  $module-name, $signal-name --> $signal-type" if $gobject-debug;
        $signal-types{$module-name}{$signal-name} = $signal-type;
      }

      else {
        note "  Signal $signal-name is not yet supported" if $gobject-debug;
      }
    }
  }

  True
}

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

=head2 Not yet supported signals
=head3 notify

The notify signal is emitted on an object when one of its properties has its value set through g_object_set_property(), g_object_set(), et al.

Note that getting this signal doesn’t itself guarantee that the value of the property has actually changed. When it is emitted is determined by the derived GObject class. If the implementor did not create the property with C<G_PARAM_EXPLICIT_NOTIFY>, then any call to g_object_set_property() results in C<notify> being emitted, even if the new value is the same as the old. If they did pass C<G_PARAM_EXPLICIT_NOTIFY>, then this signal is emitted only when they explicitly call C<g_object_notify()> or C<g_object_notify_by_pspec()>, and common practice is to do that only when the value has actually changed.

This signal is typically used to obtain change notification for a single property, by specifying the property name as a detail in the C<g_signal_connect()> call, like this:

Signal C<notify> is not yet supported.


=end pod
