package cn.geckos.effect 
{
import flash.display.Graphics;
import flash.geom.Point;
/**
 * ...书法效果
 * 参考 akm2's "Shodou" http://jsdo.it/akm2/9ClT js版的书道
 * @author Kanon
 */
public class CalligraphyEffect 
{
    //画布
    private var graphics:Graphics;
    //画笔颜色
    private var color:uint;
    //默认笔触尺寸
    private var defaultBrushSize:int;
    //最大笔触尺寸
    private var maxBrushSize:int;
    //最小笔触尺寸
    private var minBrushSize:int;
    //墨量
    private var inkAmount:Number;
    //写字时飞溅的墨汁的范围
    private var splashRange:Number;
    //飞沫最大尺寸
    private var splashInkSize:Number;
    //毛笔的毛量数组
    private var hairsVect:Vector.<Hair>;
    //最新的坐标
    private var latestPoint:Point;
    //当下坐标
    private var curPoint:Point;
    //画笔新的位置和上一次位置的距离
    private var latestStrokeLength:Number;
    //飞溅需要的距离
    private static const SPLASH_DIS:int = 75;
    public function CalligraphyEffect(graphics:Graphics, 
                                      color:uint = 0,
                                      defaultBrushSize:int = 25, 
                                      maxBrushSize:int = 35, 
                                      minBrushSize:int = 5,
                                      inkAmount:Number = 6, 
                                      splashRange:Number = 75,
                                      splashInkSize:Number = 5)
    {
        this.graphics = graphics;
        this.color = color;
        this.defaultBrushSize = defaultBrushSize;
        this.maxBrushSize = maxBrushSize;
        this.minBrushSize = minBrushSize;
        this.inkAmount = inkAmount;
        this.splashRange = splashRange;
        this.splashInkSize = splashInkSize;
        this.latestStrokeLength = 0;
        this.latestPoint = new Point();
        this.curPoint = new Point();
        this.resetTip();
    }
    
    /**
     * 重置笔刷末梢
     */
    private function resetTip():void
    {
        this.hairsVect = new Vector.<Hair>();
        var hairNum:int = this.defaultBrushSize * 2;
        var range:Number = this.defaultBrushSize / 2;
        var rx:Number;
        var ry:Number; 
        var c0:Number; 
        var x0:Number; 
        var y0:Number;
        var cv:Number; 
        var sv:Number; 
        var x:Number;
        var y:Number;
        var c:Number = this.random(Math.PI * 2);
        var hair:Hair;
        var pos:Point;
        trace("hairNum", hairNum);
        for (var i:int = 0; i < hairNum; i += 1) 
        {
            rx = this.random(range);
            ry = rx / 2;
            c0 = this.random(Math.PI * 2);
            x0 = rx * Math.sin(c0);
            y0 = ry * Math.cos(c0);
            cv = Math.cos(c);
            sv = Math.sin(c);
            pos = new Point(this.latestPoint.x + x0 * cv - y0 * sv, 
                            this.latestPoint.y + x0 * sv + y0 * cv);
            hair = new Hair(pos, 5, this.inkAmount);
            this.hairsVect.push(hair);
        }
    }
    
    /**
     * 飞溅墨汁
     * @param	range       飞溅范围
     * @param	maxSize     最大尺寸
     */
    private function splash(range:Number, maxSize:Number):void
    {
        //点的数量
        var num:int = this.random(12, 0);
        //范围半径的角度
        var c:Number; 
        //范围半径
        var r:Number;
        //点的坐标
        var x:Number; 
        var y:Number;
        for (var i:int = 0; i < num; i++) 
        {
            r = this.random(range, 1);
            c = this.random(Math.PI * 2);
            x = this.latestPoint.x + r * Math.sin(c);
            y = this.latestPoint.y + r * Math.cos(c);
            this.drawDot(x, y, this.random(maxSize, 0), Math.random());
        }
    }
    
    /**
     * 画墨点
     * @param	x       墨点的x位置
     * @param	y       墨点的y位置
     * @param	radius  墨点的半径
     * @param	alpha   墨点的透明度
     */
    private function drawDot(x:Number, y:Number, radius:Number, alpha:Number):void
    {
        this.graphics.lineStyle(0, 0, 0);
        this.graphics.beginFill(this.color, alpha);
        this.graphics.drawCircle(x, y, radius);
        this.graphics.endFill();
    }
	
	/**
	 * 按下笔触
	 */
	public function onBrushDown():void
	{
		this.resetTip();
		this.splash(this.splashRange, this.splashInkSize);
	}
    
    /**
     * 更新画笔数据
     * @param	posX    当前x坐标
     * @param	posY    当前y坐标
     */
    public function update(posX:Number, posY:Number):void
    {
        this.latestPoint.x = this.curPoint.x;
        this.latestPoint.y = this.curPoint.y;
        this.curPoint.x = posX;
        this.curPoint.y = posY;
        var stroke:Point = this.curPoint.subtract(this.latestPoint);
        var length:int = this.hairsVect.length;
        for (var i:int = 0; i < length; i += 1)
        {
            this.hairsVect[i].update(stroke);
        }
        this.latestStrokeLength = stroke.length;
    }
    
    /**`
     * 绘制
     */
    public function draw():void
    {
        var length:int = this.hairsVect.length;
        for (var i:int = 0; i < length; i += 1)
        {
            this.hairsVect[i].draw(this.graphics, this.color);
        }
        //如果瞬间距离超过一定长度则出现飞溅的效果
        if (this.latestStrokeLength > SPLASH_DIS)
            this.splash(this.splashRange, this.splashInkSize);
    }
    
    /**
     * 返回某个范围内的随机数
     * @param	max     最大范围
     * @param	min     最小范围
     * @return  随机数
     */
    private function random(max:Number, min:Number = 0):Number
    {
        return Math.random() * (max - min) + min;
    }
}
}
import flash.display.CapsStyle;
import flash.display.Graphics;
import flash.display.LineScaleMode;
import flash.geom.Point;
class Hair
{
    //默认线宽度
    private var lineWidth:Number;
    //当前线宽
    private var currentLineWidth:Number;
    //墨量
    private var inkAmount:Number;
    //最新的坐标
    private var latestPoint:Point;
    //当下坐标
    private var curPos:Point;
    public function Hair(curPos:Point, lineWidth:Number, inkAmount:Number)
    {
        this.lineWidth = lineWidth;
        this.inkAmount = inkAmount;
        this.curPos = curPos;
        this.latestPoint = this.curPos.clone();
    }
    
    /**
     * 更新数据
     * @param	stroke   上一次坐标和当前坐标相减后的坐标
     */
    public function update(stroke:Point):void
    {
        this.latestPoint.x = this.curPos.x;
        this.latestPoint.y = this.curPos.y;
        this.curPos.offset(stroke.x, stroke.y);
        var per:Number = this.clamp(this.inkAmount / stroke.length, 1, 0);
        this.currentLineWidth = this.lineWidth * per;
    }
    
    /**
     * 绘制
     * @param	graphics    画布
     * @param	color       笔触颜色
     */
    public function draw(graphics:Graphics, color:uint):void
    {
        this.drawLine(graphics, this.latestPoint, this.curPos, color, this.currentLineWidth, 1, CapsStyle.ROUND);
        //污点
        var dist:Number = Point.distance(this.curPos, this.latestPoint);
        var alpha:Number = this.clamp((1 - dist / this.inkAmount) * 0.3, 0.3, 0);
        this.drawLine(graphics, this.latestPoint, this.curPos, color, this.currentLineWidth + 5 , alpha, CapsStyle.SQUARE);
    }
    
    /**
     * 绘制一条线
     * @param	graphics        画布
     * @param	p1              线条起始坐标
     * @param	p2              线条结束坐标
     * @param	color           线条颜色
     * @param	lineWidth       线宽度
     * @param	alpha           线的透明度
     * @param	caps            线头部样式
     */
    private function drawLine(graphics:Graphics, p1:Point, p2:Point, 
                              color:uint, lineWidth:Number, alpha:Number, caps:String):void
    {
        graphics.lineStyle(lineWidth, color, alpha, false, LineScaleMode.NORMAL, caps);
        graphics.moveTo(p1.x, p1.y);
        graphics.lineTo(p2.x, p2.y);
    }
    
    /**
     * 根据传入的值判断如果超过界限则等于界限值
     * @param	n       传入的数字
     * @param	max     最大值
     * @param	min     最小值
     * @return  计算后的值
     */
    private function clamp(n:Number, max:Number, min:Number):Number
    {
        return n > max ? max : n < min ? min : n;
    }
}
