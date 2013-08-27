

package cybs.web {
	import flash.events.Event;

	public class ConnectionEvent extends Event {
		private var _data:Object;
		public static const ON_COMPLETE:String = "onComplete";

		public function ConnectionEvent(type:String, data:Object = null) {
			super(type);
			this._data = data;
			return;
		}

		public function get data():Object {
			return this._data;
		}

		override public function clone():Event {
			return new ConnectionEvent(type, this._data);
		}

		override public function toString():String {
			var str:String = "";
			for (var key:String in this.data) {

				str = str + (key + ":" + this.data[key] + "\n");
			}
			return "ConnectionEvent data:" + str;
		}

	}
}
