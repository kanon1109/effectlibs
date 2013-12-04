package cn.geckos.effect
{
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.BlurFilter;
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
	private var mouseDownX:Number;
	private var mouseDownY:Number;
	//用于抛出的上一个鼠标位置
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
	//是否显示模糊差别
	private var _showBlur:Boolean;
	//是否在滚动中
	private var isScroll:Boolean;
	//滚动显示对象
	private var scrollObj:DisplayObject;
	//是否在自动滚动
	private var isAutoScroll:Boolean;
    /**
     * 初始化鱼眼效果构造函数
     * @param	stage           效果所在的舞台
     * @param	resources       显示对象资源列表
     * @param	startX          最左边坐标
     * @param	startY          最上边坐标
     * @param	showRange       鱼眼显示范围
     * @param	gap             显示对象之间的排列间隔
     * @param	minSize         当滚动到最左边或者最右边时，显示对象最小的尺寸scale
     * @param	maxSize         当滚动到中间时，显示对象最大的尺寸scale
     * @param	dir             纵向滚动还是横向滚动 0横向，1纵向
     */
	public function FisheyeListEffect(stage:Stage,
									  resources:Vector.<DisplayObject>, 
									  startX:Number = 0, 
									  startY:Number = 0, 
									  showRange:Number = 100,
									  gap:Number = 5, 
									  minSize:Number = .5,
									  maxSize:Number = 1,
									  dir:int = FisheyeListEffect.HORIZONTAL)
	{
		this.stage = stage;
		this.resources = resources;
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
		this.update();
		this.sortDepth();
	}
	
	/**
	 * 根据方向返回中间位置
	 * @param	dir	方向
	 * @return	中间位置
	 */
	private function mathMiddlePosByDir(dir:int):Number
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
									filters: null,
									parent:dObj.parent, 
									maxRangeX:dObj.x + (this.middlePos - first.x), 
									maxRangeY:dObj.y + (this.middlePos - first.y),
									minRangeX:dObj.x - (last.x - this.middlePos),
									minRangeY:dObj.y - (last.y - this.middlePos) };
			this.changeProp(dObj);
			this.sortAry.push(this.dObjDict[dObj]);
		}
	}
	
	/**
	 * 保存当前显示对象的位置
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
	private function update():void
	{
		if (this.isMouseDown) return;
		var obj:Object;
		var dObj:DisplayObject;
		for each (obj in this.dObjDict) 
		{
			this.checkRange(obj);
			dObj = obj.dObj;
			dObj.x += this.vx;
			dObj.y += this.vy;
			//计算尺寸
			this.fixPos(dObj);
			this.changeProp(dObj);
		}
		if (!this.isAutoScroll &&
			!this.isScroll)
		{
			this.vx *= this._friction;
			this.vy *= this._friction;
		}
	}
	
	/**
	 * 拖动
	 */
	private function drag():void
	{
		if (!this.isMouseDown) return;
		var vx:Number = this.stage.mouseX - this.mouseDownX;
		var vy:Number = this.stage.mouseY - this.mouseDownY;
		this.prevX = this.stage.mouseX;
		this.prevY = this.stage.mouseY;
		this.move(vx, vy);
	}
    
    /**
     * 移动所以的显示对象
     * @param	vx      移动的x方向距离
     * @param	vy      移动的y方向距离
     */
    private function move(vx:Number, vy:Number):void
    {
        var obj:Object;
		var dObj:DisplayObject;
		for each (obj in this.dObjDict) 
		{
			this.checkRange(obj);
			dObj = obj.dObj;
			if (this.dir == FisheyeListEffect.HORIZONTAL)
				dObj.x = obj.curX + vx;
			else if (this.dir == FisheyeListEffect.VERTICAL)
				dObj.y = obj.curY + vy;
			//修正位置
			this.fixPos(dObj);
			this.changeProp(dObj);
		}
    }
	
	/**
	 * 判断运动范围
	 * @param	obj	 每一个显示对象保存的数据
	 */
	private function checkRange(obj:Object):void
	{
		var dObj:DisplayObject = obj.dObj;
		if (this.dir == FisheyeListEffect.HORIZONTAL)
		{
			if (dObj.x < this.startX - dObj.width * .5 || 
				dObj.x > this.startX + this.showRange + dObj.width * .5)
			{
				dObj.filters = null;
				if (dObj.parent)
					dObj.parent.removeChild(dObj);
			}
			else
			{
				if (!dObj.parent)
					DisplayObjectContainer(obj.parent).addChild(dObj);
			}
		}
		else if (this.dir == FisheyeListEffect.VERTICAL)
		{
			if (dObj.y < this.startY - dObj.height * .5 || 
				dObj.y > this.startY + this.showRange + dObj.height * .5)
			{
				dObj.filters = null;
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
	 * 改变显示对象的属性
	 * @param	dObj	显示对象
	 */
	private function changeProp(dObj:DisplayObject):void
	{
		//距离
		var dis:Number;
		if (this.dir == FisheyeListEffect.HORIZONTAL)
			dis = this.mathDis(dObj.x, this.middlePos);
		else if (this.dir == FisheyeListEffect.VERTICAL)
			dis = this.mathDis(dObj.y, this.middlePos);
		var obj:Object = this.dObjDict[dObj];
		if (dis <= this.showRange)
		{
			dObj.scaleX = this.mathPropValue(this.minSize, this.maxSize, dis);
			dObj.scaleY = dObj.scaleX;
			//使用模糊滤镜
			if (this._showBlur)
			{
				var blur:Number = this.mathPropValue(20, 0, dis);
				if (!obj.filters) 
				{
					obj.filters = new BlurFilter(blur, blur);
				}
				else
				{
					obj.filters.blurX = blur;
					obj.filters.blurY = blur;
				}
				dObj.filters = [obj.filters];
			}
			//使用alpha
			if (this._showAlpha) dObj.alpha = dObj.scaleX;
		}
		obj.dis = dis;
	}
	
	/**
	 * 计算改变的属性值
	 * @param	min		希望改变属性的最小值
	 * @param	max		希望改变属性的最大值
	 * @param	dis		显示对象到中心点位置的距离
	 * @return	属性值
	 */
	private function mathPropValue(min:Number, max:Number, dis:Number):Number
	{
		return (this.showRange - dis) / this.showRange * (max - min) + min;
	}
	
	/**
	 * 深度排序
	 */
	private function sortDepth():void
	{
		//排序
		this.sortAry.sortOn("dis", Array.NUMERIC);
		var i:int = this.sortAry.length - 1;
		var obj:Object;
		//倒序最快
		while (i--)
		{
			obj = this.sortAry[i];
			if (obj.dis <= this.showRange * .5)
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
	 * 滚动
	 */
	private function scroll():void 
	{
		if (this.isScroll)
		{
			if (this.dir == FisheyeListEffect.HORIZONTAL)
			{
				this.vx = (this.middlePos - this.scrollObj.x) * .1;
				if (Math.abs(this.vx) < 1) 
				{
					this.vx = 0;
					this.isScroll = false;
				}
			}
			else if (this.dir == FisheyeListEffect.VERTICAL)
			{
				this.vy = (this.middlePos - this.scrollObj.y) * .1;
				if (Math.abs(this.vy) < 1) 
				{
					this.vy = 0;
					this.isScroll = false;
				}
			}
		}
	}
    
    /**
     * 根据图片索引显示图片位置
     * @param	index       索引 从0开始
     */
    public function setPosByIndex(index:int):void
    {
        if (!this.resources) return;
        if (index < 0) index = 0;
        if (index > this.resources.length - 1) index = this.resources.length - 1;
        //保存当前显示对象的位置
		this.setDisplayObjPos();
        var dObj:DisplayObject = this.resources[index];
        //计算距离中间位置的距离
        if (this.dir == FisheyeListEffect.HORIZONTAL)
            this.move(this.middlePos - dObj.x, 0);
        else if (this.dir == FisheyeListEffect.VERTICAL)
            this.move(0, this.middlePos - dObj.y);
    }
    
    /**
     * 获取当前靠近中间的显示对象索引
     * @return      显示对象索引 如果未初始化列表则返回-1;
     */
    public function getCurPosIndex():int
    {
        if (!this.resources) return -1;
        //保存当前显示对象与中间位置的距离列表
        var length:int = this.resources.length;
        var dObj:DisplayObject;
        //当前距离
        var curDis:Number;
        //当前最短距离
        var minDis:Number = -1;
        //当前距离最小的索引
        var index:int = 0;
        for (var i:int = 0; i < length; i += 1) 
        {
            dObj = this.resources[i];
            if (this.dir == FisheyeListEffect.HORIZONTAL)
                curDis = Math.abs(this.middlePos - dObj.x);
            else if (this.dir == FisheyeListEffect.VERTICAL)
                curDis = Math.abs(this.middlePos - dObj.y);
            if (minDis < 0) 
            {
                minDis = curDis;
            }
            else if (curDis < minDis) 
            {
                minDis = curDis;
                index = i;
            }
        }
        return index;
    }
	
	/**
	 * 鼠标释放
	 */
	public function mouseUp():void
	{
		this.isMouseDown = false;
		this.isScroll = false;
		if (this.dir == FisheyeListEffect.HORIZONTAL)
			this.vx = this.stage.mouseX - this.prevX;
		else if (this.dir == FisheyeListEffect.VERTICAL)
			this.vy = this.stage.mouseY - this.prevY;
	}
	
	/**
	 * 鼠标点击
	 */
	public function mouseDown():void
	{
		if (this.dir == FisheyeListEffect.HORIZONTAL)
		{
			this.mouseDownX = this.stage.mouseX;
			this.prevX = this.stage.mouseX;
		}
		else if (this.dir == FisheyeListEffect.VERTICAL)
		{ 
			this.mouseDownY = this.stage.mouseY;
			this.prevY = this.stage.mouseY;
		}
		this.isScroll = false;
		this.isMouseDown = true;
		//保存当前显示对象的位置
		this.setDisplayObjPos();
	}
	
	/**
	 * 根据索引滚动
	 * @param	index	索引
	 */
	public function scrollByIndex(index:int):void
	{
		if (!this.resources) return;
        if (index < 0) index = 0;
        if (index > this.resources.length - 1) index = this.resources.length - 1;
        //保存当前显示对象的位置
		this.setDisplayObjPos();
		this.isScroll = true;
		this.scrollObj = this.resources[index];
	}
	
	/**
	 * 渲染
	 */
	public function render():void 
	{
		this.scroll();
		this.update();
		this.drag();
		this.sortDepth();
	}
	
	/**
	 * 销毁
	 */
	public function destroy():void
	{
		this.stage = null;
		var length:int = this.sortAry.length;
		for (var i:int = length - 1; i >= 0; i -= 1) 
		{
			this.sortAry.splice(i, 1);
		}
		
		var obj:Object;
		for each (obj in this.dObjDict) 
		{
			obj.dObj.filters = null;
			delete this.dObjDict[obj.dObj];
		}
		this.dObjDict = null;
		this.sortAry = null;
	}
	
	/**
	 * 自动滚动
	 * @param	speed	滚动速度
	 */
	public function autoScroll(speed:Number):void 
	{
		this.isAutoScroll = true;
		if (this.dir == FisheyeListEffect.HORIZONTAL)
			this.vx = speed;
		else if (this.dir == FisheyeListEffect.VERTICAL)
			this.vy = speed;
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
	
	/**
	 * 是否显示模糊差别
	 */
	public function get showBlur():Boolean { return _showBlur; }
	public function set showBlur(value:Boolean):void 
	{
		_showBlur = value;
	}
}
}