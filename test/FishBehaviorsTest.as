package  
{
import cn.geckos.FishBehaviors;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
/**
 * ...鱼类行为测试
 * @author 
 */
public class FishBehaviorsTest extends Sprite 
{
	private var fishBehaviors:FishBehaviors;
	public function FishBehaviorsTest() 
	{
		this.fishBehaviors = new FishBehaviors();
		for (var i:int = 0; i < 30; i++) 
		{
			var fishMc:Sprite = new Fish();
			fishMc.x = Math.random() * stage.stageWidth;
			fishMc.y = Math.random() * stage.stageHeight;
			this.addChild(fishMc);
			this.fishBehaviors.addFish(fishMc);
		}
		this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}
	
	private function enterFrameHandler(event:Event):void 
	{
		this.fishBehaviors.roving(new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
	}
}
}