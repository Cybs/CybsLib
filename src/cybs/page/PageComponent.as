package cybs.page {
	import flash.display.InteractiveObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import cybs.util.DisplayUtil;

	/**
	 * 自动设置分页和元件状态的控件
	 * @author yangweimin
	 * 创建时间：2013-7-10 下午3:06:13
	 *
	 */
	public class PageComponent extends EventDispatcher {
		private var pageDatas:PageDatas;
		private var isBtnGray:Boolean;
		private var pageText:TextField;
		private var currentPage:int;
		private var prevBtn:InteractiveObject;
		private var nextBtn:InteractiveObject;
		private var pageTextFormat:String;

		/**
		 *
		 * @param datas 待分页数据列表
		 * @param numPerPage 每页数量
		 * @param prevBtn 前一页按钮
		 * @param nextBtn 后一页按钮
		 * @param txtPage 页码文本框
		 *
		 */
		public function PageComponent(datas:Array, numPerPage:int, prevBtn:InteractiveObject, nextBtn:InteractiveObject, txtPage:TextField = null) {
			this.prevBtn = prevBtn;
			this.nextBtn = nextBtn;
			this.pageText = txtPage;
			this.pageDatas = new PageDatas(datas, numPerPage);
			this.currentPage = 1;
			this.setPageTextFormat();
			this.setBtnDisableStyle();
			this.initBtn();
		}

		private function refreshBtn():void {
			if (!this.isBtnGray) {
				return;
			}
			if (this.currentPage <= 1) {
				DisplayUtil.applyGray(this.prevBtn);
				if (this.prevBtn is Sprite) {
					Sprite(this.prevBtn).buttonMode = false;
				} else if (this.prevBtn is SimpleButton) {
					SimpleButton(this.prevBtn).enabled = false;
				}
			} else {
				this.prevBtn.filters = [];
				if (this.prevBtn is Sprite) {
					Sprite(this.prevBtn).buttonMode = true;
				} else if (this.prevBtn is SimpleButton) {
					SimpleButton(this.prevBtn).enabled = true;
				}
			}
			if (this.currentPage >= this.getTotalPage) {
				DisplayUtil.applyGray(this.nextBtn);
				if (this.nextBtn is Sprite) {
					Sprite(this.nextBtn).buttonMode = false;
				} else if (this.nextBtn is SimpleButton) {
					SimpleButton(this.nextBtn).enabled = false;
				}
			} else {
				this.nextBtn.filters = [];
				if (this.nextBtn is Sprite) {
					Sprite(this.nextBtn).buttonMode = true;
				} else if (this.nextBtn is SimpleButton) {
					SimpleButton(this.nextBtn).enabled = true;
				}
			}
		}

		private function onClickPrev(event:MouseEvent):void {
			if (this.currentPage <= 1) {
				return;
			}
			this.currentPage--;
			this.refreshBtn();
			this.refreshPageText();
			this.dispatchEvent(new PageComponentEvent(PageComponentEvent.ON_PAGE_CHANGE));
		}

		public function getCurrentPageData():Array {
			return this.pageDatas.getPageData(this.currentPage);
		}

		/**
		 * 重新设置待分页数据
		 * @param data 待分页数据
		 * @param isResetPage 是否将当前页重置到第一页
		 * @param numPerPage 每页数量
		 *
		 */
		public function updateData(data:Array, isResetPage:Boolean = true, numPerPage:int = -1):void {
			this.pageDatas.updateData(data, numPerPage);
			if (isResetPage) {
				this.currentPage = 1;
			} else if (this.currentPage > this.getTotalPage) {
				this.currentPage = this.getTotalPage;
			}
			this.refreshPageText();
			this.refreshBtn();
		}

		private function refreshPageText():void {
			if (this.pageText == null) {
				return;
			}
			var str:String = this.pageTextFormat.replace("{0}", this.currentPage.toString()).replace("{1}", this.getTotalPage.toString());
			this.pageText.text = str;
		}

		public function dispose():void {
			if (this.prevBtn != null) {
				this.prevBtn.removeEventListener(MouseEvent.CLICK, this.onClickPrev);
			}
			if (this.nextBtn != null) {
				this.nextBtn.removeEventListener(MouseEvent.CLICK, this.onClickNext);
			}
			this.prevBtn = null;
			this.nextBtn = null;
			this.pageText = null;
			this.pageDatas.dispose();
			this.pageDatas = null;
		}

		/**
		 * 设置按钮不能点击时样式
		 * @param isGreyButton 是否变灰不可点
		 *
		 */
		public function setBtnDisableStyle(isGreyButton:Boolean = true):void {
			this.isBtnGray = isGreyButton;
			this.refreshBtn();
		}

		private function initBtn():void {
			this.prevBtn.addEventListener(MouseEvent.CLICK, this.onClickPrev);
			this.nextBtn.addEventListener(MouseEvent.CLICK, this.onClickNext);
		}

		/**
		 * 设置当前页
		 * @param page
		 *
		 */
		public function setCurrentPage(page:int):void {
			if (page > this.getTotalPage || page < 1) {
				return;
			}
			this.currentPage = page;
			this.refreshBtn();
			this.refreshPageText();
			this.dispatchEvent(new PageComponentEvent(PageComponentEvent.ON_PAGE_CHANGE));
		}

		public function get getCurrentPage():int {
			return this.currentPage;
		}

		/**
		 * 设置页码显示格式
		 * @param format {0}：当前页，{1}:总页数
		 *
		 */
		public function setPageTextFormat(format:String = "{0}/{1}"):void {
			if (format.indexOf("{0}") >= 0) {
			}
			if (format.indexOf("{1}") < 0) {
				throw new Error("pageTextFormat error:" + format);
			}
			this.pageTextFormat = format;
			this.refreshPageText();
		}

		private function onClickNext(event:MouseEvent):void {
			if (this.currentPage >= this.getTotalPage) {
				return;
			}
			this.currentPage++;
			this.refreshBtn();
			this.refreshPageText();
			this.dispatchEvent(new PageComponentEvent(PageComponentEvent.ON_PAGE_CHANGE));
		}

		public function get getTotalPage():int {
			return this.pageDatas.getTotalPage;
		}
	}
}
