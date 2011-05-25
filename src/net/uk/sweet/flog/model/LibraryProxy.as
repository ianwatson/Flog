package net.uk.sweet.flog.model 
{
	import flash.errors.IOError;
	import flash.events.*;
	import flash.display.Loader;
	import flash.net.URLRequest;
	
    import org.puremvc.as3.interfaces.IProxy;
    import org.puremvc.as3.patterns.proxy.Proxy;
    import org.puremvc.as3.utilities.startupmanager.interfaces.IStartupProxy;	
	
	import com.blitzagency.xray.logger.XrayLogger;	
	import com.lassie.lib.IMediaLibrary;
	
	import net.uk.sweet.utils.Logger;
    import net.uk.sweet.flog.ApplicationFacade;
	import net.uk.sweet.flog.model.EntityProxy;
	
	/**
	 * Retrieves the path to the stylesheet from ApplicationData proxy, loads and parses it.
	 * Parsed stylesheet is exposed via styleSheet getter.
	 */
	public class LibraryProxy extends EntityProxy implements IStartupProxy
	{
		public static const NAME:String = "LibraryProxy";
        public static const SRNAME:String = "LibrarySRProxy";

		private var loader:Loader = new Loader();
		private var content:IMediaLibrary;
					
		public function LibraryProxy() 
		{
			super(NAME);
		}

		public function load():void
		{
            sendLoadedNotification(ApplicationFacade.STARTUP_RESOURCE_LOADING, NAME, SRNAME);
			
			var proxy:IProxy = facade.retrieveProxy(ApplicationDataProxy.NAME);
			var xml:XML = proxy.getData() as XML; 
			var source:String = xml.library.toString();

			addListeners();
			loader.load(new URLRequest(source));
		}
		
		private function addListeners():void
		{
			loader.contentLoaderInfo.addEventListener(Event.INIT, completeHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		}
		
		private function removeListeners():void
		{
			loader.contentLoaderInfo.removeEventListener(Event.INIT, completeHandler);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);		
		}		

		private function completeHandler(event:Event = null):void 
		{	
			content = loader.content as IMediaLibrary;
			removeListeners();
			sendLoadedNotification(ApplicationFacade.STARTUP_RESOURCE_LOADED, NAME, SRNAME);
		}
		
		private function errorHandler(event:IOErrorEvent = null):void 
		{
			removeListeners();
            sendLoadedNotification(ApplicationFacade.STARTUP_RESOURCE_FAILED, NAME, SRNAME);
        }
		
		/**
		 * Get a list of classes which have been exposed by the MediaLibrary
		 * @return
		 */
		public function get contents():Array 
		{ 
			return content.contents; 
		}
		
		/**
		 * Get an asset by string ref
		 * @param	ref
		 * @return   asset of any type
		 */
		public function getAsset(ref:String):* 
		{ 
			return content.getAsset(ref); 
		}
		
		/**
		 * 
		 */
		public function getAssetClass(ref:String):Class 
		{ 
			return content.getAssetClass(ref); 
		}
	}
}