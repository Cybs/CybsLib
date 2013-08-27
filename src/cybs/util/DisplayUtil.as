package cybs.util {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @author yangweimin
	 * 创建时间：2013-5-15 上午11:37:40
	 *
	 */
	public class DisplayUtil {
		public function DisplayUtil() {
		}

		/**
		 * 将文本框的字变成粗体
		 * @param txt
		 *
		 */
		public static function setBold(txt:TextField):void {
			var tf:TextFormat = new TextFormat();
			tf.bold = true;
			txt.defaultTextFormat = tf;
		}

		/**
		 * 将显示对象变成灰色
		 * @param disp
		 *
		 */
		public static function applyGray(disp:DisplayObject):void {
			var matrix:* = new Array();
			matrix = matrix.concat([0.3086, 0.6094, 0.082, 0, 0]);
			matrix = matrix.concat([0.3086, 0.6094, 0.082, 0, 0]);
			matrix = matrix.concat([0.3086, 0.6094, 0.082, 0, 0]);
			matrix = matrix.concat([0, 0, 0, 1, 0]);
			applyFilter(disp, matrix);
		}

		/**
		 * 对显示对象应用滤镜
		 * @param param1
		 * @param matrix
		 *
		 */
		public static function applyFilter(param1:DisplayObject, matrix:Array):void {
			var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			var filters:Array = [];
			filters.push(filter);
			param1.filters = filters;
		}

		/**
		 * 清除应用到显示对象的滤镜
		 * @param disp
		 *
		 */
		public static function clearFilters(disp:DisplayObject):void {
			if (disp == null) {
				return;
			}
			disp.filters = null;
		}

		/**
		 * 递归停止每一层的动画
		 * @param target
		 *
		 */
		public static function stop(target:DisplayObject):void {
			if (target is MovieClip) {
				MovieClip(target).stop();
			}
			if (target is DisplayObjectContainer) {
				var index:int = 0;
				var numChildren:int = DisplayObjectContainer(target).numChildren;
				while (index < numChildren) {
					stop(DisplayObjectContainer(target).getChildAt(index));
					index++;
				}
			} else if (target is SimpleButton) {
				if (SimpleButton(target).upState is DisplayObjectContainer) {
					stop(SimpleButton(target).upState);
				}
				if (SimpleButton(target).downState is DisplayObjectContainer) {
					stop(SimpleButton(target).downState);
				}
				if (SimpleButton(target).overState is DisplayObjectContainer) {
					stop(SimpleButton(target).overState);
				}
				if (SimpleButton(target).hitTestState is DisplayObjectContainer) {
					stop(SimpleButton(target).hitTestState);
				}
			}
		}

		/**
		 * 递归停止每一层的动画并且将对象从显示列表删除
		 * @param target
		 * @return
		 *
		 */
		public static function stopAndRemove(target:DisplayObject):Boolean {
			if (target == null) {
				return false;
			}
			stop(target);
			var parent:DisplayObjectContainer = target.parent;
			if (parent != null) {
				parent.removeChild(target);
				return true;
			}
			return false;
		}

		/**
		 * 将一个显示对象在其父对象的某个范围内居中（不缩放，其几何中心与范围的几何中心重叠）
		 * @param target
		 * @param width 范围的宽
		 * @param height 范围的长
		 * @param initPoint 范围左上角的坐标，默认是父对象的注册点
		 *
		 */
		public static function middleDisplay(target:DisplayObject, width:Number, height:Number, initPoint:Point = null):void {
			if (target.parent == null) {
				return;
			}
			if (initPoint == null) {
				initPoint = new Point(0, 0);
			}
			target.x = 0;
			target.y = 0;
			var rect:Rectangle = target.getBounds(target.parent);
			var offsetX:Number = initPoint.x - rect.x;
			var offsetY:Number = initPoint.y - rect.y;
			target.x = (width - target.width) / 2 + offsetX;
			target.y = (height - target.height) / 2 + offsetY;
		}

		/**
		 * 清除所有子对象
		 * @param target
		 *
		 */
		public static function removeAllChildren(target:DisplayObjectContainer):void {
			if (target == null) {
				return;
			}
			while (target.numChildren) {
				target.removeChildAt(target.numChildren - 1);
			}
		}

		/**
		 * 对齐显示对象
		 * @param target
		 * @param area 对象其父亲坐标系上对齐的相对范围
		 * @param alignType 对齐方式
		 * @param width 自定义显示对象的宽，不根据实际宽来对齐
		 * @param height 自定义显示对象的高，不根据实际高来对齐
		 *
		 */
		public static function align(target:DisplayObject, area:Rectangle, alignType:int = AlignType.MIDDLE_CENTER, width:int = 0, height:int = 0):void {
			if (alignType == AlignType.NONE) {
				return;
			}
			var rect:Rectangle = null;
			rect = target.getBounds(target);
			if (width > 0 && height > 0) {
				rect = new Rectangle(0, 0, width, height);
			}
			var offsetX:int = area.width - rect.width;
			var offsetY:int = area.height - rect.height;
			switch (alignType) {
				case AlignType.TOP_LEFT:  {
					target.x = area.x;
					target.y = area.y;
					break;
				}
				case AlignType.TOP_CENTER:  {
					target.x = area.x + (offsetX >> 1) - rect.x;
					target.y = area.y;
					break;
				}
				case AlignType.TOP_RIGHT:  {
					target.x = area.x + offsetX - rect.x;
					target.y = area.y;
					break;
				}
				case AlignType.MIDDLE_LEFT:  {
					target.x = area.x;
					target.y = area.y + (offsetY >> 1) - rect.x;
					break;
				}
				case AlignType.MIDDLE_CENTER:  {
					target.x = area.x + (offsetX >> 1) - rect.x;
					target.y = area.y + (offsetY >> 1) - rect.y;
					break;
				}
				case AlignType.MIDDLE_RIGHT:  {
					target.x = area.x + offsetX - rect.x;
					target.y = area.y + (offsetY >> 1) - rect.y;
					break;
				}
				case AlignType.BOTTOM_LEFT:  {
					target.x = area.x;
					target.y = area.y + offsetY - rect.y;
					break;
				}
				case AlignType.BOTTOM_CENTER:  {
					target.x = area.x + (offsetX >> 1) - rect.x;
					target.y = area.y + offsetY - rect.y;
					break;
				}
				case AlignType.BOTTOM_RIGHT:  {
					target.x = area.x + offsetX - rect.x;
					target.y = area.y + offsetY - rect.y;
					break;
				}
				default:  {
					break;
				}
			}
		}

		/**
		 * 设置鼠标是否可用
		 * @param target
		 * @param enable
		 *
		 */
		public static function setDisplayObjectMouse(target:DisplayObjectContainer, enable:Boolean):void {
			target.mouseEnabled = enable;
			target.mouseChildren = enable;
		}

		/**
		 * 获得包围矩阵
		 * @param target
		 * @return
		 *
		 */
		public static function getActualBounds(target:DisplayObject):Rectangle {
			return target.getBounds(target);
		}

		/**
		 * 将显示对象用位图版本替换
		 * @param target
		 * @return
		 *
		 */
		public static function replaceAsBitmap(target:DisplayObject):Bitmap {
			var parent:DisplayObjectContainer = target.parent;
			if (parent == null || !parent.contains(target)) {
				throw new Error("待缓存的元件不在显示列表中");
				return null;
			}
			var index:int = parent.getChildIndex(target);
			var bitmap:Bitmap = cacheAsBitmap(target);
			if (bitmap == null) {
				return null;
			}
			var rect:Rectangle = getActualBounds(target);
			bitmap.name = target.name;
			bitmap.x = target.x + rect.x;
			bitmap.y = target.y + rect.y;
			parent.addChildAt(bitmap, index);
			DisplayUtil.stopAndRemove(target);
			return bitmap;
		}

		/**
		 * 获得位图版本的显示对象
		 * @param target
		 * @return
		 *
		 */
		public static function cacheAsBitmap(target:DisplayObject):Bitmap {
			var bitmap:Bitmap = null;
			var rect:Rectangle = null;
			var matrix:Matrix = null;
			var bitmapData:BitmapData = null;
			var bounds:Rectangle = getActualBounds(target);
			if (bounds.width > 0 && bounds.height > 0) {
				rect = new Rectangle();
				rect.x = int(bounds.x);
				rect.y = int(bounds.y);
				rect.width = Number(bounds.width + bounds.x - Number(rect.x));
				rect.height = Number(bounds.height + bounds.y - Number(rect.y));
				matrix = new Matrix();
				matrix.translate(-rect.x, -rect.y);
				bitmapData = new BitmapData(getMipmapValue((rect.width + 1)), getMipmapValue((rect.height + 1)), true, 0);
				bitmapData.draw(target, matrix);
				bitmap = new Bitmap(bitmapData, PixelSnapping.AUTO, true);
				bitmap.x = bounds.x;
				bitmap.y = bounds.y;
			}
			return bitmap;
		}

		/**
		 * 获取最接近的mipmap值
		 * @param num
		 * @return 
		 * 
		 */
		public static function getMipmapValue(num:int):int {
			var tmpNum:int = num % 4;
			if (tmpNum == 0) {
				return num;
			}
			return num + (4 - tmpNum);
		}
		
		/**
		 * 等比例缩放显示对象，根据参数中宽和高的最大值计算比例
		 * @param target
		 * @param width 
		 * @param height 
		 * 
		 */
		public static function scaleDisplayObject(target:DisplayObject, width:Number, height:Number):void {
			if (target == null) {
				return;
			}
			if (width <= 0 && height <= 0) {
				return;
			}
			var scale:Number;
			if (width >= height) {
				scale = width / target.width;
			} else {
				scale = height / target.height;
			}
			target.scaleX = target.scaleY = scale;
		}
	}
}
