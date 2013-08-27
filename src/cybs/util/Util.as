package cybs.util
{
	import flash.display.InteractiveObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	/**
	 * @author yangweimin
	 * 创建时间：2013-5-14 上午9:51:55
	 * 
	 */
	public class Util
	{
		public function Util()
		{
		}
		
		/**
		 * 增加一条右键菜单信息
		 * @param content
		 * @param context
		 * 
		 */
		public static function addMenu(content:String, context:InteractiveObject):void {
			var myContextMenu:ContextMenu = new ContextMenu();
			var item:ContextMenuItem = new ContextMenuItem(content);
			myContextMenu.customItems.push(item);
			context.contextMenu = myContextMenu;
		}
		
		/**
		 * 隐藏指定的 ContextMenu 对象中的所有内置菜单项
		 * @param myContextMenu
		 * 
		 */
		public static function hideMenu(myContextMenu:ContextMenu):void {
			myContextMenu.hideBuiltInItems();
		}
		
		/**
		 * 设置文本框字体加粗
		 * @param txt
		 * 
		 */
		public static function setBold(txt:TextField):void {
			var tf:TextFormat = new TextFormat();
			tf.bold = true;
			txt.defaultTextFormat = tf;
		}
	}
}