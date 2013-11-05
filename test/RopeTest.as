package  
{
import cn.geckos.effect.Rope;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
/**
 * ...绳子效果
 * @author Kanon
 */
public class RopeTest extends Sprite 
{
    private var rope:Rope;
    private var sp:Point;
    private var ep:Point;
    private var curMc:Sprite;
    public function RopeTest() 
    {
        this.sp = new Point(mc1.x, mc1.y);
        this.ep = new Point(mc2.x, mc2.y);
        this.rope = new Rope(this.sp, this.ep);
        this.addEventListener(Event.ENTER_FRAME, loop);
        mc1.addEventListener(MouseEvent.MOUSE_DOWN, mcMouseDown);
        mc2.addEventListener(MouseEvent.MOUSE_DOWN, mcMouseDown);
        stage.addEventListener(MouseEvent.MOUSE_UP, mcMouseUp);
    }
    
    private function mcMouseUp(event:MouseEvent):void 
    {
        this.curMc.stopDrag();
    }
    
    private function mcMouseDown(event:MouseEvent):void 
    {
        var mc:Sprite = event.currentTarget as Sprite;
        mc.startDrag();
        this.curMc = mc;
    }
    
    private function loop(event:Event):void 
    {
        this.sp.x = mc1.x;
        this.sp.y = mc1.y;
        this.ep.x = mc2.x;
        this.ep.y = mc2.y;
        this.rope.update();
        this.rope.render(this.graphics, 3, 0x00F0FF);
    }
    
}
}