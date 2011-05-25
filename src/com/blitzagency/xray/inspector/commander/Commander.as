package com.blitzagency.xray.inspector.commander
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.display.DisplayObjectContainer;
	import com.blitzagency.xray.logger.XrayLog;
	import com.blitzagency.xray.inspector.util.ObjectInspector;

	public class Commander extends EventDispatcher
	{		
		private static var _instance						:Commander = null;
		public static function getInstance():Commander
		{
			if(_instance == null) _instance = new Commander();
			return _instance;
		}
		
		private var log										:XrayLog = new XrayLog();
		private var commandAry								:Array = [];
		private var _objectInspector						:ObjectInspector;
		private var _stage									:DisplayObjectContainer
		
		public function set objectInspector(p_objectInspector:ObjectInspector):void
		{
			_objectInspector = p_objectInspector;
		}
		
		public function get objectInspector():ObjectInspector
		{
			return _objectInspector;
		}
		
		public function set stage(p_stage:DisplayObjectContainer):void
		{
			_stage = p_stage;
		}
		
		public function get stage():DisplayObjectContainer
		{
			return _stage;
		}
		
		public function Commander(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function execute(p_script:String):void
		{
			commandAry = stripCommand(p_script);
			
			var command:Command = resolveCommand();
			//log.debug("command", command);
			command.execute();
		}
		
		private function stripCommand(str:String):Array
		{
			// need to retain the value that's been passed, and sometimes, that value includes a dot.  
			//we replace that value with a string "holder", then convert it back when we're ready to execute
			str = retainValue(str);
			
			str = str.split("\"]").join("");
			str = str.split("[\"").join(".");
						
			var ary:Array = str.split(".");
		
			//log.debug("stripCommand", ary.toString());
			return ary;
		}
		
		private function resolveCommand():Command
		{
			var str:String = String(commandAry[commandAry.length-1]);
			
			var command:Command = new Command();
			command.isPropChange = str.indexOf("=") > -1 ? true : false;
			command.value = restoreValue(String(getValue(str, command.isPropChange)));
			command.modifier = getModifier(str, command.isPropChange);
			try
			{
				command.target = objectInspector.buildObjectFromString(commandAry.slice(0, commandAry.length-1).join("."));
			}catch(e:Error)
			{
				log.error("Commander.resolveCommand - target is malformed", commandAry.slice(0, commandAry.length-1).join(".") + ", " + e.message); 
			}

			return command;
		}
		
		private function getModifier(str:String, isProperty:Boolean=true):String
		{
			var modifier:String;
			
			if(isProperty) 
			{
				str = str.split(" ").join("");
				modifier = String(str.split("=")[0]);
			}
			if(!isProperty) 
			{
				modifier = String(str.split("(")[0]);
			}
			
			return modifier;
		}
		
		private function getValue(str:String, isProperty:Boolean=true):Object
		{
			var value:Object;
			
			if(isProperty) 
			{
				str = str.split(" ").join("");
				value = str.split("=")[1];
			}
			if(!isProperty) 
			{
				value = str.split("(")[1];
				value = str.split(")")[0];
			}
			
			return value;
		}
		
		/**
	     * @summary replaces any "."'s with "(dot)" before exec does it's split at "."'s.  It has too look for
		 * parens and equality operators to figure out where the retainable values are.
		 *
		 * @param str:String command to execute IE: _level0.mc.x = 30.5
		 *
		 * @return Object
		 */
		private function retainValue(str:String):String
		{
			var e:Number = str.indexOf("=");
			var p:Number = str.indexOf("(");
	
			if(e > -1)
			{
				var a:Array = str.split("=");
				a[1] = a[1].split(".").join("(dot)");
				return a.join("=");
			}
	
			if(p > -1)
			{
				var lp:Number = str.indexOf(")", p);
				var st:String = str.slice(0, p);
				var ed:String = str.slice(lp+2);
				var ns:String = str.substr(p, lp).split(".").join("(dot)");
				return st + ns + ed;
			}
	
			return str;
		}
		/**
	     * @summary restores the value back with the original "."'s
		 *
		 * @param str:String command to be restored
		 *
		 * @return String
		 */
		private function restoreValue(str:String):String
		{
			return str.split("(dot)").join(".");
		}
	}
}