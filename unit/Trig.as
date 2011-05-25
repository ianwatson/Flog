package 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Ian Watson
	 */
	public class Trig extends Sprite
	{
		public function Trig()
		{
			// adjacent
			var a:int = 100;
			
			// opposite
			var b:int = 50;
			
			// draw the triangle
			graphics.lineStyle(1, 0x000000);
			graphics.lineTo(a, 0);
			graphics.moveTo(a, 0);
			graphics.lineTo(a, b);
			graphics.moveTo(a, b);
			graphics.lineTo(0, 0);
			
			// because our triangle is at 0, 0
			var x:int = a;
			var y:int = b;
			
			// angle in radians
			var radians:Number = Math.atan2(y, x);
			
			// angle in degrees (it's readable)
			var degrees:Number = Math.round(radians * (180 / Math.PI));
			
			trace("Radians: " + radians);
			trace("Degrees: " + degrees);
			
			// double the length of a (or radius)
			var a2:Number = a * 2;
			
			// calculate the x and y
			var x2:Number = a2 * Math.cos(radians);
			var y2:Number = a2 * Math.sin(radians);
			
			trace("x2: " + x2);
			trace("y2: " + y2);
			
			graphics.lineStyle(1, 0xff0000);
			graphics.moveTo(a, b);
			graphics.lineTo(x2, y2);
		}
	}
	
}