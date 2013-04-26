package  
{
import cn.geckos.effect.SniperBehavior;
import flash.display.Sprite;
import flash.events.MouseEvent;

/**
 * ...狙击测试类
 * @author Kanon
 */
public class SniperBehaviorTest extends Sprite 
{
	private var sniperBehavior:SniperBehavior;
	public function SniperBehaviorTest() 
	{
		this.sniperBehavior = new SniperBehavior(.05, .08, 1);
		this.sniperBehavior.addWaveView(mc);
		this.sniperBehavior.startWave();
		stage.addEventListener(MouseEvent.CLICK, clickHandler);
	}
	
	private function clickHandler(event:MouseEvent):void 
	{
		this.sniperBehavior.shake(20, 20);
		//this.sniperBehavior.destroy();
		//this.sniperBehavior.removeWaveView(mc);
	}
	
}
}