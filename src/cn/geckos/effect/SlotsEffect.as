package cn.geckos.effect 
{
import flash.events.TimerEvent;
import flash.utils.Timer;
/**
 * ...老虎机 苹果机
 * 总结：
 * 无论起始索引是几，如何判断一个循环滚动是否结束。
 * 
 * if (this.timer.currentCount >= this.loop * this.maxIndex)
 * 这个判断滚动次数是否大于快速滚动次数，才做慢速滚动判断，
 * 
 * 否则如果碰到目标和起始索引相同的情况会出现一次也不滚的情况。
 * 
 * 通过改变timer.sdelay来实现慢速缓缓结束。
 * 外部通过一个 funList 来实现 显示和数据的分离。
 * 
 * @author Kanon
 */
public class SlotsEffect 
{
	//最大索引
	private var maxIndex:int;
	//非慢速模式的滚动次数
	private var loop:int;
	//计时器
	private var timer:Timer;
	//当前索引
	private var _curIndex:int;
	//慢速滚动的开始索引
	private var slowIndex:int;
 	//目标索引
	private var targetIndex:int;
	//是否是逆序
	private var reverse:Boolean;
	//运行间隔 毫秒
	private var delay:Number;
	//需要外部执行的方法列表
	private var funList:Array;
	//是否进入了慢速滚动模式
	private var slowing:Boolean;
	//在到达从目标索引前，提前gapIndex个索引触发慢速滚动。
	private var gapIndex:int;
	//触发的间隔时间变长的增量
	private var _delayAdd:int = 300;
	//随机选择的索引
	private var _randomIndex:int;
	/**
	 * 老虎机效果
	 * @param	curIndex	初始化的位置索引。
	 * @param	maxIndex	总的索引数量。
	 * @param	loop		快速模式的滚动次数。
	 * 						在快速滚动次数达到后会有一次慢速滚动。一般滚动次数是loop + 1;
	 * @param	delay		运行间隔 毫秒
	 * @param	gapIndex	在到达从目标索引前，提前gapIndex个索引触发慢速滚动。
	 */
	public function SlotsEffect(curIndex:int, maxIndex:int,
								loop:int = 1, delay:Number = 50,
								gapIndex:int = 5) 
	{
		if (curIndex < 1) curIndex = 1;
		if (maxIndex < 1) maxIndex = 1;
		if (curIndex > maxIndex) curIndex = maxIndex;
		if (loop < 1) loop = 1;
		if (delay <= 0) delay = 10;
		//初始化赋值
		this._curIndex = curIndex;
		this._randomIndex = curIndex;
		this.maxIndex = maxIndex;
		this.gapIndex = Math.abs(gapIndex);
		this.delay = delay;
		this.loop = loop;
		this.addTimer(delay);
		this.funList = [];
	}
	
	/**
	 * 添加计时器
	 * @param	delay	运行间隔
	 */
	private function addTimer(delay:Number):void
	{
		if (!this.timer)
		{
			this.timer = new Timer(delay)
			this.timer.addEventListener(TimerEvent.TIMER, timerHandler);
		}
	}
	
	/**
	 * 计时器暂停
	 */
	private function stop():void
	{
		if (this.timer.running)
		{
			this.timer.stop();
			this.timer.reset();
		}
	}
	
	/**
	 * 计时器开始
	 */
	private function start():void
	{
		this.stop();
		this.timer.start();
	}
	
	/**
	 * 显示获得
	 * @param	targetIndex	获得索引
	 * @param	reverse		是否逆运行
	 */
	public function show(targetIndex:int, reverse:Boolean=false):void
	{
		if (!this.timer) return;
		if (targetIndex < 1) targetIndex = 1; 
		else if (targetIndex > maxIndex) targetIndex = maxIndex;
		this.slowing = false;
		this.timer.delay = this.delay;
		this.targetIndex = targetIndex;
		//设置间隔后的索引
		if (!reverse)
			this.slowIndex = this.fixNumber(this.targetIndex - this.gapIndex, 1, this.maxIndex);
		else
			this.slowIndex = this.fixNumber(this.targetIndex + this.gapIndex, 1, this.maxIndex);
		this.reverse = reverse;
		this.start();
	}
	
	private function timerHandler(event:TimerEvent):void 
	{
		//索引轮回
		if (!this.reverse)
		{
			this._curIndex++;
			if (this._curIndex > this.maxIndex)
				this._curIndex = 1;
		}
		else
		{
			this._curIndex--;
			if (this._curIndex < 1)
				this._curIndex = this.maxIndex;	
		}
		
		this._randomIndex = int(Math.random() * this.maxIndex + 1);
		
		//一个循环结束
		if (this.timer.currentCount >= this.loop * this.maxIndex)
		{
			//是否进入了慢速模式
			if (this._curIndex == this.slowIndex)
			{
				this.slowing = true;
				this.timer.delay += this._delayAdd;
			}
		}
		
		if (this.slowing && this._curIndex == this.targetIndex)
		{
			this._randomIndex = this.targetIndex;
			this.stop();
		}
		
		var length:int = this.funList.length;
		for (var i:int = 0; i < length; i += 1) 
		{
			this.funList[i]();
		}
	}
	
	/**
	 * 修正数字 在一个范围内
	 * @param	num     需要修正的数字
	 * @param	min     最小的范围
	 * @param	range   最大范围
	 * @return  修正后的数字
	 */
	private function fixNumber(num:Number, min:Number, range:Number):Number
	{
		num %= range;
		if (num < min) return num + range;
		return num;
	}
	
	/**
	 * 将方法放入列表中
	 * @param	fun		方法引用
	 */
	public function push(fun:Function):void
	{
		if (this.funList.indexOf(fun) == -1)
			this.funList.push(fun);
	}
	
	/**
	 * 将列表中的方法删除
	 * @param	fun		方法引用
	 */
	public function splice(fun:Function):void
	{
		var index:int = this.funList.indexOf(fun);
		if (index != -1) 
			this.funList.splice(index, 1);
	}
	
	/**
	 * 销毁
	 */
	public function destroy():void
	{
		if (this.timer)
		{
			this.timer.removeEventListener(TimerEvent.TIMER, timerHandler);
			this.timer.stop();
			this.timer = null;
		}
		var length:int = this.funList.length;
		for (var i:int = length - 1; i >= 0; i -= 1) 
		{
			this.funList.splice(i, 1);
		}
		this.funList = null;
	}
	
	/**
	 * 当前索引
	 */
	public function get curIndex():int{ return _curIndex; }
	
	/**
	 * timer延迟的增量 用于慢速滚动模式中的速度
	 */
	public function get delayAdd():int{ return _delayAdd; }
	public function set delayAdd(value:int):void 
	{
		_delayAdd = value;
	}
	
	/**
	 * 随机索引
	 */
	public function get randomIndex():int{ return _randomIndex; }
}
}