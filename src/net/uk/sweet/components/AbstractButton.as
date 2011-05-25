package net.uk.sweet.components 
{
	import flash.errors.IllegalOperationError;
	import flash.events.MouseEvent;

	import net.uk.sweet.interfaces.IButton;	
	
	/**
	 * Base class for buttons. 
	 */
	public class AbstractButton extends AbstractComponent implements IButton
	{
		private var decorator:AbstractButton;
		
		protected var _data:*;
		protected var _id:String;
		protected var _state:String = MouseEvent.MOUSE_OUT;
	
		public function AbstractButton(self:AbstractButton) 
		{	
			super(this);
			
			if (self != this) 
				throw new IllegalOperationError("AbstractButton(): abstract class cannot be instantiated directly");
				
			this.decorator = decorator;
		}

		override public function init():void
		{
			super.init();
			
			mouseChildren = false;
			buttonMode = true;

			handleState();
		}
		
		override protected function addListeners():void
		{
			super.addListeners();
			
			addEventListener(MouseEvent.MOUSE_OVER, mouseHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
		}
		
		private function mouseHandler(event:MouseEvent):void
		{
			setState(event.type);
		}
		
		override protected function removeListeners():void
		{
			super.removeListeners();
			
			removeEventListener(MouseEvent.MOUSE_OVER, mouseHandler);
			removeEventListener(MouseEvent.MOUSE_OUT, mouseHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			removeEventListener(MouseEvent.MOUSE_UP, mouseHandler);		
		}		

		public function setState(value:String):void
		{
			_state = value;
			handleState();
			
			if (decorator)
				decorator.setState(value);
		}		
		
		protected function handleState():void
		{
			// implement in subclass
		}		
		
		public function get data():* { return _data; }
		
		public function set data(value:*):void 
		{
			_data = value;
		}
		
		public function get id():String { return _id; }
		
		public function set id(value:String):void 
		{
			_id = value;
		}
	}
	
}