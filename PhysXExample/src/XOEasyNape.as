package
{
	import flash.display.DisplayObject;
	
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.space.Space;
	import nape.util.BitmapDebug;

	public class XOEasyNape
	{
		//创建nape空间
		public static var napeWorld:Space;
		//创建模拟视图
		public static var napeDebug:BitmapDebug;
		
		public function XOEasyNape()
		{
			
		}
		/**
		 *创建刚体世界，要实行刚体必须先经过这个步骤 
		 * @param _gravityX  刚体受到的X方向的重力
		 * @param _gravityY  刚体受到的Y方向的重力
		 * @return  刚体世界
		 * 
		 */
		public static function createNapeSpace(_gravityX:Number,_gravityY:Number):Space
		{
			//创建重力，并赋给nape空间
			var gravity:Vec2=new Vec2(_gravityX,_gravityY);  
			napeWorld=new Space(gravity);
			return napeWorld;
		}
		/**
		 *创建刚体模拟视图 
		 * @param stageWidth 舞台宽
		 * @param stageHeight 舞台高
		 * @return 
		 * 
		 */		
		public static function createNapeDebug(stageWidth:Number,stageHeight:Number):BitmapDebug
		{
			napeDebug=new BitmapDebug(stageWidth,stageHeight);
			return napeDebug;
		}
		
		/**
		 * 矩形刚体，注意，刚体的注册点在刚体的中心
		 * @param _x       刚体x坐标
		 * @param _y       刚体y坐标
		 * @param _width   刚体宽度
		 * @param _height  刚体高度
		 * @param isStatic 0为static，1为dynamic，2为kinematic
		 * @param userData 刚体贴图
		 * @return 
		 * 
		 */
		public static function createBox(_x:Number,_y:Number,_width:Number,_height:Number,isStatic:int=1,userData:DisplayObject=null):Body
		{
			//创建矩形或正方体body对象
			var rectangleBody:Body;
			//传参给initSizeBody函数，定义想x，y坐标即刚体类型
			rectangleBody=initSizeBody(_x,_y,isStatic);
			//创建刚体的形状，下面的是Polgon型，可以创建矩形或者正方体刚体
			//矩形形状参数有box(width:Number, height:Number, weak:Boolean=false):
			var rectangleShapes:Polygon=new Polygon(Polygon.box(_width,_height),Material.steel());
			
			//贴图处理方法
			setUserData(rectangleBody,userData);
			//把刚体形状赋予给body对象
			rectangleBody.shapes.push(rectangleShapes);
			//指定刚体所存在的空间
			rectangleBody.space=napeWorld;
			return rectangleBody;
			
		}
		/**
		 * 圆形刚体，注意，刚体的注册点在刚体的中心
		 * @param _x        刚体x坐标
		 * @param _y        刚体y坐标
		 * @param _radius   刚体半径
		 * @param isStatic  0为static，1为dynamic，2为kinematic
		 * @param userData  刚体贴图
		 * @return 
		 * 
		 */
		//创建圆形刚体
		public static function createCircle(_radius:Number, _x:Number, _y:Number, userData:DisplayObject=null):Body
		{
			//创建圆形body对象
			var body:Body 		= new Body( BodyType.DYNAMIC, new Vec2( _x, _y ) );
			var shape:Circle	= new Circle( _radius, null, new Material(0,1) );
			//圆形形状参数有.Circle(radius:Number, localCOM:Vec2=null, material:Material=null, filter:InteractionFilter=null):
//			shape.sensorEnabled=true;
//			setUserData(circleBody,userData);
			body.shapes.add( shape );
			body.space	= napeWorld;
			return body;
		}
		
		
		/**
		 * 
		 * @param _x
		 * @param _y
		 * @param _radius
		 * @param _rotation
		 * @param _edgeCount
		 * @param isStatic
		 * @param userData
		 * @return 
		 * 
		 */
		public static function createRegular(_x:Number,_y:Number,_radius:Number,_rotation:Number,_edgeCount:int,isStatic:int=1,userData:DisplayObject=null):Body
		{
			//创建多边形body对象
			var regularBody:Body;
			regularBody=initSizeBody(_x,_y,isStatic);
			//多边形的形状参数有Polygon.regular(xRadius:Number, yRadius:Number, edgeCount:int, angleOffset:Number=0.0, weak:Boolean=false):
			var regularShape:Polygon=new Polygon(Polygon.regular(_radius*2,_radius*2,_edgeCount),Material.glass());
			setUserData(regularBody,userData);
			regularBody.shapes.push(regularShape);
			regularBody.space=napeWorld;
			return regularBody;
		}
		
		//初始化刚体的坐标和刚体类型
		private static function initSizeBody(posX:Number,posY:Number,_isStatic:int):Body
		{
			var body:Body;
			if(_isStatic==0)
			{
				body=new Body(BodyType.STATIC,new Vec2(posX,posY));
			}
			if(_isStatic==1)
			{
				body=new Body(BodyType.DYNAMIC,new Vec2(posX,posY));
			}
			if(_isStatic==2)
			{
				body=new Body(BodyType.KINEMATIC,new Vec2(posX,posY));
			}
			return body;
		}
		
		private static function setUserData(body:Body,imageData:DisplayObject):void
		{
			//进行贴图，把图像赋予给body对象，并显示出来
			if(imageData!=null)
			{
				body.userData.graphic=imageData;
				imageData.x=body.position.x;
				imageData.y=body.position.y;
			}
		}
		
		//创建墙体
		public static function createWall(_x:Number=100,_y:Number=30,_width:Number=600,_height:Number=420):void
		{
			createBox(_x,_y+_height/2,10,_height,0);//左
			createBox(_x+_width/2,_y+_height,_width,10,0);//下
			createBox(_x+_width,_y+_height/2,10,_height,0);//右
			createBox(_x+_width/2,_y,_width,10,0);
		}
	}
}