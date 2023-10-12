/*
 * @Author: lipeng 1162423147@qq.com
 * @Date: 2023-08-31 14:41:55
 * @LastEditors: lipeng 1162423147@qq.com
 * @LastEditTime: 2023-09-22 22:54:33
 * @FilePath: /phoenix_picker/lib/multi_range_picker/brn_multi_column_converter.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:phoenix_base/phoenix.dart';

import 'bean/multi_column_picker_entity.dart';
import 'multi_column_picker_util.dart';

class MultiRangeSelConverter {
  const MultiRangeSelConverter();

  Map<String, List<PickerEntity>> convertPickedData(
      List<PickerEntity> selectedResults,
      {bool includeUnlimitSelection = false}) {
    return getSelectionParams(selectedResults,
        includeUnlimitSelection: includeUnlimitSelection);
  }

  Map<String, List<PickerEntity>> getSelectionParams(
      List<PickerEntity>? selectedResults,
      {bool includeUnlimitSelection = false}) {
    Map<String, List<PickerEntity>> params = Map();
    if (selectedResults == null) return params;
    for (PickerEntity menuItemEntity in selectedResults) {
      int levelCount =
          MultiColumnPickerUtil.getTotalColumnCount(menuItemEntity);
      if (levelCount == 1) {
        params.addAll(getCurrentSelectionEntityParams(menuItemEntity,
            includeUnlimitSelection: includeUnlimitSelection));
      } else if (levelCount == 2) {
        params.addAll(getCurrentSelectionEntityParams(menuItemEntity,
            includeUnlimitSelection: includeUnlimitSelection));
        menuItemEntity.children.forEach((firstLevelItem) => mergeParams(
            params,
            getCurrentSelectionEntityParams(firstLevelItem,
                includeUnlimitSelection: includeUnlimitSelection)));
      } else if (levelCount == 3) {
        params.addAll(getCurrentSelectionEntityParams(menuItemEntity,
            includeUnlimitSelection: includeUnlimitSelection));
        menuItemEntity.children.forEach((firstLevelItem) {
          mergeParams(
              params,
              getCurrentSelectionEntityParams(firstLevelItem,
                  includeUnlimitSelection: includeUnlimitSelection));
          firstLevelItem.children.forEach((secondLevelItem) {
            mergeParams(
                params,
                getCurrentSelectionEntityParams(secondLevelItem,
                    includeUnlimitSelection: includeUnlimitSelection));
          });
        });
      }
    }
    return params;
  }

  Map<String?, List<PickerEntity>> mergeParams(
      Map<String?, List<PickerEntity>> params,
      Map<String?, List<PickerEntity>> selectedParams) {
    selectedParams.forEach((String? key, List<PickerEntity> value) {
      if (params.containsKey(key)) {
        params[key]?.addAll(value);
      } else {
        params.addAll(selectedParams);
      }
    });
    return params;
  }

  Map<String, List<PickerEntity>> getCurrentSelectionEntityParams(
      PickerEntity selectionEntity,
      {bool includeUnlimitSelection = false}) {
    Map<String, List<PickerEntity>> params = Map();
    String parentKey = selectionEntity.key ?? '';
    var selectedEntity = selectionEntity.children
        .where((PickerEntity f) => f.isSelected)
        .where((PickerEntity f) {
          if (includeUnlimitSelection) {
            return true;
          } else {
            return !PhoenixTools.isEmpty(f.value);
          }
        })
        .map((PickerEntity f) => f)
        .toList();
    List<PickerEntity> selectedParams = selectedEntity;
    if (!PhoenixTools.isEmpty(selectedParams) &&
        !PhoenixTools.isEmpty(parentKey)) {
      params[parentKey] = selectedParams;
    }
    return params;
  }
}
