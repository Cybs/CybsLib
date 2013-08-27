package cybs.storage
{
	/**
	 * @author yangweimin
	 * 创建时间：2013-7-16 上午10:16:27
	 * 
	 */
	public class LocalStorageInfo
	{
		private var _value:Object;
		private var _saveTime:Date;
		
		public function LocalStorageInfo(value:Object, saveTime:Date) {
			this.value = value;
			this.saveTime = saveTime;
		}

		/**
		 * 保存时的时间
		 */
		public function get saveTime():Date
		{
			return _saveTime;
		}

		/**
		 * @private
		 */
		public function set saveTime(value:Date):void
		{
			_saveTime = value;
		}

		/**
		 * 保存的值
		 */
		public function get value():Object
		{
			return _value;
		}

		/**
		 * @private
		 */
		public function set value(value:Object):void
		{
			_value = value;
		}

	}
}