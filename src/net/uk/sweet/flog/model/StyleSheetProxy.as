package net.uk.sweet.flog.model 
{
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;
	
    import org.puremvc.as3.interfaces.IProxy;
    import org.puremvc.as3.patterns.proxy.Proxy;
    import org.puremvc.as3.utilities.startupmanager.interfaces.IStartupProxy;
	
    import net.uk.sweet.flog.ApplicationFacade;
	import net.uk.sweet.flog.model.EntityProxy;
	
	public class StyleSheetProxy extends EntityProxy implements IStartupProxy
	{
		public static const NAME:String = "StyleSheetProxy";
        public static const SRNAME:String = "StyleSheetSRProxy";

		private var loader:URLLoader = new URLLoader();
		
		public function StyleSheetProxy() 
		{
			super(NAME);
		}
		
		public function load() :void 
		{
            sendLoadedNotification(ApplicationFacade.STARTUP_RESOURCE_LOADING, NAME, SRNAME);
			
			// ApplicationDataProxy stores the styleSheet reference
			var proxy:IProxy = facade.retrieveProxy(ApplicationDataProxy.NAME);
			var xml:XML = proxy.getData() as XML; 
			var source:String = xml.stylesheet.toString();
			
			addListeners();
			loader.load(new URLRequest(source));
        }
		
		private function addListeners():void
		{
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
            loader.addEventListener(Event.COMPLETE, completeHandler);
		}
		
		private function removeListeners():void
		{
			loader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
            loader.removeEventListener(Event.COMPLETE, completeHandler);
		}
		
		private function completeHandler(event:Event = null):void 
		{
			removeListeners();
			
			data = new StyleSheet();
			data.parseCSS(URLLoader(event.target).data);
			sendLoadedNotification(ApplicationFacade.STARTUP_RESOURCE_LOADED, NAME, SRNAME);
		}
		
		private function errorHandler(e:IOErrorEvent = null):void 
		{
			removeListeners();
            sendLoadedNotification(ApplicationFacade.STARTUP_RESOURCE_FAILED, NAME, SRNAME);
        }
		
		public function get styleSheet():StyleSheet
        {
            return data as StyleSheet;
        }
	}
}