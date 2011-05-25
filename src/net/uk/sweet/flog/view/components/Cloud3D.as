package net.uk.sweet.flog.view.components
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import gs.TweenMax;
	import gs.events.TweenEvent;
	
	import net.uk.sweet.flog.interfaces.ICloudVO;
	import net.uk.sweet.flog.model.enum.ItemTypes;
	import net.uk.sweet.papervision3d.PaperBase;
	
	import org.casalib.collection.IList;
	import org.casalib.collection.List;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.typography.fonts.HelveticaBold;

	public class Cloud3D extends PaperBase
	{
		// event names
		public static const ITEM_CLICK:String = "itemClick";
		public static const DATE_CHANGE:String = "dateChange";
		public static const ZOOM_COMPLETE:String = "zoomComplete";
		
		private static const GUESTBOOK:String = "guestbook";
		private static const MEDIA:String = "photos";
		
		// settings
		private var _viewScale:Number;
		private var _timeRatio:Number;
		
		private var _zoomIncrement:Number;
		private var _zoomDecay:Number;
		private var _zoomDuration:Number;
		
		private var _cameraFov:Number;
		private var _cameraOffset:Number;
		
		private var _panEasing:Number;
		private var _visibleItems:int;
		private var _visibleOffset:int;
		
		private var _intersectionRange:Number;
		private var _intersectionRetries:int;
		
		private var _data:IList;
		private var _startDate:Date;
		private var _endDate:Date;		
		
		private var _labelIcon:Class;
		
		private var _selectedItem:InteractiveText3D;	
		
		private var totalDistance:Number;
		private var range:Number;		
		private var zoomSpeed:int;		
		
		private var __x:Number = 0;
		private var __y:Number = 0;
		
		private var locked:Boolean = false;
		private var zooming:Boolean = false;
		
		
		// TODO: constants to settings XML
		// TODO: strategy for transitions
		
		override protected function init3d():void
		{
			default_camera.fov = _cameraFov;
			default_camera.z = _cameraOffset * -1;
			
			createCloud();
		}

		private function createCloud():void
		{
			range = Math.abs(_startDate.time - _endDate.time);
			totalDistance = range * _timeRatio;			
			
			var intersecting:Array = [];
			var oldZ:int = 0;
			
			for (var i:int = 0; i < _data.size; i++) 
			{
				var vo:ICloudVO = _data.getItemAt(i) as ICloudVO;
				var title:String = vo.title;
				
				var item:InteractiveText3D = new InteractiveText3D(title, new HelveticaBold());
				item.data = vo;
				//item.iconClass = _labelIcon;
				item.addEventListener(MouseEvent.CLICK, itemClickHandler);	
				item.addEventListener(MouseEvent.MOUSE_OVER, itemOverHandler);
				item.addEventListener(MouseEvent.MOUSE_OUT, itemOutHandler);
				
				var diff:Number = _startDate.time - vo.date.time; 
				var ratio:Number = diff / range;
				var z:int = totalDistance * ratio;
				
				if (z - oldZ > _intersectionRange)
				{
					intersecting = [];
					oldZ = z;
				}			

				var point:Point = getItemPosition(item, intersecting);	
				
				item.x = point.x;
				item.y = point.y;
				item.z = z;
				
				// TODO: having text 3D parse a stylesheet would make testing color schemes much easier
				if (vo.type == GUESTBOOK) item.outColor = 0x336699;
				
				item.init();
				
				intersecting.push(item);
				default_scene.addChild(item, i.toString());                    
			}			
		}	
		
		private function getItemPosition(currentItem:InteractiveText3D, intersecting:Array):Point
		{
			var point:Point = new Point();
			var currentItemRect:Rectangle;
			var count:int = 0;
			
			if (intersecting.length)
			{
				do
				{
					point = getRandomPoint();			
					currentItemRect = new Rectangle(point.x, point.y, currentItem.width, currentItem.height);
					count ++;
				} 
				while (doItemsIntersect(currentItemRect, intersecting) && count < _intersectionRetries);	
			}
			else
			{
				point = getRandomPoint();
			}
			
			return point;
		}
		
		private function getRandomPoint():Point
		{
			var w:Number = current_viewport.viewportWidth + (current_viewport.viewportWidth * _viewScale);
			var h:Number = current_viewport.viewportHeight + (current_viewport.viewportHeight * _viewScale);
			
			var x:int = Math.round((Math.random() * w) - (w / 2)); 
			var y:int = Math.round((Math.random() * h) - (h / 2)); 			
			
			return new Point(x, y);
		}
		
		private function doItemsIntersect(currentItemRect:Rectangle, intersecting:Array):Boolean
		{
			for (var i:int = 0; i < intersecting.length; i++) 
			{
				var previousItem:InteractiveText3D = intersecting[i] as InteractiveText3D;
				var previousItemRect:Rectangle = new Rectangle(
					previousItem.x, 
					previousItem.y, 
					previousItem.width, 
					previousItem.height
				);
																
				if (currentItemRect.intersects(previousItemRect)) return true;
			}
			
			return false;
		}
		
		private function itemClickHandler(event:MouseEvent):void
		{
			_selectedItem = event.target as InteractiveText3D;
//			trace("Cloud3D.itemClickHandler(): " + _selectedItem.data.title);
			dispatchEvent(new Event(ITEM_CLICK));
		}

		private function itemOverHandler(event:MouseEvent):void
		{
			pause();
		}
		
		private function itemOutHandler(event:MouseEvent):void
		{
			restart();
		}
		
		public function reset():void
		{
			//resetState();
			TweenMax.killAllTweens();
			TweenMax.to(default_camera, 1, { 
				y: _selectedItem.y, 
				onCompleteListener: reverseCompleteHandler 
			});
			fadeTo(1, _selectedItem);					
		}
		
		public function setSelectedGuid(guid:String):void
		{
			// enable the outgoing selectedItem if it exists
			if (selectedItem != null) 
				_selectedItem.enabled = true;
			
			// update and disable incoming selected item
			_selectedItem = getItemByGuid(guid);
			_selectedItem.enabled = false;
				
			locked = true;
			
			var x:Number = _selectedItem.x;
			var y:Number = _selectedItem.y;
			var z:Number = _selectedItem.z - _cameraOffset; //	for char limit of 22		
			
			TweenMax.killAllTweens();
			TweenMax.to(default_camera, _zoomDuration, { 
				x: x, 
				y: y, 
				z: z, 
				onCompleteListener: zoomCompleteHandler 
			});
		}

		private function zoomCompleteHandler(event:TweenEvent):void
		{
			zooming = false;
			_selectedItem.enabled = true;
			fadeTo(0, selectedItem);
			
			dispatchEvent(new Event(ZOOM_COMPLETE));
		}

		private function reverseCompleteHandler(event:TweenEvent):void
		{
			_selectedItem.setSelected(false);
			_selectedItem = null;
			locked = false;
		}		
		
		private function fadeTo(target:Number, exclude:InteractiveText3D = null):void
		{	
			for (var id:String in default_scene.children)
			{
				var item:InteractiveText3D = default_scene.children[id];
				if (item != exclude)
				{
					item.enabled = Boolean(target);
					item.fadeTo(target);
				}
			}
		}
		
		private function resetState():void
		{
			for (var id:String in default_scene.children)
			{
				var item:InteractiveText3D = default_scene.children[id];
				item.reset();
			}			
		}
		
		public function scroll(delta:Number):void
		{
			TweenMax.killAllTweens();
			
			if (!zooming)
			{
				locked = false;
				zoomSpeed += delta * _zoomIncrement;
			}
		}
		
		public function shift(point:Point):void
		{
			var ratioX:Number = point.x / viewport.width;
			var startX:Number = 0 - viewport.width;
			var endX:Number = viewport.width;
			
			var ratioY:Number = point.y / viewport.height;
			var startY:Number = 0 - viewport.height;
			var endY:Number = viewport.height;
			
			__x = (ratioX * startX) + ((1 - ratioX) * endX);
			__y = ((1 - ratioY) * startY) + (ratioY * endY);			
		}
		
		override protected function processFrame():void
		{   			
			if (!locked)
			{
				default_camera.x = default_camera.x + ((__x - default_camera.x) * _panEasing);
				default_camera.y = default_camera.y + ((__y - default_camera.y) * _panEasing);
				default_camera.z = default_camera.z + zoomSpeed;
			}
			
			// decay the zoom speed
			zoomSpeed *= _zoomDecay;
			
			showActiveItems();
			dispatchEvent(new Event(DATE_CHANGE));
		} 	
		
		private function showActiveItems():void
		{
			var count:int = 0;
			for (var id:String in default_scene.children)
			{
				var item:InteractiveText3D = default_scene.children[id];
				
				if (item.z > default_camera.z + _visibleOffset && count < _visibleItems)
				{
					count ++;
					item.visible = true;
				}
				else
				{
					item.visible = false;
				}
			}
		}
		
		public function getItemByGuid(guid:String):InteractiveText3D
		{
			var item:InteractiveText3D;
			
			for (var id:String in default_scene.children)
			{
				item = default_scene.children[id];
				var vo:ICloudVO = item.data as ICloudVO;
				
				if (vo.guid == guid) return item;
			}
			
			return item;
		}
		
		public function getCurrentDate():Date
		{
			var ratio:Number = (default_camera.z + _cameraOffset) / totalDistance;
			var ms:Number = _startDate.time - (ratio * range);	
			
			var date:Date = new Date();
			date.time = ms;
			
			return date;
		}
		
		public function setColors(color_1:uint, color_2:uint):void
		{
			var item:InteractiveText3D;
			
			for (var id:String in default_scene.children)
			{
				item = default_scene.children[id];
				item.outColor = color_1;
				item.overColor = color_2;
				
				// TODO: this should be setState
				item.handleVisualState(color_1);
			}
		}
		
		public function pause():void
		{
			locked = true;
		}
		
		public function restart():void
		{
			locked = false;
		}	
			
		public function set data(value:IList):void 
		{
			_data = value;
		}
		
		public function set startDate(value:Date):void 
		{
			_startDate = value;
		}
		
		public function set endDate(value:Date):void 
		{
			_endDate = value;
		}
		
		public function get selectedItem():InteractiveText3D { return _selectedItem; }
		
		public function set labelIcon(value:Class):void 
		{
			_labelIcon = value;
		}
		
		public function set viewScale(value:Number):void 
		{
			_viewScale = value;
		}
		
		public function set timeRatio(value:Number):void 
		{
			_timeRatio = value;
		}
		
		public function set zoomIncrement(value:Number):void 
		{
			_zoomIncrement = value;
		}
		
		public function set zoomDecay(value:Number):void 
		{
			_zoomDecay = value;
		}
		
		public function set zoomDuration(value:Number):void 
		{
			_zoomDuration = value;
		}
		
		public function set cameraFov(value:Number):void 
		{
			_cameraFov = value;
		}
		
		public function set cameraOffset(value:Number):void 
		{
			_cameraOffset = value;
		}
		
		public function set panEasing(value:Number):void 
		{
			_panEasing = value;
		}
		
		public function set visibleItems(value:int):void 
		{
			_visibleItems = value;
		}
		
		public function get visibleOffset():int
		{
			return _visibleOffset;
		}
		
		public function set visibleOffset(value:int):void
		{
			_visibleOffset = value;
		}		
		
		public function set intersectionRange(value:Number):void 
		{
			_intersectionRange = value;
		}
		
		public function set intersectionRetries(value:int):void 
		{
			_intersectionRetries = value;
		}
	}	
}