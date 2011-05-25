
// TODO: unused. should be removed

package net.uk.sweet.flog.model 
{

	import flash.events.*;
	import flash.net.*;	
	
    import org.puremvc.as3.interfaces.IProxy;
    import org.puremvc.as3.patterns.proxy.Proxy;
	
	import org.casalib.collection.*;	
	
    import net.uk.sweet.flog.ApplicationFacade;
	import net.uk.sweet.flog.model.*;	
	import net.uk.sweet.flog.model.vo.KulerVO;
	import net.uk.sweet.model.Settings;	
	
	public class KulerProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "KulerProxy";

		private var loader:URLLoader = new URLLoader();
		
		private var _index:int = 0;
		private var _themes:IList = new List();
		
		private var _currentTheme:KulerVO;		
		
		public function KulerProxy() 
		{
			super(NAME);
		}
		
		public function load():void 
		{
			sendNotification(ApplicationFacade.LOAD_STARTED);
			
			var source:String = Settings.getInstance().getSetting("kuler-feed") 
								+ "&startIndex=" + _index;
								
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
			
			this.data = new XML(event.target.data);
			this.data.ignoreWhitespace = true;

			var kuler:Namespace = new Namespace("http://kuler.adobe.com/kuler/API/rss/");
			var theme:XML = data.channel.item[0].kuler::themeItem[0];
		
			var id:String = theme.kuler::themeID;
			var title:String = theme.kuler::themeTitle;
			var colors:Array = new Array();
			var swatches:XMLList = theme.kuler::themeSwatches;
			
			for each (var swatch:XML in swatches.kuler::swatch)
			{
				colors.push(Number("0x" + swatch.kuler::swatchHexColor));
			}
			
			_themes.addItem(new KulerVO(id, title, colors));
			
			updateTheme();
			sendNotification(ApplicationFacade.LOAD_COMPLETED);
		}
		
		private function errorHandler(e:IOErrorEvent = null):void 
		{
			removeListeners();
            //sendLoadedNotification(ApplicationFacade.STARTUP_RESOURCE_FAILED, NAME, SRNAME);
        }
		
		public function nextTheme():void
		{
			_index ++;
			(_index > _themes.size - 1) ? load() : updateTheme();
		}
		
		public function previousTheme():void
		{
			_index --;
			updateTheme();
		}
		
		private function updateTheme():void
		{
			sendNotification(ApplicationFacade.UPDATE_THEME);
		}
		
		public function get currentTheme():KulerVO { return _themes.getItemAt(_index); }
		
		public function addTheme(value:KulerVO):void 
		{
			_themes.addItem(value);
		}
	}
}