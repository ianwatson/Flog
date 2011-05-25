package com.blitzagency.xray.inspector.util
{
	import com.blitzagency.xray.inspector.util.ObjectInspector;
	import com.blitzagency.xray.logger.util.ObjectTools;
	import com.blitzagency.xray.inspector.commander.Commander;
	import com.blitzagency.xray.logger.XrayLog;
	
	import flash.display.DisplayObject;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.utils.Timer;
	import flash.xml.XMLDocument;
	import flash.events.TimerEvent;
	import flash.display.Sprite;
	import com.blitzagency.xray.logger.XrayLogger;
	import flash.events.AsyncErrorEvent;

	public class ControlConnection extends LocalConnection
	{
		private var log																	:XrayLog = new XrayLog();
		private var queTimer															:Timer = new Timer(25,1);
		private var serialTimer															:Timer = new Timer(25,1);
		private var dataQue																:Array = [];
		private var serializedQue														:Array = [];
		private var objectInspector														:ObjectInspector;
		
		public function ControlConnection()
		{
			super();
			client = this;
			allowDomain("*");
			allowInsecureDomain("*");
			addEventListener(StatusEvent.STATUS, statusEventHandler);
			addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			queTimer.addEventListener(TimerEvent.TIMER, timerTickHandler);
			queTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHander);
			serialTimer.addEventListener(TimerEvent.TIMER, timerTickHandler);
			serialTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHander);
		}
		
		public function setObjectInspector(p_objectInspector:ObjectInspector):void
		{
			objectInspector = p_objectInspector;
		}
        
        public function initConnection():void 
        {
        	log.debug("initConnection");
            //fpsMeter = com.blitzagency.xray.FPSMeter.getInstance();
			try
			{
				connect("_xray_remote_conn");
			}
			catch (e:ArgumentError)
			{
				log.debug("com.blitzagency.xray.inspector.util.ControlConnection.initConnection() : argument error = " + e.message);
			}
        }
		
		public function viewTreeF2(p_target:String, 
								recursiveSearch:Boolean=false, 
								showHidden:Boolean=false, 
								objectSearch:Boolean=false) :void
		{
			log.debug("view tree called", p_target);
	        
	        var data:String = objectInspector.inspectObject(p_target);
	        
	        //log.debug("data length", data.length);

	        if(data.length < 1) return;
	        var dataLength:Number = data.length;
	        if (dataLength > 5000) 
	        {
	            dataQue = new Array ();
	            var x:Number = 0;
	            while (x < dataLength) 
	            {
	                var toSend:String = data.substring(x, x + 5000);
	                var endData:Boolean = (((x + 5000) >= data.length) ? true : false);
	                dataQue.push({XMLDoc:toSend, endData:endData});
	                x = x + 5000;
	            }

	            queTimer.reset();
	            queTimer.repeatCount = dataQue.length;
	            queTimer.start();
	        } 
	        else 
	        {
	            var obj:Object = {XMLDoc:data};
	            send("_xray_conn", "setTree", obj, true);
	        }
    	}
    	
    	public function executeScript(script:String):void
    	{
    		//log.debug("execute", script);
            Commander.getInstance().execute(script);
        }
    	
    	public function fpsOn(showFPS:Boolean):void
    	{
            //fpsMeter.__set__runFPS(showFPS);
        }
        
        public function showFPS():void
    	{
            //fpsMeter.__set__runFPS(showFPS);
        }
        
        public function getMovieClipPropertiesF2(target:String, showAll:Boolean=false):void
        {
        	log.debug("getMovieClipPropertiesF2", target);
            var obj:Object = objectInspector.getProperties(target);
            serialize(obj);
        }
        
        public function getBasePropertiesF2(baseTarget:String, key:String="") :void
        {
        	log.debug("getBasePropertiesF2", baseTarget);
        	baseTarget = key.length > 0 ? baseTarget + "." + key : baseTarget;
            var obj:Object = objectInspector.getProperties(baseTarget);
            serialize(obj);
        }
    	
    	public function getObjPropertiesF2(baseTarget:String, key:String) :void
		{
			log.debug("getObjPropertiesF2", baseTarget);
            baseTarget = key.length > 0 ? baseTarget + "." + key : baseTarget;
            var obj:Object = objectInspector.getProperties(baseTarget);
            serialize(obj);
        }
        
        public function getFunctionPropertiesF2(target:String) :void
        {
        	//log.debug("getFunctionPropertiesF2", target);
            var obj:Object = objectInspector.getProperties(target);
            serialize(obj);
        }
        
        public function highlightClip(target:String,...rest) :void
        {
        	// during the flex testing, turn this off
        	return;
            var obj:Sprite = Sprite(objectInspector.buildObjectFromString(target));
            if(obj == null) return;
            obj.graphics.clear();
            obj.graphics.lineStyle(1,0x00ff00,1,false);
            obj.graphics.drawRect(0,0,obj.width, obj.height);
        }
        public function lowlightClip(target:String,...rest) :void
        {
        	return;
            var obj:Sprite = Sprite(objectInspector.buildObjectFromString(target));
            if(obj == null) return;
            obj.graphics.clear();
        }
        
        public function startExamineClipF2(p_path:String, p_type:String) :void
        {
        	return;
            /*
            var mc = eval (p_path);
            if (editTool != undefined) {
                com.blitzagency.controls.TransformTool.destroyTool();
            }
            editTool = com.blitzagency.controls.TransformTool.initialize(mc, true, false, false, false, true);
            */
        }
        
        public function stopExamineClipF2() :void
        {
        	return;
            //com.blitzagency.controls.TransformTool.destroyTool();
        }
        
        public function getConnectorVersion():void
        {
        	//
        }
        
        public function setLogLevel(p_level:Number):void
        {
        	XrayLogger.getInstance().setLevel(p_level);
        }

    	private function timerTickHandler(e:TimerEvent):void
    	{
    		if(e.target == queTimer) processQue();
    		if(e.target == serialTimer) processSerializedQue();
    	}
    	
    	private function timerCompleteHander(e:TimerEvent):void
    	{
    		// when timer is done
    	}
    	
    	private function serialize(obj:Object) :void
    	{
    		// reset que
    		serializedQue = [];
            var data:String = objectInspector.parseObjectToString(obj,"serialized");

            if(data.length > 5000)
            {
	            var x:Number = 0;
	            while (x < data.length) 
	            {
	                var str:String = data.substring(x, x + 5000);
	                var endData:Boolean = (((x + 5000) >= data.length) ? true : false);

	                serializedQue.push({XMLDoc:str, endData:endData});
	                x = x + 5000;
	            }
	            
	            serialTimer.reset();
	            serialTimer.repeatCount = serializedQue.length;
	            serialTimer.start();
	        }else
	        {
	        	var obj:Object = {XMLDoc:data};
	            send("_xray_conn", "setObjectProperties", obj, true);
	        }
        }
    	
    	private function processQue():void
    	{
            if (dataQue.length == 0) return;
            var data:Object = dataQue.shift();
                      
            send("_xray_conn", "setTree", {XMLDoc:data.XMLDoc}, data.endData);
        }
        
        private function processSerializedQue() :void
        {
        	if (serializedQue.length == 0) return ;
            var data:Object = serializedQue.shift();

            send("_xray_conn", "setObjectProperties", {XMLDoc:data.XMLDoc}, data.endData);
        }
    	
    	private function statusEventHandler(e:StatusEvent):void
    	{
    		//log.debug("statusEvent", e.level);
    		if(e.level == "status") {};//log.debug("message sent successfully");
    	}		
    	
    	private function asyncErrorHandler(e:AsyncErrorEvent):void
    	{
    		log.error("AsyncErrorEvent", e.error);
    		//if(e.level == "status") {};//log.debug("message sent successfully");
    	}
	}
}