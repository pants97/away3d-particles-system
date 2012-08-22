package a3dparticle.particle {
	import a3dparticle.animators.ParticleAnimation;
	import a3dparticle.core.SubContainer;

	import away3d.arcane;
	import away3d.cameras.Camera3D;
	import away3d.core.managers.Stage3DProxy;

	import com.pro3games.particle.jumpStart.JumpStartNode;
	import com.pro3games.particle.jumpStart.JumpStartTraverser;

	import flash.display.BlendMode;
	import flash.display3D.Context3DProgramType;



	use namespace arcane;

	/**
	 * ...
	 * @author liaocheng
	 */
	public class ParticleMaterialBase implements JumpStartNode
	{

		// use for SimpleParticlePas clean the texture.
		public var numUsedTextures:int = 0;

		private var _bothSides:Boolean;
		private var _requiresBlending:Boolean = true;
		private var _blendMode:String = BlendMode.NORMAL;

		public var renderTimes:int = 1;
		public var alphaFade:Number = 0.5;
		public var redFade:Number = 1;
		public var greenFade:Number = 1;
		public var bluFade:Number = 1;
		public var timeInterval:Number = 0.1;

		private var rawData:Vector.<Number> = new Vector.<Number>(4, true);

		/**
		 * init the particleAnimation state.set the needUV for example.
		 * @param	particleAnimation ParticleAnimation.
		 * @return
		 */
		public function initAnimation(particleAnimation:ParticleAnimation):void
		{

		}

		public function get bothSides():Boolean
		{
			return _bothSides;
		}

		public function set bothSides(value:Boolean):void
		{
			_bothSides = value;
		}

		public function get blendMode():String
		{
			return _blendMode;
		}

		public function set blendMode(value:String):void
		{
			_blendMode = value;
		}

		public function get requiresBlending():Boolean
		{
			return _requiresBlending;
		}

		public function set requiresBlending(value:Boolean):void
		{
			_requiresBlending = value;
		}

		/**
		 * generating the init color of a fragment.
		 * @param	particleAnimation ParticleAnimation.
		 * @return
		 */
		public function getFragmentCode(particleAnimation:ParticleAnimation):String
		{
			throw(new Error("abstract function"));
			return "";
		}

		public function getPostFragmentCode(particleAnimation:ParticleAnimation):String
		{
			var code:String = "";
			if (renderTimes > 1)
			{
				particleAnimation.fadeFactorConst = particleAnimation.shaderRegisterCache.getFreeFragmentConstant();
				code += "mul " + particleAnimation.colorTarget.toString() + "," + particleAnimation.colorTarget.toString() + "," + particleAnimation.fadeFactorConst.toString() + "\n";
			}
			return code;
		}

		public function render(_particleAnimation:ParticleAnimation, renderable:SubContainer, stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
			if (renderTimes > 1)
			{
				var passCount:int = renderable.particleAnimator.passCount;
				rawData[0] = redFade;
				rawData[1] = greenFade;
				rawData[2] = bluFade;
				rawData[3] = alphaFade;
				for (var i:uint = 1; i < passCount; ++i)
				{
					rawData[0] *= redFade;
					rawData[1] *= greenFade;
					rawData[2] *= bluFade;
					rawData[3] *= alphaFade;
				}
				stage3DProxy._context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, _particleAnimation.fadeFactorConst.index, rawData, 1);
			}
		}

		public function acceptTraverser(jumpStartTraverser:JumpStartTraverser):void
		{
		}
	}

}