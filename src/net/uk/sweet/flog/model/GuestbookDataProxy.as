/**
 * Proxy for remoting call which returns image data
 */

package net.uk.sweet.flog.model 
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	
	import net.uk.sweet.flog.ApplicationFacade;
	import net.uk.sweet.flog.model.EntityProxy;
	import net.uk.sweet.flog.model.enum.ItemTypes;
	import net.uk.sweet.flog.model.vo.GuestbookVO;
	import net.uk.sweet.utils.GUID;
	import net.uk.sweet.utils.Logger;
	import net.uk.sweet.utils.SweetDate;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.utilities.startupmanager.interfaces.IStartupProxy;
	
	public class GuestbookDataProxy extends EntityProxy implements IStartupProxy
	{
		public static const NAME:String = "GuestbookDataProxy";
		public static const SRNAME:String = "GuestbookDataSRProxy";

		public function GuestbookDataProxy() 
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
			var table:String = xml.remoting.table.toString();
			
			var responder:Responder = new Responder(resultHandler, faultHandler);
			
			var ns:NetConnection = new NetConnection();
			ns.objectEncoding = ObjectEncoding.AMF0;
			ns.connect(gateway);
			ns.call(service + "." + method, responder, ItemTypes.GUESTBOOK);			
        }
		
		private function resultHandler(result:Object):void
		{
			var items:Array = result.serverInfo.initialData;
			var arr:Array = [];
			
			for (var i:int = 0; i < items.length; i ++) 
			{
				var date:Date = SweetDate.convertSQLToAS(items[i][3]);
				var name:String = items[i][1];
				var message:String = items[i][2];				
				
				arr.push(getItem(name, message, date));
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
		
		public function getItem(name:String, message:String, date:Date = null):GuestbookVO
		{	
			if (date == null)
				date = new Date();
			
			return new GuestbookVO(
				GUID.create(), 
				ItemTypes.GUESTBOOK, 
				"*", 
				date, 
				date.time, 
				name, 
				message); 
		}
	}
}