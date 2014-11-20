package  
{
import cn.geckos.effect.WingmanMotionEffect;
import flash.display.Sprite;
import flash.events.Event;
import flash.ui.Mouse;
/**
 * ...僚机测试
 * @author Kanon
 */
public class WingmanMotionEffectTest extends Sprite 
{
	private var wme:WingmanMotionEffect;
	public function WingmanMotionEffectTest() 
	{
		this.wme = new WingmanMotionEffect(wing_mc);
		this.addEventListener(Event.ENTER_FRAME, loop);
	}
	
	private function loop(event:Event):void 
	{
		this.wme.follow(mouseX, mouseY);
	}
	
	
}
}