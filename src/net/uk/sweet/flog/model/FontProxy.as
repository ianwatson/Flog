package net.uk.sweet.flog.model 
{
	import flash.events.*;
	import flash.system.ApplicationDomain;
	import flash.text.Font;
	import flash.text.StyleSheet;
	
	import org.puremvc.as3.interfaces.IFacade;
    import org.puremvc.as3.interfaces.IProxy;
    import org.puremvc.as3.patterns.proxy.Proxy;
    import org.puremvc.as3.utilities.startupmanager.interfaces.IStartupProxy;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.ImageItem;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;	
	
    import net.uk.sweet.flog.ApplicationFacade;
	import net.uk.sweet.flog.model.EntityProxy;
	
	public class FontProxy extends EntityProxy implements IStartupProxy
	{
		public static const NAME:String = "FontProxy";
        public static const SRNAME:String = "FontSRProxy";

		private var loader:BulkLoader = new BulkLoader(NAME + "Loader");
		
		public function FontProxy() 
		{
			super(NAME);
		}
		
		public function load():void 
		{
            sendLoadedNotification(ApplicationFacade.STARTUP_RESOURCE_LOADING, NAME, SRNAME);
			
			/**
			 * TODO: Since it's native to PureMVC, http://trac.puremvc.org/Demo_AS3_Flex_StartupForAssets might be a better fit here
			 */
			
			var proxy:IProxy = this.facade.retrieveProxy(ApplicationDataProxy.NAME);
			var xml:XML = proxy.getData() as XML;
			var fontList:XMLList = xml.fonts.children();
			
			addListeners();
			
			// font registration is handled within the font SWF itself so 
			// all we need to worry about is loading the files in
			for (var i:int = 0; i < fontList.length(); i ++) 
			{
				var font:XML = fontList[i];
				var id:String = font.@id;
				var url:String = font.toString();

				loader.add(url, { id: id } );
			}	

			loader.start();
        }
		
		private function addListeners():void
		{
			loader.addEventListener(BulkLoader.COMPLETE, completeHandler);
			loader.addEventListener(BulkLoader.ERROR, errorHandler);
		}
		
		private function removeListeners():void
		{
			loader.removeEventListener(BulkLoader.COMPLETE, completeHandler);
			loader.removeEventListener(BulkLoader.ERROR, errorHandler);
		}		
		
		private function completeHandler(event:Event = null):void 
		{
			removeListeners();
			sendLoadedNotification(ApplicationFacade.STARTUP_RESOURCE_LOADED, NAME, SRNAME);
		}
		
		private function errorHandler(e:ErrorEvent = null):void 
		{
			removeListeners();
            sendLoadedNotification(ApplicationFacade.STARTUP_RESOURCE_FAILED, NAME, SRNAME);
        }

		public function get embeddedFonts():Array
		{
			return Font.enumerateFonts(false);
		}
		
		public function isFontEmbedded(name:String):Boolean
		{
			for (var i:int = 0; i < this.embeddedFonts.length; i ++) 
			{
				if (name == this.embeddedFonts[i].fontName) return true;
			}
			
			return false;
		}
	}
}