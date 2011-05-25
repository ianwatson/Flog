/**
 * Proxy for remoting call which returns image data
 */

package net.uk.sweet.flog.model 
{
	import flash.events.Event;
	import flash.net.*;
	
	import net.uk.sweet.flog.ApplicationFacade;
	import net.uk.sweet.flog.interfaces.ICloudVO;
	import net.uk.sweet.flog.model.EntityProxy;
	import net.uk.sweet.flog.model.enum.ItemTypes;
	import net.uk.sweet.flog.model.vo.MediaVO;
	import net.uk.sweet.utils.*;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.utilities.startupmanager.interfaces.IStartupProxy;
	
	public class MediaDataProxy extends EntityProxy implements IStartupProxy
	{
		public static const NAME:String = "MediaDataProxy";
		public static const SRNAME:String = "MediaDataSRProxy";

		public function MediaDataProxy() 
		{
			super(NAME);
		}
		
		public function load() :void 
		{
            sendLoadedNotification(ApplicationFacade.STARTUP_RESOURCE_LOADING, NAME, SRNAME);
			
			var proxy:IProxy = this.facade.retrieveProxy(ApplicationDataProxy.NAME);
			var xml:XML = proxy.getData() as XML;
			
			var gateway:String = xml.remoting.gateway.toString();
			var service:String = xml.remoting.service.toString();
			var method:String = xml.remoting.method.toString();
			
			var responder:Responder = new Responder(resultHandler, faultHandler);
			
			var ns:NetConnection = new NetConnection();
			ns.objectEncoding = ObjectEncoding.AMF0;
			ns.connect(gateway);
			ns.call(service + "." + method, responder, ItemTypes.PHOTOS);			
        }
		
		private function resultHandler(result:Object):void
		{
			var items:Array = result.serverInfo.initialData;
			var arr:Array = [];
			
			for (var i:int = 0; i < items.length; i ++) 
			{
				var type:String = ItemTypes.PHOTOS;
				var title:String = items[i][1];
				var path:String = items[i][2];
				var url:String = items[i][3];
				var date:Date = SweetDate.convertSQLToAS(items[i][4]);
				var time:Number = date.getTime();

				arr.push(new MediaVO(GUID.create(), ItemTypes.PHOTOS, title, path, url, date, time));
			}
			
			this.data = arr;
			sendLoadedNotification(ApplicationFacade.STARTUP_RESOURCE_LOADED, NAME, SRNAME);	
		}
		
		private function faultHandler(fault:Object):void
		{
			sendLoadedNotification(ApplicationFacade.STARTUP_RESOURCE_FAILED, NAME, SRNAME);
			//trace("MediaDataProxy.faultHandler(): fault: " + fault);
			//for (var prop in fault) trace(prop + ": " + fault[prop]);
		}					
	}
}