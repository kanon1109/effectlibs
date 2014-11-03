package  
{
import cn.geckos.effect.BloodSplatter;
import flash.display.Sprite;
import flash.events.MouseEvent;
import net.hires.debug.Stats;
/**
 * ...血花飞溅效果测试
 * @author Kanon
 */
public class BloodSplatterTest extends Sprite 
{
	private var bloodSplatter:BloodSplatter;
	public function BloodSplatterTest() 
	{
		this.addChild(new Stats());
		this.bloodSplatter = new BloodSplatter(this, "BloodMc");
		stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
	}
	
	private function mouseDownHandler(event:MouseEvent):void 
	{
		this.bloodSplatter.doSplatter(mouseX, mouseY);
	}
}
}