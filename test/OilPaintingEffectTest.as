package  
{
import cn.geckos.effect.OilPaintingEffect;
import flash.display.Sprite;
import flash.events.MouseEvent;
/**
 * ...油画效果测试
 * @author Kanon
 */
public class OilPaintingEffectTest extends Sprite 
{
    private var oilPaintingEffect:OilPaintingEffect;
    private var isDown:Boolean;
    public function OilPaintingEffectTest() 
    {
        this.oilPaintingEffect = new OilPaintingEffect(this.graphics, 0);
        stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
    }
    
    private function mouseUpHandler(event:MouseEvent):void 
    {
        this.isDown = false;
    }
    
    private function mouseMoveHandler(event:MouseEvent):void 
    {
        if (this.isDown)
            this.oilPaintingEffect.paintMove(mouseX, mouseY);
    }
    
    private function mouseDownHandler(event:MouseEvent):void 
    {
        this.isDown = true;
        this.oilPaintingEffect.color = Math.random() * 0xFFFFFF;
        this.oilPaintingEffect.clear();
    }
    
}
}