import 'package:flutter/material.dart';
import 'package:phoenix_base/phoenix.dart';

import '../base/picker_constants.dart';
import '../config/tag_config.dart';
import '../config/picker_config.dart';

///
extension BasePickerConfigUtils on BaseDefaultConfigUtils {
  // 选择器配置
  static PickerConfig defaultPickerConfig = PickerConfig(
    backgroundColor: pickerBackgroundColor,
    cancelTextStyle: BaseTextStyle(
      color: BaseDefaultConfigUtils.defaultCommonConfig.colorTextBase,
      fontSize: BaseDefaultConfigUtils.defaultCommonConfig.fontSizeSubHead,
    ),
    confirmTextStyle: BaseTextStyle(
      color: BaseDefaultConfigUtils.defaultCommonConfig.brandPrimary,
      fontSize: BaseDefaultConfigUtils.defaultCommonConfig.fontSizeSubHead,
    ),
    titleTextStyle: BaseTextStyle(
      color: BaseDefaultConfigUtils.defaultCommonConfig.colorTextBase,
      fontSize: BaseDefaultConfigUtils.defaultCommonConfig.fontSizeSubHead,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.none,
    ),
    pickerHeight: pickerHeight,
    titleHeight: pickerTitleHeight,
    itemHeight: pickerItemHeight,
    dividerColor: const Color(0xFFF0F0F0),
    itemTextStyle: BaseTextStyle(
      color: BaseDefaultConfigUtils.defaultCommonConfig.colorTextBase,
      fontSize: BaseDefaultConfigUtils.defaultCommonConfig.fontSizeHead,
    ),
    itemTextSelectedStyle: BaseTextStyle(
      color: BaseDefaultConfigUtils.defaultCommonConfig.brandPrimary,
      fontSize: BaseDefaultConfigUtils.defaultCommonConfig.fontSizeHead,
      fontWeight: FontWeight.w600,
    ),
    cornerRadius: 8,
  );

  /// 标签配置
  static TagConfig defaultTagConfig = TagConfig(
    tagTextStyle: BaseTextStyle(
      color: BaseDefaultConfigUtils.defaultCommonConfig.colorTextBase,
      fontSize: BaseDefaultConfigUtils.defaultCommonConfig.fontSizeCaption,
    ),
    selectTagTextStyle: BaseTextStyle(
      fontWeight: FontWeight.w600,
      color: BaseDefaultConfigUtils.defaultCommonConfig.brandPrimary,
      fontSize: BaseDefaultConfigUtils.defaultCommonConfig.fontSizeCaption,
    ),
    tagBackgroundColor: BaseDefaultConfigUtils.defaultCommonConfig.fillBody,
    selectedTagBackgroundColor:
        BaseDefaultConfigUtils.defaultCommonConfig.brandPrimary,
    tagRadius: BaseDefaultConfigUtils.defaultCommonConfig.radiusXs,
    tagHeight: 34.0,
    tagWidth: 75.0,
    tagMinWidth: 75.0,
  );
}
