package cybs.loading {
	import flash.display.MovieClip;
	import flash.display.StageScaleMode;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;

	/**
	 * 二帧自加载的文档类基类，第一帧可以放置loading元件，尽量保持第一帧和文档类的大小最小，将所有的其它元件都放在场景第二帧，并且设置类导出在第2帧，初始化代码放在init函数之后
	 * @author yangweimin
	 * 
	 */
	public class PreloaderBase extends MovieClip {
		private var loadTime:int;

		public function PreloaderBase() {
			if (this["constructor"] == PreloaderBase) {
				throw new IllegalOperationError("PreloaderBase 类为抽象类，不允许实例化!");
			}

			this.stop ();//在第一帧停止
			this.loaderInfo.addEventListener (ProgressEvent.PROGRESS, loadProgress);
			this.loaderInfo.addEventListener (Event.COMPLETE, loadComplete);
			loadTime = getTimer();
			stage.scaleMode = StageScaleMode.EXACT_FIT;
		}
		
		private function loadProgress (event:ProgressEvent):void{
			var percentLoaded:Number = event.bytesLoaded / event.bytesTotal;
			var interval:int = int((getTimer() - loadTime) / 1000);
			var speed:int = int(event.bytesLoaded / interval);
			setProgressView(int(percentLoaded * 100), speed);
		}
		
		private function loadComplete (event:Event):void{
			loaderInfo.removeEventListener (ProgressEvent.PROGRESS,loadComplete); 
			gotoAndStop (2);//载入完成跳到第二帧停止 
			init ();//进行初始化
		}
		
		/**
		 * 设置进度条的样式，默认是文本方式，可以子类重写
		 * @param progress 当前进度(0~100)
		 * @param speed 当前下载速度(byte/s)
		 */
		protected function setProgressView(progress:int, speed:int):void {
			var txt:TextField = getChildByName("txt") as TextField;
			if (txt == null) {
				txt = new TextField();
				txt.name = "txt";
				txt.autoSize = TextFieldAutoSize.CENTER;
				addChild(txt);
			}
			txt.text = "已加载flash:" + progress.toString() + "%，速度:" + int(speed / 1024).toString() + "kB/s";
			var centerX:int = (stage.stageWidth - txt.textWidth) / 2;
			var centerY:int = (stage.stageHeight - txt.textHeight) / 2;
			txt.x = centerX;
			txt.y = centerY;
		}
		
		/**
		 * 自身加载完执行初始化，请注意如果要实例化库元件请在init或其之后进行，否则会加大第一帧的大小
		 * 
		 */
		protected function init():void {
			
		}

	}
}
