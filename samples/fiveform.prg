#include "FiveLinux.ch"

function Main()

   local oWnd

   DEFINE WINDOW oWnd

   @ 2, 2 BUTTON "Button" OF oWnd DESIGN ;
      ACTION MsgInfo( "click" )

   @ 4, 2 BUTTON "Button" OF oWnd DESIGN ;
      ACTION MsgInfo( "click" )

   ACTIVATE WINDOW oWnd CENTER

return nil

#pragma BEGINDUMP

#include <hbapi.h>
#include <gtk/gtk.h>

static gboolean delete_event( GtkWidget *widget, GdkEvent  *event, gpointer   data ) 
{
    g_print ("delete event occurred\n");

    /* Change TRUE to FALSE and the main window will be destroyed with
     * a "delete_event". */

    return FALSE;
}

/* Another callback */
static void destroy( GtkWidget *widget, gpointer   data ) {
    gtk_main_quit ();
}

GtkWidget *window;
GtkWidget *button;
GtkWidget *button2;
GtkWidget *fixed;

int sx,sy;

static gboolean button_press_event( GtkWidget *widget, GdkEventButton *event ) {
	if (event->button == 1 ) printf("but down  %i , %i\n", (int)event->x, (int)event->y);
	sx=(int)event->x;
	sy=(int)event->y;

	return TRUE;
}

static gboolean
motion_notify_event( GtkWidget *widget, GdkEventMotion *event ) {

	int x, y;
	GdkModifierType state;
	gdk_window_get_pointer (window->window, &x, &y, &state);
	
	if (state & GDK_BUTTON1_MASK) {
		printf(" %i , %i \n", x-sx, y-sy);
		gtk_fixed_move( (GtkFixed*)fixed,(GtkWidget*)widget, x-sx, y-sy );
	
	}

	return TRUE;
}


HB_FUNC( TEST )
{
    window = gtk_window_new (GTK_WINDOW_TOPLEVEL);

	button = gtk_button_new_with_label ("A button");
	button2 = gtk_button_new_with_label ("Another button");

	fixed=gtk_fixed_new();

	gtk_container_add((GtkContainer*)window,(GtkWidget*)fixed);

	gtk_fixed_put( (GtkFixed*)fixed,button,50,50 );
	gtk_fixed_put( (GtkFixed*)fixed,button2,250,100 );


    g_signal_connect (G_OBJECT (window), "delete_event",G_CALLBACK (delete_event), NULL);
    g_signal_connect (G_OBJECT (window), "destroy",G_CALLBACK (destroy), NULL);

	gtk_signal_connect (GTK_OBJECT (button), "button_press_event",(GtkSignalFunc) button_press_event, NULL);
	gtk_signal_connect (GTK_OBJECT (button), "motion_notify_event",(GtkSignalFunc) motion_notify_event, NULL);

	gtk_signal_connect (GTK_OBJECT (button2), "button_press_event",(GtkSignalFunc) button_press_event, NULL);
	gtk_signal_connect (GTK_OBJECT (button2), "motion_notify_event",(GtkSignalFunc) motion_notify_event, NULL);

    gtk_container_set_border_width (GTK_CONTAINER (window), 0);

	gtk_widget_set_events(window, GDK_EXPOSURE_MASK
			 | GDK_LEAVE_NOTIFY_MASK
			 | GDK_BUTTON_PRESS_MASK
			 | GDK_POINTER_MOTION_MASK
			 | GDK_POINTER_MOTION_HINT_MASK); 

	gtk_widget_set_events(button, GDK_EXPOSURE_MASK
			 | GDK_LEAVE_NOTIFY_MASK
			 | GDK_BUTTON_PRESS_MASK
			 | GDK_POINTER_MOTION_MASK
			 | GDK_POINTER_MOTION_HINT_MASK); 

	gtk_widget_set_events(button2, GDK_EXPOSURE_MASK
			 | GDK_LEAVE_NOTIFY_MASK
			 | GDK_BUTTON_PRESS_MASK
			 | GDK_POINTER_MOTION_MASK
			 | GDK_POINTER_MOTION_HINT_MASK); 


    gtk_widget_show (button);
    gtk_widget_show (button2);
    gtk_widget_show (fixed);
    gtk_widget_show (window);
    
    gtk_main ();
}

#pragma ENDDUMP
