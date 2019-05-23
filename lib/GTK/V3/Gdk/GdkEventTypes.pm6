use v6;
#-------------------------------------------------------------------------------
=begin pod

=TITLE GTK::V3::Gdk::GdkEventTypes

=SUBTITLE Event Structures — Data structures specific to each type of event

=head1 Synopsis

  my GTK::V3::Gtk::GtkWindow $top-window .= new(:empty);
  $top-window.set-title('Hello GTK!');
  # ... etcetera ...

  # Register a signal handler for a window event
  $top-window.register-signal( self, 'handle-keypress', 'key-press-event');

  method handle-keypress ( :$widget, GdkEvent :$event ) {
    if $event.event-any.type ~~ GDK_KEY_PRESS and
       $event.event-key.keyval eq 's' {

      # key 's' pressed, stop process ...
    }
  }

The handler signature can also be defined as

  method handle-keypress ( :$widget, GdkEventKey :$event ) {
    if $event.type ~~ GDK_KEY_PRESS and $event.keyval eq 's' {

      # key 's' pressed, stop process ...
    }
  }


=end pod
#-------------------------------------------------------------------------------
use NativeCall;

use GTK::V3::X;
use GTK::V3::N::NativeLib;
use GTK::V3::N::N-GObject;
#use GTK::V3::Glib::GTypes;
use GTK::V3::Gdk::GdkTypes;

#-------------------------------------------------------------------------------
# https://developer.gnome.org/gdk3/stable/gdk3-Event-Structures.html
# https://developer.gnome.org/gdk3/stable/gdk3-Events.html
=begin pod
=head1 class GTK::V3::Gdk::GdkEventTypes
=end pod

unit class GTK::V3::Gdk::GdkEventTypes:auth<github:MARTIMM>;

#-------------------------------------------------------------------------------
=begin pod
=head1 Enums, Structs and Unions

=head2 Enum GdkEventType
Specifies the type of the event.

Do not confuse these events with the signals that GTK+ widgets emit. Although many of these events result in corresponding signals being emitted, the events are often transformed or filtered along the way.

In some language bindings, the values GDK_2BUTTON_PRESS and GDK_3BUTTON_PRESS would translate into something syntactically invalid (eg Gdk.EventType.2ButtonPress, where a symbol is not allowed to start with a number). In that case, the aliases GDK_DOUBLE_BUTTON_PRESS and GDK_TRIPLE_BUTTON_PRESS can be used instead.

=item GDK_NOTHING; a special code to indicate a null event.
=item GDK_DELETE; the window manager has requested that the toplevel window be hidden or destroyed, usually when the user clicks on a special icon in the title bar.
=item GDK_DESTROY; the window has been destroyed.
=item GDK_EXPOSE; all or part of the window has become visible and needs to be redrawn.
=item GDK_MOTION_NOTIFY; the pointer (usually a mouse) has moved.
=item GDK_BUTTON_PRESS; a mouse button has been pressed.
=item GDK_2BUTTON_PRESS; a mouse button has been double-clicked (clicked twice within a short period of time). Note that each click also generates a GDK_BUTTON_PRESS event.
=item GDK_DOUBLE_BUTTON_PRESS; alias for GDK_2BUTTON_PRESS, added in 3.6.
=item GDK_3BUTTON_PRESS; a mouse button has been clicked 3 times in a short period of time. Note that each click also generates a GDK_BUTTON_PRESS event.
=item GDK_TRIPLE_BUTTON_PRESS; alias for GDK_3BUTTON_PRESS, added in 3.6.
=item GDK_BUTTON_RELEASE; a mouse button has been released.
=item GDK_KEY_PRESS; a key has been pressed.
=item GDK_KEY_RELEASE; a key has been released.
=item GDK_ENTER_NOTIFY; the pointer has entered the window.
=item GDK_LEAVE_NOTIFY; the pointer has left the window.
=item GDK_FOCUS_CHANGE; the keyboard focus has entered or left the window.
=item GDK_CONFIGURE; the size, position or stacking order of the window has changed. Note that GTK+ discards these events for GDK_WINDOW_CHILD windows.
=item GDK_MAP; the window has been mapped.
=item GDK_UNMAP; the window has been unmapped.
=item GDK_PROPERTY_NOTIFY; a property on the window has been changed or deleted.
=item GDK_SELECTION_CLEAR; the application has lost ownership of a selection.
=item GDK_SELECTION_REQUEST; another application has requested a selection.
=item GDK_SELECTION_NOTIFY; a selection has been received.
=item GDK_PROXIMITY_IN; an input device has moved into contact with a sensing surface (e.g. a touchscreen or graphics tablet).
=item GDK_PROXIMITY_OUT; an input device has moved out of contact with a sensing surface.
=item GDK_DRAG_ENTER; the mouse has entered the window while a drag is in progress.
=item GDK_DRAG_LEAVE; the mouse has left the window while a drag is in progress.
=item GDK_DRAG_MOTION; the mouse has moved in the window while a drag is in progress.
=item GDK_DRAG_STATUS; the status of the drag operation initiated by the window has changed.
=item GDK_DROP_START; a drop operation onto the window has started.
=item GDK_DROP_FINISHED; the drop operation initiated by the window has completed.
=item GDK_CLIENT_EVENT; a message has been received from another application.
=item GDK_VISIBILITY_NOTIFY; the window visibility status has changed.
=item GDK_SCROLL; the scroll wheel was turned.
=item GDK_WINDOW_STATE; the state of a window has changed. See GdkWindowState for the possible window states.
=item GDK_SETTING. a setting has been modified.
=item GDK_OWNER_CHANGE; the owner of a selection has changed. This event type was added in 2.6
=item GDK_GRAB_BROKEN; a pointer or keyboard grab was broken. This event type was added in 2.8.
=item GDK_DAMAGE; the content of the window has been changed. This event type was added in 2.14.
=item GDK_TOUCH_BEGIN; A new touch event sequence has just started. This event type was added in 3.4.
=item GDK_TOUCH_UPDATE; A touch event sequence has been updated. This event type was added in 3.4.
=item GDK_TOUCH_END; A touch event sequence has finished. This event type was added in 3.4.
=item GDK_TOUCH_CANCEL; A touch event sequence has been canceled. This event type was added in 3.4.
=item GDK_TOUCHPAD_SWIPE; A touchpad swipe gesture event, the current state is determined by its phase field. This event type was added in 3.18.
=item GDK_TOUCHPAD_PINCH; A touchpad pinch gesture event, the current state is determined by its phase field. This event type was added in 3.18.
=item GDK_PAD_BUTTON_PRESS; A tablet pad button press event. This event type was added in 3.22.
=item GDK_PAD_BUTTON_RELEASE; A tablet pad button release event. This event type was added in 3.22.
=item GDK_PAD_RING; A tablet pad axis event from a "ring". This event type was added in 3.22.
=item GDK_PAD_STRIP; A tablet pad axis event from a "strip". This event type was added in 3.22.
=item GDK_PAD_GROUP_MODE; A tablet pad group mode change. This event type was added in 3.22.
=item GDK_EVENT_LAST; Marks the end of the GdkEventType enumeration. Added in 2.18
=end pod
#TODO look in include file if GDK_2BUTTON_PRESS has same int as GDK_DOUBLE_BUTTON_PRESS
# enum size = int because of use of -1.
enum GdkEventType is export <<
  :GDK_NOTHING(-1) GDK_DELETE GDK_DESTROY GDK_EXPOSE GDK_MOTION_NOTIFY
  GDK_BUTTON_PRESS GDK_2BUTTON_PRESS GDK_3BUTTON_PRESS GDK_BUTTON_RELEASE
  GDK_KEY_PRESS GDK_KEY_RELEASE GDK_ENTER_NOTIFY GDK_LEAVE_NOTIFY
  GDK_FOCUS_CHANGE GDK_CONFIGURE GDK_MAP GDK_UNMAP GDK_PROPERTY_NOTIFY
  GDK_SELECTION_CLEAR GDK_SELECTION_REQUEST GDK_SELECTION_NOTIFY
  GDK_PROXIMITY_IN GDK_PROXIMITY_OUT GDK_DRAG_ENTER GDK_DRAG_LEAVE
  GDK_DRAG_MOTION GDK_DRAG_STATUS GDK_DROP_START GDK_DROP_FINISHED
  GDK_CLIENT_EVENT GDK_VISIBILITY_NOTIFY
  :GDK_SCROLL(31) GDK_WINDOW_STATE
  GDK_SETTING GDK_OWNER_CHANGE GDK_GRAB_BROKEN GDK_DAMAGE GDK_TOUCH_BEGIN
  GDK_TOUCH_UPDATE GDK_TOUCH_END GDK_TOUCH_CANCEL GDK_TOUCHPAD_SWIPE
  GDK_TOUCHPAD_PINCH GDK_PAD_BUTTON_PRESS GDK_PAD_BUTTON_RELEASE
  GDK_PAD_RING GDK_PAD_STRIP GDK_PAD_GROUP_MODE GDK_EVENT_LAST

  :GDK_DOUBLE_BUTTON_PRESS(5)
  :GDK_TRIPLE_BUTTON_PRESS(6)
  >>;

#-------------------------------------------------------------------------------
=begin pod
=head2 GdkScrollDirection

Specifies the direction for GdkEventScroll.

=item GDK_SCROLL_UP: the window is scrolled up.
=item GDK_SCROLL_DOWN: the window is scrolled down.
=item GDK_SCROLL_LEFT: the window is scrolled to the left.
=item GDK_SCROLL_RIGHT: the window is scrolled to the right.
=item GDK_SCROLL_SMOOTH: the scrolling is determined by the delta values in C<GdkEventScroll>.
=comment See C<gdk_event_get_scroll_deltas()>. Since: 3.4

=end pod

enum GdkScrollDirection is export <
  GDK_SCROLL_UP GDK_SCROLL_DOWN GDK_SCROLL_LEFT GDK_SCROLL_RIGHT
  GDK_SCROLL_SMOOTH
>;

#-------------------------------------------------------------------------------
=begin pod
=head2 GdkCrossingMode

Specifies the crossing mode for C<GdkEventCrossing>.

=item GDK_CROSSING_NORMAL: crossing because of pointer motion.
=item GDK_CROSSING_GRAB: crossing because a grab is activated.
=item GDK_CROSSING_UNGRAB: crossing because a grab is deactivated.
=item GDK_CROSSING_GTK_GRAB: crossing because a GTK+ grab is activated.
=item GDK_CROSSING_GTK_UNGRAB: crossing because a GTK+ grab is deactivated.
=item GDK_CROSSING_STATE_CHANGED: crossing because a GTK+ widget changed state (e.g. sensitivity).
=item GDK_CROSSING_TOUCH_BEGIN: crossing because a touch sequence has begun, this event is synthetic as the pointer might have not left the window.
=item GDK_CROSSING_TOUCH_END: crossing because a touch sequence has ended, this event is synthetic as the pointer might have not left the window.
=item GDK_CROSSING_DEVICE_SWITCH: crossing because of a device switch (i.e. a mouse taking control of the pointer after a touch device), this event is synthetic as the pointer didn’t leave the window.

=end pod

enum GdkCrossingMode is export <
  GDK_CROSSING_NORMAL GDK_CROSSING_GRAB GDK_CROSSING_UNGRAB
  GDK_CROSSING_GTK_GRAB GDK_CROSSING_GTK_UNGRAB GDK_CROSSING_STATE_CHANGED
  GDK_CROSSING_TOUCH_BEGIN GDK_CROSSING_TOUCH_END GDK_CROSSING_DEVICE_SWITCH
>;

#-------------------------------------------------------------------------------
=begin pod
=head2 class GdkNotifyType

 Specifies the kind of crossing for #GdkEventCrossing. See the X11 protocol specification of LeaveNotify for full details of crossing event generation.

=item GDK_NOTIFY_ANCESTOR: the window is entered from an ancestor or left towards an ancestor.
=item GDK_NOTIFY_VIRTUAL: the pointer moves between an ancestor and an inferior of the window.
=item GDK_NOTIFY_INFERIOR: the window is entered from an inferior or left towards an inferior.
=item GDK_NOTIFY_NONLINEAR: the window is entered from or left towards a window which is neither an ancestor nor an inferior.
=item GDK_NOTIFY_NONLINEAR_VIRTUAL: the pointer moves between two windows which are not ancestors of each other and the window is part of the ancestor chain between one of these windows and their least common ancestor.
=item GDK_NOTIFY_UNKNOWN: an unknown type of enter/leave event occurred.
=end pod

enum GdkNotifyType is export <
  GDK_NOTIFY_ANCESTOR GDK_NOTIFY_VIRTUAL GDK_NOTIFY_INFERIOR
  GDK_NOTIFY_NONLINEAR GDK_NOTIFY_NONLINEAR_VIRTUAL GDK_NOTIFY_UNKNOWN
>;

#-------------------------------------------------------------------------------
=begin pod
=head2 class GdkEventAny

Contains the fields which are common to all event classes. This comes in handy to check its type for instance.

=item UInt $.type; the type of the event.
=item N-GObject $.window; the window which received the event.
=item Int $.send_event; 1 if the event was sent explicitly.

=end pod

class GdkEventAny is repr('CStruct') is export {
  has uint32 $.type;              # GdkEventType
  has N-GObject $.window;         # GdkWindow
  has int8 $.send_event;
}

#-------------------------------------------------------------------------------
=begin pod
=head2 class GdkEventKey

Describes a key press or key release event. The type of the event will be one of GDK_KEY_PRESS or GDK_KEY_RELEASE.

=item UInt $.type; the type of the event.
=item N-GObject $.window; the window which received the event.
=item Int $.send_event; 1 if the event was sent explicitly.
=item UInt $.time; the time of the event in milliseconds.
=item UInt $.state; a bit-mask representing the state of the modifier keys (e.g. Control, Shift and Alt) and the pointer buttons. See GdkModifierType.	[type GdkModifierType].
=item UInt $.keyval; the key that was pressed or released. See the gdk/gdkkeysyms.h header file for a complete list of GDK key codes.
=item Int $.length; the length of string.
=item Str $.string; deprecated.
=item UInt $.hardware_keycode; the raw code of the key that was pressed or released.
=item UInt $.group; the keyboard group.
=item UInt $.is_modifier; a flag that indicates if hardware_keycode is mapped to a modifier. Since 2.10
=end pod

class GdkEventKey is repr('CStruct') is export {
  has uint32 $.type;              # GdkEventType
  has N-GObject $.window;         # GdkWindow
  has int8 $.send_event;
  has uint32 $.time;
  has uint32 $.state;             # GdkModifierType
  has uint32 $.keyval;
  has int $.length;
  has Str $.string;
  has uint16 $.hardware_keycode;
  has uint8 $.group;
  has uint32 $.is_modifier;
}

#-------------------------------------------------------------------------------
=begin pod
=head2 class GdkEventButton

Used for mouse button press and button release events. The type will be one of GDK_BUTTON_PRESS, GDK_2BUTTON_PRESS, GDK_3BUTTON_PRESS or GDK_BUTTON_RELEASE,

Double and triple-clicks result in a sequence of events being received. For double-clicks the order of events will be: GDK_BUTTON_PRESS, GDK_BUTTON_RELEASE, GDK_BUTTON_PRESS, GDK_2BUTTON_PRESS and GDK_BUTTON_RELEASE.

Note that the first click is received just like a normal button press, while the second click results in a GDK_2BUTTON_PRESS being received just after the GDK_BUTTON_PRESS.

Triple-clicks are very similar to double-clicks, except that GDK_3BUTTON_PRESS is inserted after the third click. The order of the events is: GDK_BUTTON_PRESS, GDK_BUTTON_RELEASE, GDK_BUTTON_PRESS, GDK_2BUTTON_PRESS, GDK_BUTTON_RELEASE, GDK_BUTTON_PRESS, GDK_3BUTTON_PRESS and  GDK_BUTTON_RELEASE.

For a double click to occur, the second button press must occur within 1/4 of a second of the first. For a triple click to occur, the third button press must also occur within 1/2 second of the first button press.

To handle e.g. a triple mouse button presses, all events can be ignored except GDK_3BUTTON_PRESS

  method handle-keypress ( :$widget, GdkEventButton :$event ) {
    # check if left mouse button was pressed three times
    if $event.type ~~ GDK_3BUTTON_PRESS and $event.button == 1 {
      ...
    }
  }

=item UInt $.type; the type of the event.
=item N-GObject $.window; the window which received the event.
=item Int $.send_event;
=item UInt $.time; the time of the event in milliseconds.
=item Num $.x; the x coordinate of the pointer relative to the window.
=item Num $.y; the y coordinate of the pointer relative to the window.
=item Pointer[Num] $.axes; x , y translated to the axes of device , or NULL if device is the mouse.
=item UInt $.state; a bit-mask representing the state of the modifier keys (e.g. Control, Shift and Alt) and the pointer buttons. See GdkModifierType.
=item UInt $.button; the button which was pressed or released, numbered from 1 to 5. Normally button 1 is the left mouse button, 2 is the middle button, and 3 is the right button. On 2-button mice, the middle button can often be simulated by pressing both mouse buttons together.
=item N-GObject $.device; the master device that the event originated from. Use gdk_event_get_source_device() to get the slave device.
=item Num $.x_root; the x coordinate of the pointer relative to the root of the screen.
=item Num $.y_root; the y coordinate of the pointer relative to the root of the screen.

=end pod

class GdkEventButton is repr('CStruct') is export {
  has uint32 $.type;              # GdkEventType
  has N-GObject $.window;         # GdkWindow
  has int8 $.send_event;
  has uint32 $.time;
  has num64 $.x;
  has num64 $.y;
  has Pointer[num64] $.axes;
  has uint32 $.state;             # GdkModifierType
  has uint32 $.button;
  has N-GObject $.device;         # GdkDevice
  has num64 $.x_root;
  has num64 $.y_root;
}

#-------------------------------------------------------------------------------
=begin pod
=head2 class GdkEventTouch

Used for touch events. type field will be one of GDK_TOUCH_BEGIN, GDK_TOUCH_UPDATE, GDK_TOUCH_END or GDK_TOUCH_CANCEL.

Touch events are grouped into sequences by means of the sequence field, which can also be obtained with gdk_event_get_event_sequence(). Each sequence begins with a GDK_TOUCH_BEGIN event, followed by any number of GDK_TOUCH_UPDATE events, and ends with a GDK_TOUCH_END (or GDK_TOUCH_CANCEL) event. With multitouch devices, there may be several active sequences at the same time.

=item UInt $.type; the type of the event (GDK_TOUCH_BEGIN, GDK_TOUCH_UPDATE, GDK_TOUCH_END, GDK_TOUCH_CANCEL)
=item N-GObject $.window; the window which received the event.
=item Int $.send_event;

=item UInt $.time; the time of the event in milliseconds.
=item Num $.x; the x coordinate of the pointer relative to the window
=item Num $.y; the y coordinate of the pointer relative to the window
=item Pointer[num64] $.axes; x , y translated to the axes of device , or NULL if device is the mouse
=item Num state; a bit-mask representing the state of the modifier keys (e.g. Control, Shift and Alt) and the pointer buttons. See GdkModifierType.
=item Pointer $.sequence; the event sequence that the event belongs to
=item Num emulating_pointer; whether the event should be used for emulating pointer event (0 or 1)
=item N-GObject $.device; the master device that the event originated from. Use gdk_event_get_source_device() to get the slave device.
=item Num $.x_root; the x coordinate of the pointer relative to the root of the screen
=item Num $.y_root; the y coordinate of the pointer relative to the root of the screen

=end pod

class GdkEventTouch is repr('CStruct') is export {
  has uint32 $.type;              # GdkEventType
  has N-GObject $.window;         # GdkWindow
  has uint8 $.send_event;
  has uint32 $.time;
  has num64 $.x;
  has num64 $.y;
  has Pointer[num64] $.axes;
  has uint32 $.state;             # GdkModifierType
  has Pointer $.sequence;         # GdkEventSequence
  has int32 $.emulating_pointer;
  has N-GObject $.device;         # GdkDevice
  has num64 $.x_root;
  has num64 $.y_root;
}

#-------------------------------------------------------------------------------
=begin pod
=head2 GdkEventScroll:

Generated from button presses for the buttons 4 to 7. Wheel mice are usually configured to generate button press events for buttons 4 and 5 when the wheel is turned.

Some GDK backends can also generate “smooth” scroll events, which can be recognized by the GDK_SCROLL_SMOOTH scroll direction. For these, the scroll deltas can be obtained with gdk_event_get_scroll_deltas().

 =item UInt $.type: the type of the event (GDK_SCROLL).
 =item N-GObject $.window: the window which received the event.
 =item UInt $.send_event: 1 if the event was sent explicitly.
 =item UInt $.time: the time of the event in milliseconds.
 =item Num $.x: the x coordinate of the pointer relative to the window.
 =item Num $.y: the y coordinate of the pointer relative to the window.
 =item GdkModifierType $.state: a bit-mask representing the state of the modifier keys (e.g. Control, Shift and Alt) and the pointer buttons. See GdkModifierType.
 =item GdkScrollDirection $.direction: the direction to scroll to (one of GDK_SCROLL_UP, GDK_SCROLL_DOWN, GDK_SCROLL_LEFT, GDK_SCROLL_RIGHT or GDK_SCROLL_SMOOTH).
 =item N-GObject $.device: the master device that the event originated from. Use gdk_event_get_source_device() to get the slave device.
 =item Num $.x_root: the x coordinate of the pointer relative to the root of the screen.
 =item Num $.y_root: the y coordinate of the pointer relative to the root of the screen.
 =item Num $.delta_x: the x coordinate of the scroll delta
 =item Num $.delta_y: the y coordinate of the scroll delta
=end pod

class GdkEventScroll is repr('CStruct') is export {
  has uint32 $.type;
  has N-GObject $.window;
  has uint8 $.send_event;
  has uint32 $.time;
  has num64 $.x;
  has num64 $.y;
  has uint32 $.state;             # GdkModifierType
  has uint32 $.direction;         # GdkScrollDirection
  has N-GObject $.device;         # GdkDevice
  has num64 $.x_root;
  has num64 $.y_root;
  has num64 $.delta_x;
  has num64 $.delta_y;
  has uint32 $.is_stop;
};

#-------------------------------------------------------------------------------
=begin pod
=head2 GdkEventMotion

Generated when the pointer moves.

=item UInt $.type: the type of the event.
=item N-GObject $.window: the window which received the event.
=item UInt $.send_event: %TRUE if the event was sent explicitly.
=item UInt $.time: the time of the event in milliseconds.
=item Num $.x: the x coordinate of the pointer relative to the window.
=item Num $.y: the y coordinate of the pointer relative to the window.
=item Pointer[Num] $.axes: x, y translated to the axes of @device, or NULL if device is the mouse.
=item UInt $.state: (type GdkModifierType): a bit-mask representing the state of the modifier keys (e.g. Control, Shift and Alt) and the pointer buttons. See GdkModifierType.
=item Int $.is_hint: set to 1 if this event is just a hint, see the GDK_POINTER_MOTION_HINT_MASK value of GdkEventMask.
=item N-GObject $.device: the master device that the event originated from. Use C<gdk_event_get_source_device()> to get the slave device.
=item Num $.x_root: the x coordinate of the pointer relative to the root of the screen.
=item Num $.y_root: the y coordinate of the pointer relative to the root of the screen.
=end pod

class GdkEventMotion is repr('CStruct') is export {
  has uint32 $.type;
  has N-GObject $.window;
  has uint8 $.send_event;
  has uint32 $.time;
  has num64 $.x;
  has num64 $.y;
  has Pointer[num64] $.axes;
  has uint $.state;
  has int16 $.is_hint;
  has N-GObject $.device;         # GdkDevice
  has num64 $.x_root;
  has num64 $.y_root;
};

#-------------------------------------------------------------------------------
=begin pod
=head2 GdkEventExpose

Generated when all or part of a window becomes visible and needs to be redrawn.

=item UInt $.type: the type of the event (GDK_EXPOSE or GDK_DAMAGE).
=item N-GObject $.window: the window which received the event.
=item UInt $.send_event: 1 if the event was sent explicitly.
=item GdkRectangle $.area: bounding box of @egion.
=item Pointer $.region: the region that needs to be redrawn. A region is of type C<cairo_region_t> and represents a set of integer-aligned rectangles. It allows set-theoretical operations like cairo_region_union() and cairo_region_intersect() to be performed on them.
=comment Memory management of cairo_region_t is done with cairo_region_reference() and cairo_region_destroy().
=item Int $.count: the number of contiguous GDK_EXPOSE events following this one. The only use for this is “exposure compression”, i.e. handling all contiguous GDK_EXPOSE events in one go, though GDK performs some exposure compression so this is not normally needed.
=end pod

class GdkEventExpose is repr('CStruct') is export {
  has uint32 $.type;
  has N-GObject $.window;
  has uint8 $.send_event;
  has GdkRectangle $.area;        # GdkRectangle
  has Pointer $.region;           # cairo_region_t
  has int32 $.count;              # If non-zero, how many more events follow.
};

#-------------------------------------------------------------------------------
=begin pod
=head2 GdkEventCrossing

Generated when the pointer enters or leaves a window.

=item UInt $.type: the type of the event (GDK_ENTER_NOTIFY or GDK_LEAVE_NOTIFY).
=item N-GObject $.window: the window which received the event.
=item UInt $.send_event: 1 if the event was sent explicitly.
=item N-GObject $.subwindow: the window that was entered or left.
=item UInt $.time: the time of the event in milliseconds.
=item Num $.x: the x coordinate of the pointer relative to the window.
=item Num $.y: the y coordinate of the pointer relative to the window.
=item Num $.x_root: the x coordinate of the pointer relative to the root of the screen.
=item Num $.y_root: the y coordinate of the pointer relative to the root of the screen.
=item GdkCrossingMode $.mode: the crossing mode (GDK_CROSSING_NORMAL, GDK_CROSSING_GRAB, GDK_CROSSING_UNGRAB, GDK_CROSSING_GTK_GRAB, GDK_CROSSING_GTK_UNGRAB or GDK_CROSSING_STATE_CHANGED). GDK_CROSSING_GTK_GRAB, GDK_CROSSING_GTK_UNGRAB, GDK_CROSSING_STATE_CHANGED were added in 2.14 and are always synthesized, never native.
=item GdkNotifyType $.detail: the kind of crossing that happened (GDK_NOTIFY_INFERIOR, GDK_NOTIFY_ANCESTOR, GDK_NOTIFY_VIRTUAL, GDK_NOTIFY_NONLINEAR or GDK_NOTIFY_NONLINEAR_VIRTUAL).
=item Int $.focus: 1 if window is the focus window or an inferior.
=item UInt $.state: (type GdkModifierType): a bit-mask representing the state of the modifier keys (e.g. Control, Shift and Alt) and the pointer buttons. See GdkModifierType.
=end pod

class GdkEventCrossing is repr('CStruct') is export {
  has uint32 $.type;
  has N-GObject $.window;
  has uint8 $.send_event;
  has N-GObject $.subwindow;      # GdkWindow
  has uint32 $.time;
  has num64 $.x;
  has num64 $.y;
  has num64 $.x_root;
  has num64 $.y_root;
  has uint32 $.mode;              # GdkCrossingMode
  has uint32 $.detail;            # GdkNotifyType
  has int32 $.focus;
  has uint32 $.state;             # GdkModifierType
};

#-------------------------------------------------------------------------------
=begin pod
=head2 GdkEventFocus

Describes a change of keyboard focus.

=item UInt $.type: the type of the event (GDK_FOCUS_CHANGE).
=item N-GObject $.window: the window which received the event.
=item UInt $.send_event: %TRUE if the event was sent explicitly.
=item Int $.in: 1 if the window has gained the keyboard focus, 0 if it has lost the focus.
=end pod

class GdkEventFocus is repr('CStruct') is export {
  has uint32 $.type;
  has N-GObject $.window;
  has uint8 $.send_event;
  has int16 $.in;
};

#-------------------------------------------------------------------------------
=begin pod
=head2 GdkEventConfigure

Generated when a window size or position has changed.

=item GdkEventType $.type: the type of the event (GDK_CONFIGURE).
=item N-GObject $.window: the window which received the event.
=item Int $.send_event: 1 if the event was sent explicitly.
=item Int $.x: the new x coordinate of the window, relative to its parent.
=item Int $.y: the new y coordinate of the window, relative to its parent.
=item Int $.width: the new width of the window.
=item Int $.height: the new height of the window.
=end pod

class GdkEventConfigure is repr('CStruct') is export {
  has uint32 $.type;
  has N-GObject $.window;
  has uint8 $.send_event;
  has int32 $.x;
  has int32 $.y;
  has int32 $.width;
  has int32 $.height;
};

#-------------------------------------------------------------------------------
=begin pod
=head2 GdkEvent

The event structures contain data specific to each type of event in GDK. The type is a union of all structures explained above.

=end pod

class GdkEvent is repr('CUnion') is export {
  HAS GdkEventAny $.event-any;
  HAS GdkEventKey $.event-key;
  HAS GdkEventButton $.event-button;
  HAS GdkEventTouch $.event-touch;
  HAS GdkEventScroll $.event-scroll;
  HAS GdkEventMotion $.event-motion;
  HAS GdkEventExpose $.event-expose;
  HAS GdkEventCrossing $.event-crossing;
  HAS GdkEventFocus $.event-focus;
  HAS GdkEventConfigure $.event-configure;
}

#-------------------------------------------------------------------------------
# No need to define subs because all can be read from structures above.
#`{{

=begin pod
=head1 Methods

=head2 [gdk_event_] get_button

  method gdk_event_get_button ( uint $button is rw --> Int )

Extract the button number from an event.
=end pod
sub gdk_event_get_button ( GdkEvent $event, uint $button is rw )
  returns int32
  is native(&gobject-lib)
  { * }
}}
