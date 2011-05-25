package net.uk.sweet.flog.model.vo 
{
	import net.uk.sweet.flog.interfaces.ICloudVO;

	public class GuestbookVO implements ICloudVO
	{
		private var _guid:String;
		private var _type:String;
		private var _title:String;
		private var _date:Date;
		private var _time:Number;
		private var _name:String;
		private var _message:String;
		
		public function GuestbookVO(guid:String, type:String, title:String, date:Date, time:Number, name:String, message:String) 
		{
			this.guid = guid;
			this.type = type;
			this.title = title;
			this.date = date;
			this.time = time;
			this.name = name;
			this.message = message;
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
		
		public function get name():String { return _name; }
		
		public function set name(value:String):void 
		{
			_name = value;
		}		
		
		public function get message():String { return _message; }
		
		public function set message(value:String):void 
		{
			_message = value;
		}
	}
}