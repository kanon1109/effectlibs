package cn.geckos 
{
import flash.display.DisplayObject;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Dictionary;
import flash.utils.Timer;
/**
 * ...鱼类行为 捕食行为
 * @author Kanon
 */
public class FishBehaviors 
{
	//存放鱼的列表
	protected var fishDict:Dictionary;
	//移动时的速度
	protected var _speed:Number;
	protected var _roveDelay:int;
	//目标位置
	protected var targetPos:Point;
	public function FishBehaviors() 
	{
		this._speed = 10;
		this._roveDelay = 500;
		this.targetPos = new Point();
		this.fishDict = new Dictionary();
	}
	
	/**
	 * 添加一条需要此行为的鱼
	 * @param	fish  要此行为的鱼
	 */
	public function addFish(fish:DisplayObject):void
	{
		this.fishDict[fish] = { "fish": fish, 
								isGetTarget:false, 
								targetX:0, 
								targetY:0,
								vx:0, 
								vy:0,
								index:0 };
	}
	
	/**
	 * 群体移动
	 * @param	targetX  目标x位置
	 * @param	targetY  目标y位置
	 * @param	ease  	 缓动系数
	 */
	public function groupMove(targetX:Number, targetY:Number, ease:Number):void
	{
		for each (var o:Object in this.fishDict)
		{
			this.fishMove(o.fish, targetX, targetY, ease);
		}
	}
	
	/**
	 * 鱼移动
	 * @param	fish     需要移动的鱼
	 * @param	targetX  目标x位置
	 * @param	targetY  目标y位置
	 * @param	ease  	 缓动系数
	 */
	public function fishMove(fish:DisplayObject,
							  targetX:Number, 
							  targetY:Number, 
							  ease:Number):void
	{
		var o:Object = this.fishDict[fish];
		o.targetX = targetX;
		o.targetY = targetY;
		var distX:Number = (targetX - fish.x);
		var distY:Number = (targetY - fish.y);
		fish.rotation = Math.atan2(distY, distX) * 180 / Math.PI;
		fish.x += distX * ease;
		fish.y += distY * ease;
	}
	
	/**
	 * 漫游
	 * @param	rectangle  游动范围
	 */
	public function roving(rectangle:Rectangle):void
	{
		for each (var o:Object in this.fishDict)
		{
			/*if (!o.isGetTarget)
			{
				o.targetX = Math.random() * rectangle.right + rectangle.left;
				o.targetY = Math.random() * rectangle.bottom + rectangle.top;
				o.isGetTarget = true;
			}
			if (o.isGetTarget)
			{
				var p1:Point = new Point(o.fish.x, o.fish.y);
				var p2:Point = new Point(o.targetX, o.targetY);
				if (Point.distance(p1, p2) < 3)
					o.isGetTarget = false;
				else
					this.fishMove(o.fish, o.targetX, o.targetY, .1);
			}*/
			/*o.vx = 1;
			o.vy = 1;
			o.fish.rotation = Math.atan2(o.vy, o.vx) * 180 / Math.PI;
			o.fish.x += o.vx;
			o.fish.y += o.vx;*/
		}
	}
	
	/**
	 * 销毁
	 */
	public function destroy():void
	{
		this.fishDict = null;
	}
	
	/**
	 * 移动速度
	 */
	public function get speed():Number { return _speed; }
	public function set speed(value:Number):void 
	{
		_speed = value;
	}
	
	/**
	 * 漫游转向间隔
	 */
	public function get roveDelay():int { return _roveDelay; }
	public function set roveDelay(value:int):void 
	{
		_roveDelay = value;
	}
}
}