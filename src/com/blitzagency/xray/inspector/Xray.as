package com.blitzagency.xray.inspector
{
	import com.blitzagency.xray.inspector.util.ControlConnection;
	import com.blitzagency.xray.inspector.util.ObjectInspector;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.utils.getQualifiedClassName;
	import com.blitzagency.xray.logger.XrayLog;
	import flash.events.Event;
	import com.blitzagency.xray.inspector.commander.Commander;
	import flash.display.DisplayObjectContainer;
	
	/**
	* This is the main entry point for Xray
	* <p/>
	* Xray needs to be added to a sprite to gain access to the stage property.  The Flex2Xray class extends Xray and overrides the init method.  The Flex2Xray instance does not have to
	* added to any display list, just use the new constructor and it'll light right up
	*/
	
	public class Xray extends Sprite
	{
		protected var log:XrayLog = new XrayLog();
		protected var objectInspector:ObjectInspector;
		protected var controlConnection:ControlConnection;
		
		public function Xray()
		{
			init();
		}
		
		protected function init():void
		{
			var isLivePreview:Boolean = (parent != null && getQualifiedClassName(parent) == "fl.livepreview::LivePreviewParent");
			// if parent is null, then we're in livePreview
			if(isLivePreview) return;
			
			visible = false;
			
			objectInspector = new ObjectInspector();
			
			// we need to listen for when Xray's added to a DisplayList - then we can set Stage
			addEventListener(Event.ADDED_TO_STAGE,handleAddedToStage);
			
			controlConnection = new ControlConnection();
			controlConnection.setObjectInspector(objectInspector);
			controlConnection.initConnection();
			
			controlConnection.send("_xray_conn", "checkFPSOn");
		}
		
		private function handleAddedToStage(e:Event):void
		{
			// doing this so that ObjectInspector will have it's own stage property to work with
			objectInspector.stage = stage; 
			
			Commander.getInstance().objectInspector = objectInspector;
			Commander.getInstance().stage = stage.getChildByName("root1") as DisplayObjectContainer;
		}
	}
}