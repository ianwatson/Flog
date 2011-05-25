package net.uk.sweet.external
{
	
	/**
	* Data carrier for standardised parameter of external interface calls.
	* Mimics the properties of the JSON object defined for v8 external interface
	* calls. Is interchangeable with a JSON object and, in as far as it is 
	* codified in a class and allows strong-typing, is the preferred method.
	* <p>
	* Default command name of "invoke_analytics" is the standard for calls which
	* in v7 were routed through the JavaScript dcsTrk() method. These are:
	* <ol>
	* <li>1. WebTrends calls</li>
	* <li>2. getURL calls</li>
	* </ol>
	*/
	public class ExternalInterfaceData
	{
		public var command:String;
		public var params:Array;
		public var analytics:Array;
		public var returnRequired:Boolean;
		
		/**
		* Class constructor
		* 
		* @param	command 		the identifer as agreed with Tridion team, defaults to "invoke_analytics" unless overridden
		* @param	params			the list of parameters, defaults to an empty array
		* @param	analytics		the list of analytics following dcsTrck format ie. ["webtrends", "url", "window"] of which url and window are optional
		* @param	returnRequired	true if a return is required, defaults to false
		*/
		public function ExternalInterfaceData(command:String, params:Array = null, analytics:Array = null, returnRequired:Boolean = false)
		{
			this.command = command;
			this.params = params;
			this.analytics = analytics;
			this.returnRequired = returnRequired;
		}
	}
	
}