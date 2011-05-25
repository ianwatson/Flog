package net.uk.sweet.model 
{
	import net.uk.sweet.interfaces.IDictionary;
	
	/**
	 */
	public class Dictionary implements IDictionary
	{
		// the singleton name
		protected static const NAME:String = "Dictionary";
		
		// the singleton instance.
		protected static var instance:Dictionary; 
		
		// message constants
		protected const SINGLETON_MSG:String = "singleton already constructed!";
		
		private var _data:Object;
		
		public function Dictionary() 
		{
			if (instance != null) throw Error(NAME + " " + SINGLETON_MSG);
			instance = this;
		}
		
		public static function getInstance():Dictionary 
		{
			if (instance == null) instance = new Dictionary();
			return instance;
		}

		public function set data(value:Object):void 
		{
			_data = value;
		}
		
		public function getTerm(key:*):String
		{
			return _data[key] || "[" + key + "]";
		}
	}
	
}