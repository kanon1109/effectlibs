package  
{
import cn.geckos.effect.BlackHoleEffect;
import cn.geckos.event.BlackHoleEvent;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
/**
 * ...黑洞测试
 * @author Kanon
 */
public class BlackHoleEffectTest extends Sprite 
{
	private var blackHole:BlackHoleEffect;
	private var ary:Array;
	private var holeList:Array;
	public function BlackHoleEffectTest() 
	{
		this.ary = [];
		this.holeList = [];
		var sp:Sprite;
		for (var i:int = 1; this.getChildByName("mc" + i); i++) 
		{
			sp = this.getChildByName("mc" + i) as Sprite;
			ary.push(sp);
		}
		
		this.addEventListener(Event.ENTER_FRAME, loop);
		stage.addEventListener(MouseEvent.CLICK, mouseClickHandler);
	}
	
	private function mouseClickHandler(event:MouseEvent):void 
	{
		var blackHole:BlackHoleEffect = new BlackHoleEffect();
		blackHole.addEventListener(BlackHoleEvent.IN_HOLE, inHoleHandler);
		blackHole.addEventListener(BlackHoleEvent.OVER, blackHoleOverHandler);
		blackHole.addEventListener(BlackHoleEvent.ATTENUATION, attenuationHandler);
		blackHole.addSubstanceList(ary);
		blackHole.addHole(mouseX, mouseY);
		this.holeList.push(blackHole);
		var spt:Sprite = new Sprite();
		blackHole.setDebugContainer(spt);
		this.addChild(spt);
	}
	
	private function attenuationHandler(event:BlackHoleEvent):void 
	{
		//这里可以将黑洞的显示效果慢慢缩小。
	}
	
	private function blackHoleOverHandler(event:BlackHoleEvent):void 
	{
		//黑洞完全消失，可以将黑洞显示对象删除
		var blackHole:BlackHoleEffect = event.currentTarget as BlackHoleEffect;
		blackHole.destroy();
		var length:int = this.holeList.length;
		for (var i:int = length - 1; i >= 0; i--) 
		{
			var bh:BlackHoleEffect = this.holeList[i];
			if (bh == blackHole)
			{
				this.holeList.splice(i, 1);
			}
		}
	}
	
	private function inHoleHandler(event:BlackHoleEvent):void 
	{
		var dObj:DisplayObject = event.dObj;
		if (dObj.parent) dObj.parent.removeChild(dObj);
	}
	
	private function loop(event:Event):void 
	{
		var length:int = this.holeList.length;
		for (var i:int = length - 1; i >= 0; i--) 
		{
			var blackHole:BlackHoleEffect = this.holeList[i];
			blackHole.update();
			blackHole.debug();
		}
	}
	
}
}