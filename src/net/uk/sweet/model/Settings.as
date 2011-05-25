package net.uk.sweet.model 
{
	import net.uk.sweet.interfaces.ISettings;
	
	/**
	 */
	public class Settings implements ISettings
	{
		// the singleton name
		protected static const NAME:String = "Settings";
		
		// the singleton instance.
		protected static var instance:Settings; 
		
		// message constants
		protected const SINGLETON_MSG:String = "singleton already constructed!";
		
		private var _data:Object;
		
		public function Settings() 
		{
			if (instance != null) throw Error(NAME + " " + SINGLETON_MSG);
			instance = this;
		}
		
		public static function getInstance():Settings 
		{
			if (instance == null) instance = new Settings();
			return instance;
		}

		public function set data(value:Object):void 
		{
			_data = value;
		}
		
		public function getSetting(key:*):*
		{
			return _data[key];
		}
	}
	
}