package
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	import ldEasyNape.LDEasyNape;
	import ldEasyNape.LDEasyUserData;
	
	import nape.constraint.PivotJoint;
	import nape.constraint.WeldJoint;
	import nape.dynamics.InteractionGroup;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyList;
	import nape.phys.BodyType;
	import nape.phys.InteractorList;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.space.Space;
	import nape.util.BitmapDebug;
	import nape.util.ShapeDebug;
	
	public class PhysXExample extends Sprite
	{
		
		private var space:Space;
		private var debug:ShapeDebug;
//		private var debug:ShapeDebug;
		private var hoodle:Hoodle;
		private var damper:Damper;
		
		public function PhysXExample()
		{
			super();
			
			// 支持 autoOrient
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			damper = new Damper(  );
			stage.addChild( damper );
			
			LDEasyNape.initialize( stage );
			
			//1.创建一个基本的Nape空间
			//声明空间重力
			space = LDEasyNape.createWorld( 0, 800 );
			
			//3.创建模拟视图
//			debug = new ShapeDebug( stage.fullScreenWidth, stage.fullScreenHeight, 3355443 );
			debug = LDEasyNape.createDebug();
//			addChild(debug.display);
//			debug.drawBodyDetail = true;
//			debug.drawShapeDetail = true;
			
			//4.在ENTER_FRAME事件处理器中进行Nape模拟
			addEventListener(Event.ENTER_FRAME, loop);
//			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseEventHandler);
//			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			
			LDEasyNape.createWrapWall();
			addWall();
			
			addStaticBody();
			
//			testMultiFilter();
			
			hoodle = new Hoodle( 40, 40 );
//			hoodle.x 		= x;
//			hoodle.y 		= y;
//			stage.addChild( hoodle );
			
			var userData:LDEasyUserData = new LDEasyUserData();
			userData.setGraphic( hoodle );
			circleBody = LDEasyNape.createCircle( stage.fullScreenWidth - 28, stage.fullScreenHeight - 94, 20, false, false, userData );
			circleBody.userData.graphic = hoodle;	
			
//			circleBody = new Body( BodyType.DYNAMIC, new Vec2( stage.fullScreenWidth - 38, stage.fullScreenHeight - 50 ) );
//			var circleShape:Circle = new Circle( 20 );
//			circleBody.shapes.add(circleShape);
////			circleBody.space=space;
//			space.bodies.add(circleBody);
			spring = new PivotJoint( space.world, circleBody, Vec2.weak(), Vec2.weak() );
			spring.stiff 	= false;
			spring.active 	= false;
			spring.anchor1.setxy( stage.fullScreenWidth - 28, 0 );
			// 牵引力 值越大 引力越大
			spring.maxForce = 1000 * circleBody.gravMass;
			spring.space = space;
//			spring.frequency = 2;
//			spring.damping = 0.1;
			
			grad.selectable = false;
			grad.mouseEnabled = false;
			grad.text = "分数:" + gradNum;
			stage.addChild( grad );
		}
		
		private var group:InteractionGroup ;
		private var spring:PivotJoint;
		private var grad:TextField = new TextField();
		private var gradNum:int = 0;
		
		private var mc:MovieClip;
		// 添加墙
		private function addWall():void
		{
//			var body:Body = new Body( BodyType.STATIC, new Vec2( stage.fullScreenWidth/2, 7 ) );
//			var shape:Polygon = new Polygon(Polygon.box(stage.fullScreenWidth, 10));
//			body.shapes.add(shape);
//			body.space = space;
//			
			var img:Bitmap = new Bitmap( new img_groove() );
			img.x = 0;
			img.y = stage.fullScreenHeight - 122;
			stage.addChild( img );
			body = new Body( BodyType.STATIC, new Vec2( img.width/2, stage.fullScreenHeight - 33 ) );
			shape = new Polygon(Polygon.box( 399, 10));
			body.shapes.add(shape);
			body.space = space;
			for( var i:int = 0; i < 7; i++ )
			{
				var x:int = i*65 ;
				body = new Body( BodyType.STATIC, new Vec2( x, stage.fullScreenHeight - 125 ) );
				body.userData.graphic = damper;
				vertice = new <Vec2>[];
				vertice.push( new Vec2(4, 0), new Vec2( 8, 16 ), new Vec2( 8, 86), new Vec2( 0, 86), new Vec2( 0, 16) );
				shape = new Polygon( vertice );
				body.shapes.add(shape);
				body.space = space;
			}
			
			for( i=0; i < 6; i++ )
			{
				var t:TextField = new TextField();
				t.selectable = false;
				t.mouseEnabled = false;
				t.text = (i*10 + 10) + "";
				t.x = i*65 + 30;
				t.y = stage.fullScreenHeight - 110;
				stage.addChild( t );
			}
//			
//			body = new Body( BodyType.STATIC, new Vec2( 7, stage.fullScreenHeight/2 ) );
//			shape = new Polygon(Polygon.box( 10, stage.fullScreenHeight ));
//			body.shapes.add(shape);
//			body.space = space;
//			
//			body = new Body( BodyType.STATIC, new Vec2( stage.fullScreenWidth - 8, stage.fullScreenHeight/2 ) );
//			shape = new Polygon(Polygon.box( 10, stage.fullScreenHeight ));
//			body.shapes.add(shape);
//			body.space = space;
			
			var wall:Damper = new Damper(2);
			wall.x = stage.fullScreenWidth - 70 - wall.width/2;
			wall.y = stage.fullScreenHeight/2 + 70 - wall.height/2;
			stage.addChild( wall );
			body = new Body( BodyType.STATIC, new Vec2( stage.fullScreenWidth - 70, stage.fullScreenHeight/2 + 70 ) );
			body.userData.graphic = wall;
			shape = new Polygon(Polygon.box( 21, 631 ));
			body.shapes.add(shape);
			body.space = space;
			
			damper.x = stage.fullScreenWidth - 70;
			damper.y = 0;
			var body:Body = new Body( BodyType.STATIC, new Vec2( stage.fullScreenWidth - 70, 0 ) );
			body.userData.graphic = damper;
			var vertice:Vector.<Vec2> = new <Vec2>[];
			vertice.push( new Vec2(0, 0), new Vec2( 68, 0), new Vec2(68, 100) );
			var shape:Polygon = new Polygon( vertice );
			body.shapes.add(shape);
			body.space = space;
			
			mc = new mc_spring();
			mc.gotoAndStop( 1 );
			stage.addChild( mc );
			mc.x = stage.fullScreenWidth - 28 - mc.width/2;
			mc.y = stage.fullScreenHeight - 48 - mc.height/2;
			body = new Body( BodyType.STATIC, new Vec2( stage.fullScreenWidth - 29, stage.fullScreenHeight - 49 ) );
			body.userData.graphic = mc;
			shape = new Polygon(Polygon.box( 60, 50 ));
			body.shapes.add(shape);
			body.space = space;
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseEventHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			text.x = mc.x;
			text.y = mc.y;
			text.text = force.toString();
			text.textColor = 0xffffff;
			text.selectable = false;
			text.mouseEnabled = false;
			stage.addChild( text );
		}
		
		private var text:TextField = new TextField();
		// 添加静态 刚体
		private function addStaticBody():void
		{
			var num:int = 3;
			var value:int = 1;
			for( var i:int = 0; i < 6; i++ )
			{
				
				for( var j:int = 0; j < num; j++ )
				{
					var y:int = i*90 + 130;
					var x:int = j*90 + (value == 1 ? 100 : 60);
					
					var nail:Hoodle = new Hoodle( 30, 30, 2 );
					nail.x = x;
					nail.y = y;
					stage.addChild( nail );
					var circle:Body = new Body( BodyType.STATIC, new Vec2(x, y) );
					circle.userData.graphic = nail;
					var shape:Circle = new Circle( 15 );
					circle.shapes.add( shape );
					circle.space=space;
					
					circle.group = group;
				}
				value *= -1;
				num = num - value;
			}
		}
		
		private var circleBody:Body;
		protected function mouseEventHandler(e:MouseEvent):void
		{
//			if( !start )
//				return;
//			//        a.创建一个Body对象，并指定它的类型和坐标
//			var body:Body = new Body(BodyType.DYNAMIC, new Vec2(mouseX, mouseY));
//			//        b.创建刚体的形状shape，可以接收的形状有两种Cirle和Polygon，后者通过指定不同的顶点来创建任何非圆形的形状。
//			var shape:Polygon = new Polygon(Polygon.box(Math.random()*30+30,Math.random()*30+30));
//			body.shapes.add(shape);
//			//        c.指定刚体所存在的空间，即第一部分提到的空间。
//			body.space = space;
			
//			circleBody = new Body( BodyType.DYNAMIC, new Vec2(mouseX, mouseY) );
			//圆形形状参数有.Circle(radius:Number, localCOM:Vec2=null, material:Material=null, filter:InteractionFilter=null):
//			var circleShape:Circle = new Circle( 20 );
//			circleShape.position.x = 1;
//			circleShape.sensorEnabled=true;
			// 设置贴图
//			body.userData.graphic=imageData;
//			imageData.x=body.position.x;
//			imageData.y=body.position.y;
			
//			circleBody.shapes.add(circleShape);
//			circleBody.space=space;
			
			
//			circleBody.align();
//			circleBody.gravMass = 0;
//			circleBody.shapes.clear();
//			var circleShape:Circle = new Circle( 20 );
//			circleBody.shapes.add(circleShape);
//			
//			circleBody.position.x = mouseX;
//			circleBody.position.y = mouseY;
			
//			space.bodies.remove( circleBody );
			
//			var p:Vec2 = new Vec2(spring.anchor1.x, spring.anchor1.y);
//			var bodies:BodyList = space.bodiesUnderPoint(p);
//			if(bodies.length > 0){
//				var b:Body = bodies.shift();
//				spring.body2 = b;
//				spring.anchor2 = b.worldPointToLocal( p );
//				spring.anchor2 = new Vec2(mouseX, mouseY);
				start = true;
				isStart = true;
				force = 1000;
				spring.active = false;
				spring.body2.position.x = stage.fullScreenWidth - 28;
				spring.body2.position.y = stage.fullScreenHeight - 94;
//				spring.anchor1.setxy( stage.fullScreenWidth - 28, 0 );
//				var p:Vec2 = new Vec2(spring.anchor1.x, spring.anchor1.y);
//				spring.anchor2 = circleBody.worldPointToLocal(p);
//				trace( circleBody.worldPointToLocal(p) );
//			}
			mc.gotoAndStop( 2 );
			
//			group.ignore = !group.ignore;
		}
		
		private var force:Number = 1000;
		private var isStart:Boolean = false;
		protected function onMouseUp(e:MouseEvent):void
		{
//			if( !start )
//				return;
			spring.maxForce = force * circleBody.gravMass;
			spring.active = true;
			isStart = false;
			mc.gotoAndStop( 1 );
		}
		
		private function testMultiFilter():void
		{
			var Ba1:Body = createBall(10,110,100);
			var Ba2:Body = createBall(10,100,100);
			
			Ba1.shapes.at(0).filter.collisionGroup = 1;
			Ba2.shapes.at(0).filter.collisionGroup = 1;
			
			Ba1.shapes.at(0).filter.collisionMask = ~1;
			Ba2.shapes.at(0).filter.collisionMask = ~1;
			
			var Bb1:Body = createBall(50,110,100);
			var Bb2:Body = createBall(50,100,100);
			
			Bb1.shapes.at(0).filter.collisionGroup = 2;
			Bb2.shapes.at(0).filter.collisionGroup = 2;
			
			Bb1.shapes.at(0).filter.collisionMask = ~4;
			Bb2.shapes.at(0).filter.collisionMask = ~4;
			
			var Bc1:Body = createBall(100,110,100);
			var Bc2:Body = createBall(100,100,100);
			
			Bc1.shapes.at(0).filter.collisionGroup = 4;
			Bc2.shapes.at(0).filter.collisionGroup = 4;
			
			Bc1.shapes.at(0).filter.collisionMask = ~(4|2);
			Bc2.shapes.at(0).filter.collisionMask = ~(4|2);
		}
		
		private function createBall(param0:int, param1:int, param2:int):Body
		{
			var circle:Body = new Body( BodyType.DYNAMIC, new Vec2(param1, param2) );
			var shape:Circle = new Circle( param0 );
			circle.shapes.add( shape );
			circle.space=space;
			return circle;
		}
		
		
		protected var prevTime:int = 0;
		protected function loop( e:Event ):void
		{
//			spring.anchor1.setxy(mouseX, mouseY);
			
			if( isStart )
			{
				force += 1000;
				text.text = force.toString();
			}
			if( spring.active )
			{
				var v:int = Math.abs(spring.body2.position.y - mc.y);
				if( v > 70 )
					spring.active = false;
			}
			
			var t1:int = getTimer();
			
			var et:int = Math.min(50, getTimer() - prevTime);
			prevTime = getTimer();
			//Nape空间模拟
			space.step( et * .001, 30, 20);
//			space.step( 1/60, 30, 20);
			
			var t2:int = getTimer();
			
			//清除视图
			debug.clear();
			//绘制空间
			debug.draw(space);
			//优化显示图像
			debug.flush();
//			trace("physicsTime", t2 - t1);
//			trace("frameTime", getTimer() - t1);
			
			//实时更新贴图
			//1.通过Nape世界的space.liveBodies获取存储所有的活动刚体一个BodyList对象。
			for (var i:int = 0; i < space.liveBodies.length; i++) {
				//2.遍历这个BodyList对象，并通过BodyList.at(index)方法获取每个刚体的引用，同时获取贴图对象引用
				var body:Body = space.liveBodies.at(i);
				var graphic:Sprite = body.userData.graphic;
				//3.用刚体的坐标和角度更新贴图的属性，实时更新贴图
				graphic.rotation = (body.rotation * 180 / Math.PI) % 360;
				graphic.x = body.position.x ;
				graphic.y = body.position.y ;
			}
			
			
			if( circleBody.position.y > (stage.fullScreenHeight - 60) && start )
			{
//				trace("进入槽范围");
				for( i = 0; i < 6; i++ )
				{
					if( circleBody.position.x > (i*65 + 8) && circleBody.position.x < (i*65 + 73) )
					{
//						trace( "进入" + i + "号坑" );
						gradNum += i*10+10;
						grad.text = "分数:" + gradNum;
						start = false;
					}
				}
			}
			
			
			
//			LDEasyNape.updateWorld()
//			trace( hoodle.rotation );
			
//			trace( "rotation1=" + spring.body2.rotation );
//			trace( "rotation2=" + hoodle.rotation );
			
		}
		
		private var start:Boolean = true;
		private function clearBodies():void
		{
			var list:BodyList = space.bodies;
			var tempBody:Body;
			//正确的写法
			list.filter(function(b:Body):Boolean{
				return b.type != BodyType.DYNAMIC;
			});
		}
		
	}
}