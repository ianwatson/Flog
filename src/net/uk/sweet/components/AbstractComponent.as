package net.uk.sweet.components 
{
	import flash.display.*;
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	
	import net.uk.sweet.interfaces.IComponent;
	
	/**
	 * Base class for components.
	 */
	public class AbstractComponent extends Sprite implements IComponent
	{
		protected var _size:Point;
		
		public function AbstractComponent(self:AbstractComponent) 
		{
			if (self != this)
				throw new IllegalOperationError("AbstractComponent(): abstract class can't be instantiated directly");
		}		
		
		// abstract method to be implemented in subclass
		public function init():void 
		{ 
			addListeners();
		}

		// abstract method to be implemented in subclass
		protected function addListeners():void { }		
		
		// abstract method to be implemented in subclass
		public function configure():void { }
		
		// override in superclass
		public function destroy():void 
		{ 
			removeListeners();
			
			var i:int = numChildren;
			while(i --) removeChildAt(i);
		}			
		
		// abstract method to be implemented in subclass
		protected function removeListeners():void { }	
	
		public function get size():Point { return _size; }
		
		public function set size(value:Point):void 
		{
			_size = value;
		}
	}
	
}