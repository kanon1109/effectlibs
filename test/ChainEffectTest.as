package  
{
import cn.geckos.effect.ChainEffect;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;

/**
 * ...链效果测试
 * @author Kanon
 */
public class ChainEffectTest extends Sprite 
{
	private var chainEffect:ChainEffect;
	private var angle:Number;
	private var targetPoint:Point;
	private var r:Number;
	public function ChainEffectTest() 
	{
		this.chainEffect = new ChainEffect(this);
		this.chainEffect.chainLength = 4;
		this.chainEffect.move(mouseX, mouseY);
		/*this.angle = 0;
		this.r = 50 + Math.random() * 50;
		this.targetPoint = new Point(Math.random() * stage.width, Math.random() * stage.height);
		var timer:Timer = new Timer(Math.random() * 500, 1);
		timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerHandler);
		timer.start();*/
		this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
	}
	
	private function keyDownHandler(event:KeyboardEvent):void 
	{
		trace("asdasd")
		this.chainEffect.clear();
	}
	
	private function timerHandler(event:TimerEvent):void 
	{
		var timer:Timer = event.currentTarget as Timer;
		timer.stop();
		timer.reset();
		timer.delay = Math.random() * 500;
		timer.repeatCount = 1;
		timer.start();
		this.r = 50 + Math.random() * 50;
		this.targetPoint = new Point(Math.random() * stage.width, Math.random() * stage.height);
	}
	
	private function enterFrameHandler(event:Event):void 
	{
		/*var x:Number = Math.cos(this.angle) * this.r + this.targetPoint.x;
		var y:Number = Math.sin(this.angle) * this.r + this.targetPoint.y;
		this.chainEffect.render(x, y);
		this.angle += .5;*/
		this.chainEffect.render(mouseX, mouseY, .5);
	}
	
}
}