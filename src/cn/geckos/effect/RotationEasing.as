package cn.geckos.effect 
{
/**
 * ...角度缓动旋转
 * @author Kanon
 */
public class RotationEasing 
{

	/**
	 * 缓动旋转
	 * @param	originRot		原始的角度
	 * @param	originX			原点位置x
	 * @param	originY			原点位置y
	 * @param	targetX			目标位置X
	 * @param	targetY			目标位置Y
	 * @param	ease			缓存系数
	 * @return	旋转后的角度
	 */
	public static function rotate(originRot:Number, 
								  originX:Number, originY:Number, 
								  targetX:Number, targetY:Number, ease:Number = .2):Number
	{
		var dx:int = (originX - targetX);
		var dy:int = (originY - targetY);
		var r:Number = Math.atan2(dy, dx);
		
		var targetRotation = r * 180 / Math.PI;
		if (targetRotation > originRot + 180) targetRotation -= 360;
		if (targetRotation < originRot - 180) targetRotation += 360;
		
		return (targetRotation - originRot) * ease;
	}
}
}