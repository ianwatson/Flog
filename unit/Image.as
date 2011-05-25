package 
{
	import gs.easing.Bounce;
	import gs.TweenMax;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Ian Watson
	 */
	public class Image extends Sprite
	{
		private var placeHolder:Sprite = new PlaceHolder();
		
		public function Image()
		{
			trace("Image.Image(): " + placeHolder);
			
			placeHolder.scaleX = 2;
			placeHolder.scaleY = 2;
			
			TweenMax.to(placeHolder, 0.5, { scaleX: 1, scaleY: 1, ease: gs.easing.Bounce } );
			
			addChild(placeHolder);
		}
	}
	
}