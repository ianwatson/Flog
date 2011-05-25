package net.uk.sweet.flog.view
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.text.TextFieldAutoSize;
	
	import net.uk.sweet.components.*;
	import net.uk.sweet.flog.ApplicationFacade;
	import net.uk.sweet.flog.model.*;
	import net.uk.sweet.flog.model.vo.MenuVO;
	import net.uk.sweet.flog.view.components.*;
	import net.uk.sweet.model.*;
	import net.uk.sweet.utils.Logger;
	
	import org.casalib.collection.*;
	import org.libspark.ui.SWFWheel;
	import org.puremvc.as3.interfaces.*;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.utilities.startupmanager.model.StartupMonitorProxy;

    /**
     * A Mediator for interacting with the Stage.
     */
    public class StageMediator extends Mediator implements IMediator
    {
        // Cannonical name of the Mediator
        public static const NAME:String = 'StageMediator';
		
        /**
         * Constructor. 
         */
        public function StageMediator(viewComponent:Object) 
        {
            // pass the viewComponent to the superclass where 
            // it will be stored in the inherited viewComponent property
            super(NAME, viewComponent);
    
            // Retrieve reference to frequently consulted Proxies
            //spriteDataProxy = facade.retrieveProxy(SpriteDataProxy.NAME) as SpriteDataProxy;
            
			SWFWheel.initialize(stage);
			
            // Listen for events from the stage 
            stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
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
			        StartupMonitorProxy.LOADING_PROGRESS,
					StartupMonitorProxy.LOAD_RESOURCE_TIMED_OUT,
					StartupMonitorProxy.LOADING_COMPLETE,
					StartupMonitorProxy.LOADING_FINISHED_INCOMPLETE,
					StartupMonitorProxy.CALL_OUT_OF_SYNC_IGNORED,
					/* StartuMonitorProxy.LOAD_RESOURCES_REJECTED, */
					ApplicationFacade.STARTUP_RESOURCE_LOADING,
					ApplicationFacade.STARTUP_RESOURCE_LOADED,
					ApplicationFacade.STARTUP_RESOURCE_FAILED
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
			var type:String = note.getType();
			
			switch ( note.getName() )
			{
				case ApplicationFacade.STARTUP_RESOURCE_LOADING:
				{
					trace("StageMediator.handleNotification(): " + type + " loading");
                    break;
				}
                case ApplicationFacade.STARTUP_RESOURCE_LOADED: 
				{
					trace("StageMediator.handleNotification(): " + type + " loaded");
					Logger.output("StageMediator.handleNotification(): " + type + " loaded");
                    break;
				}
					
				//case StartupMonitorProxy.LOAD_RESOURCES_REJECTED:
                case StartupMonitorProxy.CALL_OUT_OF_SYNC_IGNORED:
				{
                    trace( "Abnormal State, Abort" );
                    break;
				}
                case StartupMonitorProxy.LOADING_PROGRESS:
				{
					var perc:Number = note.getBody() as Number;
                    trace( "Loading Progress: " + perc + "%" );
                    Logger.output( "Loading Progress: " + perc + "%" );
                    break;
				}
                case StartupMonitorProxy.LOADING_COMPLETE:
				{
                    trace( ">>> Loading Complete" );
                    Logger.output( ">>> Loading Complete" );
					initializeView();
                    break;
				}
                case StartupMonitorProxy.LOADING_FINISHED_INCOMPLETE:
				{
                    trace( "Loading Finished Incomplete" );
                    break;
				}
			}
        }

		private function initializeView():void
		{			
			Logger.output("init view");
			
			createBackground();
			createCloud();
			createDate();
			
			stage.addEventListener(Event.RESIZE, resizeHandler);
			
			// everything is initialised and ready to be themed
			sendNotification(ApplicationFacade.UPDATE_THEME);
		}		
		
		private function createBackground():void
		{
			var background:Sprite = new Sprite();
			stage.addChild(background);
			
			facade.registerMediator(new BackgroundMediator(BackgroundMediator.NAME, background));
		}
		
		private function createCloud():void
		{
			var cloud3D:Cloud3D = new Cloud3D();
			stage.addChild(cloud3D);
			
			facade.registerMediator(new CloudMediator(CloudMediator.NAME, cloud3D));
		}

		private function createDate():void
		{
			var date:Label = new Label();
			stage.addChild(date);
			
			facade.registerMediator(new DateMediator(DateMediator.NAME, date));
		}
		
		private function resizeHandler(event:Event):void
		{
			sendNotification(ApplicationFacade.RESIZE);
		}
		
        // The user has turned the mouse wheel over the stage
        private function mouseWheelHandler(event:MouseEvent):void
        {
			Logger.output("StageMediator.handleMouseWheel(): delta: " + event.delta);
			sendNotification(ApplicationFacade.MOUSE_SCROLLED, event.delta);
        }
		
		// The user has moved the mouse wheel over the stage
		private function mouseMoveHandler(event:MouseEvent):void
		{
			//Logger.output("StageMediator.mouseMoveHandler(): ");
			sendNotification(ApplicationFacade.MOUSE_MOVED, new Point(stage.mouseX, stage.mouseY));
		}
		
		private function keyDownHandler(event:KeyboardEvent):void
		{
			var delta:int = 0;
			if (event.keyCode == 38)
			{
				delta = 3;
			}
			else if (event.keyCode == 40)
			{
				delta = -3;
			}
			else 
			{
				delta = 0;
			}
			
			sendNotification(ApplicationFacade.MOUSE_SCROLLED, delta);
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
        protected function get stage():Stage
		{
            return viewComponent as Stage;
        }
    }
}