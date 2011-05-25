package net.uk.sweet.flog.model
{
	import flash.errors.IOError;
	import flash.events.*;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.external.ExternalInterface;
	

    import org.puremvc.as3.interfaces.IProxy;
    import org.puremvc.as3.patterns.proxy.Proxy;
    import org.puremvc.as3.utilities.startupmanager.interfaces.IStartupProxy;	
	import org.puremvc.as3.utilities.startupmanager.controller.FailureInfo;

	import net.uk.sweet.utils.Logger;
	import net.uk.sweet.external.*;	
	
    import net.uk.sweet.flog.ApplicationFacade;
	import net.uk.sweet.flog.model.EntityProxy;
	
	/**
	 * <p>
	 * Initialises external interface using initializer class and sets up a call back for
	 * external interface data received. Provides a shortcut for sending data using the 
	 * ExternalInterface stack singleton, though this can be accessed directly.</p>
	 * <p>
	 * NB. This proxy is essentially coupled to the Lexus V8 version of external_interface.js</p>
	 */
	public class ExternalInterfaceProxy extends EntityProxy implements IStartupProxy 
	{
		public static const NAME:String = "ExternalInterfaceProxy";
        public static const SRNAME:String = "ExternalInterfaceSRProxy";
		
		/*
		 * External interface method constants. You shouldn't ever need to access these 
		 * directly as this proxy provides a shortcut for sending and receiving external 
		 * interface data to and from the standard methods within the associated JavaScript.
		 * However, the constants remain public in case the need should arise to add calls
		 * to the outgoing stack or register callbacks for incoming data directly in other 
		 * classes. 
		 */
		public static const JAVASCRIPT_INTERFACE:String = "javascriptInterface";
		public static const FLASH_INTERFACE:String = "flashInterface";
		
		// setup external interface command constants 
		private static const JAVASCRIPT_AVAILABLE:String = "javascript_available";
		private static const FLASH_AVAILABLE:String = "flash_available";
		
		private var initializer:ExternalInterfaceInitializer = new ExternalInterfaceInitializer();
		private var _initialized:Boolean;

		public function ExternalInterfaceProxy() 
		{
			super(NAME);
		}

		public function load():void
		{
            sendLoadedNotification(ApplicationFacade.STARTUP_RESOURCE_LOADING, NAME, SRNAME);
			
			addListeners();
			
			initializer.method = JAVASCRIPT_INTERFACE;
			initializer.javascriptAvailableCommand = JAVASCRIPT_AVAILABLE;
			initializer.flashAvailableCommand = FLASH_AVAILABLE;
			
			initializer.initialize();
		}
		
		private function addListeners():void
		{
			initializer.addEventListener(ExternalInterfaceInitializer.INITIALIZED, initializedHandler);
			initializer.addEventListener(ExternalInterfaceInitializer.ERROR, errorHandler);			
		}
		
		private function removeListeners():void
		{
			initializer.removeEventListener(ExternalInterfaceInitializer.INITIALIZED, initializedHandler);
			initializer.removeEventListener(ExternalInterfaceInitializer.ERROR, errorHandler);		
		}
		
		private function initializedHandler(event:Event = null):void 
		{	
			//trace("ExternalInterfaceProxy.initialisedHandler(): ");
			//logger.debug("External interface initialized");
			_initialized = true;
			createCallback();
			dispatchLoadedEvent();
		}
		
		private function createCallback():void
		{
			// set up handler to receive external interface data from JavaScript
			ExternalInterface.addCallback(FLASH_INTERFACE, dataReceivedHandler);				
		}
		
		private function dataReceivedHandler(data:*):void
		{
			Logger.output("ExternalInterfaceProxy.dataReceivedHandler(): received external interface command: " + data.command);
			sendNotification(ApplicationFacade.EXTERNAL_INTERFACE_RECEIVE, data);
		}
		
		/*
		 * If external interface fails to initialise we'll output a message
		 * to the logger but continue with the rest of the loading as normal. 
		 * This allows us to side-step the issue of external interface failing
		 * in the development environment because there is no access to the 
		 * associated JavaScript.
		 */
		private function errorHandler(event:ErrorEvent = null):void 
		{
			//trace("ExternalInterfaceProxy.errorHandler(): error: " + event.text);
			Logger.output("ExternalInterfaceProxy.errorHandler(): error: " + event.text);
			_initialized = false;
			dispatchLoadedEvent();
        }
		
		private function dispatchLoadedEvent():void
		{
			removeListeners();
			sendLoadedNotification(ApplicationFacade.STARTUP_RESOURCE_LOADED, NAME, SRNAME);
		}
		
		/**
		 * If you expect a return, you should probably call the stack directly and assign 
		 * a result handler to an object within the invoking class. 
		 * 
		 * @param	data
		 */
		public function send(data:*):void
		{
			Logger.output("ExternalInterfaceProxy.send(): sending external interface command: " + data);
			if (_initialized)
				ExternalInterfaceStack.getInstance().addCall(JAVASCRIPT_INTERFACE, data);
		}
		
		public function get initialized():Boolean { return _initialized; }
	}
}