#include <hbapi.h>
#include <gtk/gtk.h>

gboolean PaintEvent( GtkWidget * widget, GdkEventExpose * event );
gboolean KeyPressEvent( GtkWidget * hWnd, GdkEventKey * event );
gboolean ButtonPressEvent( GtkWidget * hWnd, GdkEventButton * event );
gboolean motion_notify_event( GtkWidget * hWnd, GdkEventMotion * event );

#define GTK_BROWSE(obj)          GTK_CHECK_CAST(obj, gtk_browse_get_type(), GtkBrowse)
#define GTK_BROWSE_CLASS(klass)  GTK_CHECK_CLASS_CAST(klass, gtk_browse_get_type(), GtkBrowseClass)
#define GTK_IS_BROWSE(obj)       GTK_CHECK_TYPE(obj, gtk_browse_get_type ())

typedef struct _GtkBrowse        GtkBrowse;
typedef struct _GtkBrowseClass   GtkBrowseClass;

struct _GtkBrowse
{
   GtkWidget widget;

   // new data
   PangoLayout * layout;
   GtkAdjustment * hadjustment;
   GtkAdjustment * vadjustment;
};

struct _GtkBrowseClass
{
  GtkWidgetClass parent_class;

  void ( * set_scroll_adjustments ) ( GtkBrowse     * browse,
		 		      GtkAdjustment * hadjustment,
				      GtkAdjustment * vadjustment );
};

GtkType gtk_browse_get_type( void );

static GtkWidgetClass * parent_class = NULL;

static void BrwScrollAdjustments( GtkBrowse * hWnd, GtkAdjustment * hAdj,
                                  GtkAdjustment * vAdj )
{
}

static void gtk_browse_realize( GtkWidget * widget )
{
   GdkWindowAttr attributes;
   gint attributes_mask;

   g_return_if_fail( widget != NULL );
   g_return_if_fail( GTK_IS_BROWSE( widget ) );

   GTK_WIDGET_SET_FLAGS( widget, GTK_REALIZED );

   attributes.x = widget->allocation.x;
   attributes.y = widget->allocation.y;
   attributes.width = widget->allocation.width;
   attributes.height = widget->allocation.height;
   attributes.wclass = GDK_INPUT_OUTPUT;
   attributes.window_type = GDK_WINDOW_CHILD;
   attributes.event_mask = gtk_widget_get_events (widget) |
   GDK_EXPOSURE_MASK | GDK_BUTTON_PRESS_MASK | GDK_2BUTTON_PRESS |
   GDK_BUTTON_RELEASE_MASK | GDK_POINTER_MOTION_MASK |
   GDK_POINTER_MOTION_HINT_MASK;
   attributes.visual = gtk_widget_get_visual (widget);
   attributes.colormap = gtk_widget_get_colormap (widget);

   attributes_mask = GDK_WA_X | GDK_WA_Y | GDK_WA_VISUAL | GDK_WA_COLORMAP;
   widget->window = gdk_window_new (widget->parent->window, &attributes, attributes_mask);

   widget->style = gtk_style_attach (widget->style, widget->window);

   gdk_window_set_user_data( widget->window, widget );
   gdk_window_set_background( widget->window, &widget->style->base[GTK_STATE_NORMAL] );

   // gtk_style_set_background( widget->style, widget->window, GTK_STATE_NORMAL );
}

static void gtk_browse_class_init( GtkBrowseClass * class )
{
   // GtkObjectClass * object_class = ( GtkObjectClass * ) class;
   GtkWidgetClass * widget_class = ( GtkWidgetClass * ) class;

   parent_class = gtk_type_class( gtk_widget_get_type() );

   /*
   object_class->destroy = gtk_dial_destroy; */

   widget_class->realize         = gtk_browse_realize; // builds it
   widget_class->expose_event    = PaintEvent;         // paint
   widget_class->key_press_event = KeyPressEvent;      // pulsacion tecla
   widget_class->button_press_event = ButtonPressEvent; // click ratón
   // widget_class->button_press2_event = ButtonPress2Event; // double click ratón

   class->set_scroll_adjustments = BrwScrollAdjustments;

   /*
   widget_class->size_request = gtk_dial_size_request;
   widget_class->size_allocate = gtk_dial_size_allocate;
   widget_class->button_press_event = gtk_dial_button_press;
   widget_class->button_release_event = gtk_dial_button_release;
   widget_class->motion_notify_event = gtk_dial_motion_notify; */

   /*
   widget_class->set_scroll_adjustments_signal =
    g_signal_new ("set_scroll_adjustments",
		  G_OBJECT_CLASS_TYPE (G_OBJECT_CLASS(class)),
		  G_SIGNAL_RUN_LAST | G_SIGNAL_ACTION,
		  G_STRUCT_OFFSET (GtkBrowseClass, set_scroll_adjustments),
		  NULL, NULL,
		  _gtk_marshal_VOID__OBJECT_OBJECT,
		  G_TYPE_NONE, 2,
		  GTK_TYPE_ADJUSTMENT,
		  GTK_TYPE_ADJUSTMENT); */
}

static void gtk_browse_init( GtkBrowse * browse )
{
   browse->layout = gtk_widget_create_pango_layout( GTK_WIDGET( browse ), "" );
   browse->hadjustment = ( GtkAdjustment * ) gtk_adjustment_new( 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 );
   browse->vadjustment = ( GtkAdjustment * ) gtk_adjustment_new( 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 );
}

GtkType gtk_browse_get_type( void )
{
  static GtkType browse_type = 0;

  if( ! browse_type )
    {
      static const GtkTypeInfo browse_info =
      {
	 "GtkBrowse",
	 sizeof( GtkBrowse ),
	 sizeof( GtkBrowseClass ),
	 ( GtkClassInitFunc ) gtk_browse_class_init,
	 ( GtkObjectInitFunc ) gtk_browse_init,
	/* reserved_1 */ NULL,
	/* reserved_1 */ NULL,
	( GtkClassInitFunc ) NULL
      };

      browse_type = gtk_type_unique ( GTK_TYPE_WIDGET, &browse_info );
    }

   return browse_type;
}

GtkWidget * gtk_browse_new( void )
{
  GtkBrowse * browse = gtk_type_new( gtk_browse_get_type() );

  GTK_WIDGET_SET_FLAGS( GTK_WIDGET( browse ), GTK_CAN_FOCUS );

  return GTK_WIDGET( browse );
}

HB_FUNC( CREATEBROWSE )
{
   GtkBrowse * hWnd = ( GtkBrowse * ) gtk_browse_new();

   gtk_signal_connect( GTK_OBJECT( hWnd ), "button_press_event",
                       ( GtkSignalFunc ) ButtonPressEvent, NULL );

   gtk_signal_connect( GTK_OBJECT( hWnd ), "motion_notify_event",
                       ( GtkSignalFunc ) motion_notify_event, NULL );

   gtk_widget_set_events( ( GtkWidget * ) hWnd, GDK_EXPOSURE_MASK
			 | GDK_LEAVE_NOTIFY_MASK
			 | GDK_BUTTON_PRESS_MASK
			 | GDK_POINTER_MOTION_MASK
			 | GDK_POINTER_MOTION_HINT_MASK );

   hb_retnl( ( HB_ULONG ) hWnd );
}

HB_FUNC( BRWDRAWHEADERS ) // ( hWnd, pEvent, aHeaders, aColSizes, nColPos )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 );
   GdkEventExpose * event = ( GdkEventExpose * ) hb_parnl( 2 );
   int iCols = hb_parinfa( 3, 0 ), i, iLeft = 0, iRight;

   for( i = hb_parnl( 5 ) - 1; i < iCols; i++ )
   {
      if( iLeft < hWnd->allocation.width )
      {
         iRight = hb_parvnl( 4, i + 1 );

         if( iLeft + iRight > hWnd->allocation.width )
            iRight = hWnd->allocation.width - iLeft;

         if( i + 1 == iCols )
            iRight = hWnd->allocation.width - iLeft;

         gtk_paint_box( hWnd->style, hWnd->window,
	      	        GTK_STATE_NORMAL, GTK_SHADOW_OUT,
		        &event->area, hWnd, "button",
		        iLeft, 0, iRight, 21 );

	 pango_layout_set_text( GTK_BROWSE( hWnd )->layout,
	                        hb_parvc( 3, i + 1 ), -1 );

         gdk_draw_layout( hWnd->window, hWnd->style->text_gc[GTK_STATE_NORMAL],
	                  iLeft + 6, 2, GTK_BROWSE( hWnd )->layout );

         iLeft += hb_parvnl( 4, i + 1 ) - 1;
      }
   }
}

HB_FUNC( BRWDRAWLINES ) // ( hWnd, aColSizes, nColPos )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 );
   int iColSizes = hb_parinfa( 2, 0 ), i, iLeft = 0;

   for( i = 2; i < hWnd->allocation.height / 20; i++ )
   {
      gdk_draw_line( hWnd->window, hWnd->style->text_gc[ GTK_STATE_NORMAL ],
                     0, i * 20, hWnd->allocation.width, i * 20 );
   }

   gdk_draw_line( hWnd->window, hWnd->style->text_gc[ GTK_STATE_NORMAL ],
                  0, hWnd->allocation.height - 1, hWnd->allocation.width,
		  hWnd->allocation.height - 1 );

   gdk_draw_line( hWnd->window, hWnd->style->text_gc[ GTK_STATE_NORMAL ],
                  0, 20, 0, hWnd->allocation.height );

   for( i = hb_parnl( 3 ); i < iColSizes && iLeft < hWnd->allocation.width; i++ )
   {
      iLeft += hb_parvnl( 2, i ) - 1;

      gdk_draw_line( hWnd->window, hWnd->style->text_gc[ GTK_STATE_NORMAL ],
                     iLeft, 20, iLeft, hWnd->allocation.height );
   }

   gdk_draw_line( hWnd->window, hWnd->style->text_gc[ GTK_STATE_NORMAL ],
                  hWnd->allocation.width - 1, 20, hWnd->allocation.width - 1,
		  hWnd->allocation.height );

}

HB_FUNC( BRWDRAWCELL ) // ( hWnd, nRow, nCol, cText, nWidth, lSelected, nRGBColorBackGround )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 );
   GdkRectangle rect = { hb_parnl( 3 ) + 1, hb_parnl( 2 ) + 1,
                         hb_parnl( 5 ) - 3, 19 };
   PangoAttrList * attrs;

   if( hb_pcount() > 6 )
   {
      if( ! HB_ISNIL( 7 ) )
      {
         GdkColor color;

         color.pixel = hb_parnl( 7 );

         gdk_gc_set_foreground( hWnd->style->base_gc[ GTK_STATE_NORMAL ], &color );  
      }
   }   

   if( ( rect.y + rect.height ) >= hWnd->allocation.height )
      rect.height = hWnd->allocation.height - rect.y;

   gdk_draw_rectangle( hWnd->window, hWnd->style->base_gc[ hb_parl( 6 ) ?
                       GTK_STATE_SELECTED : GTK_STATE_NORMAL ], TRUE,
		       hb_parnl( 3 ), hb_parnl( 2 ), hb_parnl( 5 ),
		       rect.height );

   pango_layout_set_text( ( ( GtkBrowse * ) hWnd )->layout, hb_parc( 4 ), -1 );

   if( hb_pcount() > 6 )
   {
      if( ! HB_ISNIL( 7 ) )
      {
         GdkColor color;

         color.pixel = 0xFFFFFF;

         gdk_gc_set_foreground( hWnd->style->base_gc[ GTK_STATE_NORMAL ], &color );  
      }
   }   

   if( hb_pcount() > 7 )
   {
      if( ! HB_ISNIL( 8 ) )
      {
         guint16 blue  = hb_parnl( 8 ) / 65536;
         guint16 green = ( hb_parnl( 8 ) - ( blue * 65536 ) ) / 256;
         guint16 red   = hb_parnl( 8 ) - ( blue * 65536 ) - ( green * 256 );        

         attrs = pango_attr_list_new();
      
         pango_attr_list_insert( attrs, pango_attr_foreground_new( red * 0xFF, green * 0xFF, blue * 0xFF ) );
         // oldAttrs = pango_layout_get_attributes( ( ( GtkBrowse * ) hWnd )->layout );
         pango_layout_set_attributes( ( ( GtkBrowse * ) hWnd )->layout, attrs );
      }
   }

   /* 
      pango_layout_set_width( ( ( GtkBrowse * ) hWnd )->layout, hb_parnl( 5 ) * PANGO_SCALE );

      pango_layout_set_alignment( ( ( GtkBrowse * ) hWnd )->layout, PANGO_ALIGN_RIGHT );

      gtk_paint_layout( hWnd->style, hWnd->window,
                        hb_parl( 6 ) ? GTK_STATE_ACTIVE : GTK_STATE_NORMAL,
                        TRUE, &rect, hWnd, "cellrenderertext",            
                        hb_parnl( 3 ) + hb_parnl( 5 ) - gdk_string_width( gtk_style_get_font( GTK_WIDGET( hWnd )->style ), hb_parc( 4 ) ) - 20, // hb_parnl( 3 ) + 5,
		        hb_parnl( 2 ) + 1, ( ( GtkBrowse * ) hWnd )->layout );
   */ 
 
   gdk_draw_layout( hWnd->window, hWnd->style->bg_gc[ GTK_STATE_NORMAL ],
                    rect.x, rect.y, ( ( GtkBrowse * ) hWnd )->layout );

   if( hb_pcount() > 7 )
   {
      if( ! HB_ISNIL( 8 ) )
      {
         // pango_layout_set_attributes( ( ( GtkBrowse * ) hWnd )->layout, oldAttrs );
         // g_free( attrs );

         guint16 blue  = 0;
         guint16 green = 0;
         guint16 red   = 0;        

         attrs = pango_attr_list_new();
      
         pango_attr_list_insert( attrs, pango_attr_foreground_new( red * 0xFF, green * 0xFF, blue * 0xFF ) );
         // oldAttrs = pango_layout_get_attributes( ( ( GtkBrowse * ) hWnd )->layout );
         pango_layout_set_attributes( ( ( GtkBrowse * ) hWnd )->layout, attrs );
      }
   }
}

HB_FUNC( BRWROWCOUNT ) // ( hWnd )
{
   hb_retnl( ( ( GtkWidget * ) hb_parnl( 1 ) )->allocation.height / 20 );
}

HB_FUNC( BRWSCROLLUP )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 );

   gdk_draw_pixmap( hWnd->window, hWnd->style->fg_gc[ GTK_STATE_NORMAL ],
                    hWnd->window, 0, 40, 0, 20, hWnd->allocation.width,
		    hWnd->allocation.height - 41 );
}

HB_FUNC( BRWSCROLLDOWN )
{
   GtkWidget * hWnd = ( GtkWidget * ) hb_parnl( 1 );

   gdk_draw_pixmap( hWnd->window, hWnd->style->fg_gc[ GTK_STATE_NORMAL ],
                    hWnd->window, 0, 20, 0, 40,
		    hWnd->allocation.width, hWnd->allocation.height - 41 );
}
