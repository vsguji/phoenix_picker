/*
 * @Author: lipeng 1162423147@qq.com
 * @Date: 2023-08-31 14:41:55
 * @LastEditors: lipeng 1162423147@qq.com
 * @LastEditTime: 2023-09-22 22:59:53
 * @FilePath: /phoenix_picker/lib/multi_range_picker/multi_column_picker_util.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'bean/multi_column_picker_entity.dart';

/// BrnMultiColumnPicker相关工具类
class MultiColumnPickerUtil {
  /// 筛选项最多不超过三层,故直接写代码判断,本质为深度优先搜索。
  static int getTotalColumnCount(BrnPickerEntity? entity) {
    int count = 0;
    BrnPickerEntity? rootEntity = entity;
    while (rootEntity?.parent != null) {
      rootEntity = rootEntity?.parent!;
    }

    if (rootEntity != null && rootEntity.children.isNotEmpty) {
      count = count > 1 ? count : 1;
      for (BrnPickerEntity firstLevelEntity in rootEntity.children) {
        if (firstLevelEntity.children.isNotEmpty) {
          count = count > 2 ? count : 2;
          for (BrnPickerEntity secondLevelEntity in firstLevelEntity.children) {
            if (secondLevelEntity.children.isNotEmpty) {
              count = 3;
              break;
            }
          }
        }
      }
    }
    return count;
  }

  /// 确定当前 Item 在第几层级
  static int getCurrentColumnIndex(BrnPickerEntity? currentItem) {
    int listIndex = -1;
    if (currentItem != null) {
      listIndex = 0;
      var parent = currentItem.parent;
      while (parent != null) {
        listIndex++;
        parent = parent.parent;
      }
    }
    return listIndex;
  }

  ///
  /// [entity] 传入当前点击的 Item
  /// !!! 在设置 isSelected = true之前进行 check。
  /// 返回 true 符合条件，false 不符合条件
  static bool isSelectedCountExceed(BrnPickerEntity? entity) {
    if (entity == null || entity.parent == null) return false;
    return entity.parent!.getSelectedChildCount() <
        entity.parent!.maxSelectedCount;
  }
}
