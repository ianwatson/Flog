/**
 * @author: Sebastian Martens; sebastian@sebastian-martens.de
 */ 
package net.uk.sweet.external
{
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.utils.Timer;
	
	import org.casalib.collection.*;
	
	/**
	 * @classdescription: ExternalInterfaceStack implements a stack for JavaScript calls from AS3 via the ExternalInterface Class. Sometimes
	 * 					  if you use too many JS Calls at the same time, not all JS Calls will be handled correctly. With this 
	 * 					  class you can use a stack which will call the js functions asynchronous with a timer. You are also able to
	 * 					  get rid of double called functions.
	 * 						
	 *                    Ian Watson modified name and package; cheeky perhaps, but wanted all ExternalInterface classes to reside in the same
	 *                    package. Also converted to a singleton (if ever there was a candidate for a singleton, this is surely it) and 
	 *                    changed collection type to org.casalib.collection.List from mx.collection.ArrayCollection.				
	 */ 
	public class ExternalInterfaceStack
	{
		public static const STACK_MODE_LIFO:int = 0;
		public static const STACK_MODE_FIFO:int = 1;
		
		private var _stack:IList; // stack of javascript calls
		private var _callTimer:Timer; // timer object
		private var _timerInterval:int = 500; // interval timer calles javascript functions in ms
		private var _stackMode:int = STACK_MODE_LIFO; // sets internal stack mode 
		private var _isExAvailable:Boolean;
		
		private static var instance:ExternalInterfaceStack;
		private static var allowInstantiation:Boolean;


		/**
		 * setter method for timer interval value
		 * @param value:Int - timer interval in milliseconds
		 */ 
		public function set timerInterval( value:int ):void{
			var isRunning:Boolean = this._callTimer.running;
			
			// stop timer, set new value and restart if timeer was running
			this._callTimer.stop();
			this._timerInterval = value;
			this._callTimer.delay = this._timerInterval;
			
			if( isRunning ) this._callTimer.start();
		}
		
		/**
		 * getter method for timer interval
		 * @return Int - set timer interval
		 */ 
		public function get timeInterval():int{
			return this._timerInterval;
		}
		
		/**
		 * pauses the execution of javascript calls
		 */
		public function pauseExecution():void{
			this._callTimer.stop();
		}
		
		/**
		 * restarts the execution of javascript calls 
		 */ 
		public function startExecution():void{
			if( this._stack.size > 0 ){
				this._callTimer.start();
			}
		}
		
		/**
		 * returns if the timer is running 
		 * @return Boolean - is the execution timer running 
		 */ 
		public function isExecutionRunning():Boolean{
			return this._callTimer.running;
		}		
		
		/**
		 * constructor method. Singleton class, do not instantiate directly, use getInstance method
		 * @param stackMode:int - stack mode of handling stack entries
		 */ 
		public function ExternalInterfaceStack( stackMode:int = STACK_MODE_FIFO ):void {
		
			if (allowInstantiation) {
				
				// test if ExInterface is available
				this._isExAvailable = ExternalInterface.available;
				
				// init stack
				this._stack = new List();
				
				// timer 
				this._callTimer = new Timer( this._timerInterval );
				this._callTimer.addEventListener(TimerEvent.TIMER, stackHandler);
				
				// stack mode 
				this._stackMode = stackMode;
			} else {
				throw new Error("Instantiation failed, use getInstance() method: ");
			}
		}
		
		public static function getInstance():ExternalInterfaceStack 
		{
			if (instance == null) {
				allowInstantiation = true;
				instance = new ExternalInterfaceStack();
				allowInstantiation = false;
			}
			return instance;
		}
		
		/**
		 * adds an javascript function call to call stack
		 * @param funcName:String - function name of js function to call
		 * @param paramter:Object - object of paramters to path to the javascript function
		 * 							Object will be converted to JSON and hand over an JSON-Object
		 * @param resultHandler:Function - method to handler javascript results
		 * @param skipOldCalls:Boolean - if true older calls in stack of the same functionname won't be 
		 * 								 called any more, only latest call
		 * @param convert2JSON:Boolean - if true the parameter object will be converted to JSON for the javascript call
		 * @return Int value of stack position, returns -1 if External Interface is not available
		 */ 
		public function addCall( funcName:String, parameter:Object=null, resultHandler:Function=null, skipOldCalls:Boolean=false, convert2JSON:Boolean=false ):int{
			var position:int = this._stack.size;
			
			// External Interface not available
			if( !this._isExAvailable ) return -1;
			
			// create object and add to stack
			var o:Object = { functionName:funcName, params:parameter, resHandler:resultHandler, skip:skipOldCalls, id:position, convertToJSON:convert2JSON };
			this._stack.addItemAt( o, position );
			
			// start timer if not running
			if( !this._callTimer.running ) this._callTimer.start(); 
			
			return position;
		}
		
		/**
		 * removes an javascript call from stack
		 * @param id:int - identifier position of call which was returned from addCall Method
		 * @return Boolean - function found an removed, false if already called
		 */ 
		public function removeCall( id:int ):Boolean{
			var result:Boolean = false;
			var isRunning:Boolean = this._callTimer.running;
			
			// no item in stack
			if( this._stack.size==0 ) return true; 
			
			// stop call timer to avoid access confilcts
			this._callTimer.stop();
			
			// search in stack for id
			for( var i:int=0; i<this._stack.size; i++ ){
				if( Object(this._stack.getItemAt(i)).id == id ){
					result = this._stack.removeItemAt( i );
				}
			}
			
			// restart timer
			if( isRunning ) this._callTimer.start();
			
			return result;
		}
		
		/**
		 * returns a JSON string of an object
		 * @param obj:Object - object to convert into json string
		 * @return JSON String
		 */ 
		private function objToJSON( obj:Object ):String{
			var json:String;
			
			// parse object to json string
			json = "{";
			for( var o:Object in obj.params ){
				json += o + ":'" + obj.params[ o ] + "',";
			}
			json = json.substring(0,json.length-1) + "}";
			
			return json;
		}
		
		/**
		 * search for functions with functionname = name and removes it from stack
		 * @param name:String - name of function to delete from stack
		 * @return Int - number of removed entries
		 */ 
		private function cleanStack( name:String ):int{
			var found:int = 0;
			
			// search in stack for id
			for( var i:int=0; i<this._stack.size; i++ ){
				if( Object(this._stack.getItemAt(i)).functionName == name ){
					if( this._stack.removeItemAt( i ) ) found++;
				}
			}
			
			return found;
		}
		
		/**
		 * handles timer event and calls single javascript function from stack
		 * @param event:Timer - timer event
		 */  
		private function stackHandler( event:TimerEvent ):void{
			var obj:Object;
			var json:String;
			var jsResult:Object;
			
			// get call object by stack mode
			switch( this._stackMode ){
				case STACK_MODE_LIFO: 
					obj = this._stack.removeItemAt( this._stack.size-1 ); 
					break;
				
				case STACK_MODE_FIFO:
				default: 
					obj = this._stack.removeItemAt( 0 );
					break; 	
			}
			
			// convert object to JSON String
			json = objToJSON( obj );
			
			// find older calls and remove
			if( Boolean( obj.skip ) ){
				this.cleanStack( obj.functionName );	
			}
			
			// call javascript function
			jsResult = ExternalInterface.call( obj.functionName, obj.convertToJSON?json:obj.params );
			if( obj.resHandler ) obj.resHandler( jsResult );
			
			// stop timer on last stack entry
			if( this._stack.size == 0 ) this._callTimer.stop();
			
		}
		
		/**
		 * returns the n number of registered functions at this momment 
		 * @return INT - numer of registered functions, which are not executed yet
		 */ 
		public function getRegisteredFunctionsCount():int{
			return this._stack.size;
		}

	}
}