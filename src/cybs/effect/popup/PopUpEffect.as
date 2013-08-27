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
	 * 创建时间：2013-8-5 下午2:22:54
	 *
	 */
	public class PopUpEffect {
		private var _container:DisplayObjectContainer;
		private var _callback:Function;
		private var _bitmap:Bitmap;
		private var _content:DisplayObject;

		public function PopUpEffect(container:DisplayObjectContainer, content:DisplayObject, offsetX:int, offsetY:int, x:int, y:int, duration:Number = 0.2, callback:Function = null) {
			this._container = container;
			this._content = content;
			this._callback = callback;
			this._content.x = x;
			this._content.y = y;
			this._bitmap = DisplayUtil.cacheAsBitmap(content);
			if (this._bitmap == null) {
				this.onComplete(this._content);
				return;
			}
			var rect:Rectangle = DisplayUtil.getActualBounds(this._content);
			this._bitmap.x = offsetX + rect.x * 0.1;
			this._bitmap.y = offsetY + rect.y * 0.1;
			var scale:Number = 0.1;
			this._bitmap.scaleY = scale;
			this._bitmap.scaleX = scale;
			container.addChild(this._bitmap);
			content.visible = false;
			TweenLite.to(this._bitmap, duration, {x: x + rect.x, y: y + rect.y, scaleX: 1, scaleY: 1, onComplete: this.onComplete, onCompleteParams: [content], ease: Back.easeOut});
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

		public function get window():DisplayObject {
			return this._content;
		}

		private function onComplete(param1:DisplayObject):void {
			param1.visible = true;
			this._container.addChild(this._content);
			if (this._callback != null) {
				this._callback.apply(null, [param1]);
			}
			this.dispose();
		}
	}
}
