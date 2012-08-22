package com.pro3games.particle.jumpStart {
	import a3dparticle.core.SubContainer;

	public interface JumpStartTraverser {

		function apply(jumpStartee:JumpStartee):void;
		function pushJumpStarter(subContainer:SubContainer = null):void;
	}
}
