package 
{
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.typography.fonts.HelveticaBold;
	import org.papervision3d.materials.special.Letter3DMaterial;
	
	/**
	 * ...
	 * @author Ian Watson
	 */
	public class Text extends PaperBase 
	{
		private var text:InteractiveText3D;
		
		public function Text() 
		{	
			init(550, 400);
		}		
		
		override protected function init3d():void 
		{
			// This function should hold all of the stages needed
			// to initialise everything used for papervision.
			// Models, materials, cameras etc.
			trace("Text.init3d(): ");

			var letterMaterial:Letter3DMaterial = new Letter3DMaterial(0x000000, 1);
			letterMaterial.interactive = false;		

			text = new InteractiveText3D("Hello world", new HelveticaBold(), letterMaterial, "0");
			text.useOwnContainer = true;
			text.x = Math.round((Math.random() * viewport.width) - (viewport.width / 2)); 
			text.y = Math.round((Math.random() * viewport.height) - (viewport.height / 2)); 
			text.z = 200;
			text.selected = true;
			//text.fade(0);			
		
			default_scene.addChild(text);
		}

		override protected function initEvents():void 
		{
			trace("Text.initEvents(): ");
			super.initEvents();
			text.interactive.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, itemClickHandler);
		}
		
		private function itemClickHandler(event:InteractiveScene3DEvent):void
		{
			trace("Text.itemClickHandler(): ");
		}
		
		override protected function processFrame():void 
		{
			// Process any movement or animation here.
		}
	}
	
}