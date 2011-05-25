package net.uk.sweet.utils
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.utils.Timer;
	
	/**
	* Staggered queue (FIFO) utility. Items are exposed in order of addition after
	* a supplied delay. 
	*/
	public class Queue extends EventDispatcher
	{
		public static const ITEM_QUEUED:String = "itemQueued";
		
		// delay in dispatch of queue items in seconds
		private var _delay:Number = 0.5; 
	
		private var timer:Timer;
		private var queue:Array;
		
		/**
		 * Class constructor.
		 */
		public function Queue():void 
		{
			super();
		}
		
		/**
		* Adds a call to the queue and, if necessary, starts the timer used to stagger calls.
		* 
		* @param	item	the object to add to the queue
		*/
		public function addItem(item:*):void
		{				
			// create the array if required
			if (queue == null)
			{
				queue = [];
			}
			
			// add item to the queue
			queue.push(item);

			// initialise the timer if required
			if (timer == null)
			{
				timer = new Timer(_delay * 1000);
				timer.addEventListener(TimerEvent.TIMER, itemQueued);
			}
			
			// if the timer isn't running start it
			if (!timer.running) timer.start();
		}
		
		// Called on an interval set up to simulate framerate.
		// Informs subscribers that a call is pending and checks for completion of queue.
		private function itemQueued(event:TimerEvent):void
		{
			this.dispatchEvent(new Event(Queue.ITEM_QUEUED));
			
			// have we finished yet?
			if (queue.length == 0) timer.stop();
		}	
		
		/**
		*  Returns the next object in the queue and removes it.
		*
		*  @return	the next call in the queue
		*/    
		public function get nextItem():*
		{    
			return queue.splice(0, 1)[0];
		}
		
		public function set delay(value:Number):void 
		{
			_delay = value;
		}
	}
}