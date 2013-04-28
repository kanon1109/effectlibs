package cn.geckos.effect 
{
import flash.display.DisplayObjectContainer;
import flash.geom.Point;
import flash.utils.Dictionary;
/**
 * ...链子效果
 * @author Kanon
 */
public class ChainEffect 
{
	//存放线条的字典
	private var lineDict:Dictionary;
	//对象池
	private var pool:Array;
	//外部容器
	private var parent:DisplayObjectContainer;
	//还未加速度前的位置
	private var prevPos:Point;
	//加了速度的位置
	private var curPos:Point;
	//起始位置
	private var x:Number;
	private	var y:Number;
	//线条颜色和粗细
	protected var _lineColor:uint = 0xFFFFFF;
	protected var _lineSize:uint = 8;
	public function ChainEffect(parent:DisplayObjectContainer) 
	{
		this.parent = parent;
		this.lineDict = new Dictionary();
		this.pool = [];
		this.prevPos = new Point();
		this.curPos = new Point();
		this.x = 0;
		this.y = 0;
	}
	
	/**
	 * 移动初始点
	 * @param	x	起始点x坐标
	 * @param	y	起始点y坐标
	 */
	public function move(x:Number, y:Number):void
	{
		this.x = x;
		this.y = y;
		this.prevPos.x = this.x;
		this.prevPos.y = this.y;
	}
	
	/**
	 * 渲染效果
	 * @param	targetX  链式效果的目标x位置
	 * @param	targetY  链式效果的目标y位置
	 */
	public function render(targetX:Number, targetY:Number):void
	{
		this.curPos.x = targetX;
		this.curPos.y = targetY;
		if (Point.distance(this.prevPos, this.curPos) > 1)
		{
			var line:Line;
			//如果对象池是空的则新建一个line
			if (this.pool.length == 0)
			{
				line = new Line(this.prevPos.x, this.prevPos.y, 
								this.curPos.x, this.curPos.y,
								this.lineColor, this.lineSize);
			}
			else
			{
				//对象池获取
				line = this.pool.shift();
				line.init(this.prevPos.x, this.prevPos.y, 
						  this.curPos.x, this.curPos.y,
						  this.lineColor, this.lineSize);
			}
			if (!this.lineDict[line])
				this.lineDict[line] = line;
			this.parent.addChild(line);
			this.prevPos.x = targetX;
			this.prevPos.y = targetY;
		}
		this.update();
	}
	
	/**
	 * 更新线条状态
	 */
	private function update():void
	{
		if (!this.lineDict) return;
		var line:Line;
		for each (line in this.lineDict) 
		{
			line.draw();
			line.thickness--;
			if (line.thickness <= 0)
			{
				line.remove();
				this.lineDict[line] = null;
				delete this.lineDict[line];
				this.pool.push(line);
			}
		}
	}
	
	/**
	 * 清除
	 */
	public function clear():void
	{
		var line:Line;
		var length:int = this.pool.length;
		for (var i:int = length - 1; i >= 0; i -= 1) 
		{
			line = this.pool[i];
			line.remove();
			this.pool.splice(i, 1);
		}
		
		for each (line in this.lineDict) 
		{
			line.remove();
			this.lineDict[line] = null;
			delete this.lineDict[line];
		}
	}
	
	/**
	 * 销毁
	 */
	public function destroy():void
	{
		this.clear();
		this.prevPos = null;
		this.curPos = null;
		this.parent = null;
		this.pool = null;
		this.lineDict = null;
	}
	
	/**
	 * 设置线条颜色
	 */
	public function get lineColor():uint{ return _lineColor; }
	public function set lineColor(value:uint):void 
	{
		_lineColor = value;
	}
	
	/**
	 * 线条粗细
	 */
	public function get lineSize():uint{ return _lineSize; }
	public function set lineSize(value:uint):void 
	{
		_lineSize = value;
	}
}
}
import flash.display.Sprite;
class Line extends Sprite
{
	//线条的位置
	private var sx:Number;
	private var sy:Number;
	private var ex:Number;
	private var ey:Number;
	//线条的粗细
	private var _thickness:Number;
	//线条颜色
	private var color:uint;
	public function Line(sx:Number, sy:Number, ex:Number, ey:Number, color:uint, thickness:Number = 5)
	{
		this.init(sx, sy, ex, ey, color, thickness);
	}
	
	/**
	 * 初始化
	 * @param	sx
	 * @param	sy
	 * @param	ex
	 * @param	ey
	 * @param	color
	 * @param	thickness
	 */
	public function init(sx:Number, sy:Number, ex:Number, ey:Number, color:uint, thickness:Number = 5)
	{
		this.sx = sx;
		this.sy = sy;
		this.ex = ex;
		this.ey = ey;
		this.color = color;
		this.thickness = thickness;
	}
	
	/**
	 * 绘制
	 */
	public function draw():void
	{
		this.graphics.clear();
		this.graphics.lineStyle(this.thickness, this.color);
		this.graphics.moveTo(this.sx, this.sy);
		this.graphics.lineTo(this.ex, this.ey);
	}
	
	/**
	 * 销毁
	 */
	public function remove():void
	{
		this.graphics.clear();
		if (this.parent)
			this.parent.removeChild(this)
	}
	
	/**
	 * 线条粗细
	 */
	public function get thickness():Number{ return _thickness; }
	public function set thickness(value:Number):void 
	{
		_thickness = value;
	}
}