/**
 * 
 */

package net.uk.sweet.flog.view.components
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.utils.getDefinitionByName;
	
	import gs.TweenMax;
	import gs.easing.*;
	
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.MovieMaterial;
	import org.papervision3d.materials.special.Letter3DMaterial;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.typography.Font3D;
	import org.papervision3d.typography.Letter3D;
	import org.papervision3d.typography.Text3D;
	import org.papervision3d.typography.VectorLetter3D;
	
	
	public class InteractiveText3D extends Text3D 
	{
		// true for Helvetica Bold
		private static const ICON_SIZE:int = 40;
		private static const FADE_DURATION:Number = 0.5;
		private static const PADDING:int = 10;
		
		private var _overColor:uint = 0xff0000;
		private var _pressColor:uint = 0x336699;
		private var _outColor:uint = 0x000000;
		
		private var interactive:Plane;
			
		private var __width:Number;
		private var __height:Number;
		private var __alpha:Number = 1;
		
		private var _data:Object;
		
		private var _selected:Boolean = false;
		
		public function InteractiveText3D(text:String, font:Font3D, name:String = null) 
		{
			super(text, font, new Letter3DMaterial(0x000000, 1), name);
			
		}	
		
		public function init():void
		{
			__width = calculateWidth();
			__height = calculateHeight();
			
			// we use the plane to capture interactivity
			interactive = new Plane(new ColorMaterial(0xff0000, 0, true), __width, __height, 1, 1);
			interactive.useOwnContainer = true;
			interactive.addEventListener(InteractiveScene3DEvent.OBJECT_OVER, overHandler);
			interactive.addEventListener(InteractiveScene3DEvent.OBJECT_OUT, outHandler);
			interactive.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, pressHandler);
			interactive.addEventListener(InteractiveScene3DEvent.OBJECT_RELEASE, overHandler);
			interactive.addEventListener(InteractiveScene3DEvent.OBJECT_RELEASE_OUTSIDE, outHandler);
			addChild(interactive);
			
			handleVisualState(_outColor);
		}
		
		private function calculateWidth():Number
		{
			var w:Number = 0;
			for (var i:int = 0; i < letters.length; i++) 
			{
				w += (letters[i] as Letter3D).width;
			}
			return w;
		}
		
		private function calculateHeight():Number
		{
			var h:Number = 0;
			for (var i:int = 0; i < letters.length; i++) 
			{
				var letter:Letter3D = letters[i];
				if (letter.height > h)
					h = letter.height;
			}
			return h;
		}
		
		private function overHandler(event:InteractiveScene3DEvent):void
		{
			handleVisualState(_overColor);
			dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
		}

		private function outHandler(event:InteractiveScene3DEvent):void
		{
			handleVisualState(_outColor);
			dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
		}		
		
		private function pressHandler(event:InteractiveScene3DEvent):void
		{
			handleVisualState(_pressColor);
			dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}		
		
		public function handleVisualState(color:uint):void
		{
			for each (var letter:VectorLetter3D in letters)
			{
				letter.material = new Letter3DMaterial(color, 1);
			}
		}
		
		public function fadeTo(alpha:Number):void
		{
			var tween:TweenMax = new TweenMax(this, FADE_DURATION, { _alpha: alpha, ease: Strong.easeIn } );
		}
		
		public function set enabled(enabled:Boolean):void
		{
			interactive.visible = enabled;
		}
		
		public function set _alpha(alpha:Number):void
		{
			__alpha = alpha;
			
			for each (var letter:VectorLetter3D in letters)
			{
				// there has to be a better way than this to fade out the word
				letter.material = new Letter3DMaterial(_outColor, alpha);
			}			
		}
		
		public function get _alpha():Number { return __alpha; }		
		
		public function setSelected(selected:Boolean):void
		{
			_selected = selected;
			var target:int = int(_selected);

		}	
				
		public function get width():Number { return __width; }
		
		public function get height():Number { return __height; }

		public function set outColor(value:uint):void 
		{
			_outColor = value;
		}
		
		public function set overColor(value:uint):void 
		{
			_overColor = value;
		}
		
		public function set pressColor(value:uint):void 
		{
			_pressColor = value;
		}
		
		public function get selected():Boolean { return _selected; }
		
		public function get data():Object { return _data; }
		
		public function set data(value:Object):void 
		{
			_data = value;
		}
		
		public function reset():void
		{
			setSelected(false);
			handleVisualState(_outColor);
		}
	}
}