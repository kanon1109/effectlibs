package  
{
import cn.geckos.effect.SniperBehavior;
import flash.display.Sprite;

/**
 * ...狙击测试类
 * @author Kanon
 */
public class SniperBehaviorTest extends Sprite 
{
	private var sniperBehavior:SniperBehavior;
	public function SniperBehaviorTest() 
	{
		this.sniperBehavior = new SniperBehavior(.05, .08, 2);
		
		this.sniperBehavior.addWaveView(mc);
		
		this.sniperBehavior.startWave();
	}
	
}
}