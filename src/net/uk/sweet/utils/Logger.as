package net.uk.sweet.utils 
{
	import com.blitzagency.xray.logger.XrayLogger;
	import com.blitzagency.xray.logger.Log;
	
	/**
	 *
	 */
	public class Logger 
	{
		private static var _XRAY:XrayLogger;
		
		public function Logger() 
		{
			
		}
		public static function set XRay(value:XrayLogger):void
		{
			Logger._XRAY = value;
		}
		
		public static function output(msg:String, dump:Object = null, level:Number = 0):void
		{
			var message:String = msg;
			var log:Log = new Log(message, dump, level);
			switch(level)
			{
				case	0	:	if (Logger._XRAY!=null) Logger._XRAY.debug(log);
								message = (dump == null) ? "debug : " + message : dump + " : debug : " + msg;
								break;
				case	1	:	if (Logger._XRAY!=null) Logger._XRAY.info(log);
								message = (dump == null) ? "info : " + message : dump + " : info : " + msg;
								break;
				case	2	:	if (Logger._XRAY!=null) Logger._XRAY.warn(log);
								message = (dump == null) ? "warn : " + message : dump + " : warn : " + msg;
								break;
				case	3	:	if (Logger._XRAY!=null) Logger._XRAY.error(log);
								message = (dump == null) ? "error : " + message : dump + " : error : " + msg;
								break;
				case	4	:	if (Logger._XRAY!=null) Logger._XRAY.fatal(log);
								message = (dump == null) ? "fatal : " + message : dump + " : fatal : " + msg;
								break;
				default		:	if (Logger._XRAY!=null) Logger._XRAY.debug(log);
								message = (dump == null) ? "debug : " + message : dump + " : debug : " + msg;
								break;
			}
			trace(message);
		}
		
	}
	
}