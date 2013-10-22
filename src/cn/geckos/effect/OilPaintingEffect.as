package cn.geckos.effect 
{
import flash.display.CapsStyle;
import flash.display.Graphics;
import flash.display.LineScaleMode;
import flash.display.Stage;
/**
 * ...油画效果
 * @author Kanon
 */
public class OilPaintingEffect 
{
    private var prevX:int;
    private var prevY:int;
    private var startPosX:int;
    private var startPosY:int;
    //笔触颜色
    private var color:uint;
    //图形
    private var graphics:Graphics;
    public function OilPaintingEffect(stage:Stage, graphics:Graphics, color:uint = 0) 
    {
        this.stage = stage;
        this.graphics = graphics;
        this.color = color;
    }
    
    /**
     * 移动笔触
     */
    private function paintMove():void
    {
        var distance:Number = Math.sqrt(Math.pow(this.prevX - this.startPosX, 2) + Math.pow(this.prevY - this.startPosY, 2));
        var a:Number = distance * 10 * (Math.pow(Math.random(), 2) - 0.5);
        var r:Number = Math.random() - 0.5;
        //根据距离移动速度显示笔触大小
        var size:Number = Math.random() * 15 / distance;
        var disX:Number = (this.prevX - this.startPosX) * Math.sin(0.5) + this.startPosX;
        var disY:Number = (this.prevY - this.startPosY) * Math.cos(0.5) + this.startPosY;
        this.startPosX = this.prevX;
        this.startPosY = this.prevY;
        this.prevX = this.stage.mouseX;
        this.prevY = this.stage.mouseY;
        
        this.graphics.moveTo(this.startPosX, this.startPosY);
        this.graphics.curveTo(disX, disY, this.prevX, this.prevY);
        this.graphics.lineStyle(((Math.random() + 20 / 10 - 0.5) * size + (1 - Math.random() + 30 / 20 - 0.5) * size), 
                                  this.color, 1, false, LineScaleMode.NONE, CapsStyle.ROUND);   
        this.graphics.moveTo(this.startPosX + a, this.startPosY + a);
        this.graphics.lineTo(this.startPosX + r + a, this.startPosY + r + a);
        this.graphics.endFill();
    }
    
    /**
     * 清除
     */
    public function clear():void
    {
        this.graphics.clear();
    }
}
}