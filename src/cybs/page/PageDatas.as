package cybs.page {

	/**
	 * 分页数据
	 * @author yangweimin
	 * 创建时间：2013-7-10 下午2:53:02
	 *
	 */
	public class PageDatas {
		private var totalPage:int;
		private var data:Array;
		private var numPerPage:int;

		/**
		 * 
		 * @param pages 所有待分页数据列表
		 * @param numPerPage 每页显示的数据项数量
		 * 
		 */
		public function PageDatas(pages:Array, numPerPage:int) {
			this.numPerPage = numPerPage;
			this.updateData(pages);
		}

		public function get getTotalPage():int {
			return this.totalPage;
		}

		/**
		 * 更新全部分页数据
		 * @param pages
		 * @param numPerPage
		 * 
		 */
		public function updateData(pages:Array, numPerPage:int = -1):void {
			this.data = pages;
			if (numPerPage != -1) {
				this.numPerPage = numPerPage;
			}
			this.totalPage = (pages.length - 1) / this.numPerPage + 1;
			if (this.totalPage == 0) {
				this.totalPage = 1;
			}
		}

		public function dispose():void {
			this.data = null;
		}

		/**
		 * 获得某页的数据
		 * @param page 从1开始
		 * @return 
		 * 
		 */
		public function getPageData(page:int):Array {
			if (page <= 0) {
				throw new Error("page 参数不能<= 0");
				return;
			}
			var index:int = 0;
			var datas:Array = [];
			var i:int = 0;
			while (i < this.numPerPage) {

				index = i + this.numPerPage * (page - 1);
				if (index >= this.data.length) {
					break;
				}
				datas.push(this.data[index]);
				i++;
			}
			return datas;
		}
	}
}
