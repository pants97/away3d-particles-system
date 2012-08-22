package a3dparticle.particle {
	import a3dparticle.animators.ParticleAnimation;
	import a3dparticle.core.SubContainer;

	import away3d.arcane;
	import away3d.cameras.Camera3D;
	import away3d.core.managers.Stage3DProxy;
	import away3d.materials.utils.DefaultMaterialManager;
	import away3d.materials.utils.ShaderRegisterElement;
	import away3d.textures.BitmapTexture;

	import com.pro3games.particle.jumpStart.JumpStartTraverser;
	import com.pro3games.particle.jumpStart.JumpStartee;
	import com.pro3games.particle.jumpStart.JumpStarter;

	import flash.display.BitmapData;
	import flash.display3D.Context3DProgramType;


	use namespace arcane;
	/**
	 * ...
	 * @author liaocheng
	 */
	public class ParticleBitmapMaterial extends ParticleMaterialBase implements JumpStartee
	{
		private var _texture:BitmapTexture;
		
		private var _smooth:Boolean;
		private var _repeat:Boolean;
		private var _mipmap:Boolean;
		
		private var _alphaThreshold:Number;
		private var _cutOffData : Vector.<Number>;
		private var cutOffReg:ShaderRegisterElement;
		
		private var _finalBitmapDataReceived:Boolean;
		private var _jumpStartStage3DProxy:Stage3DProxy;
		
		public function ParticleBitmapMaterial(bitmap:BitmapData, smooth:Boolean = true, repeat : Boolean = false, mipmap : Boolean = true, alphaThreshold:Number = 0)
		{
			this.numUsedTextures = 1;
			this._smooth = smooth;
			this._repeat = repeat;
			this._mipmap = mipmap;
			_texture = new BitmapTexture(bitmap);
			_cutOffData = new Vector.<Number>(4, true);
			
			if (alphaThreshold < 0) alphaThreshold = 0;
            else if (alphaThreshold > 1) alphaThreshold = 1;
			_alphaThreshold = alphaThreshold;
            _cutOffData[0] = _alphaThreshold;
		}
		
		override public function initAnimation(particleAnimation:ParticleAnimation):void
		{
			particleAnimation.needUV = true;
		}
		
		public function set bitmapData(value:BitmapData):void
		{
			_texture.bitmapData = value;
			
			if ((_finalBitmapDataReceived = (value && value != DefaultMaterialManager.getDefaultTexture().bitmapData)) && _jumpStartStage3DProxy)
			{
				_texture.getTextureForStage3D(_jumpStartStage3DProxy);
				_jumpStartStage3DProxy = null;
			}
		}
		
		override public function getFragmentCode(_particleAnimation:ParticleAnimation):String
		{
			_particleAnimation.textSample = _particleAnimation.shaderRegisterCache.getFreeTextureReg();
			
			var code:String = "";
			var wrap : String = _repeat ? "wrap" : "clamp";
			var tex:String = "";
			if (_smooth)
			{
				if (_mipmap) tex = "<2d," + wrap + "," + "linear,miplinear>";
				else tex = "<2d," + wrap + "," + "linear,nomip>";
			}
			else
			{
				if (_mipmap) tex = "<2d," + wrap + "," + "nearest,mipnearest>";
				else tex = "<2d," + wrap + "," + "nearest,nomip>";
			}
			code += "tex " + _particleAnimation.colorTarget.toString() + "," + _particleAnimation.uvVar.toString() + "," + _particleAnimation.textSample.toString() + tex + "\n";
			if (_alphaThreshold > 0)
			{
				cutOffReg = _particleAnimation.shaderRegisterCache.getFreeFragmentConstant();
				var temp:ShaderRegisterElement = _particleAnimation.shaderRegisterCache.getFreeFragmentSingleTemp();
				code += "sub " + temp +", " +  _particleAnimation.colorTarget.toString() + ".w, " + cutOffReg.toString() + ".x\n";
				code += "kil " + temp +"\n";
            }
			return code;
		}
		
		override public function render(_particleAnimation:ParticleAnimation, renderable : SubContainer, stage3DProxy : Stage3DProxy, camera : Camera3D) : void
		{
			super.render(_particleAnimation, renderable, stage3DProxy, camera);
			stage3DProxy.setTextureAt(_particleAnimation.textSample.index, _texture.getTextureForStage3D(stage3DProxy));
			if (_alphaThreshold > 0)
			{
				stage3DProxy._context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, cutOffReg.index, _cutOffData);
			}
		}
		
		override public function acceptTraverser(jumpStartTraverser:JumpStartTraverser):void
		{
			jumpStartTraverser.apply(this);
		}

		public function jumpStart(jumpStarter:JumpStarter):void
		{
			var stage3DProxy:Stage3DProxy = jumpStarter.stage3DProxy;
			
			if (_finalBitmapDataReceived)
			{
				_texture.getTextureForStage3D(stage3DProxy);
				stage3DProxy = null;
			}

			_jumpStartStage3DProxy = stage3DProxy;
			
			jumpStarter.exit(this);
		}
		
	}

}