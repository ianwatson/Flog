package
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import gs.events.TweenEvent;
	
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.objects.primitives.Cylinder;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.objects.special.VectorShape3D;
	import org.papervision3d.typography.VectorLetter3D;
	
	import gs.TweenMax;
	
	import org.papervision3d.materials.special.Letter3DMaterial;
	import org.papervision3d.typography.fonts.HelveticaBold;
    import org.papervision3d.typography.Text3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.materials.*;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.scenes.*;
	import org.papervision3d.view.Viewport3D;	
	import org.papervision3d.view.BasicView;	

	public class TagCloud extends Sprite
	{
		private static var VIEW_WIDTH:int = 550;
		private static var VIEW_HEIGHT:int = 400;
		
		// the boundaries for word placement at 50% bigger than the view
		private static var SCAPE_WIDTH:int = 825;
		private static var SCAPE_HEIGHT:int = 600;
		
		// this value multipled by mouse wheel delta to increment zoom speed
		private static var ZOOM_INCREMENT:int = 20;
		
		// for optimisation; the distance from the camera 
		// at which an object becomes visible
		private static var VISIBLE_RANGE:int = 20000;
		
		// essentials for a papervision scene
		private var camera:Camera3D;
		private var scene:Scene3D;
		private var render:BasicRenderEngine; 		
		private var view:Viewport3D;            
		private var pivot:DisplayObject3D;    
		private var pv3dStage:Sprite = new Sprite();
		
		private var totalDistance:int;
		private var zoomSpeed:int;
		private var spacing:int = 2000;
		
		private var items:Array;
		private var placeHolder:Plane;
		
		private var tags:Array;
		private var selectedItem:InteractiveText3D;
		
		private var __x:Number = 0;
		private var __y:Number = 0;
		
		private var locked:Boolean = false;
		private var zooming:Boolean = false;
		
		public function TagCloud(tags:Array) 
		{
			this.tags = tags;
			
			createScene();
			createCloud();
		}
		
		private function createScene():void
		{
			camera = new Camera3D();   
			camera.fov = 35;
			
 			addChild(pv3dStage);
			
			view = new Viewport3D(VIEW_WIDTH, VIEW_HEIGHT, true, true);
			// need this to pick up interactivity off the viewport
			view.graphics.beginFill(0xFFFFFF, 1);
			view.graphics.drawRect(0, 0, VIEW_WIDTH, VIEW_HEIGHT);
			view.graphics.endFill();
			view.interactive = true;

			pv3dStage.addChild(view);
			
			scene	= new Scene3D();
			render	= new BasicRenderEngine();
			pivot   = new DisplayObject3D();	
			
			//stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboard);
		}

		private function createCloud():void
		{
			items = [];
			totalDistance = (tags.length * spacing) + 1000;
			
			for (var i:int = 0; i < tags.length; i++) 
			{
				var letterMaterial:Letter3DMaterial = new Letter3DMaterial(0x000000, 1);
				letterMaterial.interactive = false;		

				var item:InteractiveText3D = new InteractiveText3D(tags[i], new HelveticaBold(), letterMaterial, i.toString());
				item.x = Math.round((Math.random() * SCAPE_WIDTH) - (SCAPE_WIDTH / 2)); 
				item.y = Math.round((Math.random() * SCAPE_HEIGHT) - (SCAPE_HEIGHT / 2)); 
				item.z = (i * spacing) + spacing;
				item.interactive.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, itemClickHandler);
				//item.hitArea.addEventListener(InteractiveScene3DEvent.OBJECT_OVER, itemOverHandler);				
				
				items.push(item);
				pivot.addChild(item);                    
			}			
			
			scene.addChild(pivot); 	
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}	
		
		/*
		private function itemClickHandler(event:InteractiveScene3DEvent):void
		{		
			//trace("TagCloud.viewClickHandler(): ");
			var colorMaterial:ColorMaterial = new ColorMaterial(0xff0000, 1);
			
			locked = true;
			
			placeHolder = new Plane(colorMaterial, 500, 500);
			placeHolder.x = VIEW_WIDTH / 2 - 500 / 2;
			placeHolder.y = VIEW_WIDTH / 2 - 500 / 2;
			placeHolder.z = camera.z + VISIBLE_RANGE;
			
			scene.addChild(placeHolder);
			
			// TODO: come up with a name for this 1250 value
			TweenMax.to(placeHolder, 2, { z: camera.z + 1250 } );
		}
		*/
		
		private function itemClickHandler(event:InteractiveScene3DEvent):void
		{
			//trace("TagCloud.itemClickHandler(): ");
			var id:int = parseInt((event.target as Plane).name);
			
			// enable the outgoing selectedItem if it exists
			if (selectedItem != null) selectedItem.enabled = true;
			
			// update and disable incoming selected item
			selectedItem = items[id];
			selectedItem.enabled = false;
				
			locked = true;
			
			var x:Number = selectedItem.x;
			var y:Number = selectedItem.y;
			var z:Number = selectedItem.z - 1250; //	for char limit of 22		
			//__z = item.z - 35; // FOV value, but 1000 is better
			
			TweenMax.to(camera, 2, { x: x, y: y, z: z, onCompleteListener: zoomCompleteHandler }); 	
		}
		
		private function zoomCompleteHandler(event:TweenEvent):void
		{
			//trace("TagCloud.zoomCompleteHandler(): ");
			zooming = false;
		}
		
		private function show(bool:Boolean):void
		{
			//var target:int = Number(bool) * 1;			
			for (var i:int = 0; i < items.length; i ++)
			{
				var item:InteractiveText3D = items[i];
				if (item != selectedItem)
				{
					item.fade(0.25);
				}
			}
		}
		
		private function mouseWheelHandler(event:MouseEvent):void
		{
			TweenMax.killAllTweens();
			
			if (!zooming)
			{
				locked = false;
				zoomSpeed += event.delta * ZOOM_INCREMENT;
			}
		}
		
		private function mouseMoveHandler(event:MouseEvent):void
		{
			var ratioX:Number = mouseX / VIEW_WIDTH;
			var startX:Number = 0 - VIEW_WIDTH;
			var endX:Number = VIEW_WIDTH;
			
			var ratioY:Number = mouseY / VIEW_HEIGHT;
			var startY:Number = 0 - VIEW_HEIGHT;
			var endY:Number = VIEW_HEIGHT;
			
			__x = (ratioX * startX) + ((1 - ratioX) * endX);
			__y = ((1 - ratioY) * startY) + (ratioY * endY);
		}
		
		private function enterFrameHandler(event:Event):void
		{   
			// this pseudo easing is nicer than the tween engines
			if (!(zooming || locked))
			{
				camera.x = camera.x + ((__x - camera.x) * 0.035);
				camera.y = camera.y + ((__y - camera.y) * 0.035);
				camera.z = camera.z + zoomSpeed;
				
				// decay the increment
				zoomSpeed *= 0.97;
			}
			else
			{
				/*
				for (var j:int = 0; j < items.length; j ++)
				{
					var hitItem:InteractiveText3D = items[j];
					if (hitItem.visible && Math.abs(placeHolder.z - hitItem.z) < 200)
					{
						var x:Number = hitItem.x - (VIEW_WIDTH / 2);
						var y:Number = hitItem.y - (VIEW_HEIGHT / 2);
						
						var angle:Number = Math.atan2(y, x);
						var radius:Number = (VIEW_WIDTH * 20);
						
						var xx:Number = radius * Math.cos(angle);
						var yy:Number = radius * Math.sin(angle);
						
						TweenMax.to(hitItem, 10, { x: xx, y: yy } );
					}
				}
				*/
			}
			
			
			for (var i:int = 0; i < items.length; i ++)
			{
				var item:InteractiveText3D = items[i];
				// spacing is 2000 so this shows 10 items
				item.visible = (item.z - camera.z < VISIBLE_RANGE);
			}
			
			render.renderScene(scene, camera, view);
		} 	
	}	
}