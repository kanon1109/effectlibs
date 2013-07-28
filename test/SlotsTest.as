package  
{
import cn.geckos.effect.SlotsEffect;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
/**
 * ...老虎机测试
 * @author Kanon
 */
public class SlotsTest extends Sprite 
{
	private var slotsEffect:SlotsEffect;
	public function SlotsTest() 
	{
		this.slotsEffect = new SlotsEffect(10, 15, 2, 50);
		this.slotsEffect.push(selectMc);
		this.stopAllMc();
		this.selectMc();
		
		btn1.addEventListener(MouseEvent.CLICK, btn1ClickHandler);
		btn2.addEventListener(MouseEvent.CLICK, btn2ClickHandler);
	}
	
	private function btn2ClickHandler(event:MouseEvent):void 
	{
		this.slotsEffect.splice(randomSelect);
		this.slotsEffect.push(selectMc);
		this.slotsEffect.show(int(Math.random() * 15 + 1), true);
	}
	
	private function btn1ClickHandler(event:MouseEvent):void 
	{
		this.slotsEffect.splice(selectMc);
		this.slotsEffect.push(randomSelect);
		this.slotsEffect.show(int(Math.random() * 15 + 1), true);
	}
	
	
	private function clickHandler(event:MouseEvent):void 
	{
		
	}
	
	/**
	 * 选中某个mc
	 * @param	mc
	 */
	private function selectMc():void
	{
		this.stopAllMc();
		var mc:MovieClip = this.getChildByName("b" + this.slotsEffect.curIndex) as MovieClip;
		mc.nextFrame();
	}
	
	private function randomSelect():void
	{
		this.stopAllMc();
		var mc:MovieClip = this.getChildByName("b" + this.slotsEffect.randomIndex) as MovieClip;
		mc.nextFrame();
	}
	
	private function stopAllMc():void
	{
		var mc:MovieClip;
		for (var i:int = 1; this.getChildByName("b" + i); i++) 
		{
			mc = this.getChildByName("b" + i) as MovieClip;
			mc.gotoAndStop(1);
		}
	}
	
	private function keyDownHandler(event:KeyboardEvent):void 
	{
		this.slotsEffect.destroy();
	}
	
}
}