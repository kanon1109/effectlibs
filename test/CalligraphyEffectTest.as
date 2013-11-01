package  
{
import cn.geckos.effect.CalligraphyEffect;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
/**
 * ...毛笔效果测试
 * @author Kanon
 */
public class CalligraphyEffectTest extends Sprite 
{
	private var isDown:Boolean;
	private var calligraphyEffect:CalligraphyEffect
	public function CalligraphyEffectTest() 
	{
		this.calligraphyEffect = new CalligraphyEffect(this.graphics, 0);
		stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
        stage.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
        this.addEventListener(Event.ENTER_FRAME, loop);
	}
    
    private function doubleClickHandler(event:MouseEvent):void 
    {
        this.graphics.clear();
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
        this.isDown = true;
		this.calligraphyEffect.onBrushDown();
    }
}
}