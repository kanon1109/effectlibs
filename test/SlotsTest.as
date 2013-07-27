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
	private var slotsEffect:SlotsEffect
	public function SlotsTest() 
	{
		this.slotsEffect = new SlotsEffect(10, 15, 2, 50);
		this.slotsEffect.push(selectMc);
		this.stopAllMc();
		this.selectMc();
		stage.addEventListener(MouseEvent.CLICK, clickHandler);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
	}
	
	var index:int
	private function clickHandler(event:MouseEvent):void 
	{
		//var index:int = int(Math.random() * 15 + 1);
		//trace("index", index);
		index++;
		this.slotsEffect.show(index, true);
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