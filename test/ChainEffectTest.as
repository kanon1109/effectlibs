package  
{
import cn.geckos.ChainEffect;
import flash.display.Sprite;
import flash.events.Event;

/**
 * ...链效果测试
 * @author Kanon
 */
public class ChainEffectTest extends Sprite 
{
	private var chainEffect:ChainEffect
	public function ChainEffectTest() 
	{
		this.chainEffect = new ChainEffect(this);
		this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}
	
	private function enterFrameHandler(event:Event):void 
	{
		this.chainEffect.render(mouseX, mouseY);
	}
	
}
}