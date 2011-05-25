package 
{
	import flash.display.Sprite;
	import flash.text.Font;
	
	public class Main extends Sprite 
	{
		[Embed(source = "C:/WINDOWS/Fonts/Arial.ttf", 		
		fontName = "Arial",
		unicodeRange = "U+0061-U+007A, U+0041-U+005A ",
		mimeType = "application/x-font")]
		public var Arial:Class;
		
		public function Main():void 
		{
			Font.registerFont(Arial);
		}
	}
}