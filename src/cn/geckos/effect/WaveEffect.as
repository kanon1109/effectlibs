package cn.geckos.effect 
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.events.Event;
import flash.filters.DisplacementMapFilter;
import flash.geom.Point;
/**
 * ...水波效果
 * @author Kanon
 */
public class WaveEffect 
{
	private var offset:Number;
	private var bitmapData:BitmapData;
	private var dmf:DisplacementMapFilter;
	private var target:DisplayObject;
	private var speed:Number;
	public function WaveEffect(target:DisplayObject, speed:Number = 1) 
	{
		if (!target) return;
		this.offset = 1;
		this.bitmapData = new BitmapData(target.width, target.height, false, 0);
		this.dmf = new DisplacementMapFilter(this.bitmapData, new Point(), 10, 2, 10, 15, "clamp");
		this.target = target;
		this.target.filters = [this.dmf];
		this.speed = speed;
	}
	
	/**
	 * 渲染
	 */
	public function render():void
	{
		var filterList:Array = this.target.filters;
		var point:Point = new Point(this.offset, this.offset * .1);
		this.bitmapData.perlinNoise(45, 5, 3, 10, true, false, 7, true, 
									[point, point]);
		this.target.filters = filterList;
		this.offset += this.speed;
	}
}
}