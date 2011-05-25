package com.blitzagency.xray.logger
{
	import com.blitzagency.xray.logger.XrayLogger;
	import com.blitzagency.xray.logger.Log;
	import com.blitzagency.xray.logger.util.ObjectTools;

	public class XrayLog
	{
		private var logger:XrayLogger;
		private var classReference:String = "";
		
		public function XrayLog(classRef:Object=null)
		{
			// CONSTRUCT
			logger = XrayLogger.getInstance();
			
			if(classRef != null) classReference = ObjectTools.getImmediateClassPath(classRef);
		}
		
		public function debug(message:String, ...rest):void
		{
			message = classReference.length > 0 ? classReference + " : " + message : message;
			if(rest.length == 0) logger.debug(new Log(message, null, XrayLogger.DEBUG));
			for(var i:Number=0;i<rest.length;i++)
			{
				if(i > 0) message = "";
				logger.debug(new Log(message, rest[i], XrayLogger.DEBUG));
			}
		}
		
		public function info(message:String, ...rest):void
		{
			message = classReference.length > 0 ? classReference + " : " + message : message;
			if(rest.length == 0) logger.info(new Log(message, null, XrayLogger.INFO));
			for(var i:Number=0;i<rest.length;i++)
			{
				if(i > 0) message = "";
				logger.info(new Log(message, rest[i], XrayLogger.INFO));
			}
		}
		
		public function warn(message:String, ...rest):void
		{
			message = classReference.length > 0 ? classReference + " : " + message : message;
			if(rest.length == 0) logger.warn(new Log(message, null, XrayLogger.WARN));
			for(var i:Number=0;i<rest.length;i++)
			{
				if(i > 0) message = "";
				logger.warn(new Log(message, rest[i], XrayLogger.WARN));
			}
		}
		
		public function error(message:String, ...rest):void
		{
			message = classReference.length > 0 ? classReference + " : " + message : message;
			if(rest.length == 0) logger.error(new Log(message, null, XrayLogger.ERROR));
			for(var i:Number=0;i<rest.length;i++)
			{
				if(i > 0) message = "";
				logger.error(new Log(message, rest[i], XrayLogger.ERROR));
			}
		}
		
		public function fatal(message:String, ...rest):void
		{
			message = classReference.length > 0 ? classReference + " : " + message : message;
			if(rest.length == 0) logger.fatal(new Log(message, null, XrayLogger.FATAL));
			for(var i:Number=0;i<rest.length;i++)
			{
				if(i > 0) message = "";
				logger.fatal(new Log(message, rest[i], XrayLogger.FATAL));
			}
		}
	}
}