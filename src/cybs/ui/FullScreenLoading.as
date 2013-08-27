package cybs.ui {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class FullScreenLoading {
		private static var _stage:Stage;

		public static function get stage():Stage {
			return _stage;
		}

		private static var _container:Sprite = new Sprite();
		private static var _background:Sprite;
		private static var _clsName:String;
		private static var _icon:MovieClip;
		private static var _isBlack:Boolean = true;
		private static var _swfUrl:String;
		private static var _alpha:Number;

		public function FullScreenLoading() {
		}

		private static function addIcon(isBlack:Boolean):void {
			if (_background == null) {
				_background = new Sprite();
				_container.addChild(_background);
				_container.addChild(_icon);
			}
			var alpha:Number = isBlack ? (_alpha) : (0);
			_background.graphics.beginFill(4278190080, alpha);
			_background.graphics.drawRect(0, 0, _stage.stageWidth, _stage.stageHeight);
			_background.graphics.endFill();
			_stage.addChild(_container);
			_stage.addEventListener(Event.ADDED, onAdded);
			_icon.play();
			middleCenter(_icon);
		}

		private static function middleCenter(target:DisplayObject):void {
			var bounds:Rectangle = target.getBounds(_stage);
			var centerX:Number = (_stage.stageWidth - bounds.width) / 2;
			var centerY:Number = (_stage.stageHeight - bounds.height) / 2;
			var offsetX:Number = centerX - bounds.x;
			var offsetY:Number = centerY - bounds.y;
			_icon.x = _icon.x + offsetX;
			_icon.y = _icon.y + offsetY;
		}

		public static function init(stage:Stage, icon:MovieClip, alpha:Number = 0.3):void {
			_stage = stage;
			_icon = icon;
			_alpha = alpha;
		}

		private static function onAdded(event:Event):void {
			var index:int = _stage.getChildIndex(_container);
			var top:int = _stage.numChildren - 1;
			if (index != top) {
				_stage.setChildIndex(_container, top);
			}
		}

		public static function show(isBlack:Boolean = true):void {
			var isBlack:Boolean = isBlack;
			if (_icon == null) {
				throw new Error("请先调用init方法初始化数据");
			} else {
				addIcon(isBlack);
			}
			_isBlack = isBlack;
		}

		public static function close():void {
			if (_background == null) {
				return;
			}
			_icon.stop();
			_background.graphics.clear();
			if (_container.parent) {
				_container.parent.removeChild(_container);
			}
			_stage.removeEventListener(Event.ADDED, onAdded);
		}

	}

}
