import 'package:flutter/material.dart';
import 'package:phoenix_base/phoenix.dart';
import 'package:phoenix_picker/extension/picker_total_config.dart';

import 'base/picker_title.dart';
import 'base/picker_title_config.dart';
import 'picker_cliprrect.dart';

/// 该picker用于显示自定的底部弹出框: 对话框结构如下：
///              column
///             /      \
///            /       \
///     (透明的上半部)   column(下半部)
///                   /           \
///                  /             \
///            确认取消标题栏       show方法传入的widget(因此传入的contentwidget 需要满足column的布局规则)
/// 显示的视图：标题(标准的)+内容(自定义的content)
/// contentWidget 底部对话框的内容区的widget
/// title 默认文本为 请选择
/// confirm 底部对话框的确认，可以是widget，也可以是String，容错处理是文本 确认
/// cancel 底部对话框的取消，可以是widget，也可以是String， 容错处理是文本 取消
/// onConfirmPressed 点击确定的回调 如果不设置 则关闭picker 需要使用者去关闭picker
/// onCancelPressed 点击取消的回调 如果不设置 则关闭picker
/// barrierDismissible 点击对话框外部 是否取消对话框
class BottomPicker {
  static void show(
    BuildContext context, {
    required contentWidget,
    String title = '请选择',
    dynamic confirm,
    dynamic cancel,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
    bool showTitle = true,
  }) {
    final ThemeData theme = Theme.of(context);
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        final Widget pageChild = BottomPickerWidget(
          contentWidget: contentWidget,
          confirm: confirm,
          cancel: cancel,
          onConfirmPressed: onConfirm,
          onCancelPressed: onCancel,
          barrierDismissible: barrierDismissible,
          pickerTitleConfig: PickerTitleConfig(
            titleContent: title,
            showTitle: showTitle,
          ),
        );
        return Theme(data: theme, child: pageChild);
      },
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 150),
      transitionBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: child,
        );
      },
      useRootNavigator: true,
    );
  }
}

class BottomPickerWidget extends StatefulWidget {
  final Widget contentWidget;
  final dynamic confirm;
  final dynamic cancel;
  final Function()? onConfirmPressed;
  final Function()? onCancelPressed;
  final bool barrierDismissible;
  final PickerTitleConfig pickerTitleConfig;

  const BottomPickerWidget({
    Key? key,
    required this.contentWidget,
    this.confirm,
    this.cancel,
    this.onConfirmPressed,
    this.onCancelPressed,
    this.barrierDismissible = true,
    this.pickerTitleConfig = PickerTitleConfig.Default,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BottomPickerWidgetState();
  }
}

class BottomPickerWidgetState extends State<BottomPickerWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    //用于动画
    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _animation = Tween(end: Offset.zero, begin: const Offset(0.0, 1.0))
        .animate(_controller);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _controller.reverse();
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0x33999999),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(child: _buildTopWidget()),
            _buildBottomWidget(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildBottomWidget() {
    return SlideTransition(
      position: _animation as Animation<Offset>,
      child: PickerClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
              BaseThemeConfig.instance.getConfig().pickerConfig.cornerRadius),
          topRight: Radius.circular(
              BaseThemeConfig.instance.getConfig().pickerConfig.cornerRadius),
        ),
        child: Container(
          color: Colors.white,
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Offstage(
                offstage: !widget.pickerTitleConfig.showTitle,
                child: _buildTitleWidget(),
              ),
              SafeArea(top: false, child: widget.contentWidget),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleWidget() {
    return PickerTitle(
      onCancel: () {
        if (widget.onCancelPressed == null) {
          _closeDialog();
        } else {
          widget.onCancelPressed!();
        }
      },
      onConfirm: () {
        if (widget.onConfirmPressed == null) {
          _closeDialog();
        } else {
          widget.onConfirmPressed!();
        }
      },
      pickerTitleConfig: widget.pickerTitleConfig.copyWith(
        cancel: _buildCancelWidget(),
        confirm: _buildConfirmWidget(),
      ),
    );
  }

  Widget? _buildConfirmWidget() {
    Widget? confirmWidget;
    if (widget.confirm is Widget) {
      confirmWidget = widget.confirm;
    } else if (widget.confirm is String) {
      confirmWidget = _buildDefaultConfirm(widget.confirm);
    } else {
      confirmWidget =
          _buildDefaultConfirm(BrnIntl.of(context).localizedResource.confirm);
    }
    return confirmWidget;
  }

  Widget? _buildCancelWidget() {
    Widget? cancelWidget;
    if (widget.cancel is Widget) {
      cancelWidget = widget.cancel;
    } else if (widget.cancel is String) {
      cancelWidget = _buildDefaultCancel(widget.cancel);
    } else {
      cancelWidget =
          _buildDefaultCancel(BrnIntl.of(context).localizedResource.cancel);
    }
    return cancelWidget;
  }

  Widget _buildDefaultConfirm(String string) {
    return Text(
      string,
      style: TextStyle(
          color: BaseThemeConfig.instance.getConfig().commonConfig.brandPrimary,
          fontSize: 16.0),
      textAlign: TextAlign.right,
    );
  }

  Widget _buildDefaultCancel(String? string) {
    return Text(
      string ?? BrnIntl.of(context).localizedResource.cancel,
      style: TextStyle(
          color:
              BaseThemeConfig.instance.getConfig().commonConfig.colorTextBase,
          fontSize: 16.0),
      textAlign: TextAlign.right,
    );
  }

  Widget _buildTopWidget() {
    return GestureDetector(
      onTap: () {
        if (widget.barrierDismissible) {
          _closeDialog();
        }
      },
      child: Container(
        color: const Color(0x33999999),
      ),
    );
  }

  void _closeDialog() {
    Navigator.of(context).maybePop();
  }
}
