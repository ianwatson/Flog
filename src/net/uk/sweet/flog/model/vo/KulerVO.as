package net.uk.sweet.flog.model.vo 
{
	public class KulerVO 
	{
		public var id:String;
		public var title:String;
		public var url:String;
		public var colors:Array;
		
		public function KulerVO(id:String, title:String, colors:Array) 
		{
			this.id = id;
			this.title = title;
			this.colors = colors;
		}
	}
}