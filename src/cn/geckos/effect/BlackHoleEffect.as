package cn.geckos.effect 
{
import cn.geckos.event.BlackHoleEvent;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.EventDispatcher;
/**
 * ...黑洞效果
 * 黑洞持续时间结束后会进入衰减期，衰减期内不会发生吸入。
 * @author Kanon
 */
public class BlackHoleEffect extends EventDispatcher
{
	//引力
	private var g:Number;
	//黑洞作用半径范围
	private var range:Number;
	//旋转的角速度
	private var angleSpeed:Number;
	//物质列表存放被吸引的物质
	private var subList:Array;
	//黑洞位置
	private var holePosX:Number;
	private var holePosY:Number;
	//是否开启黑洞
	private var isStart:Boolean;
	//是否结束
	private var isOver:Boolean;
	//最短距离
	private var minDis = 15;
	//持续时间（毫秒）
	private var time:int;
	//持续时间（帧）
	private var timeFrame:int;
	//结束后缓动时间（毫秒）
	private var overTime:int = 2000;
	//结束后缓动时间（帧）
	private var overTimeFrame:int;
	//帧频
	private var fps:int;
	//摩擦力
	private var f:Number = .99;
	//调试容器
	private var debugSprite:Sprite;
	//玩家可以设置一个附加在黑洞对象上的数据对象可以是显示对象或者其他类的对象
	public var useData:Object;
	public function BlackHoleEffect(g:Number = 10, range:Number = 400, angleSpeed:Number = 5, time:int = 2000, fps:int = 60) 
	{
		this.g = g;
		this.f = f;
		this.range = range;
		this.angleSpeed = angleSpeed;
		this.time = time;
		this.fps = fps;
		this.subList = [];
	}
	
	/**
	 * 添加黑洞
	 * @param	holePosX	黑洞位置x
	 * @param	holePosY	黑洞位置y
	 */
	public function addHole(holePosX:Number, holePosY:Number):void
	{
		this.holePosX = holePosX;
		this.holePosY = holePosY;
		this.isStart = true;
		this.isOver = false;
		this.timeFrame = this.time / 1000 * fps;
		this.overTimeFrame = this.overTime / 1000 * fps;
	}
	
	/**
	 * 添加被吸引的物质列表
	 * @param	ary		物质列表
	 */
	public function addSubstanceList(ary:Array):void
	{
		if (!this.subList) return;
		this.subList = this.subList.concat(ary);
	}
	
	/**
	 * 更新
	 */
	public function update():void
	{
		if (!this.isStart) return;
		if (!this.subList) return;
		var length:int = this.subList.length;
		var obj:DisplayObject;
		var dis:Number;
		for (var i:int = length - 1; i >= 0; i--) 
		{
			obj = this.subList[i];
			dis = this.mathDistance(this.holePosX, this.holePosY, obj.x, obj.y);
			if (dis <= range)
			{
				var speed:Number = this.g * (1 - dis / range);
				if (!this.isOver)
				{
					if (dis <= this.minDis) 
					{
						//小于最短距离
						var blackHoleEvent:BlackHoleEvent = 
								new BlackHoleEvent(BlackHoleEvent.IN_HOLE, obj);
						this.dispatchEvent(blackHoleEvent);
						this.subList.splice(i, 1);
					}
					if (speed > dis) speed = dis;
				}
				else
				{
					//黑洞生命周期结束
					speed = 0;
					this.angleSpeed = this.angleSpeed * this.f;
				}
				//如果在影响范围内
				var dx:Number = obj.x - this.holePosX; 
				var dy:Number = obj.y - this.holePosY;
				var radians:Number = Math.atan2(dy, dx);
				var vx:Number = speed * Math.cos(radians);
				var vy:Number = speed * Math.sin(radians);
				obj.x -= vx;
				obj.y -= vy;
				//算出角速度
				radians += Math.PI / 2;
				vx = this.angleSpeed * Math.cos(radians);
				vy = this.angleSpeed * Math.sin(radians);
				obj.x += vx;
				obj.y += vy;
				var angle:Number = radians / Math.PI * 180;
				obj.rotation = angle;
			}
		}
		this.timeFrame--
		if (this.timeFrame <= 0)
		{
			this.timeFrame = 0;
			//黑洞持续时间结束
			this.isOver = true;
			this.dispatchEvent(new BlackHoleEvent(BlackHoleEvent.ATTENUATION));
		}
		if (this.isOver)
		{
			//进入衰减期
			this.overTimeFrame--
			if (this.overTimeFrame <= 0)
			{
				//衰减期结束
				this.overTimeFrame = 0;
				this.isStart = false;
				this.dispatchEvent(new BlackHoleEvent(BlackHoleEvent.OVER));
			}
		}
	}
	
	/**
	 * 设置调试容器
	 * @param	container
	 */
	public function setDebugContainer(c:Sprite):void
	{
		this.debugSprite = c;
	}
	
	/**
	 * 销毁
	 */
	public function destroy():void
	{
		this.subList = null;
		if (this.debugSprite)
			this.debugSprite.graphics.clear();
	}
	
	/**
	 * 调试
	 */
	public function debug():void
	{
		if (!this.debugSprite) return;
		if (!this.isStart) return;
		this.debugSprite.graphics.clear();
		this.debugSprite.graphics.lineStyle(1, 0xFF0000);
		this.debugSprite.graphics.drawCircle(this.holePosX, this.holePosY, this.range);
	}
	
	/**
	 * 计算距离
	 * @param	x1	点1的x坐标
	 * @param	y1	点1的y坐标
	 * @param	x2	点2的x坐标
	 * @param	y2	点2的y坐标
	 * @return	2点之间的距离
	 */
	private function mathDistance(x1:Number, y1:Number, x2:Number, y2:Number):Number
	{
		return Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
	}
}
}




