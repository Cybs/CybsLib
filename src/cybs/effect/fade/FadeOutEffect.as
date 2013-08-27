package cybs.effect.fade {
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import cybs.util.DisplayUtil;

	/**
	 * @author yangweimin
	 * 创建时间：2013-7-11 下午3:35:12
	 *
	 */
	public class FadeOutEffect {
		private var _callback:Function;
		private var _content:DisplayObject;
		private var _bitmap:Bitmap;

		public function FadeOutEffect(content:DisplayObject, duration:Number = 0.5, callback:Function = null) {
			this._content = content;
			this._callback = callback;
			var _loc_4:* = DisplayUtil.getActualBounds(content);
			var container:DisplayObjectContainer = content.parent;
			this._bitmap = DisplayUtil.replaceAsBitmap(content);
			if (this._bitmap == null) {
				return;
			}
			this._bitmap.x = this._content.x;
			this._bitmap.y = this._content.y;
			TweenLite.to(this._bitmap, duration, {alpha: 0, onComplete: this.onComplete, onCompleteParams: [content, container], ease: Linear.easeNone});
		}

		private function onComplete(content:DisplayObject, container:DisplayObjectContainer):void {
			container.addChild(content);
			if (this._callback != null) {
				this._callback.apply(null, [content]);
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
