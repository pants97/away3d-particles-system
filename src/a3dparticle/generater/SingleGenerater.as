package a3dparticle.generater
{
	import a3dparticle.particle.ParticleSample;

	/**
	 * ...
	 * @author liaocheng
	 */
	public class SingleGenerater extends GeneraterBase
	{

		public function SingleGenerater(particleSample:ParticleSample, count:uint)
		{
			super(count);
			
			for (var i:uint = 0; i < count; i++)
			{
				_particlesSamples[i] = particleSample;
			}
		}

	}

}