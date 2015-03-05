package cybs.effect
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * 下雪特效组件，自身是所有雪花的显示列表容器
	 * @author yangweimin
	 * 
	 */
	public class Snow extends Sprite
	{
		private var _width:int;
		private var _height:int;
		private var _speed:Number = 1.5;
		private var _wind:Number = 2;
		private var _minSnowSize:int = 1.5;
		private var _maxSnowSize:int = 0.6;
		private var _stopHeight:int = 0.4;
		private var _num:int = 100;
		private var _snowflakes:Array = [];
		private var _flakeClass:Class;
		
		/**
		 * 构造雪花组件
		 * @param info 雪花动画参数{width:宽度(必须)，height:高度(必须), num：雪花数量, speed:雪花下落速度, wind:风速, min:最小缩小比例, max:最大放大比例, stop:停止的高度(百分比)}
		 * 
		 */
		public function Snow(info:Object)
		{
			if (info == null) {
				return;
			}
			_width = info.width;
			_height = info.height;
			if (_width <= 0 || _height <= 0) {
				throw new ArgumentError("width或height参数不能为null或小于等于0");
				return;
			}
			_snowflakes = info.num || _snowflakes;
			_speed = info.speed || _speed;
			_wind = info.wind || _wind;
			_minSnowSize = info.min || _minSnowSize;
			_maxSnowSize = info.max || _maxSnowSize;
			_stopHeight = info.stop || _stopHeight;
		}
		
		/**
		 * 播放雪花
		 * @param flakeClass 雪花颗粒的元件导出类
		 * 
		 */
		public function play(flakeClass:Class):void {
			if (flakeClass == null) {
				return;
			}
			this._flakeClass = flakeClass;
			
			for (var i:int = 0; i < _num; i++) 
			{
				newASnowflake();
			}
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			this.addEventListener(Event.ENTER_FRAME, onFalling);
		}
		
		private function onRemove(event:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME, onFalling);
		}
		
		private function onFalling(event:Event):void
		{
			for (var i:int = _snowflakes.length - 1; i >= 0; i--) 
			{
				var sf:MovieClip = this._snowflakes[i];
				// 不在停止区域
				if (!(sf.y < this._height && sf.y > sf.stopHeight)) {
					sf.x += sf.wind;
					sf.y += sf.speed;
					//掉出去了，回到上方
					if (sf.y > _height + 10) {
						sf.y = -20;
					}
					if (sf.x > this._width + 20 || sf.x < -20) {
						sf.x = Math.random() * _width;
						sf.y = -20;
					}
				} else {
					//生成新雪花
					
					//停下开始融化
					sf.alpha -= 0.01;
					if (sf.alpha < 0.02) {
						this.removeChild(sf);
						var index:int = _snowflakes.indexOf(sf);
						_snowflakes.splice(index, 1);
						newASnowflake();
					}
				}
			}
		}
		
		private function newASnowflake():MovieClip {
			var sf:MovieClip = new _flakeClass();
			sf.cacheAsBitmap = true;
			sf.alpha = 0.2 + Math.random() * 0.8;
			sf.x = Math.random() * _width;
			sf.y = Math.random() * _height / 3 - 100;
			sf.scaleX = sf.scaleY = randRange(_minSnowSize as Number, _maxSnowSize as Number);
			sf.wind = this._wind - 4 + Math.random() * 4.2;
			sf.speed = this._speed + Math.random() * 2;
			sf.finished = false;
			sf.stopHeight = randRange(_height * _stopHeight as Number, _height as Number);
			_snowflakes.push(sf);
			this.addChild(sf);
			return sf;
		}
		
		private function randRange(min:Number, max:Number):Number
		{
			var randomNum:Number = Math.floor(Math.random() * (max - min + 1)) + min;
			return randomNum;
		}
	}
}