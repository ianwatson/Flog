package com.blitzagency.xray.inspector.flex2
{
	import com.blitzagency.xray.inspector.Xray;
	import com.blitzagency.xray.inspector.commander.Commander;
	import com.blitzagency.xray.inspector.util.ControlConnection;
	import com.blitzagency.xray.inspector.util.ObjectInspector;
	import com.blitzagency.xray.logger.XrayLog;
	
	import flash.display.DisplayObjectContainer;
	
	import mx.core.Application;

	public class Flex2Xray extends Xray
	{		
		public function Flex2Xray()
		{
			super();
		}	
		
		protected override function init():void
		{
			log.debug("Flex xray constructor called");
			
			objectInspector = new FlexObjectInspector();
			
			controlConnection = new ControlConnection();
			controlConnection.setObjectInspector(objectInspector);
			controlConnection.initConnection();
			
			Commander.getInstance().objectInspector = objectInspector;
			Commander.getInstance().stage = mx.core.Application.application as DisplayObjectContainer;
			
			controlConnection.send("_xray_conn", "checkFPSOn");
		}	
	}
}