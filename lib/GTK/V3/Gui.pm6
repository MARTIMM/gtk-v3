use v6;

use GTK::V3::X;

# Role to capture tools and other thingies needed by widgets. This
# means that it cannot be used by GtkMain, GdkScreen etc

#-------------------------------------------------------------------------------
class N-GtkWidget
  is repr('CPointer')
  is export
  { }

#-------------------------------------------------------------------------------
role GTK::V3::Gui:auth<github:MARTIMM> {

  #-----------------------------------------------------------------------------
  has N-GtkWidget $!gtk-widget;
#  has Str $!native-sub-name = '';

  #-----------------------------------------------------------------------------
  method CALL-ME ( N-GtkWidget $widget? --> N-GtkWidget ) {

    if ?$widget {
      #if GdkWindow::GDK_WINDOW_TOPLEVEL
      #$!gtk-widget = N-GtkWidget;
      $!gtk-widget = $widget;
    }

    $!gtk-widget
  }

  #-----------------------------------------------------------------------------
  # Fallback method to find the native subs which then can be called as if it
  # were a method. Each class must provide their own 'fallback' method which,
  # when nothing found, must call the parents fallback with 'callsame'.
  # The subs in some class all start with some prefix which can be left out too
  # provided that the fallback functions must also test with an added prefix.
  # So e.g. a sub 'gtk_label_get_text' defined in class GtlLabel can be called
  # like '$label.gtk_label_get_text()' or '$label.get_text()'. As an extra
  # feature dashes can be used instead of underscores, so '$label.get-text()'
  # works too.
  method FALLBACK ( $native-sub, |c ) {

    CATCH { test-catch-exception( $_, $native-sub); }

    # call the fallback functions of the role user
    my Callable $s = self.fallback($native-sub);

    test-call( $s, $!gtk-widget, |c)
  }
}
