package cn.geckos 
{
import flash.events.TimerEvent;
import flash.text.TextField;
import flash.utils.Timer;
/**
 * ...字符串文本工具
 * @author Kanon
 */
public class TextEffect 
{
	//计时器
	private var timer:Timer;
	//需要显示的字符串
	private var str:String;
	//文本
	private var text:TextField;
	//字符串显示的当前索引
	private var index:int;
	//结束后的回调
	public var completeFun:Function;
	public function TextEffect()
	{
		
	}
	
	/**
	 * 逐行显示
	 * @param	text  	文本
	 * @param	str   	字符串
	 * @param	delay   显示的间隔毫秒数
	 */
	public function progressShow(text:TextField, str:String, delay:Number):void
	{
		this.text = text;
		this.str = str;
		this.addTimer(delay);
	}
	
	/**
	 * 创建计时器
	 */
	private function addTimer(delay:Number):void
	{
		this.removeTimer();
		this.index = 0;
		this.timer = new Timer(delay);
		this.timer.addEventListener(TimerEvent.TIMER, timerHandler);
		this.timer.start();
	}
	
	private function timerHandler(event:TimerEvent):void 
	{
		var subStr:String = this.str.charAt(this.index);
		this.text.appendText(subStr);
		this.index++;
		if (this.index == this.str.length)
		{
			if (this.completeFun is Function)
				this.completeFun();
			this.removeTimer();
		}
	}
	
	/**
	 * 销毁计时器
	 */
	private function removeTimer():void
	{
		if (this.timer)
		{
			this.timer.removeEventListener(TimerEvent.TIMER, timerHandler);
			this.timer.stop();
			this.timer.stop();
			this.timer = null;
		}
	}
	
	/**
	 * 销毁
	 */
	public function destory():void
	{
		this.text = null;
		this.removeTimer();
	}
}
}