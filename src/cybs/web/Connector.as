

package cybs.web {
	import flash.errors.IllegalOperationError;

	/**
	 * 连接类的构造类的抽象基类
	 * @author yangweimin
	 * 
	 */
	public class Connector {
		public function Connector() {
		}

		/**
		 * 构建一个连接类的实例，由子类实现具体生成的实例
		 * @param url 消息地址
		 * @param isCompressed 是否压缩数据
		 * @return 
		 * 
		 */
		protected function createConnection(url:String, isCompressed:Boolean = false):Connection {
			throw new IllegalOperationError("抽象方法未被子类重写");
		}

		/**
		 * 发送消息
		 * @param url 消息地址
		 * @param params 发送的参数
		 * @param callBack 发送成功的回调函数
		 * @param errorCallBack 错误回调函数
		 * @param method
		 * @param cookie
		 * @param isCompressed 是否压缩
		 * 
		 */
		public function sendMessage(url:String, params:Object = null, callBack:Function = null, errorCallBack:Function = null, method:String = null, cookie:String = null, isCompressed:Boolean = false):void {
			var connection:Connection = this.createConnection(url, isCompressed);
			if (method) {
				connection.call(params, callBack, errorCallBack, cookie, method);
			} else {
				connection.call(params, callBack, errorCallBack, cookie);
			}
		}
	}
}
