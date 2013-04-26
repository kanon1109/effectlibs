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
	private static var shape:Shape;
	private var waveVx:Number;
	private var waveVy:Number;
	private var range:Number;
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
		this.dict[view] = { "view":view, "angleX":0, "angleY":0 };
	}
	
	/**
	 * 狙击枪的镜头摇晃
	 * @param	vx		摇晃速度x
	 * @param	vy		摇晃速度y
	 * @param	range	摇晃范围
	 */
	private function viewWave(vx:Number, vy:Number, range:Number):void
	{
		if (!this.dict) return;
		for each (var o:Object in this.dict)
		{
			var view:DisplayObject = o.view;
			var angleX:Number = o.angleX;
			var angleY:Number = o.angleY;
			//----MakeThingMove第3章双角波形公式----
			var vx:Number = Math.sin(angleX) * range;
			var vy:Number = Math.sin(angleY) * range;
			angleX += vx;
			angleY += vy;
			view.x += vx;
			view.y += vy;
			trace(angleX, angleY);
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
	 * 受伤中招
	 */
	public function hurt():void
	{
		
	}
	
	/**
	 * 销毁
	 */
	public function destroy():void
	{
		this.dict = null;
	}
}
}