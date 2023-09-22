import 'dart:math';
import 'package:flutter/material.dart';
import 'package:phoenix_base/phoenix.dart';
import 'package:phoenix_picker/extension/picker_total_config.dart';

import '../../base/picker.dart';
import '../../base/picker_title.dart';
import '../../base/picker_title_config.dart';
import '../../config/picker_config.dart';
import '../date_picker_constants.dart';
import '../date_time_formatter.dart';

/// TimePicker widget.

enum ColumnTimeType { hour, minute, second }

/// BrnTimeWidget widget. Can display time picker
// ignore: must_be_immutable
class TimeWidget extends StatefulWidget {
  TimeWidget({
    Key? key,
    this.minDateTime,
    this.maxDateTime,
    this.initDateTime,
    this.dateFormat = datetimePickerTimeFormat,
    this.pickerTitleConfig = PickerTitleConfig.Default,
    this.minuteDivider = 1,
    this.onCancel,
    this.onChange,
    this.onConfirm,
    this.themeData,
  }) : super(key: key) {
    DateTime minTime = minDateTime ?? DateTime.parse(datePickerMinDatetime);
    DateTime maxTime = maxDateTime ?? DateTime.parse(datePickerMaxDatetime);
    assert(minTime.compareTo(maxTime) < 0);
    themeData ??= PickerConfig();
    themeData = BaseThemeConfig.instance
        .getConfig(configId: themeData!.configId)
        .pickerConfig
        .merge(themeData);
  }

  final DateTime? minDateTime, maxDateTime, initDateTime;
  final String? dateFormat;
  final PickerTitleConfig pickerTitleConfig;
  final DateVoidCallback? onCancel;
  final DateValueCallback? onChange, onConfirm;
  final int? minuteDivider;

  PickerConfig? themeData;

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() =>
      _TimeWidgetState(minDateTime, maxDateTime, initDateTime, minuteDivider);
}

class _TimeWidgetState extends State<TimeWidget> {
  static int _defaultMinuteDivider = 1;

  late DateTime _minTime, _maxTime;
  late int _currHour, _currMinute, _currSecond;
  late int _minuteDivider;
  late List<int> _hourRange, _minuteRange, _secondRange;
  late FixedExtentScrollController _hourScrollCtrl,
      _minuteScrollCtrl,
      _secondScrollCtrl;

  late Map<String, FixedExtentScrollController?> _scrollCtrlMap;
  late Map<String, List<int>> _valueRangeMap;

  bool _isChangeTimeRange = false;

  _TimeWidgetState(DateTime? minTime, DateTime? maxTime, DateTime? initTime,
      int? minuteDivider) {
    minTime ??= DateTime.parse(datePickerMinDatetime);
    maxTime ??= DateTime.parse(datePickerMaxDatetime);
    initTime ??= DateTime.now();
    _minTime = minTime;
    _maxTime = maxTime;
    _currHour = initTime.hour;
    _currMinute = initTime.minute;
    _currSecond = initTime.second;

    if (minuteDivider == null || minuteDivider <= 0) {
      _minuteDivider = _defaultMinuteDivider;
    } else {
      _minuteDivider = minuteDivider;
    }

    // limit the range of hour
    _hourRange = _calcHourRange();
    _currHour = min(max(_hourRange.first, _currHour), _hourRange.last);

    // limit the range of minute
    _minuteRange = _calcMinuteRange();
    _currMinute = min(max(_minuteRange.first, _currMinute), _minuteRange.last);
    _currMinute -= _currMinute % _minuteDivider;
    // limit the range of second
    _secondRange = _calcSecondRange();
    _currSecond = min(max(_secondRange.first, _currSecond), _secondRange.last);

    // create scroll controller
    _hourScrollCtrl =
        FixedExtentScrollController(initialItem: _currHour - _hourRange.first);
    _minuteScrollCtrl = FixedExtentScrollController(
        initialItem: (_currMinute - _minuteRange.first) ~/ _minuteDivider);
    _secondScrollCtrl = FixedExtentScrollController(
        initialItem: _currSecond - _secondRange.first);

    _scrollCtrlMap = {
      'H': _hourScrollCtrl,
      'm': _minuteScrollCtrl,
      's': _secondScrollCtrl
    };
    _valueRangeMap = {'H': _hourRange, 'm': _minuteRange, 's': _secondRange};
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Material(
          color: Colors.transparent, child: _renderPickerView(context)),
    );
  }

  /// render time picker widgets
  Widget _renderPickerView(BuildContext context) {
    Widget pickerWidget = _renderDatePickerWidget();

    // display the title widget
    if (widget.pickerTitleConfig.title != null ||
        widget.pickerTitleConfig.showTitle) {
      Widget titleWidget = PickerTitle(
        pickerTitleConfig: widget.pickerTitleConfig,
        onCancel: () => _onPressedCancel(),
        onConfirm: () => _onPressedConfirm(),
      );
      return Column(children: <Widget>[titleWidget, pickerWidget]);
    }
    return pickerWidget;
  }

  /// pressed cancel widget
  void _onPressedCancel() {
    if (widget.onCancel != null) {
      widget.onCancel!();
    }
    Navigator.pop(context);
  }

  /// pressed confirm widget
  void _onPressedConfirm() {
    if (widget.onConfirm != null) {
      DateTime now = DateTime.now();
      DateTime dateTime = DateTime(
          now.year, now.month, now.day, _currHour, _currMinute, _currSecond);
      widget.onConfirm!(dateTime, _calcSelectIndexList());
    }
    Navigator.pop(context);
  }

  /// notify selected time changed
  void _onSelectedChange() {
    if (widget.onChange != null) {
      DateTime now = DateTime.now();
      DateTime dateTime = DateTime(
          now.year, now.month, now.day, _currHour, _currMinute, _currSecond);
      widget.onChange!(dateTime, _calcSelectIndexList());
    }
  }

  /// find scroll controller by specified format
  FixedExtentScrollController? _findScrollCtrl(String format) {
    FixedExtentScrollController? scrollCtrl;
    _scrollCtrlMap.forEach((key, value) {
      if (format.contains(key)) {
        scrollCtrl = value;
      }
    });
    return scrollCtrl;
  }

  /// find item value range by specified format
  List<int>? _findPickerItemRange(String format) {
    List<int>? valueRange;
    _valueRangeMap.forEach((key, value) {
      if (format.contains(key)) {
        valueRange = value;
      }
    });
    return valueRange;
  }

  /// render the picker widget of year、month and day
  Widget _renderDatePickerWidget() {
    List<Widget> pickers = [];
    List<String> formatArr =
        DateTimeFormatter.splitDateFormat(widget.dateFormat);
    formatArr.forEach((format) {
      List<int>? valueRange = _findPickerItemRange(format);

      Widget pickerColumn = _renderDatePickerColumnComponent(
        scrollCtrl: _findScrollCtrl(format),
        valueRange: valueRange,
        format: format,
        valueChanged: (value) {
          if (format.contains('H')) {
            _changeHourSelection(value);
          } else if (format.contains('m')) {
            _changeMinuteSelection(value);
          } else if (format.contains('s')) {
            _changeSecondSelection(value);
          }
        },
      );
      pickers.add(pickerColumn);
    });
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, children: pickers);
  }

  Widget _renderDatePickerColumnComponent({
    required FixedExtentScrollController? scrollCtrl,
    required List<int>? valueRange,
    required String format,
    required ValueChanged<int> valueChanged,
  }) {
    return Expanded(
      flex: 1,
      child: Container(
        height: widget.themeData!.pickerHeight,
        decoration: BoxDecoration(color: widget.themeData!.backgroundColor),
        child: Picker.builder(
          backgroundColor: widget.themeData!.backgroundColor,
          lineColor: widget.themeData!.dividerColor,
          scrollController: scrollCtrl,
          itemExtent: widget.themeData!.itemHeight,
          onSelectedItemChanged: valueChanged,
          childCount: format.contains('m')
              ? _calculateMinuteChildCount(valueRange, _minuteDivider)
              : valueRange!.last - valueRange.first + 1,
          itemBuilder: (context, index) {
            int value = valueRange!.first + index;

            if (format.contains('m')) {
              value = _minuteDivider * index;
            }

            return _renderDatePickerItemComponent(
                getColumnType(format), index, value, format);
          },
        ),
      ),
    );
  }

  // ignore: missing_return
  ColumnTimeType? getColumnType(String format) {
    if (format.contains('H')) {
      return ColumnTimeType.hour;
    } else if (format.contains('m')) {
      return ColumnTimeType.minute;
    } else if (format.contains('s')) {
      return ColumnTimeType.second;
    }
    return null;
  }

  _calculateMinuteChildCount(List<int>? valueRange, int? divider) {
    if (divider == 0) {
      debugPrint("Cant devide by 0");
      return (valueRange!.last - valueRange.first + 1);
    }

    return (valueRange!.last - valueRange.first + 1) ~/ divider!;
  }

  Widget _renderDatePickerItemComponent(
      ColumnTimeType? columnType, int index, int value, String format) {
    TextStyle textStyle = widget.themeData!.itemTextStyle.generateTextStyle();
    if ((ColumnTimeType.hour == columnType &&
            index == _calcSelectIndexList()[0]) ||
        (ColumnTimeType.minute == columnType &&
            index == _calcSelectIndexList()[1]) ||
        (ColumnTimeType.second == columnType &&
            index == _calcSelectIndexList()[2])) {
      textStyle = widget.themeData!.itemTextSelectedStyle.generateTextStyle();
    }
    return Container(
      height: widget.themeData!.itemHeight,
      alignment: Alignment.center,
      child: Text(DateTimeFormatter.formatDateTime(value, format),
          style: textStyle),
    );
  }

  /// change the selection of hour picker
  void _changeHourSelection(int index) {
    int value = _hourRange.first + index;
    if (_currHour != value) {
      _currHour = value;
      _changeTimeRange();
      _onSelectedChange();
    }
  }

  /// change the selection of month picker
  void _changeMinuteSelection(int index) {
    int value = index * _minuteDivider;
    if (_currMinute != value) {
      _currMinute = value;
      _changeTimeRange();
      _onSelectedChange();
    }
  }

  /// change the selection of second picker
  void _changeSecondSelection(int index) {
    int value = _secondRange.first + index;
    if (_currSecond != value) {
      _currSecond = value;
      _changeTimeRange();
      _onSelectedChange();
    }
  }

  /// change range of minute and second
  void _changeTimeRange() {
    if (_isChangeTimeRange) {
      return;
    }
    _isChangeTimeRange = true;

    List<int> minuteRange = _calcMinuteRange();
    bool minuteRangeChanged = _minuteRange.first != minuteRange.first ||
        _minuteRange.last != minuteRange.last;
    if (minuteRangeChanged) {
      // selected hour changed
      _currMinute = max(min(_currMinute, minuteRange.last), minuteRange.first);
      _currMinute -= _currMinute % _minuteDivider;
    }

    List<int> secondRange = _calcSecondRange();
    bool secondRangeChanged = _secondRange.first != secondRange.first ||
        _secondRange.last != secondRange.last;
    if (secondRangeChanged) {
      // second range changed, need limit the value of selected second
      _currSecond = max(min(_currSecond, secondRange.last), secondRange.first);
    }

    setState(() {
      _minuteRange = minuteRange;
      _secondRange = secondRange;

      _valueRangeMap['m'] = minuteRange;
      _valueRangeMap['s'] = secondRange;
    });

    if (minuteRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      int currMinute = _currMinute;
      _minuteScrollCtrl
          .jumpToItem((minuteRange.last - minuteRange.first) ~/ _minuteDivider);
      if (currMinute < minuteRange.last) {
        _minuteScrollCtrl.jumpToItem(currMinute - minuteRange.first);
      }
    }

    if (secondRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      int currSecond = _currSecond;
      _secondScrollCtrl.jumpToItem(secondRange.last - secondRange.first);
      if (currSecond < secondRange.last) {
        _secondScrollCtrl.jumpToItem(currSecond - secondRange.first);
      }
    }

    _isChangeTimeRange = false;
  }

  /// calculate selected index list
  List<int> _calcSelectIndexList() {
    int hourIndex = _currHour - _hourRange.first;
    int minuteIndex = (_currMinute - _minuteRange.first) ~/ _minuteDivider;
    int secondIndex = _currSecond - _secondRange.first;
    return [hourIndex, minuteIndex, secondIndex];
  }

  /// calculate the range of hour
  List<int> _calcHourRange() {
    return [_minTime.hour, _maxTime.hour];
  }

  /// calculate the range of minute
  List<int> _calcMinuteRange({currHour}) {
    int minMinute = 0, maxMinute = 59;
    int minHour = _minTime.hour;
    int maxHour = _maxTime.hour;
    currHour ??= _currHour;

    if (minHour == currHour) {
      // selected minimum hour, limit minute range
      minMinute = _minTime.minute;
    }
    if (maxHour == currHour) {
      // selected maximum hour, limit minute range
      maxMinute = _maxTime.minute;
    }
    return [minMinute, maxMinute];
  }

  /// calculate the range of second
  List<int> _calcSecondRange({currHour, currMinute}) {
    int minSecond = 0, maxSecond = 59;
    int minHour = _minTime.hour;
    int maxHour = _maxTime.hour;
    int minMinute = _minTime.minute;
    int maxMinute = _maxTime.minute;

    currHour ??= _currHour;
    currMinute ??= _currMinute;

    if (minHour == currHour && minMinute == currMinute) {
      // selected minimum hour and minute, limit second range
      minSecond = _minTime.second;
    }
    if (maxHour == currHour && maxMinute == currMinute) {
      // selected maximum hour and minute, limit second range
      maxSecond = _maxTime.second;
    }
    return [minSecond, maxSecond];
  }
}
