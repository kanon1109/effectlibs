package cn.geckos.effect 
{
import flash.display.Sprite;
/**
 * ...僚机的跟随效果
 * @author Kanon
 */
public class WingmanMotionEffect 
{
	//僚机
	private var wingMc:Sprite;
	//僚机速度
	private var vx:Number;
	private var vy:Number;
	public function WingmanMotionEffect(wingMc:Sprite)
	{
		this.wingMc = wingMc;
		this.vx = 0;
		this.vy = 0;
	}
	
	/**
	 * 跟随
	 * @param	targetX		目标位置x
	 * @param	targetY		目标位置y
	 */
	public function follow(targetX:Number, targetY:Number):void
	{
		if (!this.wingMc) return;
		//缓动系数
		var ease:Number = .001;
		//衰减系数
		var decay:Number = .98;
		//阻力
		var resistance:Number = .05;
		//加速度
		var ax:Number = -(this.wingMc.x - targetX) * ease;
		var ay:Number = -(this.wingMc.y - targetY) * ease;
		
		if (ax > 0) ax -= resistance;
		else ax += resistance;
		if (ay > 0) ay -= resistance;
		else ay += resistance;
		
		this.vx += ax;
		this.vy += ay;
		//衰减
		this.vx *= decay;
		this.vy *= decay;
		this.wingMc.x += this.vx;
		this.wingMc.y += this.vy;
	}
	
}
}