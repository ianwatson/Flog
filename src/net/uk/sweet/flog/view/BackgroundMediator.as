package net.uk.sweet.flog.view
{
    import flash.display.GradientType;
    import flash.display.InterpolationMethod;
    import flash.display.SpreadMethod;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.text.TextFieldAutoSize;
    
    import net.uk.sweet.flog.ApplicationFacade;
    import net.uk.sweet.flog.view.components.*;
    import net.uk.sweet.utils.Logger;
    import net.uk.sweet.utils.SweetDate;
    
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.Mediator;

    /**
     * A Mediator for interacting with the date label component.
     */
    public class BackgroundMediator extends BaseMediator
    {
        // Cannonical name of the Mediator
        public static const NAME:String = 'BackgroundMediator';
		
        /**
         * Constructor. 
         */
        public function BackgroundMediator(mediatorName:String = null, viewComponent:Object = null) 
        {
            // pass the viewComponent to the superclass where 
            // it will be stored in the inherited viewComponent property
            super(mediatorName, viewComponent);
        }


        /**
         * List all notifications this Mediator is interested in.
         * <P>
         * Automatically called by the framework when the mediator
         * is registered with the view.</P>
         * 
         * @return Array the list of Nofitication names
         */
        override public function listNotificationInterests():Array 
        {
			return  [    
						ApplicationFacade.RESIZE
			        ];
        }

        /**
         * Handle all notifications this Mediator is interested in.
         * <P>
         * Called by the framework when a notification is sent that
         * this mediator expressed an interest in when registered
         * (see <code>listNotificationInterests</code>.</P>
         * 
         * @param INotification a notification 
         */
        override public function handleNotification( note:INotification ):void 
        {
			switch ( note.getName() )
			{
				case ApplicationFacade.RESIZE:
				{
					draw();
					break;
				}
			}
        }	

		override public function onRegister():void
		{
			super.onRegister();
			
			draw();
		}
		
		private function draw():void
		{
			var width:Number = background.stage.stageWidth;
			var height:Number = background.stage.stageHeight;
			
			//draw bkgnd
			//full stage sprite is required for tilt mouse out
			var fillType:String = GradientType.LINEAR;
			var colors:Array = [0xEFEFEF, 0xC1C1C1, 0xD9D9D9, 0xF2F2F2, 0xFCFCFC, 0x626C7D];
			var alphas:Array = [1, 1, 1, 1, 1, 1];
			var ratios:Array = [0, 60, 80, 120, 140, 255];
			var matr:Matrix = new Matrix();
			var boxRotation:Number = Math.PI/2;
			matr.createGradientBox(width, height, boxRotation, 0, 0);
			var spreadMethod:String = SpreadMethod.PAD;
			var interp:String = InterpolationMethod.RGB;
			background.graphics.clear();
			background.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod, interp);
			background.graphics.drawRect(0, 0, width, height);
		}
		
        /**
         * Cast the viewComponent to its actual type.
         * 
         * <P>
         * This is a useful idiom for mediators. The
         * PureMVC Mediator class defines a viewComponent
         * property of type Object. </P>
         * 
         * <P>
         * Here, we cast the generic viewComponent to 
         * its actual type in a protected mode. This 
         * retains encapsulation, while allowing the instance
         * (and subclassed instance) access to a 
         * strongly typed reference with a meaningful
         * name.</P>
         * 
         * @return background the viewComponent cast to Sprite
         */
        protected function get background():Sprite
		{
            return viewComponent as Sprite;
        }
    }
}