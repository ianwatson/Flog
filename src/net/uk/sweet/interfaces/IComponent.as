package net.uk.sweet.interfaces 
{
	import flash.geom.Point;

	/**
	 * Interface for components
	 */
	public interface IComponent 
	{
		function init():void;
		function destroy():void;
		
		function set size(value:Point):void;
		function get size():Point;
	}
}