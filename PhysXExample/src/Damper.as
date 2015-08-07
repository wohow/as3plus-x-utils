package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;

	public class Damper extends Sprite
	{
		protected static var Crate : Class;
		//		protected static var crateTexture:Texture;
		
		protected static var instanceCount:int = 0;
		
		//		public var id:String;
		
		public function Damper( type:int = 1 ){
			//			id = "crate_" + instanceCount++;
			
			var image:Bitmap = new Bitmap( type == 1 ? new img_damper() : new img_wall() );
			//image.smoothing = TextureSmoothing.TRILINEAR;
//			image.width 	= width;
//			image.height 	= height;
			image.x 		= -(width/2);
			image.y 		= -(height/2);
			//			pivotX = width/2;
			//			pivotY = height/2;
			
			addChild( image );
		}
		
		
	}
}