package cybs.storage
{
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;

	/**
	 * flash本地存储管理
	 * @author yangweimin
	 * 创建时间：2013-7-16 上午10:15:36
	 * 
	 */
	public class LocalStorageManager
	{
		private static const TIME_KEY_PREFIX:String = "CybsShareObjTime_";
		private static const NAME:String = "CybsShareObj";
		private static const DEFAULT_MIN_DISK_SPACE:int = 100000;
		
		public function LocalStorageManager() {
		}
		
		/**
		 * 在本地保存值
		 * @param key
		 * @param value
		 * @return 
		 * 
		 */
		public static function saveValue(key:String, value:Object):Boolean {
			var so:SharedObject;
			var onFlushStatus:Function;
			var key:String = key;
			var value:Object = value;
			so = SharedObject.getLocal(NAME);
			so.data[key] = value;
			so.data[TIME_KEY_PREFIX + key] = new Date();
			var flushStatus:String;
			try {
				flushStatus = so.flush(DEFAULT_MIN_DISK_SPACE);
			} catch (error:Error) {
				trace("写入SharedObject失败，key:" + key);
				return false;
			}
			if (flushStatus != null) {
				switch (flushStatus) {
					case SharedObjectFlushStatus.PENDING:  {
						onFlushStatus = function(event:NetStatusEvent):void {
							switch (event.info.code) {
								case "SharedObject.Flush.Success":
									break;
								case "SharedObject.Flush.Failed":
									break;
								default:
									trace(event.info.code);
									break;
							}
							so.removeEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
							return;
						};
						so.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
						return false;
					}
					case SharedObjectFlushStatus.FLUSHED:  {
						break;
					}
					default:  {
						break;
					}
				}
			}
			return true;
		}
		
		/**
		 * 获取key值
		 * @param key
		 * @return 
		 * 
		 */
		public static function getValue(key:String):LocalStorageInfo {
			try {
				var so:SharedObject = SharedObject.getLocal(NAME);
			} catch (error:Error) {
				trace("SharedObject.getLocal失败，name:" + NAME);
			}
			var value:Object = so.data[key];
			if (value == null) {
				return null;
			}
			var saveTime:Date = so.data[TIME_KEY_PREFIX + key];
			var info:LocalStorageInfo = new LocalStorageInfo(value, saveTime);
			return info;
		}
		
		/**
		 * 清除某个值
		 * @param key
		 * 
		 */
		public static function clearValue(key:String):void {
			try {
				var so:SharedObject = SharedObject.getLocal(NAME);
			} catch (error:Error) {
				trace("SharedObject.getLocal失败，name:" + NAME);
			}
			so.data[key] = null;
			so.data[TIME_KEY_PREFIX + key] = null;
			delete so.data[key];
			delete so.data[TIME_KEY_PREFIX + key];
		}
		
		/**
		 * 将所有保存过的值清除
		 * 
		 */
		public static function clearAllValues():void {
			try {
				var so:SharedObject = SharedObject.getLocal(NAME);
			} catch (error:Error) {
				trace("SharedObject.getLocal失败，name:" + NAME);
			}
			for (var key:String in so.data) {
				so.data[key] = null;
				delete so.data[key];
			}
		}
	}
}