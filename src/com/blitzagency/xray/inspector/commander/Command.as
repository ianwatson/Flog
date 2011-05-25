package com.blitzagency.xray.inspector.commander
{
	public class Command
	{
		public var isPropChange								:Boolean;
		public var modifier									:String;
		public var value									:Object;
		public var target									:Object;
		
		public function Command()
		{
			
		}
		
		public function execute():void
		{
			if(isPropChange) target[modifier] = resolveValueType(value);
			if(!isPropChange) target[modifier](resolveValueType(value));
		}
		
		private function resolveValueType(obj:Object):Object
		{
			switch(obj)
			{
				case "true":
					return true;
				break;
				case "false":
					return false;
				break;
				default:
					var str:String = String(obj);
					if(!isNaN(parseInt(str)))
					{
						// it's Number
						return Number(parseInt(str));
					}else
					{
						// it's a string
						str = str.split("\"").join("");
						str = str.split("'").join("");
						return str;
					}
			}
		}
	}
}