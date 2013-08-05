package cn.geckos.effect 
{
import flash.events.TimerEvent;
import flash.utils.Timer;
/**
 * ...大转盘效果 用于抽奖
 * @author Kanon
 */
public class WheelEffect 
{
	//快速转动的圈数;
	private var loop:int;
	//当前圈数
	private var curLoop:int;
	//计时器
	private var timer:Timer;
	//存放function的数组
	private var funList:Vector.<Function>;
	//运行间隔
	private var delay:Number;
	//当前角度
	private var _curRotation:Number;
	//旋转一圈角度
	private var roundRoation:int;
	//角速度
	private var angle:Number;
	//目标角度
	private var targetRotation:Number;
	//摩擦力
	private var friction:Number;
	//进入慢速运动时的角度
	private var slowRotation:Number;
	//是否进入了慢速滚动模式
	private var slowing:Boolean;
	public function WheelEffect(loop:int, angle:Number = 1)
	{
		this.loop = loop;
		this.delay = 33;
		this.roundRoation = 360;
		this.friction = .93;
		this.slowRotation = 30;
		this.angle = angle;
		this.funList = new Vector.<Function>();
		this.addTimer(this.delay);
	}
	
	/**
	 * 添加计时器
	 * @param	delay	计时器运行间隔
	 */
	private function addTimer(delay:Number):void
	{
		this.timer = new Timer(delay);
		this.timer.addEventListener(TimerEvent.TIMER, timerHandler);
	}
	
	/**
	 * 删除计时器
	 */
	private function removeTimer():void
	{
		if (this.timer)
		{
			this.timer.removeEventListener(TimerEvent.TIMER, timerHandler);
			this.timer.stop();
		}
	}
	
	/**
	 * 开始效果
	 * @param	targetAngel	目标角度
	 */
	public function start(targetAngel:Number):void
	{
		if (this.angle < 0) this._curRotation = 360;
		else if (this.angle > 0) this._curRotation = 0;
		this.targetRotation = targetAngel;
		this.curLoop = 0;
		this.slowing = false;
		this.stop();
		this.timer.start();
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
	
	private function timerHandler(event:TimerEvent):void 
	{
		this._curRotation += this.angle;
		if (this.angle > 0)
		{
			if (this.curRotation >= this.roundRoation)
			{
				this.curLoop++;
				this._curRotation = 0;
			}
		}
		else if (this.angle < 0)
		{
			if (this.curRotation <= 0)
			{
				this.curLoop++;
				this._curRotation = 360;
			}
		}
		if (this.curLoop >= this.loop)
		{
			trace("this.curRotation", this.curRotation);
			trace("this.targetRotation", this.targetRotation);
			if (Math.abs(this.curRotation - this.targetRotation) <= this.slowRotation)
				this.slowing = true;
		}
		
		if (this.slowing)
		{
			trace("this.slowing this.curRotation", this.curRotation);
			trace("this.slowing this.targetRotation", this.targetRotation);
			this._curRotation += (this.targetRotation - this._curRotation) * .8;
		}
		
		//小于.05 则暂停
		if (Math.abs(this.angle) <= .05) this.angle = 0;
		var fun:Function;
		var length:int = this.funList.length;
		for (var i:int = 0; i < length; i += 1) 
		{
			fun = this.funList[i];
			if (fun is Function) fun();
		}
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
	 * 消耗方法
	 */
	public function destroy():void
	{
		this.removeTimer();
		var length:int = this.funList.length;
		for (var i:int = length - 1; i >= 0; i -= 1) 
		{
			this.funList.splice(i, 1);
		}
		this.funList = null;
	}
	
	/**
	 * 当前角度
	 */
	public function get curRotation():Number { return _curRotation; };
}
}