package net.uk.sweet.interfaces 
{
	/**
	 * Interface for button components
	 */
	public interface IButton
	{
		function get data():*;
		function set data(value:*):void;

		function get id():String;
		function set id(value:String):void;		
		
		function setState(value:String):void;
	}
	
}