package  
{
import cn.geckos.effect.FlameGunEffect;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import net.hires.debug.Stats;
/**
 * ...火焰弹效果测试
 * @author Kanon
 */
public class FlameGunEffectTest extends Sprite 
{
	private var fge:FlameGunEffect;
	private var pMc:Sprite;
	public function FlameGunEffectTest() 
	{
		this.addChild(new Stats());
		this.pMc = this.getChildByName("p_mc") as Sprite;
		this.fge = new FlameGunEffect(this, "FlameMc", 250, 400, 10, -90, 2, .1, 300);
		stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		this.addEventListener(Event.ENTER_FRAME, loop);
	}
	
	private function mouseUpHandler(event:MouseEvent):void 
	{
		this.pMc.stopDrag();
		this.fge.status = FlameGunEffect.STOP;
	}
	
	private function mouseDownHandler(event:MouseEvent):void 
	{
		var target:DisplayObject = event.target as DisplayObject;
		if(target == this.pMc) this.pMc.startDrag();
		else this.fge.status = FlameGunEffect.FIRE;
	}
	
	private function loop(event:Event):void 
	{
		var rad:Number = Math.atan2(mouseY - this.fge.startY, mouseX - this.fge.startX);
		this.fge.rotation = rad / Math.PI * 180;
		this.fge.move(this.pMc.x, this.pMc.y);
		this.fge.update();
	}
}
}