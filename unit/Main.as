package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * 
	 */
	public class Main extends MovieClip
	{
		private var data:TagLoader;
		private var cloud:TagCloud;
		
		public function Main() 
		{
			data = new TagLoader();
			data.addEventListener(Event.COMPLETE, dataLoadedHandler);
			data.load();				
		}
		
		private function dataLoadedHandler(event:Event):void 
		{
			//trace("Main.dataLoadedHandler(): ");
			cloud = new TagCloud(data.tags);
			addChild(cloud);
		}
	}
	
}