package net.uk.sweet.flog.view
{
    import flash.events.Event;
    import flash.geom.ColorTransform;
    import flash.text.TextFieldAutoSize;
    
    import net.uk.sweet.flog.ApplicationFacade;
    import net.uk.sweet.flog.view.components.*;
    import net.uk.sweet.utils.Logger;
    import net.uk.sweet.utils.SweetDate;
    
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.Mediator;

    /**
     * A Mediator for interacting with the date label component.
     */
    public class DateMediator extends BaseMediator
    {
        // Cannonical name of the Mediator
        public static const NAME:String = 'DateMediator';
		
        /**
         * Constructor. 
         */
        public function DateMediator(mediatorName:String = null, viewComponent:Object = null) 
        {
            // pass the viewComponent to the superclass where 
            // it will be stored in the inherited viewComponent property
            super(mediatorName, viewComponent);
        }


        /**
         * List all notifications this Mediator is interested in.
         * <P>
         * Automatically called by the framework when the mediator
         * is registered with the view.</P>
         * 
         * @return Array the list of Nofitication names
         */
        override public function listNotificationInterests():Array 
        {
			return  [    
						ApplicationFacade.UPDATE_DATE,
						ApplicationFacade.UPDATE_THEME
			        ];
        }

        /**
         * Handle all notifications this Mediator is interested in.
         * <P>
         * Called by the framework when a notification is sent that
         * this mediator expressed an interest in when registered
         * (see <code>listNotificationInterests</code>.</P>
         * 
         * @param INotification a notification 
         */
        override public function handleNotification( note:INotification ):void 
        {
			switch ( note.getName() )
			{
				case ApplicationFacade.UPDATE_DATE:
				{	
					//trace("DateMediator.handleNotification(): date changed: ");
					var today:Date = note.getBody() as Date;
					date.setText("<p class='date'>" + SweetDate.localeDateString(today) + "</p>");
					date.x = (date.stage.stageWidth - date.width) / 2;
                    break;
				}
				case ApplicationFacade.UPDATE_THEME:
				{
					var colorTransform:ColorTransform = new ColorTransform();
					colorTransform.color = dataProxy.theme.colors[0];
					date.transform.colorTransform = colorTransform;
					break;
				}
			}
        }	

		override public function onRegister():void
		{
			super.onRegister();
			
			date.border = true;
			date.styleSheet = styleSheetProxy.styleSheet;
			date.autoSize = TextFieldAutoSize.LEFT;
			date.y = date.stage.stageHeight - 40;
		}
		
        /**
         * Cast the viewComponent to its actual type.
         * 
         * <P>
         * This is a useful idiom for mediators. The
         * PureMVC Mediator class defines a viewComponent
         * property of type Object. </P>
         * 
         * <P>
         * Here, we cast the generic viewComponent to 
         * its actual type in a protected mode. This 
         * retains encapsulation, while allowing the instance
         * (and subclassed instance) access to a 
         * strongly typed reference with a meaningful
         * name.</P>
         * 
         * @return date the viewComponent cast to Label
         */
        protected function get date():Label
		{
            return viewComponent as Label;
        }
    }
}