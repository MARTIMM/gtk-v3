use v6;

#-------------------------------------------------------------------------------
class X::Gui is Exception {
  has $.message;

  submethod BUILD ( Str:D :$!message ) { }
}

#-------------------------------------------------------------------------------
sub test-catch-exception ( Exception $e, Str $native-sub ) is export {

note "Error type: ", $e.WHAT;
note "Error message: ", $e.message;
note "Exception: ", $e;

  given $e {

#TODO X::Method::NotFound
#     No such method 'message' for invocant of type 'Any'
#TODO Argument
#     Calling gtk_button_get_label(N-GtkWidget, Str) will never work with declared signature (N-GtkWidget $widget --> Str)
#TODO Return
#     Type check failed for return value

    # X::AdHoc
    when .message ~~ m:s/Cannot invoke this object/ {
      die X::Gui.new(
        :message("Could not find native sub '$native-sub\(...\)'")
      );
    }

    # NotFound, triggered by getting signature from an Any
    when .message ~~ m:s/"No such method 'signature' for invocant of type 'Callable'"/ {
      die X::Gui.new(
        :message("Could not find native sub '$native-sub\(...\)'")
      );
    }

    # X::AdHoc
    when .message ~~ m:s/Native call expected return type/ {
      die X::Gui.new(
        :message("Wrong return type of native sub '$native-sub\(...\)'")
      );
    }

    # X::AdHoc
    when .message ~~ m:s/will never work with declared signature/ {
      die X::Gui.new(:message(.message));
    }

    when X::TypeCheck::Argument {
      die X::Gui.new(:message(.message));
    }

    default {
      die X::Gui.new(
        :message(.message)
      );
    }
  }
}

#-------------------------------------------------------------------------------
sub test-call ( Callable:D $found-routine, $gobject, |c --> Mu ) is export {

  my List $sig-params = $found-routine.signature.params;
note "TC 0 parameters: ", $found-routine.signature.params;
note "TC 1 type 1st arg: ", $sig-params[0].type.^name;

  if +$sig-params and
     $sig-params[0].type.^name ~~ m/^ ['GTK::V3::G' .*?]? 'N-G' / {
note "\ncall with widget: ", $gobject.gist, ', ', |c.gist;
    $found-routine( $gobject, |c)
  }

  else {
note "\ncall without widget: ", |c.gist;
    $found-routine(|c)
  }
}
