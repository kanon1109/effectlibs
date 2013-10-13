package cn.geckos.effect 
{
import flash.display.CapsStyle;
import flash.display.Graphics;
import flash.display.LineScaleMode;
import flash.geom.ColorTransform;
/**
 * ...绘制2叉树
 * @author Kanon
 */
public class Tree 
{
	/**
	 * 绘制方法
	 * @param	graphics	绘制的图像
	 * @param	startX		树的根节点x坐标
	 * @param	startY		树的根节点y坐标
	 * @param	length		树干的长度
	 * @param	angle		树干的倾斜角度
	 * @param	depth		树的茂密度
	 * @param	branchWidth	树干的宽度
	 */
	public static function draw(graphics:Graphics, 
								startX:Number, startY:Number, 
								length:Number, angle:Number, 
								depth:int, branchWidth:Number):void
	{
		//最大分支数
		var maxBranch:int = 3;
		var maxAngle:Number = Math.PI * .5;
		//结束点的位置根据角度来倾斜
		var endX:Number = startX + length * Math.cos(angle);
		var endY:Number = startY + length * Math.sin(angle);
		var colorTf:ColorTransform = new ColorTransform();
		//根据深度显示颜色
		if (depth > 2)
		{
			colorTf.redOffset = (Math.random() * 64) + 64;
			colorTf.greenOffset = 50;
			colorTf.blueOffset = 25;
		}
		else colorTf.greenOffset = (Math.random() * 64) + 128;
		graphics.lineStyle(branchWidth, colorTf.color, 1, true, 
						   LineScaleMode.NORMAL, CapsStyle.ROUND); 
		graphics.moveTo(startX, startY);
		graphics.lineTo(endX, endY);
		var newDepth:int = depth - 1;
		if (newDepth == 0) return;
		var subBranches:int = Math.random() * (maxBranch - 1) + 1;
		//树干宽度缩小
		branchWidth *= .7;
		for (var i:int = 0; i <= subBranches; i += 1)
		{
			//新角度从一个范围中随机
			var newAngle:Number = angle + Math.random() * maxAngle - maxAngle * 0.5;
			var newLength:Number = length * (0.7 + Math.random() * 0.3);
			Tree.draw(graphics, endX, endY, newLength, newAngle, newDepth, branchWidth);
		}
	}
}
}