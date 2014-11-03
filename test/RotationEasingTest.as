package  
{
import cn.geckos.effect.RotationEasing;
import flash.display.Sprite;
import flash.events.Event;

/**
 * ...缓动旋转测试
 * @author Kanon
 */
public class RotationEasingTest extends Sprite 
{
	public function RotationEasingTest() 
	{
		this.addEventListener(Event.ENTER_FRAME, loop);
	}
	
	private function loop(event:Event):void 
	{
		mc.rotation += RotationEasing.rotate(mc.rotation, mc.x, mc.y, mouseX, mouseY);
	}
}
}