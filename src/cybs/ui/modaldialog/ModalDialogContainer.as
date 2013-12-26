package cybs.ui.modaldialog {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import cybs.util.AlignType;
	import cybs.util.DisplayUtil;

	/**
	 * @author yangweimin
	 * 创建时间：2013-7-11 下午3:08:33
	 *
	 */
	public class ModalDialogContainer extends Sprite {
		private var _alignType:int;
		private var _height:int;
		private var _window:DisplayObject;
		private var _width:int;
		private var _isGrayBackground:Boolean;
		private var _alpha:Number;

		function ModalDialogContainer(dialog:DisplayObject, isGray:Boolean, alignType:int, alpha:Number) {
			this._window = dialog;
			this._isGrayBackground = isGray;
			this._alignType = alignType;
			this._alpha = alpha;
			if (isGray) {
				ModalDialogGrayBackground.instance.removeGrayBackground();
				ModalDialogGrayBackground.instance.alpha = alpha;
				this.addChild(ModalDialogGrayBackground.instance.background);
			}
			ModalDialogManager.getInstance().stage.addEventListener(Event.RESIZE, this.onResize);
			this.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemoved);
		}

		private function onRemoved(event:Event):void {
			ModalDialogManager.getInstance().stage.removeEventListener(Event.RESIZE, this.onResize);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemoved);
			while (this.numChildren) {
				this.removeChildAt((this.numChildren - 1));
			}
			this._window = null;
		}

		private function onResize(event:Event):void {
			this.alignWindow(this._width, this._height);
		}

		public function get window():DisplayObject {
			return this._window;
		}

		public function alignWindow(width:int = 0, height:int = 0):void {
			if (this._alignType == AlignType.NONE) {
				return;
			}
			if (width == 0) {
			}
			if (height == 0) {
				DisplayUtil.align(this.window, new Rectangle(0, 0, ModalDialogManager.getInstance().stage.stageWidth, ModalDialogManager.getInstance().stage.stageHeight), this._alignType);
			} else {
				this._width = width;
				this._height = height;
				DisplayUtil.align(this.window, new Rectangle(0, 0, ModalDialogManager.getInstance().stage.stageWidth, ModalDialogManager.getInstance().stage.stageHeight), this._alignType, width, height);
			}
		}

		public function get isGrayBackground():Boolean {
			return this._isGrayBackground;
		}

	}
}
