/*
 * @Author: lipeng 1162423147@qq.com
 * @Date: 2023-09-22 21:21:54
 * @LastEditors: lipeng 1162423147@qq.com
 * @LastEditTime: 2023-09-22 23:01:15
 * @FilePath: /phoenix_picker/lib/extension/picker_total_config.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
/*
 * @Author: lipeng 1162423147@qq.com
 * @Date: 2023-09-22 21:21:54
 * @LastEditors: lipeng 1162423147@qq.com
 * @LastEditTime: 2023-09-22 22:09:38
 * @FilePath: /phoenix_picker/lib/extension/picker_total_config.dart
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
import 'package:phoenix_base/phoenix.dart';

import '../config/tag_config.dart';
import '../config/picker_config.dart';
import 'picker_default_config_utils.dart';

class PickerTotalConfig extends BaseTotalConfig {
  PickerTotalConfig({PickerConfig? pickerConfig})
      : _pickerConfig = pickerConfig;

  PickerConfig? _pickerConfig;

  PickerConfig get buttonConfig =>
      _pickerConfig ?? BasePickerConfigUtils.defaultPickerConfig;

  @override
  void initThemeConfig(String configId) {
    super.initThemeConfig(configId);
    _pickerConfig ??= PickerConfig();
    buttonConfig.initThemeConfig(
      configId,
      currentLevelCommonConfig: commonConfig,
    );
  }
}

class TagTotalConfig extends BaseTotalConfig {
  TagTotalConfig({TagConfig? tagConfig}) : _tagConfig = tagConfig;

  TagConfig? _tagConfig;

  TagConfig get tagConfig =>
      _tagConfig ?? BasePickerConfigUtils.defaultTagConfig;

  @override
  void initThemeConfig(String configId) {
    super.initThemeConfig(configId);
    _tagConfig ??= TagConfig();
    tagConfig.initThemeConfig(
      configId,
      currentLevelCommonConfig: commonConfig,
    );
  }
}

extension BasePickerTotalConfig on BaseTotalConfig {
  ///
  static PickerConfig? _pickerConfig;
  PickerConfig get pickerConfig =>
      _pickerConfig ?? BasePickerConfigUtils.defaultPickerConfig;
  set pickerTotalConfig(PickerTotalConfig config) {
    _pickerConfig = config.buttonConfig;
  }

  ///
  static TagConfig? _tagConfig;
  TagConfig get tagConfig =>
      _tagConfig ?? BasePickerConfigUtils.defaultTagConfig;
  set tagTotalConfig(TagTotalConfig config) {
    _tagConfig = config.tagConfig;
  }
}
