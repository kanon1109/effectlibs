package  
{
import cn.geckos.effect.BeeBehavior;
import flash.display.Sprite;
import flash.events.MouseEvent;

/**
 * ...
 * @author 
 */
public class BeeBehaviorTest extends Sprite 
{
	private var beeBehavior:BeeBehavior;
	private var isPause:Boolean;
	public function BeeBehaviorTest() 
	{
		this.beeBehavior = new BeeBehavior();
		for (var i:int = 0; i < 20; i++) 
		{
			var bee:Bee = new Bee();
			bee.x = Math.random() * (stage.stageWidth - 100) + 100;
			bee.y = Math.random() * (stage.stageHeight - 100) + 100;
			this.beeBehavior.addBee(bee);
			this.addChild(bee);
		}
		this.beeBehavior.start();
		
		stage.addEventListener(MouseEvent.CLICK, clickHandler);
	}
	
	private function clickHandler(event:MouseEvent):void 
	{
		isPause = !isPause;
		if (isPause)
			this.beeBehavior.pause();
		else
			this.beeBehavior.start();
	}
	
}
}