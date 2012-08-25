package a3dparticle.generater
{
	import a3dparticle.particle.ParticleSample;

	/**
	 * ...
	 * @author liaocheng
	 */
	public class MutiWeightGenerater extends GeneraterBase
	{

		public function MutiWeightGenerater(samples:Vector.<ParticleSample>, weights:Vector.<int>, count:uint)
		{
			super(count);
			
			var total:int = 0;
			var i:uint;
			var j:uint;
			var current:Number;
			
			var _weights:Vector.<int> = new Vector.<int>();

			for (i = 0; i < samples.length; i++)
			{
				total += weights[i];
				_weights.push(total);
			}
			for (j = 0; j < count; j++)
			{
				current = Math.random() * total;
				for (i = 0; i < samples.length; i++)
				{
					if (current < _weights[i]) break;
				}
				_particlesSamples[j] = samples[i];
			}

		}

	}

}