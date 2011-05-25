/**
 * Document class of build, instantiates and starts ApplicationFacade
*/

package net.uk.sweet.flog 
{
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import net.uk.sweet.flog.ApplicationFacade;
	
	[SWF(width="700", height="400", backgroundColor="#ffffff", frameRate="31")]
	public class Main extends MovieClip
	{
		/**
		 * Main Class
		 * 
		 * Document class for movie
		 */
		public function Main() 
		{
			// grab any flash vars from the loaderInfo property of root
			var flashVars:Object = LoaderInfo(this.root.loaderInfo).parameters;
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;		
			
			var facade:ApplicationFacade = ApplicationFacade.getInstance();
			facade.startup(stage, flashVars);
		}	
	}
}
