package  
{
import cn.geckos.effect.CalligraphyEffect;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import net.hires.debug.Stats;
/**
 * ...毛笔效果测试
 * @author Kanon
 */
public class CalligraphyEffectTest extends Sprite 
{
	private var isDown:Boolean;
	private var calligraphyEffect:CalligraphyEffect;
	public function CalligraphyEffectTest() 
	{
		//this.calligraphyEffect = new CalligraphyEffect(this.graphics, 0);
        stage.doubleClickEnabled = true;
		this.calligraphyEffect = new CalligraphyEffect(this, 550, 400);
		stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
        stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        stage.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
        //this.addEventListener(Event.ENTER_FRAME, loop);
		this.addChild(new Stats());
	}
	
	private function mouseMoveHandler(event:MouseEvent):void 
	{
		this.calligraphyEffect.update(mouseX, mouseY);
        if (this.isDown)
			this.calligraphyEffect.draw();
	}
    
    private function doubleClickHandler(event:MouseEvent):void 
    {
        this.calligraphyEffect.clear();
    }
    
    private function loop(event:Event):void 
    {
        this.calligraphyEffect.update(mouseX, mouseY);
        if (this.isDown)
			this.calligraphyEffect.draw();
    }
	
	private function mouseUpHandler(event:MouseEvent):void 
    {
        this.isDown = false;
    }
    
    private function mouseDownHandler(event:MouseEvent):void 
    {
		//this.calligraphyEffect.clear();
        this.isDown = true;
		this.calligraphyEffect.onBrushDown();
    }
}
}