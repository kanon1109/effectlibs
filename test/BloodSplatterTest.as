package  
{
import cn.geckos.effect.BloodSplatter;
import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Keyboard;
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
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHander);
	}
	
	private function onKeyDownHander(event:KeyboardEvent):void 
	{
		if (event.keyCode == Keyboard.R)
		{
			this.bloodSplatter.clear();
		}
	}
	
	private function mouseDownHandler(event:MouseEvent):void 
	{
		this.bloodSplatter.doSplatter(mouseX, mouseY);
	}
}
}