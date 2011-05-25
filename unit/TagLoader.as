/**
 * Proxy for remoting call which returns image data
 */

package
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	
	
	public class TagLoader extends EventDispatcher
	{
		private var _tags:Array = new Array();
		
		public function TagLoader() 
		{
			super();
		}
		
		public function load() :void 
		{
			var gateway:String = "http://sweetweb.dsvr.co.uk/amfphp/gateway.php";
			var service:String = "LucillesFlog";
			var method:String = "GetEntries";
			var table:String = "photos";
			
			var responder:Responder = new Responder(resultHandler, faultHandler);
			
			var ns:NetConnection = new NetConnection();
			ns.objectEncoding = ObjectEncoding.AMF0;
			ns.connect(gateway);
			ns.call(service + "." + method, responder, table);			
        }
		
		private function resultHandler(result:Object):void
		{
			var items:Array = result.serverInfo.initialData;
			for (var i:int = 0; i < items.length; i ++) 
			{
				var title:String = items[i][1];
				//var path:String = items[i][2];
				//var url:String = items[i][3];
				//var date:String = items[i][4];
				
				
				
				//trace("ImageDataProxy.resultHandler(): title: " + title);
				//trace("ImageDataProxy.resultHandler(): path: " + path);
				//trace("ImageDataProxy.resultHandler(): url: " + url);
				//trace("ImageDataProxy.resultHandler(): date: " + date);
				
				//_mediaData.addItem(new MediaVO(title, path, url, date));
				_tags.push(title);
			}
			
			//sendLoadedNotification(ApplicationFacade.MEDIA_DATA_LOADED, NAME, SRNAME);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function faultHandler(fault:Object):void
		{
			trace("ImageDataProxy.faultHandler(): fault: " + fault);
			//for (var prop in fault) trace(prop + ": " + fault[prop]);
		}
		
		public function get tags():Array { return _tags; }
	}
}