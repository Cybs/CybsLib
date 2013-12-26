package cybs.ui.modaldialog {
	import flash.display.Shape;
	import flash.events.Event;
	
	import cybs.util.DisplayUtil;

	/**
	 * @author yangweimin
	 * 创建时间：2013-7-11 下午3:07:08
	 *
	 */
	public class ModalDialogGrayBackground {
		private static const ALPHA:Number = 0.3;
		private static var _instance:ModalDialogGrayBackground;
		private var _background:Shape;
		private var _alpha:Number = ALPHA;

		public function ModalDialogGrayBackground() {
			this._background = new Shape();
			ModalDialogManager.getInstance().stage.addEventListener(Event.RESIZE, this.onResize);
		}

		public function get alpha():Number
		{
			return _alpha;
		}

		public function set alpha(value:Number):void
		{
			value = value > 1 ? 1 : value;
			value = value < 0 ? 0 : value;
			_alpha = value;
			drawBackground();
		}

		private function drawBackground():void {
			this._background.graphics.clear();
			this._background.graphics.beginFill(0, _alpha);
			this._background.graphics.drawRect(0, 0, ModalDialogManager.getInstance().stage.stageWidth, ModalDialogManager.getInstance().stage.stageHeight);
			this._background.graphics.endFill();
			return;
		}

		public function removeGrayBackground():void {
			alpha = ALPHA;
			DisplayUtil.stopAndRemove(this._background);
		}

		private function onResize(event:Event):void {
			this.drawBackground();
		}

		public function get background():Shape {
			this.drawBackground();
			return this._background;
		}

		public static function get instance():ModalDialogGrayBackground {
			if (_instance == null) {
				_instance = new ModalDialogGrayBackground;
			}
			return _instance;
		}
	}
}
