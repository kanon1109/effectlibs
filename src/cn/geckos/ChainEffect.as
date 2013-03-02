package cn.geckos 
{
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.geom.Point;
import flash.utils.Dictionary;
/**
 * ...链子效果
 * @author Kanon
 */
public class ChainEffect 
{
	//点的索引
	protected var pointIndex:int;
	//需要删除的点的索引
	protected var allowIndex:int;
	//链子的长度
	protected var _chainLength:int = 10;
	//存放位置的列表
	protected var posDictionary:Dictionary;
	//外部容器
	private var parent:DisplayObjectContainer;
	//还未加速度前的位置
	private var prevPos:Point;
	//加了速度的位置
	private var curPos:Point;
	//起始位置
	private var x:Number;
	private	var y:Number;
	//速度
	private var vx:Number;
	private var vy:Number;
	public function ChainEffect(parent:DisplayObjectContainer) 
	{
		this.parent = parent;
		this.allowIndex = this.pointIndex - this.chainLength;
		this.posDictionary = new Dictionary();
		this.x = this.y = 0;
		this.vx = this.vy = 0;
		this.prevPos = new Point();
		this.curPos = new Point();
	}
	
	/**
	 * 移动到某个位置
	 * @param	x  x坐标
	 * @param	y  y坐标
	 */
	public function move(x:Number, y:Number):void
	{
		this.x = x;
		this.y = y;
	}
	
	/**
	 * 渲染效果
	 * @param	targetX  链式效果的目标x位置
	 * @param	targetY  链式效果的目标y位置
	 * @param	ease     缓动系数 默认为1 无缓动
	 */
	public function render(targetX:Number, targetY:Number, ease:Number = 1):void
	{
		this.vx = (targetX - this.x) * ease;
		this.vy = (targetY - this.y) * ease;
		this.prevPos.x = this.x;
		this.prevPos.y = this.y;
		this.x += this.vx;
		this.y += this.vy;
		this.curPos.x = this.x;
		this.curPos.y = this.y;
		if (Point.distance(this.prevPos, this.curPos) > 1)
			this.draw(this.curPos, this.prevPos);
		this.pointIndex++;
		this.allowIndex++;
		if (this.allowIndex >= this.pointIndex)
			this.allowIndex = this.pointIndex - this.chainLength;
		this.removeChainNode(this.allowIndex);
	}
	
	/**
	 * 绘制效果 父类可继承效果
	 * @param	curPos  当前绘制坐标的位置
	 * @param	prevPos 上一个绘制坐标的位置
	 */
	protected function draw(curPos:Point, prevPos:Point):void
	{
		var spt:Sprite = new Sprite();
		spt.graphics.clear();
		spt.graphics.lineStyle(4);
		spt.graphics.moveTo(prevPos.x, prevPos.y);
		spt.graphics.lineTo(curPos.x, curPos.y);
		this.parent.addChild(spt);
		this.posDictionary[this.pointIndex] = spt;
	}
	
	/**
	 * 销毁效果链上的一个节点 父类可继承效果
	 * @param	index   节点的索引
	 */
	protected function removeChainNode(index:int):void
	{
		if (!this.posDictionary) return;
		var spt:Sprite = this.posDictionary[index];
		if (spt)
		{
			spt.graphics.clear();
			if (spt.parent)
				spt.parent.removeChild(spt);
		}
		delete this.posDictionary[index];
	}
	
	/**
	 * 清除
	 */
	public function clear():void
	{
		for each (var spt:Sprite in this.posDictionary) 
		{
			if (spt && spt.parent)
			{
				spt.graphics.clear();
				spt.parent.removeChild(spt);
			}
		}
	}
	
	/**
	 * 销毁
	 */
	public function destory():void
	{
		this.clear();
		this.prevPos = null;
		this.curPos = null;
		this.posDictionary = null;
		this.parent = null;
	}
	
	/**
	 * 链子的长度
	 */
	public function get chainLength():int{ return _chainLength; }
	public function set chainLength(value:int):void 
	{
		_chainLength = value;
		this.allowIndex = this.pointIndex - this.chainLength;
	}
}
}