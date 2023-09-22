import 'package:flutter/material.dart';
import 'package:phoenix_base/phoenix.dart';
import 'package:phoenix_picker/extension/picker_total_config.dart';

import 'base/picker_title.dart';
import 'base/picker_title_config.dart';
import 'picker_cliprrect.dart';
import 'config/picker_config.dart';

enum BrnCommonPickBackType {
  cancel,
  confirm,
}

typedef TagsPickerContentBuilder = Widget Function(
    BuildContext context, VoidCallback? onUpdate);

/// 创建时传入Builder 或者 子类实现 createBuilder 函数
// ignore: must_be_immutable
abstract class CommonTagsPicker extends StatefulWidget {
  final BuildContext context;
  final ValueChanged? onConfirm;
  final VoidCallback? onCancel;
  final TagsPickerContentBuilder? contentBuilder;
  final PickerTitleConfig pickerTitleConfig;

  PickerConfig? themeData;

  CommonTagsPicker(
      {Key? key,
      required this.context,
      this.onConfirm,
      this.onCancel,
      this.contentBuilder,
      this.pickerTitleConfig = PickerTitleConfig.Default,
      this.themeData})
      : super(key: key) {
    themeData ??= PickerConfig();
    themeData = BaseThemeConfig.instance
        .getConfig(configId: themeData!.configId)
        .pickerConfig
        .merge(themeData);
  }

  void show() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return this;
        }).then((type) {
      if (type == BrnCommonPickBackType.confirm) {
        if (onConfirm != null) {
          onConfirm!(getConfirmData());
        }
      } else {
        if (onCancel != null) {
          onCancel!();
        }
      }
    });
  }

  /// 子类重写实现builder
  @protected
  Widget? createBuilder(BuildContext context, VoidCallback? onUpdate) {
    return null;
  }

  /// 子类需重写getConfirmData()函数，直接使用LJTagsPickerWidget类时忽略
  @protected
  Object getConfirmData();

  @override
  _CommonPickerState createState() => _CommonPickerState();
}

class _CommonPickerState extends State<CommonTagsPicker> {
  VoidCallback? _onUpdate;

  @override
  void initState() {
    super.initState();
    _onUpdate = () {
      setState(() {
        /*刷新*/
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return PickerClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(
            BaseThemeConfig.instance.getConfig().pickerConfig.cornerRadius),
        topRight: Radius.circular(
            BaseThemeConfig.instance.getConfig().pickerConfig.cornerRadius),
      ),
      child: Container(
          color: Colors.white,
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(minHeight: 168.0, maxHeight: 370.0),
            child: Stack(
              children: <Widget>[
                _createContentWidget(),
                _createHeaderWidget(), // 保证头视图在Stack的最上层
              ],
            ),
          )),
    );
  }

  // 创建头部视图
  Widget _createHeaderWidget() {
    return PickerTitle(
      pickerTitleConfig: widget.pickerTitleConfig,
      themeData: widget.themeData,
      onCancel: () {
        Navigator.of(widget.context).pop(BrnCommonPickBackType.cancel);
      },
      onConfirm: () {
        Navigator.of(widget.context).pop(BrnCommonPickBackType.confirm);
      },
    );
  }

  /// 创建内容视图
  Widget _createContentWidget() {
    Widget? contentWidget;
    if (widget.contentBuilder != null) {
      contentWidget = widget.contentBuilder!(context, _onUpdate);
    } else {
      contentWidget = widget.createBuilder(context, _onUpdate);
    }
    contentWidget ??= const SizedBox(
      height: 200.0,
      child: Center(
        child: Text('未配置数据'),
      ),
    );
    return Container(
      padding: EdgeInsets.only(top: widget.themeData!.titleHeight), // 流出头部视图
      child: ListView(
        shrinkWrap: true, // 列表高度自适应
        controller: ScrollController(keepScrollOffset: false), // 若视图小于弹窗则不滑动
        children: <Widget>[contentWidget],
      ),
    );
  }
}
