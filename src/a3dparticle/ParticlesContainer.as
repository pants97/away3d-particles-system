package a3dparticle {
	import away3d.core.managers.Stage3DProxy;
	import a3dparticle.animators.actions.ActionBase;
	import a3dparticle.animators.ParticleAnimation;
	import a3dparticle.animators.ParticleAnimationtor;
	import a3dparticle.core.ParticlesNode;
	import a3dparticle.core.SubContainer;
	import a3dparticle.generater.GeneraterBase;
	import a3dparticle.particle.ParticleParam;
	import a3dparticle.particle.ParticleSample;
	import away3d.animators.IAnimationSet;
	import away3d.bounds.AxisAlignedBoundingBox;
	import away3d.bounds.BoundingVolumeBase;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Object3D;
	import away3d.core.partition.EntityNode;
	import away3d.entities.Entity;
	

	/**
	 * A container of particles
	 * @author liaocheng.Email:liaocheng210@126.com.
	 */
	public class ParticlesContainer extends Entity
	{
		public var initParticleFun:Function;
		
		protected var _animator:ParticleAnimationtor;
		protected var _particleAnimation : ParticleAnimation;
		
		protected var _isStart:Boolean;
		protected var _hasGen:Boolean;
		protected var _alwaysInFrustum:Boolean;
		
		
		public var _subContainers : Vector.<SubContainer>;
		
		public function ParticlesContainer(isClone:Boolean=false)
		{
			super();
			if (!isClone)
			{
				_particleAnimation = new ParticleAnimation();
				
				_animator = new ParticleAnimationtor(_particleAnimation);
				_subContainers = new Vector.<SubContainer>();
			}
		}
		
		public function set alwaysInFrustum(value:Boolean):void
		{
			_alwaysInFrustum = value;
		}
		
		public function get alwaysInFrustum():Boolean
		{
			return _alwaysInFrustum;
		}
		
		
		public function set playbackSpeed(value:Number):void
		{
			_animator.playbackSpeed = value;
		}
		public function get playbackSpeed():Number
		{
			return _animator.playbackSpeed;
		}
		public function set time(value:Number):void
		{
			_animator.absoluteTime = value * 1000;
		}
		public function get time():Number
		{
			return _animator.absoluteTime /1000;
		}
		
		public function addAction(action:ActionBase):void
		{
			if (_hasGen) throw(new Error("can't add action after gen!"));
			_particleAnimation.addAction(action);
		}
		
		public function set startTimeFun(fun:Function):void
		{
			_particleAnimation.startTimeFun = fun;
		}
		
		public function set hasDuringTime(value:Boolean):void
		{
			_particleAnimation.hasDuringTime = value;
		}
		
		public function set hasSleepTime(value:Boolean):void
		{
			_particleAnimation.hasSleepTime = value;
		}
		
		public function set duringTimeFun(fun:Function):void
		{
			_particleAnimation.duringTimeFun = fun;
		}
		
		public function set sleepTimeFun(fun:Function):void
		{
			_particleAnimation.sleepTimeFun = fun;
		}
		
		public function set loop(value:Boolean):void
		{
			_particleAnimation.loop = value;
		}
		
		public function generate(generater:GeneraterBase):void
		{
			if (_hasGen) throw(new Error("has generated!"));
			
			_particleAnimation.startGen();

			var _vec:Vector.<ParticleSample> = generater.particlesSamples;
			
			var vertexData:Vector.<Number>;
			var uvData:Vector.<Number>;
			var indexData:Vector.<uint>;
			var subVertexData:Vector.<Number>;
			var subUVData:Vector.<Number>;
			var subIndexData:Vector.<uint>;
			var j:uint;
			var length:uint;
			var param:ParticleParam;
			var tempIndex:uint;
			var nowVertexLen:int;
			var sample:ParticleSample;
			var numSamples:uint = _vec.length;
			var subContainer:SubContainer;
			
			for (var i:uint = 0; i < numSamples; i++)
			{
				sample = _vec[i];
				for (j = 0; j < _subContainers.length; j++)
				{
					subContainer = _subContainers[j];
					if (subContainer.particleMaterial == sample.material) break;
				}
				if (j == _subContainers.length)
				{
					_subContainers[j] = subContainer = new SubContainer(this, sample.material);
				}
				indexData = sample.subGem.indexData;
				vertexData = sample.subGem.vertexData;
				uvData = sample.subGem.UVData;
				
				subIndexData = subContainer.indexData;
				subVertexData = subContainer.vertexData;
				subUVData = subContainer.UVData;
				
				subContainer.numTriangles += sample.subGem.numTriangles;
				nowVertexLen = subVertexData.length / 3;
				length = indexData.length;
				for (tempIndex = 0; tempIndex < length; tempIndex += 3)
				{
					subIndexData.push(indexData[tempIndex] + nowVertexLen, indexData[tempIndex + 1] + nowVertexLen, indexData[tempIndex + 2] + nowVertexLen);
				}
				length = uvData.length;
				for (tempIndex = 0; tempIndex < length; tempIndex += 2)
				{
					subUVData.push(uvData[tempIndex], uvData[tempIndex + 1]);
				}
				
				param = initParticleParam();
				param.total = numSamples;
				param.index = i;
				param.sample = sample;
				
				if (initParticleFun != null) initParticleFun(param);
				
				_particleAnimation.genOne(param);
				length = vertexData.length;
				for (tempIndex = 0; tempIndex < length; tempIndex += 3)
				{
					subVertexData.push(vertexData[tempIndex], vertexData[tempIndex + 1], vertexData[tempIndex + 2]);
					_particleAnimation.distributeOne(i, tempIndex, subContainer);
				}
				
			}
			_particleAnimation.finishGen();
			_hasGen = true;
			
		}
		
		protected function initParticleParam():ParticleParam
		{
			return new ParticleParam;
		}
		
		public function start():void
		{
			_isStart = true;
			_animator.start();
		}
		
		public function stop():void
		{
			_isStart = false;
			_animator.stop();
		}
				
		override protected function createEntityPartitionNode() : EntityNode
		{
			return new ParticlesNode(this);
		}
		
		override protected function getDefaultBoundingVolume():BoundingVolumeBase
		{
			return new AxisAlignedBoundingBox();
		}

		override protected function updateBounds():void
		{
			_bounds.fromExtremes( -100, -100, -100, 100, 100, 100 );
			_boundsInvalid = false;
		}
		
		public function get animation() : IAnimationSet
		{
			return _particleAnimation;
		}
		
		public function get animator() : ParticleAnimationtor
		{
			return _animator;
		}
		
		
		/**
		 * @inheritDoc
		 */
		override public function clone() : Object3D
		{
			if (!_hasGen) throw(new Error("can't not clone a object that has not gen!"));
			var clone : ParticlesContainer = new ParticlesContainer(true);
			clone._hasGen = _hasGen;
			clone._particleAnimation = _particleAnimation;
			clone._animator = new ParticleAnimationtor(_particleAnimation);
			clone._subContainers = new Vector.<SubContainer>();
			clone._isStart = _isStart;
			clone.alwaysInFrustum = alwaysInFrustum;
			
			if (_isStart) clone.start();
			for (var j:uint = 0; j < _subContainers.length; j++)
			{
				clone._subContainers[j] = _subContainers[j].clone(clone);
			}
			
			clone.transform = transform;
			clone.pivotPoint = pivotPoint;
			clone.partition = partition;
			clone.bounds = _bounds.clone();
			clone.name = name;

			var numChildren:uint = this.numChildren;
			for (var i:int = 0; i < numChildren; ++i) {
				clone.addChild(ObjectContainer3D(getChildAt(i).clone()));
			}
			return clone;
		}

		public function jumpStart(stage3DProxy:Stage3DProxy):void
		{
			var len:uint = _subContainers.length;
			for (var i:uint = 0; i < len; ++i)
			{
				_subContainers[i].jumpStart(stage3DProxy);
			}
		}
		
	}

}
