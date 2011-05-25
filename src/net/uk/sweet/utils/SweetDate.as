package net.uk.sweet.utils 
{
	
	/**
	 * Ripped off from flash kit, thanks Gohloum
	 * http://board.flashkit.com/board/showthread.php?t=794482
	 */
	public class SweetDate 
	{
		// convert SQL DateTime string to AS3 Date object
		// expected format: 2007-04-08
        public static function convertSQLToAS(s:String):Date
        {
            // split the date
            var d:Array = s.split("-");
            
            // do if statement here
            d[0] = adjustYearForPrevMilennia(d[0]);
            var date:Date = new Date(d[0], d[1]-1, d[2]);
            return date;
        }
		
		/**
		* Converts supplied milliseconds into days
		* 
		* @param	milliseconds to convert
		* 
		* @return	the number of days
		*/
		public static function convertMillisecondsToDays(milliseconds:Number):Number
		{
			return milliseconds / (1000 * 60 * 60 * 24);
		}		
		
		// custom version of Date's toLocaleDateString which adds a leading
		// 0 to the day of the month when it is less than 10. 
		public static function localeDateString(date:Date):String
		{
			var tmp:String = date.toLocaleDateString();
			var elements:Array = tmp.split(" ");
			
			if (Number(elements[2]) < 10) 
				elements[2] = "0" + elements[2];
				
			return elements.join(" ");
		}
		
		/*
        public static function convertSQLToAS(s:String):Date
        {
            // split the date from the time
            var dt:Array = s.split(" ");
            // separate the date values
            var d:Array = dt[0].split("-");
            // separate the time values
            var t:Array = dt[1].split(":");
            
            // do if statement here
            d[0] = adjustYearForPrevMilennia(d[0]);
            var date:Date = new Date(d[0], d[1]-1, d[2], t[0], t[1], t[2]);
            return date;
        }
		*/
        
        // helper function to enforce 1900 series year values
        private static function adjustYearForPrevMilennia(year:int):int
        {
            if (year < 2000)
            {
                var syear:String = year.toString();
                syear = syear.substr(2, 2);
                year = parseInt(syear);
            }
            
            return year;
        }
        
        // convert AS3 date to SQL DateTime formatted string
        public static function convertASToSQL(date:Date):String
        {
            // month processing
            date.month++;
            var month:String = enforceLeadingZero(date.month);
            
            // day processing
            var day:String = enforceLeadingZero(date.day);
            
            // hour processing
            var hours:String = enforceLeadingZero(date.hours);
            
            // minutes processing
            var minutes:String = enforceLeadingZero(date.minutes);
            
            // seconds processing
            var seconds:String = enforceLeadingZero(date.seconds);
            
            return date.fullYear + "-" + month + "-" + day + "T" + hours + ":" + minutes + ":" + seconds;
        }
        
        // same as above using UTC
        public static function convertASDateUTCToSQLDateTime(date:Date):String
        {
            // month processing
            date.month++;
            var month:String = enforceLeadingZero(date.monthUTC);
            
            // day processing
            var day:String = enforceLeadingZero(date.dayUTC);
            
            // hour processing
            var hours:String = enforceLeadingZero(date.hoursUTC);
            
            // minutes processing
            var minutes:String = enforceLeadingZero(date.minutesUTC);
            
            // seconds processing
            var seconds:String = enforceLeadingZero(date.secondsUTC);
            
            return date.fullYearUTC + "-" + month + "-" + day + "T" + hours + ":" + minutes + ":" + seconds;
        }
        
        // leading zero helper function needed for correct fromatting of SQL ready string
        private static function enforceLeadingZero(i:int):String
        {
            if (i.toString().length < 2)
            {
                return "0" + i;
            }
            else
            {
                return i.toString();
            }
        } 
	}
	
}