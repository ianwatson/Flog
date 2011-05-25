package net.uk.sweet.external
{
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	import net.uk.sweet.external.ExternalInterfaceData;	
	
	/**
	 * 
	 */
	public class ExternalInterfaceInitializer extends EventDispatcher
	{		
		// event constants
		public static const INITIALIZED:String = "initialized";
		public static const ERROR:String = "error";
		
		// the JavaScript method to call for page availability testing
		private var _method:String = "javascriptInterface";
		
		// value for command property of JSON param for page availaibility tetsing
		private var _javascriptAvailableCommand:String = "javascript_available";
		private var _flashAvailableCommand:String = "flash_available";
		
		// timer settings for polling the parent page
		private var _delay:int = 100;
		private var _repeat:int = 50;
		
		private var timer:Timer;

		public function initialize():void
		{
            if (ExternalInterface.available) 
			{
                try
				{
					timer = new Timer(_delay, _repeat);
					timer.addEventListener(TimerEvent.TIMER, timerHandler);
					timer.start();
                } 
				catch (error:SecurityError) 
				{
                    //trace("A SecurityError occurred: " + error.message + "\n");
					dispatchErrorEvent(error);
                } 
				catch (error:Error) 
				{
                    //trace("An Error occurred: " + error.message + "\n");
					dispatchErrorEvent(error);
                }
            } 
			else 
			{
				dispatchErrorEvent(new Error("ExternalInterface is not available"));
            }	
		}
		
        private function timerHandler(event:TimerEvent):void 
		{
			if (timer.currentCount < timer.repeatCount)
			{
				call();
			}
			else
			{
				stop();
				var msg:String = "Tried JavaScript method " 
											+ _method + " " 
											+ timer.repeatCount 
											+ " times, stopping";
											
				dispatchErrorEvent(new Error(msg));
			}
        }
		
		private function call():void
		{
			var data:ExternalInterfaceData = new ExternalInterfaceData(
												_javascriptAvailableCommand, 
												null, null, true);	
												
			if (ExternalInterface.call(_method, data))
			{
				stop();
				dispatchInitialisedEvent();
			}
		}
		
		public function stop():void
		{
			timer.stop();
		}
		
		private function dispatchInitialisedEvent():void
		{
			dispatchEvent(new Event(INITIALIZED));
			
			/*
			 * Any callbacks should be set up by interested parties on receipt
			 * of the INITIALIZED event dispatched above. 
			 * The following call lets the JavaScript know that we are ready
			 * to receive calls. This provides the hook for setting via JavaScript
			 * any properties required during start up. 
			 */
			var data:ExternalInterfaceData = new ExternalInterfaceData(
												_flashAvailableCommand, 
												null, null, true);
												
			ExternalInterface.call(_method, data);
		}
		
		private function dispatchErrorEvent(error:Error):void
		{
			//trace("........ ExternalInterfaceManager.dispatchErrorEvent(): ");
			dispatchEvent(new ErrorEvent(ERROR, false, false, error.message));
		}
		
		public function set method(value:String):void 
		{
			_method = value;
		}
		
		public function set flashAvailableCommand(value:String):void 
		{
			_flashAvailableCommand = value;
		}
		
		public function set javascriptAvailableCommand(value:String):void 
		{
			_javascriptAvailableCommand = value;
		}
		
		public function set delay(value:int):void 
		{
			_delay = value;
		}
		
		public function set repeat(value:int):void 
		{
			_repeat = value;
		}
	}
}