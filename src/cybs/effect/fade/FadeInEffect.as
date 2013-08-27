package cybs.effect.fade {
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	import cybs.util.DisplayUtil;

	/**
	 * 淡入效果
	 * @author yangweimin
	 * 创建时间：2013-7-11 下午3:32:13
	 *
	 */
	public class FadeInEffect {
		private var _container:DisplayObjectContainer;
		private var _callback:Function;
		private var _content:DisplayObject;
		private var _bitmap:Bitmap;

		public function FadeInEffect(container:DisplayObjectContainer, content:DisplayObject, x:int, y:int, duration:Number = 0.8, callback:Function = null) {
			this._container = container;
			this._content = content;
			this._callback = callback;
			this._content.x = x;
			this._content.y = y;
			content.alpha = 0;
			container.addChild(content);
			DisplayUtil.setDisplayObjectMouse(container, false);
			TweenLite.to(content, duration, {alpha: 0.95, onComplete: this.onComplete, onCompleteParams: [content], ease: Linear.easeNone});
		}

		private function onComplete(target:DisplayObject):void {
			DisplayUtil.setDisplayObjectMouse(this._container, true);
			if (this._callback != null) {
				this._callback.apply(null, [target]);
				this._callback = null;
			}
			this.dispose();
		}

		public function dispose():void {
			if (this._bitmap != null) {
				TweenLite.killTweensOf(this._bitmap);
				DisplayUtil.stopAndRemove(this._bitmap);
				this._bitmap = null;
			}
			this._container = null;
			this._content = null;
			this._callback = null;
		}
	}
}
