import 'package:flutter/material.dart';
import 'package:phoenix_base/phoenix.dart';
import 'package:phoenix_picker/extension/picker_total_config.dart';

import '../extension/picker_default_config_utils.dart';

/// 选择器配置
class PickerConfig extends BaseConfig {
  /// 遵循外部主题配置
  /// 默认为 [BasePickerConfigUtils.defaultPickerConfig]
  PickerConfig({
    Color? backgroundColor,
    BaseTextStyle? cancelTextStyle,
    BaseTextStyle? confirmTextStyle,
    BaseTextStyle? titleTextStyle,
    double? pickerHeight,
    double? titleHeight,
    double? itemHeight,
    BaseTextStyle? itemTextStyle,
    BaseTextStyle? itemTextSelectedStyle,
    Color? dividerColor,
    double? cornerRadius,
    String configId = GLOBAL_CONFIG_ID,
  })  : _backgroundColor = backgroundColor,
        _cancelTextStyle = cancelTextStyle,
        _confirmTextStyle = confirmTextStyle,
        _titleTextStyle = titleTextStyle,
        _pickerHeight = pickerHeight,
        _titleHeight = titleHeight,
        _itemHeight = itemHeight,
        _itemTextStyle = itemTextStyle,
        _itemTextSelectedStyle = itemTextSelectedStyle,
        _dividerColor = dividerColor,
        _cornerRadius = cornerRadius,
        super(configId: configId);

  /// 日期选择器的背景色
  /// 默认为 [PICKER_BACKGROUND_COLOR]
  Color? _backgroundColor;

  /// 取消文字的样式
  ///
  /// BaseTextStyle(
  ///   color: [BrnCommonConfig.colorTextBase],
  ///   fontSize: [BrnCommonConfig.fontSizeSubHead],
  /// )
  BaseTextStyle? _cancelTextStyle;

  /// 确认文字的样式
  ///
  /// BaseTextStyle(
  ///   color: [BrnCommonConfig.brandPrimary],
  ///   fontSize: [BrnCommonConfig.fontSizeSubHead],
  /// )
  BaseTextStyle? _confirmTextStyle;

  /// 标题文字的样式
  ///
  /// BaseTextStyle(
  ///   color: [BrnCommonConfig.colorTextBase],
  ///   fontSize: [BrnCommonConfig.fontSizeSubHead],
  ///   fontWidget:FontWeight.w600,
  /// )
  BaseTextStyle? _titleTextStyle;

  /// 日期选择器的高度
  /// 默认为 [PICKER_HEIGHT]
  double? _pickerHeight;

  /// 日期选择器标题的高度
  /// 默认为 [PICKER_TITLE_HEIGHT]
  double? _titleHeight;

  /// 日期选择器列表的高度
  /// 默认为 [PICKER_ITEM_HEIGHT]
  double? _itemHeight;

  /// 日期选择器列表的文字样式
  ///
  /// BaseTextStyle(
  ///   color: [BrnCommonConfig.colorTextBase],
  ///   fontSize: [BrnCommonConfig.fontSizeHead],
  /// )
  BaseTextStyle? _itemTextStyle;

  /// 日期选择器列表选中的文字样式
  ///
  /// BaseTextStyle(
  ///   color: [BrnCommonConfig.brandPrimary],
  ///   fontSize: [BrnCommonConfig.fontSizeHead],
  ///   fontWidget: FontWeight.w600,
  /// )
  BaseTextStyle? _itemTextSelectedStyle;

  Color? _dividerColor;
  double? _cornerRadius;

  Color get backgroundColor =>
      _backgroundColor ??
      BasePickerConfigUtils.defaultPickerConfig.backgroundColor;

  BaseTextStyle get cancelTextStyle =>
      _cancelTextStyle ??
      BasePickerConfigUtils.defaultPickerConfig.cancelTextStyle;

  BaseTextStyle get confirmTextStyle =>
      _confirmTextStyle ??
      BasePickerConfigUtils.defaultPickerConfig.confirmTextStyle;

  BaseTextStyle get titleTextStyle =>
      _titleTextStyle ??
      BasePickerConfigUtils.defaultPickerConfig.titleTextStyle;

  double get pickerHeight =>
      _pickerHeight ?? BasePickerConfigUtils.defaultPickerConfig.pickerHeight;

  double get titleHeight =>
      _titleHeight ?? BasePickerConfigUtils.defaultPickerConfig.titleHeight;

  double get itemHeight =>
      _itemHeight ?? BasePickerConfigUtils.defaultPickerConfig.itemHeight;

  BaseTextStyle get itemTextStyle =>
      _itemTextStyle ?? BasePickerConfigUtils.defaultPickerConfig.itemTextStyle;

  BaseTextStyle get itemTextSelectedStyle =>
      _itemTextSelectedStyle ??
      BasePickerConfigUtils.defaultPickerConfig.itemTextSelectedStyle;

  Color get dividerColor =>
      _dividerColor ?? BasePickerConfigUtils.defaultPickerConfig.dividerColor;

  double get cornerRadius =>
      _cornerRadius ?? BasePickerConfigUtils.defaultPickerConfig.cornerRadius;

  @override
  void initThemeConfig(
    String configId, {
    BaseCommonConfig? currentLevelCommonConfig,
  }) {
    super.initThemeConfig(
      configId,
      currentLevelCommonConfig: currentLevelCommonConfig,
    );

    /// 用户全局组件配置
    PickerConfig pickerConfig =
        BaseThemeConfig.instance.getConfig(configId: configId).pickerConfig;

    _backgroundColor ??= pickerConfig.backgroundColor;
    _pickerHeight ??= pickerConfig.pickerHeight;
    _titleHeight ??= pickerConfig.titleHeight;
    _itemHeight ??= pickerConfig.itemHeight;
    _dividerColor ??= pickerConfig.dividerColor;
    _cornerRadius ??= pickerConfig.cornerRadius;
    _titleTextStyle = pickerConfig.titleTextStyle.merge(
      BaseTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_titleTextStyle),
    );
    _cancelTextStyle = pickerConfig.cancelTextStyle
        .merge(
          BaseTextStyle(
            color: commonConfig.colorTextBase,
            fontSize: commonConfig.fontSizeSubHead,
          ),
        )
        .merge(_cancelTextStyle);
    _confirmTextStyle = pickerConfig.confirmTextStyle.merge(
      BaseTextStyle(
        color: commonConfig.brandPrimary,
        fontSize: commonConfig.fontSizeSubHead,
      ).merge(_confirmTextStyle),
    );
    _itemTextStyle = pickerConfig.itemTextStyle.merge(
      BaseTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeHead,
      ).merge(_itemTextStyle),
    );
    _itemTextSelectedStyle = pickerConfig.itemTextSelectedStyle.merge(
      BaseTextStyle(
        color: commonConfig.brandPrimary,
        fontSize: commonConfig.fontSizeHead,
      ).merge(_itemTextSelectedStyle),
    );
  }

  PickerConfig copyWith({
    Color? backgroundColor,
    BaseTextStyle? cancelTextStyle,
    BaseTextStyle? confirmTextStyle,
    BaseTextStyle? titleTextStyle,
    double? pickerHeight,
    double? titleHeight,
    double? itemHeight,
    BaseTextStyle? itemTextStyle,
    BaseTextStyle? itemTextSelectedStyle,
    Color? dividerColor,
    double? cornerRadius,
  }) {
    return PickerConfig(
      backgroundColor: backgroundColor ?? _backgroundColor,
      cancelTextStyle: cancelTextStyle ?? _cancelTextStyle,
      confirmTextStyle: confirmTextStyle ?? _confirmTextStyle,
      titleTextStyle: titleTextStyle ?? _titleTextStyle,
      pickerHeight: pickerHeight ?? _pickerHeight,
      titleHeight: titleHeight ?? _titleHeight,
      itemHeight: itemHeight ?? _itemHeight,
      itemTextStyle: itemTextStyle ?? _itemTextStyle,
      itemTextSelectedStyle: itemTextSelectedStyle ?? _itemTextSelectedStyle,
      dividerColor: dividerColor ?? _dividerColor,
      cornerRadius: cornerRadius ?? _cornerRadius,
    );
  }

  PickerConfig merge(PickerConfig? other) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other._backgroundColor,
      cancelTextStyle: cancelTextStyle.merge(other._cancelTextStyle),
      confirmTextStyle: confirmTextStyle.merge(other._confirmTextStyle),
      titleTextStyle: titleTextStyle.merge(other._titleTextStyle),
      pickerHeight: other._pickerHeight,
      titleHeight: other._titleHeight,
      itemHeight: other._itemHeight,
      itemTextStyle: itemTextStyle.merge(other._itemTextStyle),
      itemTextSelectedStyle:
          itemTextSelectedStyle.merge(other._itemTextSelectedStyle),
      dividerColor: other._dividerColor,
      cornerRadius: other._cornerRadius,
    );
  }
}
