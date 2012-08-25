package a3dparticle.particle
{
	public class ParticleParamPool
	{
		
		private static const _pool:Vector.<ParticleParam> = new Vector.<ParticleParam>();
		private static var _top:uint;
		
		public static function get():ParticleParam
		{
			var particleParam:ParticleParam = null;
			if (_top > 0) {
				particleParam = _pool[--_top];
			} else {
				particleParam = new ParticleParam();
			}
			return particleParam;
		}
		
		public static function put(particleParam:ParticleParam):void
		{
			particleParam.sample = null;
			particleParam.index = 0;
			particleParam.total = 0;
			particleParam.startTime = 0;
			particleParam.duringTime = 0;
			particleParam.sleepTime = 0;
			
			for (var x:String in particleParam)
			{
				delete particleParam[x];
			}
			
			_pool[_top++] = particleParam;
		}
	}
}
