package  
{
import cn.geckos.effect.BlackHoleEffect;
import cn.geckos.event.BlackHoleEvent;
import com.greensock.TweenMax;
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.getDefinitionByName;
import net.hires.debug.Stats;
/**
 * ...黑洞测试
 * @author Kanon
 */
public class BlackHoleEffectTest extends Sprite 
{
	private var blackHole:BlackHoleEffect;
	private var ary:Array;
	private var holeList:Array;
	private var holeSpt:Sprite;
	private var btnSpt:Sprite;
	private var mcSpt:Sprite;
	public function BlackHoleEffectTest() 
	{
		this.ary = [];
		this.holeList = [];
		this.holeSpt = new Sprite();
		this.addChild(this.holeSpt);
		this.mcSpt = new Sprite();
		this.addChild(this.mcSpt);
		this.addChild(btn);
		
		this.addChild(new Stats());
		
		this.addEventListener(Event.ENTER_FRAME, loop);
		stage.addEventListener(MouseEvent.CLICK, mouseClickHandler);
		btn.addEventListener(MouseEvent.CLICK, btnClickHandler);
		this.addObj();
	}
	
	private function btnClickHandler(event:MouseEvent):void 
	{
		event.stopPropagation();
		this.addObj();
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
		
		var bhMc:MovieClip = new BlackHole();
		bhMc.x = mouseX;
		bhMc.y = mouseY;
		bhMc.scaleX = 0;
		bhMc.scaleY = 0;
		this.holeSpt.addChild(bhMc);
		blackHole.useData = bhMc;
		TweenMax.to(bhMc, .2, { scaleX:1, scaleY:1 } );
		TweenMax.to(bhMc, 4, { rotation:360, repeat: -1 } );
	}
	
	private function attenuationHandler(event:BlackHoleEvent):void 
	{
		//这里可以将黑洞的显示效果慢慢缩小。
		var blackHole:BlackHoleEffect = event.currentTarget as BlackHoleEffect;
		var bhMc:MovieClip = blackHole.useData as MovieClip;
		TweenMax.to(bhMc, 2, { scaleX:0, scaleY:0 } );
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
				var bhMc:MovieClip = bh.useData as MovieClip;
				bh.useData = null;
				if (bhMc && bhMc.parent)
					bhMc.parent.removeChild(bhMc);
				break;
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
		}
	}
	
	private function addObj():void
	{
		var num:int = randnum(10, 20);
		for (var i:int = 1; i <= num; i++) 
		{
			var index:int = randnum(1, 4);
			var myClass:Class = getDefinitionByName("mc" + index) as Class;
			var sp:Sprite = new myClass();
			sp.x = randnum(0, stage.stageWidth);
			sp.y = randnum(0, stage.stageHeight);
			this.ary.push(sp);
			mcSpt.addChild(sp);
		}
	}
	
	public function randnum(a:Number, b:Number):Number
    {
        return Math.random() * (b - a) + a;
    }
}
}