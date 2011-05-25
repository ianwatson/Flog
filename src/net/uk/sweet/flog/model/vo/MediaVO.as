package net.uk.sweet.flog.model.vo 
{
	import net.uk.sweet.flog.interfaces.ICloudVO;
	
	public class MediaVO implements ICloudVO
	{
		private var _guid:String;
		private var _type:String;
		private var _title:String;
		private var _path:String;
		private var _url:String;
		private var _date:Date;
		private var _time:Number;
		
		public function MediaVO(guid:String, type:String, title:String, 
								path:String, url:String, date:Date, time:Number) 
		{
			this.guid = guid;
			this.type = type;
			this.title = title;
			this.path = path;
			this.url = url;
			this.date = date;
			this.time = time;
		}
		
		public function get guid():String { return _guid; }
		
		public function set guid(value:String):void 
		{
			_guid = value;
		}
		
		public function get type():String { return _type; }
		
		public function set type(value:String):void 
		{
			_type = value;
		}	
		
		public function get title():String { return _title; }
		
		public function set title(value:String):void 
		{
			_title = value;
		}
		
		public function get path():String { return _path; }
		
		public function set path(value:String):void 
		{
			_path = value;
		}
		
		public function get url():String { return _url; }
		
		public function set url(value:String):void 
		{
			_url = value;
		}
		
		public function get date():Date { return _date; }
		
		public function set date(value:Date):void 
		{
			_date = value;
		}
		
		public function get time():Number { return _time; }
		
		public function set time(value:Number):void 
		{
			_time = value;
		}
	}
}