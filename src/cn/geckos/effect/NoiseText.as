package cn.geckos.effect 
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BitmapDataChannel;
import flash.display.GradientType;
import flash.display.Sprite;
import flash.events.Event;
import flash.filters.BlurFilter;
import flash.filters.DisplacementMapFilter;
import flash.filters.DisplacementMapFilterMode;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.text.TextField;
/**
 * ...文本噪动效果
 * @author Kanon
 */
public class NoiseText extends Sprite
{
    //高宽
    private var w:Number;
    private var h:Number;
    //需要躁动的文本
    private var tf:TextField;
    //文本的matrix
    private var tfMatrix:Matrix;
    //背景位图数据
    private var backBmpData:BitmapData;
    //背景位图
    private var backbmp:Bitmap;
    //背景遮罩
    private var backMask:Sprite;
    //用于显示文字的画布位图数据
    private var canvasBmpData:BitmapData;
    //文字阴影位图数据
    private var shadowBmpData:BitmapData;
    //噪点位图数据
    private var perlinBmpData:BitmapData;
    //是否被初始化过
    private var inited:Boolean;
    public function NoiseText(w:Number, h:Number, tf:TextField) 
    {
        this.w = w;
        this.h = h;
        this.init(tf);
    }
    
    /**
     * 显示
     */
    public function init(tf:TextField):void
    {
        if (this.inited) return;
        this.tf = tf;
        this.perlinBmpData = new BitmapData(this.w, this.h, true, 0);
        //----初期化背景----
        var matrix:Matrix = new Matrix();
        matrix.createGradientBox(this.w, this.h, Math.PI / 2, 0, 0);
        
        //背景位图的遮罩，作为backbmp的遮罩使其颜色变成graphics的填充色
        this.backMask = new Sprite();
        this.backMask.cacheAsBitmap = true;
        //产生中间白色渐变过度到上下的颜色填充
        this.backMask.graphics.beginGradientFill(GradientType.LINEAR, 
                                                 [0, 0, 0],
                                                 [0.5, 0.1, 0.5],
                                                 [0, 128, 255],
                                                 matrix);
                                                 
        this.backMask.graphics.drawRect(0, 0, this.w, this.h);
        this.backMask.graphics.endFill();
        
        this.backBmpData = new BitmapData(this.w, this.h, true, 0);
        this.backbmp = new Bitmap(this.backBmpData);
        this.backbmp.cacheAsBitmap = true;
        this.backbmp.mask = this.backMask;
        this.addChild(this.backbmp);
        this.addChild(this.backMask);
        //--------------------
        
        //文字阴影
        this.shadowBmpData = new BitmapData(this.w, this.h, true, 0);
        this.addChild(new Bitmap(this.shadowBmpData));
        
        this.tfMatrix = new Matrix(1, 0, 0, 1, this.w / 2 - this.tf.width / 2, this.h / 2 - this.tf.height / 2);
        //用于显示文字的画布
        this.canvasBmpData = new BitmapData(this.w, this.h, true, 0);
        this.addChild(new Bitmap(this.canvasBmpData));
    }
    
    /**
     * 开始显示
     */
    public function show():void
    {
        if (!this.hasEventListener(Event.ENTER_FRAME))
            this.addEventListener(Event.ENTER_FRAME, loop);
    }
    
    /**
     * 暂停
     */
    public function pause():void
    {
        if (this.hasEventListener(Event.ENTER_FRAME))
            this.removeEventListener(Event.ENTER_FRAME, loop);
    }
    
    private function loop(event:Event):void
    {
        //产生perlin噪点图像
        this.perlinBmpData.perlinNoise(20, 20, 1, Math.random() * 100, true, false,
                                BitmapDataChannel.ALPHA | BitmapDataChannel.RED,
                                false,
                                [0]);
        //文字画布清空
        this.canvasBmpData.fillRect(this.canvasBmpData.rect, 0);
        this.tfMatrix.tx = this.w / 2 - this.tf.width / 2 + (Math.random() * 4 - 2);
        this.tfMatrix.ty = this.h / 2 - this.tf.height / 2 + (Math.random() * 4 - 2);
        this.canvasBmpData.draw(this.tf, this.tfMatrix);
        
        var scale:Number = 5;
        //随机一个数如果为0，则设置perlin噪点到一个较大的值，使文字有忽然跳动的感觉。
        if (int(Math.random() * 30) == 0) scale = 40;
        
        //将噪点滤镜添加进画布中
        this.canvasBmpData.applyFilter(this.canvasBmpData, this.canvasBmpData.rect, new Point(), 
                                        new DisplacementMapFilter(this.perlinBmpData, new Point(),
                                                                    BitmapDataChannel.ALPHA,
                                                                    BitmapDataChannel.RED,
                                                                    scale,
                                                                    scale,
                                                                    DisplacementMapFilterMode.CLAMP,
                                                                    0,
                                                                    0));
                                
        //文字阴影清空
        this.shadowBmpData.fillRect(this.shadowBmpData.rect, 0);
        this.shadowBmpData.draw(this.canvasBmpData, null, new ColorTransform(0, 0, 0, 1, 50, 50, 50, 0));
        this.shadowBmpData.applyFilter(this.shadowBmpData, this.shadowBmpData.rect, new Point(), new BlurFilter(10, 10,3));
        //背景位图产生噪点
        this.backBmpData.noise(Math.random() * 100,  0, 255, 8 | 4 | 2 | 1, true);
    }
    
    /**
     * 销毁
     */
    public function remove():void
    {
        this.pause();
        if (this.backbmp && this.backbmp.parent)
            this.backbmp.parent.removeChild(this.backbmp);
        this.backbmp = null;
        
        if (this.backMask && this.backMask.parent)
            this.backMask.parent.removeChild(this.backMask);
        this.backMask = null;
        
        if (this.canvasBmpData) this.canvasBmpData.dispose();
        if (this.backBmpData) this.backBmpData.dispose();
        if (this.shadowBmpData) this.shadowBmpData.dispose();
        if (this.perlinBmpData) this.perlinBmpData.dispose();
        
        this.tfMatrix = null;
        
        this.canvasBmpData = null;
        this.backBmpData = null;
        this.shadowBmpData = null;
        this.perlinBmpData = null;
        
        this.tf = null;
        
        this.inited = false;
    }
}
}