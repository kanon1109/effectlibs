package cn.geckos.event 
{
import flash.display.DisplayObject;
import flash.events.Event;
/**
 * ...黑洞事件
 * @author Kanon
 */
public class BlackHoleEvent extends Event 
{
	//进入黑洞消息
	public static const IN_HOLE:String = "inHole";
	//结束消息
	public static const OVER:String = "over";
	//黑洞衰减消息
	public static const ATTENUATION:String = "Attenuation";
	public var dObj:DisplayObject
	public function BlackHoleEvent(type:String, obj:DisplayObject=null, bubbles:Boolean = false, cancelable:Boolean = false)
	{ 
		this.dObj = obj;
		super(type, bubbles, cancelable);
	} 
	
	public override function clone():Event 
	{ 
		return new BlackHoleEvent(type, this.dObj, bubbles, cancelable);
	} 
	
	public override function toString():String 
	{ 
		return formatToString("BlackHoleEvent", "type", "bubbles", "cancelable", "eventPhase"); 
	}
	
}
}