/**
 * Initialises and caches the Core actors of the triumverate:
 * Model, View and Controller.
 * Provides a single place to access all of their public methods. 
 * Allows Proxies, Mediators and Commands to talk to each other in a loosely coupled way, 
 * without having to import or work directly with the Core framework actors. 
 * 
*/
package net.uk.sweet.flog
{
	import flash.display.Stage;
	
	import net.uk.sweet.flog.controller.*;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;
	import org.puremvc.as3.utilities.startupmanager.controller.StartupResourceFailedCommand;
	import org.puremvc.as3.utilities.startupmanager.controller.StartupResourceLoadedCommand;
    
    public class ApplicationFacade extends Facade implements IFacade
	{
        // Startup notification name constants
		public static const INIT_VARS:String = "initVars";
		public static const STARTUP:String = "startup";
		
		public static const STARTUP_RESOURCE_LOADING:String = "startupResourceLoading";
		public static const STARTUP_RESOURCE_LOADED:String = "startupResourceLoaded";
		public static const STARTUP_RESOURCE_FAILED:String = "startupResourceFailed"; 	
		
		public static const RESIZE:String = "resize";
		
		public static const MOUSE_SCROLLED:String = "mouseScrolled";
		public static const MOUSE_MOVED:String = "mouseMoved";

		public static const LOGO_CLICKED:String = "logoClicked";
		public static const ZOOM_COMPLETED:String = "zoomCompleted";
		
		public static const LOAD_STARTED:String = "loadStarted";
		public static const LOAD_COMPLETED:String = "loadCompleted";
		
		public static const UPDATE_DATE:String = "updateDate";
		public static const UPDATE_THEME:String = "updateTheme";
		
		public static const SET_SELECTED_ITEM:String = "setSelectedItem";
		public static const ADD_GUESTBOOK_ITEM:String = "addGuestbookItem";
		public static const EXTERNAL_INTERFACE_RECEIVE:String = "externalInterfaceReceive";
		
		public static const PAUSE:String = "pause";
		public static const RESTART:String = "restart";
		public static const RESET:String = "reset";

        /**
         * Singleton ApplicationFacade Factory Method
         */
        public static function getInstance():ApplicationFacade
		{
            if (instance == null) instance = new ApplicationFacade();
            return instance as ApplicationFacade;
        }

        /**
         * Register Commands with the Controller 
         */
        override protected function initializeController() : void 
        {
            super.initializeController();         
			
			// Register startup commands
			registerCommand(INIT_VARS, InitVarsCommand);
			registerCommand(STARTUP, StartupCommand);  
			
			registerCommand(STARTUP_RESOURCE_LOADED, StartupResourceLoadedCommand);
			registerCommand(STARTUP_RESOURCE_FAILED, StartupResourceFailedCommand);
			
			registerCommand(EXTERNAL_INTERFACE_RECEIVE, ExternalInterfaceReceiveCommand);
			registerCommand(ZOOM_COMPLETED, ZoomCompletedCommand);
        }
        
        public function startup(stage:Stage, flashVars:Object):void
        {
			//trace("ApplicationFacade.startup(): " + flashVars);
			sendNotification(INIT_VARS, flashVars);
			sendNotification(STARTUP, stage);
        } 
    }
}