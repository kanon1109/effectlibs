package  
{
import cn.geckos.effect.Tree;
import flash.display.Sprite;

/**
 * ...2叉树绘制测试
 * @author Kanon
 */
public class TreeTest extends Sprite 
{
	
	public function TreeTest() 
	{
		Tree.draw(this.graphics, 275, 400, 60, -Math.PI / 2, 12, 12);
	}
	
}
}