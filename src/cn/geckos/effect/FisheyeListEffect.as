package cn.geckos.effect
{
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.Dictionary;
/**
 * ...相册拖动效果
 * 图片必须保证相同大小
 * @author Kanon
 */
public class FisheyeListEffect 
{
	//纵向或横向
	public static const VERTICAL:int = 0;
	public static const HORIZONTAL:int = 1;
	//起始位置
	private var startX:Number;
	private var startY:Number;
	//间隔
	private var gap:Number;
	//速度
	private var vx:int;
	private var vy:int;
	//舞台
	private var stage:Stage;
	//资源列表
	private var resources:Vector.<DisplayObject>;
	//用于排序的列表
	private var sortAry:Array;
	//点击的位置坐标
	private var prevX:Number;
	private var prevY:Number;
	//摩擦力
	private var _friction:Number = .96;
	//存放前置和后置显示对象的字典
	private var dObjDict:Dictionary;
	//是否鼠标点击
	private var isMouseDown:Boolean;
	//运动方向
	private var dir:int;
	//显示范围
	private var showRange:Number;
	//中间位置
	private var middlePos:Number;
	//显示时的最大尺寸
	private var maxSize:Number;
	//显示时的最小尺寸
	private var minSize:Number;
	//是否显示alpha差别
	private var _showAlpha:Boolean;
	public function FisheyeListEffect(stage:Stage, 
									  resources:Vector.<DisplayObject>, 
									  startX:Number = 0, 
									  startY:Number = 0, 
									  showRange:Number = 100,
									  gap:Number = 5, 
									  minSize:Number = .5,
									  maxSize:Number = 1,
									  dir = FisheyeListEffect.HORIZONTAL)
	{
		this.stage = stage;
		this.startX = startX;
		this.startY = startY;
		this.gap = gap;
		this.minSize = minSize;
		this.maxSize = maxSize;
		this.dir = dir;
		//显示范围始终是一个正数
		if (showRange <= 0) showRange = 100;
		this.showRange = showRange;
		this.dObjDict = new Dictionary();
		this.middlePos = this.mathMiddlePosByDir(dir);
		this.sortAry = [];
		this.init(resources, dir);
		this.sortDepth();
		this.initEvent();
	}
	
	/**
	 * 根据方向返回中间位置
	 * @param	dir	方向
	 * @return	中间位置
	 */
	private function mathMiddlePosByDir(dir):Number
	{
		if (dir == FisheyeListEffect.HORIZONTAL) 
			return this.showRange * .5 + this.startX;
		else
			return this.showRange * .5 + this.startY;
	}
	
	/**
	 * 初始化
	 * @param	resources		资源列表
	 * @param	dir				方向 0纵向、1横向
	 */
	private function init(resources:Vector.<DisplayObject>, dir:int):void 
	{
		var dObj:DisplayObject;
		var length:int = resources.length;
		if (length < 2) return;
		var prevObj:DisplayObject;
		var nextObj:DisplayObject;
		for (var i:int = 0; i < length; i += 1)
		{
			dObj = resources[i];
			if (i < length - 1) nextObj = resources[i + 1];
			if (!prevObj)
			{
				dObj.x = this.startX;
				dObj.y = this.startY;
				prevObj = resources[length - 1];
			}
			else
			{
				if (dir == FisheyeListEffect.HORIZONTAL)
				{
					dObj.x = prevObj.x + prevObj.width * .5 + this.gap + dObj.width * .5;
					dObj.y = this.startY;
				}
				else if (dir == FisheyeListEffect.VERTICAL)
				{
					dObj.x = this.startX;
					dObj.y = prevObj.y + prevObj.height * .5 + this.gap + dObj.height * .5;
				}
			}
			prevObj = dObj;
		}
		
		//第一个显示对象和最后一个
		var first:DisplayObject = resources[0];
		var last:DisplayObject = resources[length - 1];
		for (i = 0; i < length; i += 1)
		{
			dObj = resources[i];
			this.dObjDict[dObj] = { prev:prevObj, 
									next:nextObj, 
									dObj:dObj, 
									dis: -1,
									parent:dObj.parent, 
									maxRangeX:dObj.x + (this.middlePos - first.x), 
									maxRangeY:dObj.y + (this.middlePos - first.y),
									minRangeX:dObj.x - (last.x - this.middlePos),
									minRangeY:dObj.y - (last.y - this.middlePos) };
			this.mathSize(this.minSize, this.maxSize, dObj);
			
			this.sortAry.push(this.dObjDict[dObj]);
		}
	}
	
	/**
	 * 初始化
	 */
	private function initEvent():void
	{
		this.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDonwHandler);
		this.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		this.stage.addEventListener(Event.ENTER_FRAME, loop);
	}
	
	private function mouseUpHandler(event:MouseEvent):void 
	{
		if (this.dir == FisheyeListEffect.HORIZONTAL)
			this.vx = (this.stage.mouseX - this.prevX) * .1;
		else if (this.dir == FisheyeListEffect.VERTICAL)
			this.vy = (this.stage.mouseY - this.prevY) * .1;
		this.isMouseDown = false;
	}
	
	private function mouseDonwHandler(event:MouseEvent):void 
	{
		this.prevX = this.stage.mouseX;
		this.prevY = this.stage.mouseY;
		this.isMouseDown = true;
		//设置显示对象的位置
		this.setDisplayObjPos();
	}
	
	/**
	 * 设置显示对象的位置
	 */
	private function setDisplayObjPos():void
	{
		var obj:Object;
		var dObj:DisplayObject;
		for each (obj in this.dObjDict) 
		{
			dObj = obj.dObj;
			obj.curX = dObj.x;
			obj.curY = dObj.y;
		}
	}
	
	/**
	 * 抛出
	 */
	private function thow():void
	{
		var obj:Object;
		var dObj:DisplayObject;
		for each (obj in this.dObjDict) 
		{
			dObj = obj.dObj;
			dObj.x += this.vx;
			dObj.y += this.vy;
			
			//计算尺寸
			this.fixPos(dObj);
			this.mathSize(this.minSize, this.maxSize, dObj);
		}
	}
	
	/**
	 * 拖动
	 */
	private function drag():void
	{
		var vx:Number = this.stage.mouseX - this.prevX;
		var vy:Number = this.stage.mouseY - this.prevY;
		var obj:Object;
		var dObj:DisplayObject;
		for each (obj in this.dObjDict) 
		{
			dObj = obj.dObj;
			if (this.dir == FisheyeListEffect.HORIZONTAL)
				dObj.x = obj.curX + vx;
			else if (this.dir == FisheyeListEffect.VERTICAL)
				dObj.y = obj.curY + vy;
			//计算尺寸
			this.fixPos(dObj);
			this.mathSize(this.minSize, this.maxSize, dObj);
		}
	}
	
	/**
	 * 判断运动范围
	 */
	private function checkRange():void
	{
		var obj:Object;
		var dObj:DisplayObject;
		var isOut:Boolean;
		for each (obj in this.dObjDict) 
		{
			dObj = obj.dObj;
			if (this.dir == FisheyeListEffect.HORIZONTAL)
			{
				if (dObj.x < this.startX - dObj.width * .5 || 
					dObj.x > this.startX + this.showRange + dObj.width * .5)
					isOut = true;
				else
					isOut = false;
			}
			else if (this.dir == FisheyeListEffect.VERTICAL)
			{
				if (dObj.y < this.startY - dObj.height * .5 || 
					dObj.y > this.startY + this.showRange + dObj.height * .5)
					isOut = true;
				else
					isOut = false;
			}
			if (isOut)
			{
				if (dObj.parent)
					dObj.parent.removeChild(dObj);
			}
			else
			{
				if (!dObj.parent)
					DisplayObjectContainer(obj.parent).addChild(dObj);
			}
		}
	}
	
	/**
	 * 主循环
	 * @param	event
	 */
	private function loop(event:Event):void 
	{
		this.checkRange();
		if (!this.isMouseDown)
		{
			this.thow();
			this.vx *= this._friction;
			this.vy *= this._friction;
		}
		else this.drag();
		this.sortDepth();
	}
	
	/**
	 * 修正位置
	 * @param	dObj	显示对象
	 */
	private function fixPos(dObj:DisplayObject):void 
	{
		var obj:Object = this.dObjDict[dObj];
		if (this.dir == FisheyeListEffect.HORIZONTAL)
		{
			if (dObj.x > obj.maxRangeX) dObj.x = obj.maxRangeX;
			else if (dObj.x < obj.minRangeX) dObj.x = obj.minRangeX;
		}
		else if (this.dir == FisheyeListEffect.VERTICAL)
		{
			if (dObj.y > obj.maxRangeY) dObj.y = obj.maxRangeY;
			else if (dObj.y < obj.minRangeY) dObj.y = obj.minRangeY;
		}
	}
	
	/**
	 * 计算尺寸
	 * @param	min		最小尺寸
	 * @param	max		最大尺寸
	 * @param	dObj	显示对象
	 */
	private function mathSize(min:Number, max:Number, dObj:DisplayObject):void
	{
		//距离
		var dis:Number;
		if (this.dir == FisheyeListEffect.HORIZONTAL)
			dis = this.mathDis(dObj.x, this.middlePos);
		else if (this.dir == FisheyeListEffect.VERTICAL)
			dis = this.mathDis(dObj.y, this.middlePos);
		if (dis <= this.showRange)
		{
			dObj.scaleX = (this.showRange - dis) / this.showRange * (max - min) + min;
			dObj.scaleY = dObj.scaleX;
			if (this._showAlpha) dObj.alpha = dObj.scaleX;
		}
		var obj:Object = this.dObjDict[dObj];
		obj.dis = dis;
	}
	
	/**
	 * 深度排序
	 */
	private function sortDepth():void
	{
		//排序
		this.sortAry.sortOn("dis", Array.NUMERIC | Array.DESCENDING);
		var length:int = this.sortAry.length;
		var obj:Object;
		for (var i:int = 0; i < length; i += 1) 
		{
			obj = this.sortAry[i];
			if (obj.dis < this.showRange * .5)
				DisplayObjectContainer(obj.parent).addChild(obj.dObj);
		}
	}
	
	/**
	 * 计算2个点的直线距离 非斜线
	 * @param	pos1		位置1
	 * @param	pos2		位置2
	 * @return	距离
	 */
	private function mathDis(pos1:Number, pos2:Number):Number
	{
		return Math.abs(pos1 - pos2);
	}
	
	/**
	 * 销毁
	 */
	public function destroy():void
	{
		this.stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDonwHandler);
		this.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		this.stage.removeEventListener(Event.ENTER_FRAME, loop);
		this.stage = null;
		
		var length:int = this.sortAry.length;
		for (var i:int = length - 1; i >= 0; i -= 1) 
		{
			this.sortAry.splice(i, 1);
		}
		
		var obj:Object;
		for each (obj in this.dObjDict) 
		{
			delete this.dObjDict[obj.dObj];
		}
		
		this.dObjDict = null;
		this.sortAry = null;
	}
	
	/**
	 * 摩擦力 有效范围 .1 - 1 之间
	 */
	public function get friction():Number{ return _friction; }
	public function set friction(value:Number):void 
	{
		_friction = value;
	}
	
	/**
	 * 是否显示alpha差别
	 */
	public function get showAlpha():Boolean{ return _showAlpha; }
	public function set showAlpha(value:Boolean):void 
	{
		_showAlpha = value;
	}
}
}