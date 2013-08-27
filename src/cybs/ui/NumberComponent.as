package cybs.ui {
	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * 生成美术数字的控件，通过传入数字和数字样式的导出类，生成数字
	 * @author yangweimin
	 * 创建时间：2013-7-8 下午3:50:38
	 *
	 */
	public class NumberComponent extends Sprite {
		private var _num:int;
		private var _span:int;
		private var _numClass:Class;
		private var _minShowNum:int;
		private var _nums:Vector.<int>;
		private var _sign:MovieClip;

		/**
		 * 构造函数
		 * @param num 需要显示的数字
		 * @param cls 数字样式的导出类，必须是MovieClip的导出类，注册点在数字左上角，每帧一个数字，第一帧是0，最后一帧是9
		 * @param minNum 最小的显示位数，例如值为3位时，数字9的显示形式是009
		 * @param span 每一位数字的间距，像素为单位
		 * @param mcSign 正负符号的元件，可选，第一帧是+，第二帧是-
		 *
		 */
		public function NumberComponent(num:int, cls:Class, minNum:int = 1, span:int = 5, mcSign:MovieClip = null) {
			if (num < 0 && mcSign == null) {
				throw new ArgumentError("负数必须传入符号的元件");
			}
			if (cls == null) {
				throw new ArgumentError("数字的导出类不能为空");
			}
			if (minNum <= 0) {
				throw new ArgumentError("最小的显示位数不能小于零");
			}
			this._num = num;
			this._numClass = cls;
			this._minShowNum = minNum;
			this._span = span;
			this._sign = mcSign;
			this.parseAndSetNum();

		}

		private function parseNums():void {
			this._nums = new Vector.<int>();
			var numCopy:int = this._num;
			if (numCopy <= 0) {
				numCopy = numCopy * -1;
			}
			if (numCopy == 0) {
				this._nums.push(0);
			} else {
				while (numCopy) {
					var digit:int = numCopy % 10;
					this._nums.push(digit);
					numCopy /= 10;
				}
			}

		}

		private function clearNums():void {
			while (numChildren) {
				removeChildAt((numChildren - 1));
			}

		}

		/**
		 * 当前显示的数字值
		 * @return
		 *
		 */
		public function get num():int {
			return this._num;
		}

		public function set num(param1:int):void {
			this._num = param1;
			this.clearNums();
			this.parseAndSetNum();
		}

		private function parseAndSetNum():void {
			this.parseNums();
			this.setNums();

		}

		private function setNums():void {
			var mcDigit:MovieClip = null;
			var zeroNums:int = 0;
			var curX:int = 0;
			if (this._sign) {
				if (this._num > 0) {
					addChild(this._sign);
					this._sign.gotoAndStop(1);
					curX = this._sign.width + this._span;
				} else if (this._num < 0) {
					addChild(this._sign);
					this._sign.gotoAndStop(2);
					curX = this._sign.width + this._span;
				}
			}
			var templateMC:MovieClip = new this._numClass() as MovieClip;
			templateMC.gotoAndStop(9);
			var commonWidth:int = templateMC.width;//有些数字会窄有些会宽，统一以8的宽度为基准
			
			//补零
			if (this._minShowNum > this._nums.length) {
				zeroNums = this._minShowNum - this._nums.length;
				var i:int = 0;
				while (i < zeroNums) {
					mcDigit = new this._numClass() as MovieClip;
					this.setNumMC(0, mcDigit);
					addChild(mcDigit);
					mcDigit.x = curX + (commonWidth + this._span) * i;
					i++;
				}
				curX = mcDigit.x + commonWidth + this._span;
			}
			
			var j:int = 0;
			while (this._nums.length) {
				mcDigit = new this._numClass() as MovieClip;
				this.setNumMC(this._nums.pop(), mcDigit);
				addChild(mcDigit);
				mcDigit.x = (commonWidth + this._span) * j + curX;
				j++;
			}
			if (this._sign && this._sign.parent) {
				this._sign.y = (mcDigit.height - this._sign.height) / 2;
			}
		}

		private function setNumMC(num:int, mc:MovieClip):void {
			if (mc == null) {
				throw new ArgumentError("数字的导出类必须是MovieClip");
			}
			if (mc.totalFrames < 10) {
				throw new ArgumentError("数字的MovieClip必须包含0～9的数字，每帧一个数字，第一帧是0，依次递增");
			}
			mc.gotoAndStop((num + 1));
		}

	}
}
