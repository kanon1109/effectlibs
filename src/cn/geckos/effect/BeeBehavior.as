package cn.geckos.effect 
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
/**
 * ...蜜蜂行为
 * @author Kanon
 */
public class BeeBehavior
{
	//蜜蜂字典
	private var beeDict:Dictionary;
	//随机范围
	private var rangeX:Number;
	private var rangeY:Number;
	//摩擦力
	private var friction:Number = .95;
	private static var shape:Shape;
	public function BeeBehavior(rangeX:Number, rangeY:Number)
	{
		this.rangeX = rangeX;
		this.rangeY = rangeY;
		this.beeDict = new Dictionary();
		BeeBehavior.shape = new Shape();
	}
	
	/**
	 * 添加蜜蜂
	 * @param	bee 蜜蜂对象
	 */
	public function addBee(bee:DisplayObject):void
	{
		if (!this.beeDict[bee])
			this.beeDict[bee] = { "obj":bee, "vx":0, "vy":0 };
	}
	
	/**
	 * 去除一个蜜蜂
	 * @param	bee	蜜蜂对象
	 */
	public function removeBee(bee:DisplayObject):void
	{
		if (!this.beeDict || !this.beeDict[bee]) return;
		this.beeDict[bee] = null;
		delete this.beeDict[bee];
	}
	
	/**
	 * 行为开始
	 */
	public function start():void
	{
		if (!BeeBehavior.shape.hasEventListener(Event.ENTER_FRAME))
			BeeBehavior.shape.addEventListener(Event.ENTER_FRAME, loop);
	}
	
	/**
	 * 暂停
	 */
	public function pause():void
	{
		if (BeeBehavior.shape.hasEventListener(Event.ENTER_FRAME))
			BeeBehavior.shape.removeEventListener(Event.ENTER_FRAME, loop);
	}
	
	private function loop(event:Event):void 
	{
		if (!this.beeDict) return;
		for each (var o:Object in this.beeDict) 
		{
			var bee:DisplayObject = o.obj;
			o.vx += Math.random() * rangeX - rangeX * .5;
			o.vy += Math.random() * rangeY - rangeY * .5;
			bee.x += o.vx;
			bee.y += o.vy;
			o.vx *= this.friction;
			o.vy *= this.friction;
		}
	}
	
	/**
	 * 销毁
	 */
	public function destroy():void
	{
		for (var key:String in this.beeDict) 
		{
			this.beeDict[key] = null;
			delete this.beeDict[key];
		}
		this.beeDict = null;
		this.pause();
		BeeBehavior.shape = null;
	}
}
}