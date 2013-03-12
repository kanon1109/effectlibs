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
	protected var _chainLength:int = 4;
	//存放位置的列表
	protected var posDictionary:Dictionary;
	//外部容器
	private var parent:DisplayObjectContainer;
	//绘制容器
	private var drawSpt:Sprite;
	private var prevPos:Point;
	public function ChainEffect(parent:DisplayObjectContainer) 
	{
		this.parent = parent;
		this.allowIndex = this.pointIndex - this.chainLength;
		this.posDictionary = new Dictionary();
		this.drawSpt = new Sprite();
		this.parent.addChild(this.drawSpt);
	}
	
	/**
	 * 渲染效果
	 * @param	targetX  链式效果的目标x位置
	 * @param	targetY  链式效果的目标y位置
	 */
	public function render(targetX:Number, targetY:Number):void
	{
		var spt:Sprite = new Sprite();
		this.drawSpt.addChild(spt);
		var vx:Number = targetX - spt.x;
		var vy:Number = targetY - spt.y;
		spt.x += vx;
		spt.y += vy;
		this.pointIndex++;
		this.posDictionary[this.pointIndex] = spt;
		if (this.prevPos)
			this.prevPos = spt.globalToLocal(this.prevPos);
		this.draw(spt, this.prevPos);
		this.prevPos = new Point(spt.x, spt.y);
		this.allowIndex++;
		if (this.allowIndex >= this.pointIndex)
			this.allowIndex = this.pointIndex - this.chainLength;
		this.removeChainNode(this.allowIndex);
	}
	
	/**
	 * 绘制效果 父类可继承效果
	 * @param	prevPos 上一个绘制坐标的位置
	 * @param	curPos  当前绘制坐标的位置
	 */
	protected function draw(spt:Sprite, prevPos:Point):void
	{
		if (prevPos)
		{
			spt.graphics.clear();
			spt.graphics.lineStyle(4);
			spt.graphics.moveTo(0, 0);
			spt.graphics.lineTo(prevPos.x, prevPos.y);
		}
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
			delete this.posDictionary[index];
		}
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