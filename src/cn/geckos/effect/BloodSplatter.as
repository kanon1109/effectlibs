package cn.geckos.effect 
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.utils.getDefinitionByName;
/**
 * ...血液飞溅效果
 * @author Kanon
 */
public class BloodSplatter 
{
	//飞溅数量
	private var num:int;
	//飞溅距离
	private var dis:int;
	//飞溅强度
	private var intensity:Number;
	//飞溅大小
	private var size:Number;
	//画布
	private var bitmap:Bitmap;
	//资源链接
	private var assest:String;
	//类链接
	private var AssetsClass:Class;
	//容器
	private var container:DisplayObjectContainer;
	//舞台宽度
	private var stageWidth:Number;
	//舞台高度
	private var stageHeight:Number;
	/**
	 * @param	container		效果外部容器
	 * @param	assest			飞溅资源的库link
	 * @param	width			舞台宽度
	 * @param	height			舞台高度
	 * @param	num				飞溅数量
	 * @param	dis				飞溅距离
	 * @param	intensity		飞溅强度
	 * @param	size			飞溅大小
	 */
	public function BloodSplatter(container:DisplayObjectContainer, 
								  assest:String,
								  stageWidth:int = 550,
								  stageHeight:int = 400,
								  num:int = 12, 
								  dis:Number = 65, 
								  intensity:Number = .8, 
								  size:Number = 1.6)
	{
		this.num = num;
		this.dis = dis;
		this.intensity = intensity;
		this.size = size;
		this.assest = assest;
		this.container = container;
		this.stageWidth = stageWidth;
		this.stageHeight = stageHeight;
		var bitmapData:BitmapData = new BitmapData(stageWidth, stageHeight, true, 0xFFFFFF);
		this.bitmap = new Bitmap(bitmapData, "auto", true);
		this.container.addChild(this.bitmap);
		this.AssetsClass = getDefinitionByName(assest) as Class;
	}
	
	/**
	 * 根据位置绘制血迹
	 * @param	targetX		x坐标
	 * @param	targetY		y坐标
	 */
	public function doSplatter(targetX:Number, targetY:Number):void
	{
		for (var i:int = 0; i < this.num; i += 1)
		{
			//创建血迹
			var tempSpt:DisplayObject = new this.AssetsClass() as DisplayObject;
			
			//设置位置
			tempSpt.x = targetX + Math.random() * (this.dis + 1) - (this.dis / 2);
			tempSpt.y = targetY + Math.random() * (this.dis + 1) - (this.dis / 2);
			
			//trace(Math.random() * (this.dis + 1) - (this.dis / 2));
			
			//设置缩放
			tempSpt.scaleX = Math.random() * this.size + this.size / 4;
			tempSpt.scaleY = Math.random() * this.size + this.size / 4;
			
			//角度
			tempSpt.rotation = Math.random() * 360;
			
			//透明度
			tempSpt.alpha = Math.random() * this.intensity + this.intensity / 4;
			
			this.container.addChild(tempSpt);
			
			//位置和角度的矩阵
			var matrix:Matrix = new Matrix();
			matrix.rotate(tempSpt.rotation * Math.PI / 180);
			matrix.tx = tempSpt.x;
			matrix.ty = tempSpt.y;
			//透明度
			var ct:ColorTransform = new ColorTransform();
			ct.alphaMultiplier = tempSpt.alpha;
			
			//绘制
			this.bitmap.bitmapData.draw(tempSpt, matrix, ct, null, null, true);
			
			this.container.removeChild(tempSpt);
		}
	}
	
	/**
	 * 清除画布
	 */
	public function clear():void
	{
		if (this.bitmap)
			this.bitmap.bitmapData.fillRect(new Rectangle(0, 0, this.stageWidth, this.stageHeight), 0x000000);
	}
	
	/**
	 * 销毁
	 */
	public function destroy():void
	{
		if (this.bitmap)
		{
			this.bitmap.bitmapData.dispose();
			if (this.bitmap.parent) this.bitmap.parent.removeChild(this.bitmap);
			this.bitmap = null;
		}
	}
}
}