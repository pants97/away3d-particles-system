package com.pro3games.particle.jumpStart {

	import a3dparticle.core.SubContainer;

	import away3d.core.managers.Stage3DProxy;

	public class JumpStartCollector implements JumpStartTraverser {
		
		private var fJumpStartersStack:Vector.<JumpStarter> = null;
		private var fJumpStarter:JumpStarter = null;
		private var fStage3DProxy:Stage3DProxy = null;
		
		public function JumpStartCollector() {
			fJumpStartersStack = new Vector.<JumpStarter>();
		}
		
		public function clear():void {
			fJumpStartersStack.length = 0;
			fStage3DProxy = null;
		}
		
		public function reset(stage3DProxy:Stage3DProxy):void {
			fStage3DProxy = stage3DProxy;
			pushJumpStarter();
		}

		public function traverse(jumpStartNode:JumpStartNode):void {
			jumpStartNode.acceptTraverser(this);
		}
		
		public function apply(jumpStartee:JumpStartee):void {
			fJumpStarter.apply(jumpStartee);
		}
		
		public function proceed():Boolean {
			if (fJumpStarter.hasJumpStartees() && !fJumpStarter.proceed()) {
				JumpStarter.put(fJumpStarter);
				popJumpStarter();
			}
			return (fJumpStarter != null);
		}
		
		public function pushJumpStarter(subContainer:SubContainer = null):void {
			fJumpStarter = JumpStarter.get(fStage3DProxy, subContainer);
			fJumpStartersStack.push(fJumpStarter);
		}

		private function popJumpStarter():void {
			fJumpStartersStack.pop();
			var jumpStartersCount:uint = fJumpStartersStack.length;
			if (jumpStartersCount > 0) {
				fJumpStarter = fJumpStartersStack[jumpStartersCount - 1];
			} else {
				fJumpStarter = null;
			}
		}
	}
}
