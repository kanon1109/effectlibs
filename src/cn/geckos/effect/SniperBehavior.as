package cn.geckos.effect 
{
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.events.Event;
import flash.utils.Dictionary;
/**
 * ...狙击手 狙击镜摇晃效果
 * @author 
 */
public class SniperBehavior 
{
	private var dict:Dictionary;
	private var waveVx:Number;
	private var waveVy:Number;
	private var range:Number;
	private static var shape:Shape;
	public function SniperBehavior(waveVx:Number, waveVy:Number, range:Number) 
	{
		this.dict = new Dictionary();
		this.waveVx = waveVx;
		this.waveVy = waveVy;
		this.range = range;
		SniperBehavior.shape = new Shape();
	}
	
	/**
	 * 添加需要摇晃的视图
	 * @param	view	需要摇晃的视图
	 */
	public function addWaveView(view:DisplayObject):void
	{
		if (this.dict[view]) return;
		this.dict[view] = { "view":view, "angleX":0, "angleY":0 };
	}
	
	/**
	 * 删除不需要摇晃的视图
	 * @param	view	不需要摇晃的视图
	 */
	public function removeWaveView(view:DisplayObject):void
	{
		if (!this.dict[view]) return;
		this.dict[view] = null;
		delete this.dict[view];
	}
	
	/**
	 * 狙击枪的镜头摇晃
	 * @param	speedX		摇晃速度x
	 * @param	speedY		摇晃速度y
	 * @param	range		摇晃范围
	 */
	private function viewWave(speedX:Number, speedY:Number, range:Number):void
	{
		if (!this.dict) return;
		for each (var o:Object in this.dict)
		{
			var view:DisplayObject = o.view;
			//----MakeThingMove第3章双角波形公式----
			var vx:Number = Math.sin(o.angleX) * range;
			var vy:Number = Math.sin(o.angleY) * range;
			o.angleX += speedX;
			o.angleY += speedY;
			view.x += vx;
			view.y += vy;
		}
	}
	
	/**
	 * 开始摇晃
	 */
	public function startWave():void
	{
		if (!SniperBehavior.shape || 
			SniperBehavior.shape.hasEventListener(Event.ENTER_FRAME))
			return
		SniperBehavior.shape.addEventListener(Event.ENTER_FRAME, loop);
	}
	
	private function loop(event:Event):void 
	{
		this.viewWave(this.waveVx, this.waveVy, this.range);
	}
	
	/**
	 * 震动
	 */
	public function shake(rangeX:Number, rangeY:Number):void
	{
		if (!this.dict) return;
		for each (var o:Object in this.dict)
		{
			var view:DisplayObject = o.view;
			var x:Number = view.x + Math.random() * rangeX - rangeX;
			var y:Number = view.y + Math.random() * rangeY - rangeY;
			var vx:Number = x - view.x;
			var vy:Number = y - view.y;
			view.x += vx;
			view.y += vy;
		}
	}
	
	/**
	 * 销毁
	 */
	public function destroy():void
	{
		for (var key:String in this.dict) 
		{
			this.dict[key] = null;
			delete this.dict[key];
		}
		this.dict = null;
		if (SniperBehavior.shape && 
			SniperBehavior.shape.hasEventListener(Event.ENTER_FRAME))
		{
			SniperBehavior.shape.removeEventListener(Event.ENTER_FRAME, loop);
			SniperBehavior.shape = null;
		}
	}
}
}