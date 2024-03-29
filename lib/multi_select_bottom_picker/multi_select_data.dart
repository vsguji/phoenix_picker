/// 底部多选 Picker 数据类
class MultiSelectBottomPickerItem {
  /// 选项编号
  String code;

  /// 选项内容
  String content;

  /// 是否选中
  bool isChecked;

  MultiSelectBottomPickerItem(this.code, this.content,
      {this.isChecked = false});
}
