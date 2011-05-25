package 
{
	import flash.display.MovieClip;
	import net.uk.sweet.utils.SweetDate;
	
	/**
	 * 
	 */
	public class DateTest extends MovieClip
	{
		
		public function DateTest() 
		{
			var startDate:Date = new Date();
			var endDate:Date = startDate;
			
			var dates:Array = new Array();
			dates.push(new Date("Sat Jun 30 00:00:00 GMT+0100 2007"));
			dates.push(new Date("Wed Jun 20 00:00:00 GMT+0100 2007"));
			dates.push(new Date("Fri Jun 8 00:00:00 GMT+0100 2007"));
			dates.push(new Date("Mon Jun 4 00:00:00 GMT+0100 2007"));
			dates.push(new Date("Tue May 15 00:00:00 GMT+0100 2007"));
			dates.push(new Date("Fri Apr 20 00:00:00 GMT+0100 2007"));
			dates.push(new Date("Thu May 10 00:00:00 GMT+0100 2007"));
			dates.push(new Date("Wed May 23 00:00:00 GMT+0100 2007"));
			dates.push(new Date("Tue May 22 00:00:00 GMT+0100 2007"));
			dates.push(new Date("Tue May 1 00:00:00 GMT+0100 2007"));
			dates.push(new Date("Sun Apr 15 00:00:00 GMT+0100 2007"));
			dates.push(new Date("Sat Mar 24 00:00:00 GMT+0000 2007"));
			dates.push(new Date("Sat Mar 20 00:00:00 GMT+0000 2007"));
			dates.push(new Date("Wed Mar 28 00:00:00 GMT+0100 2007"));
			dates.push(new Date("Sun Mar 25 00:00:00 GMT+0000 2007"));			
			
			for (var i:int = 0; i < dates.length; i++) 
			{
				var date:Date = dates[i];
				if (date.time < endDate.time) endDate = date;
			}
			
			trace("DateTest.DateTest(): endDate: " + endDate);
			
			var range:Number = startDate.time - endDate.time;
			
			trace("DateTest.DateTest(): range: " + SweetDate.convertMillisecondsToDays(range));
			
			for (var j:int = 0; j < dates.length; j++) 
			{
				var date:Date = dates[j];
				var diff:Number = startDate.time - date.time;
				//trace("DateTest.DateTest(): diff: " + SweetDate.convertMillisecondsToDays(diff));
				trace("DateTest.DateTest(): " + (diff / range));
			}
			
			/*
			var startDate:Date = new Date();
			var endDate:Date = new Date(2007, 02, 24);
			
			var one_day:Number = 1000 * 60 * 60 * 24;
			
			trace(startDate);
			trace(endDate);
			
			var diff:Number = Math.abs(startDate.time - endDate.time);
			
			trace(diff);
			trace(SweetDate.convertMillisecondsToDays(diff));
			*/
		}
	}
	
}