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
#.note;
  given $e {

#TODO X::Method::NotFound
#     No such method 'message' for invocant of type 'Any'
#TODO Argument
#
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
sub test-call ( $handler, $gobject, |c ) is export {

  my List $sig-params = $handler.signature.params;
#note "Parameters: ", $sig-params, ', ', $gobject;
#note "P0: ", $sig-params[0].type.^name;
  if +$sig-params and
     $sig-params[0].type.^name ~~ m/^ ['GTK::V3::G' .*?]? 'N-G' / {
#note "\ncall with widget";
    &$handler( $gobject, |c)
  }

  else {
#note "\ncall without widget";
    &$handler(|c)
  }
}
