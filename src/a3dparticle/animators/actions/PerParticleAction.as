package a3dparticle.animators.actions {
	import a3dparticle.core.SubContainer;
	import a3dparticle.particle.ParticleParam;

	import away3d.arcane;
	import away3d.core.managers.Stage3DProxy;

	import com.pro3games.particle.jumpStart.JumpStartTraverser;
	import com.pro3games.particle.jumpStart.JumpStartee;
	import com.pro3games.particle.jumpStart.JumpStarter;

	import flash.display3D.Context3D;
	import flash.display3D.VertexBuffer3D;


	use namespace arcane;
	/**
	 * ...
	 * @author ...
	 */
	public class PerParticleAction extends ActionBase implements JumpStartee
	{
		
		protected var _vertexBuffer : VertexBuffer3D;
		protected var _vertices : Vector.<Number> = new Vector.<Number>();
		
		protected var dataLenght:uint = 1;
		protected var _name:String = "PerParticleAction";
		
		protected var context3D:Context3D;
		
		private var _paramDirty:Boolean;
		private var _bufferDirty:Boolean;
		
		public function PerParticleAction()
		{

		}
		
		public function genOne(param:ParticleParam):void
		{
			
		}
		
		public function distributeOne(index:int, verticeIndex:uint, subContainer:SubContainer):void
		{
			
		}
		
		public function invalidateBuffers():void
		{
			_paramDirty = true;
			_bufferDirty = true;
		}
		
		public function getExtraData(subContainer:SubContainer):Vector.<Number>
		{
			var t:Vector.<Number>;
			if (!(t=subContainer.extraDatas[_name]))
			{
				t = subContainer.extraDatas[_name] = new Vector.<Number>;
			}
			else if (_paramDirty)
			{
				_paramDirty = false;
				t.length = 0;
			}
			return t;
		}
		
		public function getExtraBuffer(stage3DProxy : Stage3DProxy,subContainer:SubContainer) : VertexBuffer3D
		{
			var t:VertexBuffer3D;
			if (!(t=subContainer.extraBuffers[_name]) || context3D != stage3DProxy.context3D)
			{
				t = subContainer.extraBuffers[_name] = stage3DProxy._context3D.createVertexBuffer(subContainer.extraDatas[_name].length / dataLenght, dataLenght);
				t.uploadFromVector(subContainer.extraDatas[_name], 0, subContainer.extraDatas[_name].length / dataLenght);
				context3D = stage3DProxy.context3D;
			}
			else if (_bufferDirty)
			{
				_bufferDirty = false;
				t.uploadFromVector(subContainer.extraDatas[_name], 0, subContainer.extraDatas[_name].length / dataLenght);
				
			}
			return t;
		}

		override public function acceptTraverser(jumpStartTraverser:JumpStartTraverser):void
		{
			jumpStartTraverser.apply(this);
		}
		
		public function jumpStart(jumpStarter:JumpStarter):void
		{
			getExtraBuffer(jumpStarter.stage3DProxy, jumpStarter.subContainer);
			jumpStarter.exit(this);
		}
		
	}

}