package a3dparticle.generater 
{
	import a3dparticle.particle.ParticleSample;
	/**
	 * ...
	 * @author liaocheng
	 */
	public class GeneraterBase 
	{
		
		protected var _particlesSamples:Vector.<ParticleSample>;

		public function GeneraterBase(count:uint)
		{
			_particlesSamples = new Vector.<ParticleSample>(count, true);
		}
		
		final public function get particlesSamples():Vector.<ParticleSample>
		{
			return _particlesSamples;
		}
		
	}

}