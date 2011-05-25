package 
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	import net.uk.sweet.flog.library.OpenIcon;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.special.Letter3DMaterial;
	import org.papervision3d.objects.primitives.Sphere;
	import org.papervision3d.typography.fonts.HelveticaBold;
	import flash.display.Sprite;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import net.uk.sweet.flog.view.components.InteractiveText3D;
	import org.papervision3d.typography.VectorLetter3D;
	
	/**
	 * ...
	 * @author Ian Watson
	 */
	public class Button extends PaperBase
	{
		public function Button()
		{
			super();
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.INIT, loadCompleteHandler);
			loader.load(new URLRequest("../bin/assets/library.swf"));

		}
		
		private function loadCompleteHandler(event:Event):void
		{
			trace("Button.loadCompleteHandler(): ");
			init(stage.stageWidth, stage.stageHeight);	
			
			//var cross:MovieClip = new OpenIcon();
			//addChild(cross);
			//
			//var cross2:MovieClip = new OpenIcon();
			//cross2.y = 50;
			//addChild(cross2);
		}
		
		override protected function init3d():void
		{		
			//var sphere:Sphere = new Sphere(new ColorMaterial(0xff0000, 1), 200);
			//sphere.alpha = 0;
			//default_scene.addChild(sphere);
			
			var item:InteractiveText3D = new InteractiveText3D("Hello World", new HelveticaBold(), "1");
			item.interactive.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, itemClickHandler);	
			item.setSelected(true);
			//item.setActive(true);
			item.fadeTo(0);
			//item._alpha = 0;	
			
			var item2:InteractiveText3D = new InteractiveText3D("Hello World", new HelveticaBold(), "2");
			item2.interactive.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, itemClickHandler);	
			item2.y = 120;
			//item2.setActive(true);
			item2.fadeTo(0);
			//item2._alpha = 0;
			
			default_scene.addChild(item);
			default_scene.addChild(item2);
		}
		
		private function itemClickHandler(event:InteractiveScene3DEvent):void
		{
			trace("Button.itemClickHandler(): ");
		}
	}
	
}