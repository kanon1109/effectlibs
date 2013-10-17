package cn.geckos.effect 
{
import flash.display.Graphics;
import flash.geom.Point;
/**
 * ...绳子效果
 * 参考 makc3d's The rope
 * @author Kanon
 */
public class Rope 
{
    //其实位置
    private var sp:Point;
    private var ep:Point;
    //2个中心点的坐标 用于双重贝塞尔曲线
    private var c1:Point;
    private var c2:Point;
    //2个点的速度
    private var v1:Point;
    private var v2:Point;
    //绳子的长度（下垂的幅度）
    private var h:Number;
    public function Rope(sp:Point, ep:Point, h:Number = 150) 
    {
        this.sp = sp;
        this.ep = ep;
        this.h = h;
    }
    
    /**
     * 更新数据
     */
    public function update():void
    {
        var dis:Number = Point.distance(this.sp, this.ep);
        //.25和.75 修正绳子下垂后的弧度，.5 控制拉伸后的弧度
        var cx1:Number = this.sp.x + (this.ep.x - this.sp.x) * .25;
        var cy1:Number = this.sp.y + (this.ep.y - this.sp.y) * .25 + 4 * this.h * Math.exp( -.5 * dis / this.h) / 3;
        var cx2:Number = this.sp.x + (this.ep.x - this.sp.x) * .75;
        var cy2:Number = this.sp.y + (this.ep.y - this.sp.y) * .75 + 4 * this.h * Math.exp( -.5 * dis / this.h) / 3;
        
        if (this.c1)
        {
            var cvx1:Number = cx1 - this.c1.x;
            var cvy1:Number = cy1 - this.c1.y;
            //缓动公式 .95和.9控制绳子下垂后摆动的速度
            this.v1.x = .95 * (.9 * this.v1.x + .1 * cvx1);
            this.v1.y = .95 * (.9 * this.v1.y + .1 * cvy1);
            this.c1.x += this.v1.x;
            this.c1.y += this.v1.y;
            
            var cvx2:Number = cx2 - this.c2.x;
            var cvy2:Number = cy2 - this.c2.y;
            //缓动公式 
            this.v2.x = .95 * (.9 * this.v2.x + .1 * cvx2);
            this.v2.y = .95 * (.9 * this.v2.y + .1 * cvy2);
            this.c2.x += this.v2.x;
            this.c2.y += this.v2.y;
        }
        else
        {
            this.c1 = new Point(cx1, cy1);
            this.c2 = new Point(cx2, cy2);
            this.v1 = new Point();
            this.v2 = new Point();
        }
    }
    
    /**
     * 渲染绘制
     * @param	graphics    绘制的图形
     * @param	thickness   线宽
     * @param	color       颜色
     */
    public function render(graphics:Graphics, thickness:Number, color:uint):void
    {
        graphics.clear();
        graphics.lineStyle(thickness, color);
        graphics.moveTo(this.sp.x, this.sp.y);
        graphics.cubicCurveTo(this.c1.x, this.c1.y, 
                              this.c2.x, this.c2.y, 
                              this.ep.x, this.ep.y);
    }
}
}