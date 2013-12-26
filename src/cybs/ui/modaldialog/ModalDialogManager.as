package cybs.ui.modaldialog {
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.utils.Dictionary;
	
	import cybs.effect.fade.FadeInEffect;
	import cybs.effect.fade.FadeOutEffect;
	import cybs.effect.popup.PopDownEffect;
	import cybs.effect.popup.PopUpEffect;
	import cybs.ui.PanelEffect;
	import cybs.util.AlignType;
	import cybs.util.DisplayUtil;

	/**
	 * @author yangweimin
	 * 创建时间：2013-7-11 下午3:16:19
	 *
	 */
	public class ModalDialogManager extends Dictionary {
		private var _stage:Stage;
		private var _toShowInfos:Vector.<Object>;
		private var _isPlayingEffect:Boolean = false;
		private var _windowTable:Array;
		private static var _instance:ModalDialogManager;

		public function ModalDialogManager() {
			this._toShowInfos = new Vector.<Object>;
			if (_instance != null) {
				throw new Error("ModalDialogManager is implemented as Singleton!");
			}
			this._windowTable = [];
		}

		public function get stage():Stage {
			return _stage;
		}

		public function set stage(value:Stage):void {
			_stage = value;
		}

		private function onPanelRemoved(dialog:DisplayObject):void {
			this._isPlayingEffect = false;
			DisplayUtil.stopAndRemove(dialog.parent);
			ModalDialogGrayBackground.instance.removeGrayBackground();
			if (this._windowTable.length > 0) {
				var container:ModalDialogContainer = null;
				container = this._windowTable[(this._windowTable.length - 1)];
				if (container.isGrayBackground) {
					container.addChildAt(ModalDialogGrayBackground.instance.background, 0);
				}
			}
			this.showWaitingWindows();
		}

		public function clearAll():void {
			var container:ModalDialogContainer = null;
			var i:int = this._windowTable.length - 1;
			while (i >= 0) {
				container = this._windowTable[i];
				this.removeModalDialog(container.window);
				i--;
			}
		}

		public function removeModalDialog(dialog:DisplayObject, effect:int = 2):Boolean {
			if (dialog.parent == null) {
				return false;
			}
			var index:int = -1;
			var i:int = 0;
			var container:ModalDialogContainer = null;
			while (i < this._windowTable.length) {
				container = this._windowTable[i];
				if (container.contains(dialog)) {
					index = i;
					break;
				}
				i++;
			}
			if (index == -1) {
				return false;
			}
			this._windowTable.splice(index, 1);
			if (effect == PanelEffect.FADE) {
				this._isPlayingEffect = true;
				new FadeOutEffect(dialog, 0.2, this.onPanelRemoved);
			} else if (effect == PanelEffect.POP) {
				this._isPlayingEffect = true;
				new PopDownEffect(dialog, dialog.x + dialog.width * 0.45, dialog.y + dialog.height * 0.45, 0.25, this.onPanelRemoved);
			} else {
				this.onPanelRemoved(dialog);
			}
			return true;
		}

		private function showWaitingWindows():void {
			var info:Object = this._toShowInfos.shift();
			if (info) {
				this.addModalDialog(info.window, info.grayBackground, info.effect, info.alignType, info.x, info.y, info.width, info.height);
			}
		}

		public function addModalDialog(dialog:DisplayObject, isGray:Boolean = true, effect:int = PanelEffect.FADE, alignType:int = 4, x:int = 0, y:int = 0, width:int = 0, height:int = 0, alpha:Number = 0.3):Boolean {
			var container:ModalDialogContainer
			for each (container in this._windowTable) {
				if (container.contains(dialog)) {
					return false;
				}
			}
			if (this._isPlayingEffect) {
				this._toShowInfos.push({window: dialog, grayBackground: isGray, effect: effect, alignType: alignType, x: x, y: y, width: width, height: height});
				return true;
			}
			if (alignType == AlignType.NONE) {
				dialog.x = x;
				dialog.y = y;
			}
			container = new ModalDialogContainer(dialog, isGray, alignType, alpha);
			_stage.addChild(container);
			container.alignWindow(width, height);
			this._windowTable.push(container);
			if (effect == PanelEffect.POP) {
				this._isPlayingEffect = true;
				new PopUpEffect(container, dialog, dialog.x + dialog.width * 0.45, dialog.y + dialog.height * 0.45, dialog.x, dialog.y, 0.3, this.onPanelAdded);
			} else if (effect == PanelEffect.FADE) {
				this._isPlayingEffect = true;
				new FadeInEffect(container, dialog, dialog.x, dialog.y, 0.22, this.onPanelAdded);
			} else {
				container.addChild(dialog);
				this.onPanelAdded(dialog);
			}
			return true;
		}

		private function onPanelAdded(param1:DisplayObject):void {
			this._isPlayingEffect = false;
			this.showWaitingWindows();
		}

		public static function getInstance():ModalDialogManager {
			if (_instance == null) {
				_instance = new ModalDialogManager;
			}
			return _instance;
		}
	}
}
