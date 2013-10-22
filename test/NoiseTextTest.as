package  
{
import cn.geckos.effect.NoiseText;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
/**
 * ...噪点文本测试
 * @author Kanon
 */
public class NoiseTextTest extends Sprite 
{
    private var t:TextField;
    private var noiseText:NoiseText;
    private var isPause:Boolean;
    public function NoiseTextTest() 
    {
        var textFt:TextFormat = new TextFormat();
        textFt.size = 40;
        this.t = new TextField();
        this.t.width = 200;
        this.t.height = 80;
        this.t.autoSize = TextFieldAutoSize.LEFT;
        this.t.text = "很恐怖";
        this.t.x = (this.stage.stageWidth - this.t.width) * .5;
        this.t.y = (this.stage.stageHeight - this.t.height) * .5;
        this.t.setTextFormat(textFt);
        
        this.noiseText = new NoiseText(this.stage.stageWidth, this.stage.stageHeight, this.t);
        this.addChild(this.noiseText);
        this.noiseText.show();
        
        stage.addEventListener(MouseEvent.CLICK, clickHandler);
    }
    
    private function clickHandler(event:MouseEvent):void 
    {
        this.isPause = !this.isPause;
        if (this.isPause) this.noiseText.pause();
        else this.noiseText.show();
        /*this.noiseText.remove();
        this.noiseText.init(this.t);
        this.noiseText.show();*/
    }
    
}
}