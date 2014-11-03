package  
{
import cn.geckos.effect.WaveEffect;
import flash.display.Sprite;
import flash.events.Event;
import net.hires.debug.Stats;
/**
 * ...波纹效果测试
 * @author Kanon
 */
public class WaveEffectTest extends Sprite 
{
	private var waveEffect:WaveEffect;
	public function WaveEffectTest() 
	{
		this.addChild(new Stats());
		this.waveEffect = new WaveEffect(water_mc);
		this.addEventListener(Event.ENTER_FRAME, loop);
	}
	
	private function loop(event:Event):void 
	{
		this.waveEffect.render();
	}
}
}