package net.uk.sweet.flog.view
{
    import flash.events.Event;
    import flash.geom.Point;
    
    import net.uk.sweet.flog.ApplicationFacade;
    import net.uk.sweet.flog.interfaces.ICloudVO;
    import net.uk.sweet.flog.model.vo.KulerVO;
    import net.uk.sweet.flog.model.vo.MediaVO;
    import net.uk.sweet.flog.view.components.*;
    import net.uk.sweet.utils.Logger;
    
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.Mediator;
	
    /**
     * A Mediator for interacting with the 3d cloud component.
     */
    public class CloudMediator extends BaseMediator
    {
        // Cannonical name of the Mediator
        public static const NAME:String = 'CloudMediator';
		
        /**
         * Constructor. 
         */
        public function CloudMediator(mediatorName:String = null, viewComponent:Object = null) 
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
						ApplicationFacade.UPDATE_THEME,
						ApplicationFacade.MOUSE_SCROLLED,
						ApplicationFacade.MOUSE_MOVED,
						ApplicationFacade.SET_SELECTED_ITEM, 
						ApplicationFacade.PAUSE,
						ApplicationFacade.RESTART,
						ApplicationFacade.RESET,
						ApplicationFacade.ADD_GUESTBOOK_ITEM
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
				case ApplicationFacade.UPDATE_THEME:
				{
					var theme:KulerVO = dataProxy.theme;
					cloud3D.setColors(theme.colors[1], theme.colors[2]);
					break;
				}
				case ApplicationFacade.MOUSE_SCROLLED:
				{	
					var delta:Number = note.getBody() as Number;
					//Logger.output("CloudMediator.handleNotification(): cloud scroll: " + delta);
					cloud3D.scroll(delta);
                    break;
				}
                case ApplicationFacade.MOUSE_MOVED: 
				{
					//trace("CloudMediator.handleNotification(): cloud shift: ");
					var point:Point = note.getBody() as Point;
					cloud3D.shift(point);
                    break;
				}
				case ApplicationFacade.SET_SELECTED_ITEM:
				{
					var guid:String = (note.getBody() as ICloudVO).guid;
					cloud3D.setSelectedGuid(guid);
					break;
				}
				case ApplicationFacade.PAUSE:
				{
					Logger.output("Pausing");
					cloud3D.pause();
					break;
				}
				case ApplicationFacade.RESTART:
				{
					Logger.output("Restarting");
					cloud3D.restart();
					break;
				}
				case ApplicationFacade.RESET:
				{
					Logger.output("Resetting");
					cloud3D.reset();
					break;
				}
				case ApplicationFacade.ADD_GUESTBOOK_ITEM:
				{
					Logger.output("Guestbook item added");
					break;
				}
			}
        }
         
		override public function onRegister():void 
		{
			super.onRegister();

			cloud3D.data = dataProxy.cloudData;
			cloud3D.startDate = dataProxy.startDate;
			cloud3D.endDate = dataProxy.endDate;
			cloud3D.labelIcon = libraryProxy.getAssetClass("OpenIcon");
			cloud3D.viewScale = parseFloat(settings.getSetting("view-scale"));
			cloud3D.timeRatio = parseFloat(settings.getSetting("time-ratio"));
			cloud3D.zoomIncrement = parseFloat(settings.getSetting("zoom-increment"));
			cloud3D.zoomDecay = parseFloat(settings.getSetting("zoom-decay"));
			cloud3D.zoomDuration = parseFloat(settings.getSetting("zoom-duration"));
			cloud3D.cameraFov = parseFloat(settings.getSetting("camera-fov"));
			cloud3D.cameraOffset = parseFloat(settings.getSetting("camera-offset"));
			cloud3D.panEasing = parseFloat(settings.getSetting("pan-easing"));
			cloud3D.visibleItems = parseInt(settings.getSetting("visible-items"));
			cloud3D.visibleOffset = parseInt(settings.getSetting("visible-offset"));
			cloud3D.intersectionRange = parseFloat(settings.getSetting("intersection-range"));
			cloud3D.intersectionRetries = parseFloat(settings.getSetting("intersection-retries"));
			cloud3D.addEventListener(Cloud3D.ITEM_CLICK, itemClickHandler);
			cloud3D.addEventListener(Cloud3D.DATE_CHANGE, dateChangeHandler);
			cloud3D.addEventListener(Cloud3D.ZOOM_COMPLETE, zoomCompleteHandler);
			cloud3D.init(cloud3D.stage.stageWidth, cloud3D.stage.stageHeight);
		}
		
		private function itemClickHandler(event:Event):void
		{
			//trace("CloudMediator.itemClickHandler(): ");
			var item:ICloudVO = ICloudVO(cloud3D.selectedItem.data);
			dataProxy.setSelectedItem(item);
		}
		
		private function dateChangeHandler(event:Event):void
		{
			//trace("CloudMediator.dateChangedHandler(): ");
			sendNotification(ApplicationFacade.UPDATE_DATE, cloud3D.getCurrentDate());
		}		
		
		private function zoomCompleteHandler(event:Event):void
		{
			sendNotification(ApplicationFacade.ZOOM_COMPLETED);
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
         * @return stage the viewComponent cast to flash.display.Stage
         */
        protected function get cloud3D():Cloud3D
		{
            return viewComponent as Cloud3D;
        }
    }
}