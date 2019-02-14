[toc]

# Classes and relations
* All classes which work with GtkWidget e.g. return them on xyz_new(), are inheriting the GtkWidget class.

```plantuml

hide members
hide circle

'class Gui
'class GSignal
'GSignal <|-- GtkWidget
'X <-* Gui


class X

class GMain
class GList

class GdkScreen
class GdkDisplay
class GdkWindow

class GtkMain
class GtkCssProvider
class GtkTextBuffer
class GtkBuilder

class GObject

class GtkWidget

class GtkBin
class GtkContainer
class GtkTextView

class GtkLabel

class GtkButton
class GtkToggleButton
class GtkCheckButton
class GtkRadioButton

class GtkWindow
class GtkDialog
class GtkAboutDialog

GtkBin <|-- GtkButton
GtkButton <|-- GtkToggleButton
GtkToggleButton <|-- GtkCheckButton
GtkCheckButton <|-- GtkRadioButton

GtkBin <|-- GtkWindow
GtkWindow <|-- GtkDialog
GtkDialog <|-- GtkAboutDialog

GtkWidget <|-- GtkLabel
GtkWidget <|-- GtkEntry

GtkContainer <|-- GtkBin
GtkContainer <|-- GtkTextView
GtkWidget <|-- GtkContainer
'GtkBin --* GtkButton

'GdkScreen <---o GtkWidget
'GdkDisplay <---o GtkWidget
'GdkWindow <---o GtkWidget

GObject <|--- GtkWidget
GObject <|--- GtkBuilder
GObject <|--- GtkTextBuffer
GObject <|--- GtkCssProvider

GObject <|--- GdkScreen
GObject <|--- GdkWindow
GObject <|--- GdkDisplay

```
