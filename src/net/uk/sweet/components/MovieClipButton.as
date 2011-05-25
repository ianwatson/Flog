package net.uk.sweet.components
{
	import flash.display.MovieClip;
	import flash.errors.IllegalOperationError;
	import flash.events.MouseEvent;

	import net.uk.sweet.components.AbstractButton;
	
	/**
	 * 
	 */
	public class MovieClipButton extends AbstractButton
	{
		private var _movieClip:MovieClip;
		
		private var _overFrame:String = MouseEvent.MOUSE_OVER;
		private var _outFrame:String = MouseEvent.MOUSE_OUT;
		private var _downFrame:String = MouseEvent.MOUSE_DOWN;
		private var _upFrame:String = MouseEvent.MOUSE_UP;
		
		public function MovieClipButton()
		{
			super(this);
		}
		
		override protected function addListeners():void 
		{
			super.addListeners();
			trace("MovieClipButton.addListeners(): ");
		}
		
		override protected function handleState():void 
		{
			var frame:String;
			
			switch (_state)
			{
				case MouseEvent.MOUSE_OVER:
				frame = _overFrame;
				break;
				
				case MouseEvent.MOUSE_OUT:
				frame = _outFrame;
				break;
				
				case MouseEvent.MOUSE_DOWN:
				frame = _downFrame;
				break;
				
				case MouseEvent.MOUSE_UP:
				frame = _upFrame;
				break;

				default:
				throw new IllegalOperationError("MovieClipButton.handleState(): state not recognised");
			}
			
			_movieClip.gotoAndStop(frame);
		}
		
		public function get movieClip():MovieClip { return _movieClip; }
		
		public function setMovieClip(value:MovieClip):void 
		{
			_movieClip = value;
			addChild(_movieClip);
		}
		
		public function set overFrame(value:String):void 
		{
			_overFrame = value;
		}
		
		public function set outFrame(value:String):void 
		{
			_outFrame = value;
		}
		
		public function set downFrame(value:String):void 
		{
			_downFrame = value;
		}
		
		public function set upFrame(value:String):void 
		{
			_upFrame = value;
		}
	}
}