package  
{
import cn.geckos.effect.TextEffect;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
/**
 * ...
 * @author Kanon
 */
public class TextEffectTest extends Sprite 
{
	private var textEffect:TextEffect;
	private var text:TextField;
	public function TextEffectTest() 
	{
		this.text = this.getChildByName("txt") as TextField;
		this.textEffect = new TextEffect();
		this.textEffect.progressShow(this.text, "asdasdasdqe12sdqwasd啊吴涤清我的阿斯达阿斯顿请问阿斯达", 10);
		stage.addEventListener(MouseEvent.CLICK, stageClickHandler);
	}
	
	private function stageClickHandler(event:MouseEvent):void 
	{
		this.textEffect.destroy();
	}
	
}
}