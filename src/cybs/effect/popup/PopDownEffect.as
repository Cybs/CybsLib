package cybs.effect.popup {
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	
	import cybs.util.DisplayUtil;

	/**
	 * @author yangweimin
	 * 创建时间：2013-8-5 下午2:19:06
	 *
	 */
	public class PopDownEffect {
		private var _callback:Function;
		private var _bitmap:Bitmap;

		public function PopDownEffect(target:DisplayObject, x:int, y:int, duration:Number = 0.2, callback:Function = null) {
			if (target.parent == null) {
				return;
			}
			this._callback = callback;
			var rect:Rectangle = DisplayUtil.getActualBounds(target);
			var parent:DisplayObjectContainer = target.parent;
			this._bitmap = DisplayUtil.replaceAsBitmap(target);
			if (this._bitmap == null) {
				return;
			}
			TweenLite.to(this._bitmap, duration, {x: x + rect.x, y: y + rect.y, scaleX: 0.1, scaleY: 0.1, onComplete: this.onComplete, onCompleteParams: [target, parent], ease: Back.easeIn});
		}

		private function onComplete(target:DisplayObject, parent:DisplayObjectContainer):void {
			parent.addChild(target);
			if (this._callback != null) {
				this._callback.apply(null, [target]);
			}
			this.dispose();
		}

		public function dispose():void {
			if (this._bitmap != null) {
				TweenLite.killTweensOf(this._bitmap);
				DisplayUtil.stopAndRemove(this._bitmap);
				this._bitmap = null;
			}
			this._callback = null;
		}
	}
}
