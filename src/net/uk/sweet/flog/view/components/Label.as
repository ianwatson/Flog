/*
	var test_txt:Label = new Label();
	test_txt.styleSheet = (this.model as IModel).getStyleSheet();
	test_txt.setText("<h1>" + title + "</h1>");
	test_txt.width = 400;
	test_txt.x = 500;
	test_txt.y = 500;
*/
	
package net.uk.sweet.flog.view.components 
{
	import flash.text.*;
	
	public class Label extends TextField
	{
		public function Label() 
		{
			super();
		}
		
		// expectation is that value will be HTML
		public function setText(value:String):void
		{
			// TODO: this should be handled with an exception
			if (this.styleSheet == null) trace("Label.setLabel(): no stylesheet set");
			
			this.htmlText = value;
			this.embedFonts = this.isFontEmbedded();
		}
		
		// returns true if the font used to style the text field has been embedded
		private function isFontEmbedded():Boolean
		{
			var embeddedFonts:Array = Font.enumerateFonts(false);
			var fontName:String = this.getTextFormat().font;
			var embedded:Boolean = false;
			
			for (var i:int = 0; i < embeddedFonts.length; i ++) 
			{
				if (embeddedFonts[i].fontName == fontName)
				{
					embedded = true;
					break;
				}
			}
			
			return embedded;
		}		
	}
	
}