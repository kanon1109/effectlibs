package cn.geckos.effect 
{
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
/**
 * ...火焰枪效果
 * @author Kanon
 */
public class FlameGunEffect 
{
	//火焰资源
	private var flameSrcName:String;
	//发射速度
	private var speed:Number;
	//发射角度
	private var _rotation:Number;
	//最大缩放比
	private var maxScale:Number;
	//最小alpha值
	private var minAlpha:Number;
	//最大射程距离
	private var distance:Number;
	//发射位置的浮动
	private var floating:Number;
	//火焰弹列表
	private var flameList:Array;
	//外部容器
	private var parent:DisplayObjectContainer;
	//发射位置x坐标
	private var _startX:Number;
	//发射位置y坐标
	private var _startY:Number;
	//缩放速度
	private var scaleSpeed:Number;
	//透明度速度
	private var alphaSpeed:Number;
	//状态
	private var _status:int;
	//开火状态
	public static const FIRE = 1;
	//停止状态
	public static const STOP = 0;
	public function FlameGunEffect(parent:DisplayObjectContainer, 
								   flameSrcName:String, 
								   startX:Number = 0, startY:Number = 0,
								   speed:Number = 5,  rotation:Number = 0, 
								   maxScale:Number = 1, minAlpha:Number = .1, 
								   distance:Number = 100, floating:Number = 10, 
								   scaleSpeed:Number = .1, alphaSpeed:Number = .05) 
	{
		this.parent = parent;
		this.flameSrcName = flameSrcName;
		this.speed = speed;
		this.rotation = rotation;
		this.maxScale = maxScale;
		this.minAlpha = minAlpha;
		this.distance = distance;
		this.move(startX, startY);
		this.flameList = [];
		this.floating = floating;
		this.scaleSpeed = scaleSpeed;
		this.alphaSpeed = alphaSpeed;
	}
	
	/**
	 * 移动
	 * @param	x	发射位置x坐标
	 * @param	y	发射位置y坐标
	 */
	public function move(x:Number = 0, y:Number = 0):void
	{
		this._startX = x;
		this._startY = y;
	}
	
	/**
	 * 发射
	 */
	private function fire():void
	{
		var rot:Number = this.rotation + randnum(-this.floating, this.floating);
		var rad:Number = rot / 180 * Math.PI;
		var vx:Number = Math.cos(rad) * this.speed;
		var vy:Number = Math.sin(rad) * this.speed;
		var flameSpt:Flame = new Flame(this.flameSrcName, vx, vy, 
										this.startX, this.startY, 
										this.maxScale, this.minAlpha, 
										this.distance, this.scaleSpeed, this.alphaSpeed);
		flameSpt.rotation = this.rotation;
		this.flameList.push(flameSpt);
		this.parent.addChild(flameSpt);
	}
	
	/**
	 * 渲染
	 */
	public function update():void
	{
		switch (this._status) 
		{
			case FlameGunEffect.FIRE:
				this.fire();
				break;
		}
		//更新火焰弹数据
		var length:int = this.flameList.length;
		for (var i:int = length - 1; i >= 0; i -= 1) 
		{
			var flame:Flame = this.flameList[i];
			flame.update();
			if (flame.isOutRange())
			{
				flame.destroy();
				this.flameList.splice(i, 1);
			}
		}
	}
	
	/**
	 * 获取状态
	 */
	public function get status():int 
	{
		return _status;
	}
	
	/**
	 * 设置状态
	 */
	public function set status(value:int):void 
	{
		_status = value;
	}
	
	/**
	 * 获取角度
	 */
	public function get rotation():Number 
	{
		return _rotation;
	}
	
	/**
	 * 设置角度
	 */
	public function set rotation(value:Number):void 
	{
		_rotation = value;
	}
	
	/**
	 * 获取起始x位置
	 */
	public function get startX():Number 
	{
		return _startX;
	}
	
	/**
	 * 获取起始y位置
	 */
	public function get startY():Number 
	{
		return _startY;
	}
	
	/**
     * 返回 a - b之间的随机数，不包括  Math.max(a, b)
     * @param a
     * @param b
     * @return 假设 a < b, [a, b)
     */
    private function randnum(a:Number, b:Number):Number
    {
        return Math.random() * (b - a) + a;
    }
}
}
import flash.display.Sprite;
import flash.utils.getDefinitionByName;
class Flame extends Sprite
{
	//资源
	private var spt:Sprite;
	//速度向量
	private var vx:Number;
	private var vy:Number;
	//发射位置x坐标
	private var startX:Number;
	//发射位置y坐标
	private var startY:Number;
	//最大缩放比
	private var maxScale:Number;
	//最小alpha值
	private var minAlpha:Number;
	//最大射程距离
	private var distance:Number;
	//缩放速度
	private var scaleSpeed:Number;
	//透明度速度
	private var alphaSpeed:Number;
	public function Flame(flameSrcName:String, vx:Number, vy:Number, 
							startX:Number, startY:Number, 
							maxScale:Number, minAlpha:Number, distance:Number, 
							scaleSpeed:Number, alphaSpeed:Number)
	{
		var FlameClass:Class = getDefinitionByName(flameSrcName) as Class;
		this.startX = startX;
		this.startY = startY;
		this.vx = vx;
		this.vy = vy;
		this.x = startX;
		this.y = startY;
		this.scaleX = .2;
		this.scaleY = this.scaleY;
		this.maxScale = maxScale;
		this.minAlpha = minAlpha;
		this.distance = distance;
		this.scaleSpeed = scaleSpeed;
		this.alphaSpeed = alphaSpeed;
		this.spt = new FlameClass() as Sprite;
		this.addChild(spt);
	}
	
	/**
	 * 更新速度
	 */
	public function update():void
	{
		this.x += this.vx;
		this.y += this.vy;
		this.scaleX += this.alphaSpeed;
		this.scaleY = this.scaleX;
		if (this.scaleX > this.maxScale) this.scaleX = this.maxScale;
		if (this.mathDistance(this.x, this.y, this.startX, this.startY) >= this.distance * .5)
			this.alpha -= this.alphaSpeed;
		if (this.alpha < this.minAlpha) this.alpha = this.minAlpha;
	}
	
	/**
	 * 是否超过射程
	 * @return
	 */
	public function isOutRange():Boolean
	{
		return this.mathDistance(this.x, this.y, this.startX, this.startY) >= this.distance;
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
	
	/**
	 * 销毁
	 */
	public function destroy():void
	{
		if (this.spt.parent) this.spt.parent.removeChild(this.spt);
		if (this.parent) this.parent.removeChild(this);
		this.spt = null;
	}
}