import 'package:flutter/painting.dart';
import 'package:phoenix_base/phoenix.dart';
import 'package:phoenix_picker/extension/picker_total_config.dart';

import '../extension/picker_default_config_utils.dart';

/// 标签配置类
class TagConfig extends BaseConfig {
  TagConfig({
    BaseTextStyle? tagTextStyle,
    BaseTextStyle? selectTagTextStyle,
    double? tagRadius,
    Color? tagBackgroundColor,
    Color? selectedTagBackgroundColor,
    double? tagHeight,
    double? tagWidth,
    double? tagMinWidth,
    String configId = GLOBAL_CONFIG_ID,
  })  : _tagTextStyle = tagTextStyle,
        _selectTagTextStyle = selectTagTextStyle,
        _tagRadius = tagRadius,
        _tagBackgroundColor = tagBackgroundColor,
        _selectedTagBackgroundColor = selectedTagBackgroundColor,
        _tagHeight = tagHeight,
        _tagWidth = tagWidth,
        _tagMinWidth = tagMinWidth,
        super(configId: configId);

  /// tag 文本样式
  ///
  /// BaseTextStyle(
  ///   color: [BrnCommonConfig.colorTextBase],
  ///   fontSize: [BrnCommonConfig.fontSizeCaption],
  /// )
  BaseTextStyle? _tagTextStyle;

  /// tag选中文本样式
  ///
  /// BaseTextStyle(
  ///   color: [BrnCommonConfig.brandPrimary],
  ///   fontSize: [BrnCommonConfig.fontSizeCaption],
  ///   fontWeight: FontWeight.w600,
  /// )
  BaseTextStyle? _selectTagTextStyle;

  /// 标签背景色
  /// default [BrnCommonConfig.fillBody]
  Color? _tagBackgroundColor;

  /// 选中背景色
  /// default [BrnCommonConfig.brandPrimary]
  Color? _selectedTagBackgroundColor;

  /// 标签圆角
  /// 默认为 [BrnCommonConfig.radiusXs]
  double? _tagRadius;

  /// 标签高度，跟 fixWidthMode 无关
  /// 默认为 34
  double? _tagHeight;

  /// 标签宽度，且仅在组件设置了固定宽度（fixWidthMode 为 true）时才生效
  /// 默认为 75
  double? _tagWidth;

  /// 标签最小宽度
  /// 默认为 75
  double? _tagMinWidth;

  BaseTextStyle get tagTextStyle =>
      _tagTextStyle ?? BasePickerConfigUtils.defaultTagConfig.tagTextStyle;

  BaseTextStyle get selectTagTextStyle =>
      _selectTagTextStyle ??
      BasePickerConfigUtils.defaultTagConfig.selectTagTextStyle;

  Color get tagBackgroundColor =>
      _tagBackgroundColor ??
      BasePickerConfigUtils.defaultTagConfig.tagBackgroundColor;

  Color get selectedTagBackgroundColor =>
      _selectedTagBackgroundColor ??
      BasePickerConfigUtils.defaultTagConfig.selectedTagBackgroundColor;

  double get tagRadius =>
      _tagRadius ?? BasePickerConfigUtils.defaultTagConfig.tagRadius;

  double get tagHeight =>
      _tagHeight ?? BasePickerConfigUtils.defaultTagConfig.tagHeight;

  double get tagWidth =>
      _tagWidth ?? BasePickerConfigUtils.defaultTagConfig.tagWidth;

  double get tagMinWidth =>
      _tagMinWidth ?? BasePickerConfigUtils.defaultTagConfig.tagMinWidth;

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
    TagConfig tagConfig =
        BaseThemeConfig.instance.getConfig(configId: configId).tagConfig;

    _tagHeight ??= tagConfig._tagHeight;
    _tagWidth ??= tagConfig._tagWidth;
    _tagMinWidth ??= tagConfig._tagMinWidth;
    _tagRadius ??= commonConfig.radiusXs;
    _tagBackgroundColor ??= commonConfig.fillBody;
    _selectedTagBackgroundColor ??= commonConfig.brandPrimary;
    _tagTextStyle = tagConfig.tagTextStyle.merge(
      BaseTextStyle(
        color: commonConfig.colorTextBase,
        fontSize: commonConfig.fontSizeCaption,
      ).merge(_tagTextStyle),
    );
    _selectTagTextStyle = tagConfig.selectTagTextStyle.merge(
      BaseTextStyle(
        color: commonConfig.brandPrimary,
        fontSize: commonConfig.fontSizeCaption,
      ).merge(_selectTagTextStyle),
    );
  }

  TagConfig copyWith({
    BaseTextStyle? textStyle,
    BaseTextStyle? selectTextStyle,
    double? radius,
    Color? backgroundColor,
    Color? selectedBackgroundColor,
    double? height,
    double? width,
    double? tagMinWidth,
  }) {
    return TagConfig(
      tagTextStyle: textStyle ?? _tagTextStyle,
      selectTagTextStyle: selectTextStyle ?? _selectTagTextStyle,
      tagRadius: radius ?? _tagRadius,
      tagBackgroundColor: backgroundColor ?? _tagBackgroundColor,
      selectedTagBackgroundColor:
          selectedBackgroundColor ?? _selectedTagBackgroundColor,
      tagHeight: height ?? _tagHeight,
      tagWidth: width ?? _tagWidth,
      tagMinWidth: tagMinWidth ?? _tagMinWidth,
    );
  }

  TagConfig merge(TagConfig? other) {
    if (other == null) return this;
    return copyWith(
      textStyle: tagTextStyle.merge(other._tagTextStyle),
      selectTextStyle: selectTagTextStyle.merge(other._selectTagTextStyle),
      radius: other._tagRadius,
      backgroundColor: other._tagBackgroundColor,
      selectedBackgroundColor: other._selectedTagBackgroundColor,
      height: other._tagHeight,
      width: other._tagWidth,
      tagMinWidth: other._tagMinWidth,
    );
  }
}
