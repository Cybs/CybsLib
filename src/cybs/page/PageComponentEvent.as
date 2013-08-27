package cybs.page
{
	import flash.events.Event;
	
	/**
	 * @author yangweimin
	 * 创建时间：2013-7-10 下午3:05:06
	 * 
	 */
	public class PageComponentEvent extends Event
	{
		public static const ON_PAGE_CHANGE:String = "ON_PAGE_CHANGE";
		
		public function PageComponentEvent(type:String)
		{
			super(type);
		}
		
		override public function toString() : String
		{
			return formatToString("PageComponentEvent", "type", "bubbles", "cancelable", "eventPhase", "params");
		}
		
		override public function clone() : Event
		{
			return new PageComponentEvent(this.type);
		}

	}
}