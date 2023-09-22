/*
 * @Author: lipeng 1162423147@qq.com
 * @Date: 2023-07-24 14:22:29
 * @LastEditors: lipeng 1162423147@qq.com
 * @LastEditTime: 2023-09-22 22:13:06
 * @FilePath: /phoenix_picker/lib/base/brn_picker_title_config.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:flutter/material.dart';

import 'picker_constants.dart';

class PickerTitleConfig {
  /// DateTimePicker theme.
  ///
  /// [cancel] Custom cancel widget.
  /// [confirm] Custom confirm widget.
  /// [title] Custom title widget. If specify a title widget, the cancel and confirm widgets will not display. Must set [titleHeight] value for custom title widget.
  /// [showTitle] Whether display title widget or not. If set false, the default cancel and confirm widgets will not display, but the custom title widget will display if had specified one custom title widget.
  /// [titleContent] Title content
  const PickerTitleConfig({
    this.cancel,
    this.confirm,
    this.title,
    this.showTitle = pickerShowTitleDefault,
    this.titleContent,
  });

  static const PickerTitleConfig Default = const PickerTitleConfig();

  /// Custom cancel [Widget].
  final Widget? cancel;

  /// Custom confirm [Widget].
  final Widget? confirm;

  /// Custom title [Widget]. If specify a title widget, the cancel and confirm widgets will not display.
  final Widget? title;

  /// Whether display title widget or not. If set false, the default cancel and confirm widgets will not display, but the custom title widget will display if had specified one custom title widget.
  final bool showTitle;

  final String? titleContent;

  PickerTitleConfig copyWith({
    Widget? cancel,
    Widget? confirm,
    Widget? title,
    bool? showTitle,
    String? titleContent,
  }) {
    return PickerTitleConfig(
      cancel: cancel ?? this.cancel,
      confirm: confirm ?? this.confirm,
      title: title ?? this.title,
      showTitle: showTitle ?? this.showTitle,
      titleContent: titleContent ?? this.titleContent,
    );
  }
}
