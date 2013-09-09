package  
{
import cn.geckos.effect.FisheyeListEffect;
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;
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
		var mc:Sprite
		for (var i:int = 1; i <= 1000; i += 1)
		{
			mc = new Mc();
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
	}
	
}
}