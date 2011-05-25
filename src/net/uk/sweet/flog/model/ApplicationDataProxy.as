/**
 * Loads the content XML from path specified in "content_xml" of flashVars 
 * or DEFAULT_PATH static if not defined, and exposes data for other proxies to use
 * via raw XML data
 */

package net.uk.sweet.flog.model 
{

	import flash.events.*;
	import flash.net.*;
	
	import net.uk.sweet.flog.ApplicationFacade;
	import net.uk.sweet.flog.interfaces.ICloudVO;
	import net.uk.sweet.flog.model.EntityProxy;
	import net.uk.sweet.flog.model.vo.*;
	import net.uk.sweet.model.Dictionary;
	import net.uk.sweet.model.Settings;
	
	import org.casalib.collection.*;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import org.puremvc.as3.utilities.startupmanager.interfaces.IStartupProxy;
	
	public class ApplicationDataProxy extends EntityProxy implements IStartupProxy
	{
		public static const NAME:String = "ApplicationDataProxy";
        public static const SRNAME:String = "ApplicationDataSRProxy";

		private static const DEFAULT_PATH:String = "xml/content.xml";
		
		private var loader:URLLoader = new URLLoader();
		private var _selectedItem:ICloudVO;
				
		public function ApplicationDataProxy() 
		{
			super(NAME);
		}
		
		public function load():void 
		{
            sendLoadedNotification(ApplicationFacade.STARTUP_RESOURCE_LOADING, NAME, SRNAME);
			
			var proxy:IProxy = facade.retrieveProxy(InitVarsProxy.NAME);
			var source:String = proxy.getData().content_xml || DEFAULT_PATH;
			
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
			
			// store the raw data
			this.data = new XML(event.target.data);
			this.data.ignoreWhitespace = true;

			// grab dictionary and settings
			Dictionary.getInstance().data = parseKeyValueData(data.dictionary.children());
			Settings.getInstance().data = parseKeyValueData(data.settings.children());

			sendLoadedNotification(ApplicationFacade.STARTUP_RESOURCE_LOADED, NAME, SRNAME);
		}
		
		private function parseKeyValueData(xml:XMLList):Object
		{
			var data:Object = { };
			
			for (var i:int = 0; i < xml.length(); i ++)
			{
				var key:String = xml[i].@id;
				var value:String = xml[i].toString();
				
				data[key] = value;
			}

			return data;
		}	

		private function parseTheme():KulerVO
		{
			var id:String = data.default_theme.id;
			var title:String = data.default_theme.title;
			var swatches:XMLList = data.default_theme.swatches;
			var colors:Array = new Array();
			
			for each (var swatch:XML in swatches.swatch) 
				colors.push(parseInt("0x" + swatch));
			
			return new KulerVO(id, title, colors);
		}
		
		private function errorHandler(e:IOErrorEvent = null):void 
		{
			removeListeners();
            sendLoadedNotification(ApplicationFacade.STARTUP_RESOURCE_FAILED, NAME, SRNAME);
        }

		public function get theme():KulerVO
		{
			return parseTheme();
		}
		
		public function get cloudData():IList
		{
			var mediaData:MediaDataProxy = MediaDataProxy(
				facade.retrieveProxy(MediaDataProxy.NAME));
			
			var guestbookData:GuestbookDataProxy = GuestbookDataProxy(
				facade.retrieveProxy(GuestbookDataProxy.NAME));
			
			// join media and guestbook data and sort by date
			return new List((mediaData.getData() as Array).concat(
				(guestbookData.getData() as Array)).sortOn("time", Array.DESCENDING));
		}
		
		// Start date is today
		public function get startDate():Date
		{
			return new Date();	
		}
		
		// End date is the earliest cloud item
		public function get endDate():Date
		{
			return ICloudVO(cloudData.getItemAt(0)).date;
		}
		
		public function get selectedItem():ICloudVO { return _selectedItem; }
		
		public function setSelectedItem(value:ICloudVO):void 
		{
			_selectedItem = value;
			sendNotification(ApplicationFacade.SET_SELECTED_ITEM, _selectedItem); 
		}
	}
}