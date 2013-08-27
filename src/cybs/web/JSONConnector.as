

package cybs.web {

	public class JSONConnector extends Connector {

		public function JSONConnector() {
		}

		override protected function createConnection(url:String, isCompressed:Boolean = false):Connection {
			return new JSONConnection(url, isCompressed);
		}

	}
}
