package  
{
import cn.geckos.effect.FisheyeListEffect;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.utils.getDefinitionByName;
import net.hires.debug.Stats;
/**
 * ...测试
 * @author Kanon
 */
public class FisheyeListEffectTest extends Sprite 
{
	private var fisheyeListEffect:FisheyeListEffect;
	private var resources:Vector.<DisplayObject>;
	public function FisheyeListEffectTest() 
	{
		this.addChild(new Stats());
		this.resources = new Vector.<DisplayObject>();
		var mc:Sprite;
		var MyClass:Class;
		for (var i:int = 0; i < 5; i += 1)
		{
			MyClass = getDefinitionByName("mc" + i) as Class;
			mc = new MyClass() as Sprite;
			this.addChild(mc);
			this.resources.push(mc);
		}
		this.fisheyeListEffect = new FisheyeListEffect(stage, resources, 
											100, 300, 
											700, -80, 
											.3, 1, 
											FisheyeListEffect.HORIZONTAL);
		this.fisheyeListEffect.showBlur = true;
		this.fisheyeListEffect.showAlpha = true;
		this.fisheyeListEffect.isLoop = true;
		
		this.fisheyeListEffect.autoScroll(-1);
        this.initEvent();
	}
	
	/**
	 * 初始化
	 */
	private function initEvent():void
	{
		this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
		this.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDonwHandler);
		this.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		this.stage.addEventListener(Event.ENTER_FRAME, loop);
	}
	
	private function mouseUpHandler(event:MouseEvent):void 
	{
		//this.fisheyeListEffect.mouseUp();
	}
	
	private function mouseDonwHandler(event:MouseEvent):void 
	{
		if (event.target is Sprite)
		{	
			var mc:Sprite = event.target as Sprite;
			var index:int = this.resources.indexOf(mc);
			this.fisheyeListEffect.scrollByIndex(index);
		}
		//this.fisheyeListEffect.mouseDown();
	}
	
	private function loop(event:Event):void 
	{
		this.fisheyeListEffect.render();
	}
    
    private function onKeyDownHandler(event:KeyboardEvent):void 
    {
        //this.fisheyeListEffect.setPosByIndex(1);
        trace(this.fisheyeListEffect.getCurPosIndex());
    }
	
}
}