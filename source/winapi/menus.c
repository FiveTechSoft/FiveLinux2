#include <hbapi.h>
#include <gtk/gtk.h>

void MenuItemSelect( GtkMenuItem * hMenuItem, gpointer user_data );

HB_FUNC( CREATEMENU )
{
   hb_retnl( ( HB_ULONG ) gtk_menu_bar_new() );
}

HB_FUNC( CREATEPOPUP )
{
   hb_retnl( ( HB_ULONG ) gtk_menu_new() );
}

HB_FUNC( MENUSHOWPOPUP )
{
   gtk_menu_popup( ( GtkMenu * ) hb_parnl( 1 ), NULL, NULL, NULL, NULL, 0,
   		   gtk_get_current_event_time() );
}

HB_FUNC( MENUSHOWITEM )
{
   gtk_widget_show( ( GtkWidget * ) hb_parnl( 1 ) );
}

HB_FUNC( SETMENU )
{
   GtkWidget * hVBox = ( GtkWidget * ) gtk_object_get_data( GTK_OBJECT(
                       hb_parnl( 1 ) ), "vbox" );
   GtkWidget * hMenu = ( GtkWidget * ) hb_parnl( 2 );

   gtk_box_pack_start( GTK_BOX( hVBox ), hMenu, FALSE, FALSE, 0 );
   gtk_box_reorder_child( GTK_BOX( hVBox ), hMenu, 0 );
}

HB_FUNC( APPENDMENU )
{
   GtkWidget * hMenu = ( GtkWidget * ) hb_parnl( 1 );
   GtkWidget * hItem;

   if( HB_ISCHAR( 3 ) )
      hItem = gtk_image_menu_item_new_from_stock( hb_parc( 3 ), NULL );
   else
   {
      if( hb_parclen( 2 ) > 0 )
         hItem = gtk_menu_item_new_with_mnemonic( hb_parc( 2 ) );
      else
      {
         hItem = gtk_menu_item_new();
	 gtk_widget_set_sensitive( hItem, FALSE );
      }
   }   

   gtk_container_add( GTK_CONTAINER( hMenu ), hItem );

   gtk_signal_connect( GTK_OBJECT( hItem ), "activate",
   		       GTK_SIGNAL_FUNC( MenuItemSelect ), NULL );

   hb_retnl( ( HB_ULONG ) hItem );
}

HB_FUNC( ADDPOPUP )
{
   gtk_menu_item_set_submenu( GTK_MENU_ITEM( hb_parnl( 1 ) ),
   			      ( GtkWidget * ) hb_parnl( 2 ) );
}

HB_FUNC( MENUSELITEM )
{
   gtk_menu_shell_select_item( ( GtkMenuShell * ) hb_parnl( 1 ), ( GtkWidget * ) hb_parnl( 2 ) );
}
