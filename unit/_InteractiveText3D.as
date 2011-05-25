/**
 * 
 */

package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import org.papervision3d.materials.MovieAssetMaterial;
	
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.typography.Text3D;
	import org.papervision3d.typography.Font3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.ColorMaterial;
	
	import gs.easing.*;	
	import gs.TweenMax;
	
	public class InteractiveText3D extends Text3D 
	{
		// true for Helvetica Bold
		private static const CHAR_WIDTH:int = 50;
		private static const CLOSE_BUTTON_HEIGHT:int = 50;
		private static const HEIGHT:int = 90;
		
		private static const PADDING:int = 10;
		private static const FADE_DURATION:int = 2;
		
		private var close:Plane;
		
		private var _interactive:Plane;
		private var __width:Number;
		
		private var _selected:Boolean = false;
		
		public function InteractiveText3D(text:String, font:Font3D, material:MaterialObject3D, name:String = null) 
		{
			super(text, font, material, name);
			
			__width = CHAR_WIDTH * text.length;
				
			close = new Plane(new MovieAssetMaterial("CloseButton", true), CHAR_WIDTH, CLOSE_BUTTON_HEIGHT);
			close.useOwnContainer = true;
			close.x = (__width * 0.5) + PADDING;
			close.y = (HEIGHT * 0.5) - PADDING;
			addChild(close);
			
			// we use the plane to capture interactivity
			_interactive = new Plane(new ColorMaterial(0xff0000, 0, true), __width, HEIGHT, 1, 1);
			_interactive.name = name;
			_interactive.useOwnContainer = true;

			addChild(_interactive);
		}	
		
		public function fade(alpha:Number):void
		{
			TweenMax.killAllTweens();
			TweenMax.to(this, FADE_DURATION, { alpha: alpha, ease: Strong.easeIn });
		}
		
		public function set enabled(enabled):void
		{
			_interactive.visible = enabled;
		}
		
		public function set selected(selected:Boolean):void
		{
			_selected = selected;
			var target:Number = Number(selected);
			
			// fade the button in and out according to state
			TweenMax.killAllTweens();
			TweenMax.to(close, FADE_DURATION, { alpha: alpha, ease: Strong.easeIn } );
		}
		
		public function get width():Number { return __width; }
		
		public function get height():Number { return HEIGHT; }
		
		public function get interactive():Plane { return _interactive; }
	}
	
}