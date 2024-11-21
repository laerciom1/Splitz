import 'package:another_xlider/models/handler.dart';
import 'package:another_xlider/models/handler_animation.dart';
import 'package:another_xlider/models/slider_step.dart';
import 'package:another_xlider/models/tooltip/tooltip.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:flutter/material.dart';
import 'package:multi_thumb_slider/multi_thumb_slider.dart';
import 'package:splitz/extensions/widgets.dart';
import 'package:splitz/presentation/theme/slice_colors.dart';
import 'package:another_xlider/another_xlider.dart';

const _sliderHeight = 8.0;

class SliceSlider extends StatelessWidget {
  const SliceSlider({
    this.onRangesChanged,
    this.rangesQty,
    this.initRangeValues,
    super.key,
  }) : assert(
            (initRangeValues == null && rangesQty != null) ||
                (initRangeValues != null && rangesQty == null),
            'Choose only one of initRangeValues or rangesQty');

  final void Function(List<double>)? onRangesChanged;
  final List<double>? initRangeValues;
  final int? rangesQty;

  List<double> getInitValues() {
    if (rangesQty != null) {
      final defaultSlice = 100 / rangesQty!;
      return List.generate(rangesQty! - 1, (idx) => defaultSlice * idx + 1);
    }
    var sum = 0.0;
    return List.generate(
      initRangeValues!.length - 1,
      (idx) {
        sum += initRangeValues![idx];
        return sum;
      },
    );
  }

  List<double> getRangesByValues(List<double> values) {
    final newRanges = <double>[];
    var sum = 0.0;
    for (double value in values) {
      final valueToAdd = value - sum;
      newRanges.add(valueToAdd);
      sum += valueToAdd;
    }
    newRanges.add(100 - sum);
    return newRanges;
  }

  Widget getThumb(BuildContext context) => Container(
        width: _sliderHeight * 2,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
      );

  Widget get2RangesSlider(BuildContext context, List<double> values) {
    final handler = FlutterSliderHandler(
      child: getThumb(context),
    );
    return FlutterSlider(
      values: [values[0]],
      min: 0.0,
      max: 100.0,
      handler: handler,
      handlerWidth: _sliderHeight * 2,
      handlerHeight: _sliderHeight * 2,
      step: const FlutterSliderStep(step: 1),
      tooltip: FlutterSliderTooltip(disabled: true),
      handlerAnimation: const FlutterSliderHandlerAnimation(scale: 1.0),
      onDragging: (handlerIndex, lowerValue, upperValue) {
        onRangesChanged?.call(getRangesByValues([lowerValue]));
      },
      trackBar: FlutterSliderTrackBar(
        activeTrackBarHeight: _sliderHeight,
        inactiveTrackBarHeight: _sliderHeight,
        inactiveTrackBar: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(_sliderHeight)),
          color: sliceColors[1],
        ),
        activeTrackBar: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(_sliderHeight)),
          color: sliceColors[0],
        ),
      ),
    ).withPadding(const EdgeInsets.symmetric(horizontal: 16, vertical: 12));
  }

  Widget get3RangesSlider(BuildContext context, List<double> values) {
    final handler = FlutterSliderHandler(
      child: getThumb(context),
    );
    final colors = <Color>[
      sliceColors[0],
      sliceColors[0],
      sliceColors[2],
      sliceColors[2],
    ];
    final midValue = ((values[0] / 100) + (values[1] / 100)) / 2;
    final stops = <double>[0.0, midValue, midValue + .001, 1.0];
    return FlutterSlider(
      rangeSlider: true,
      values: [values[0], values[1]],
      min: 0.0,
      max: 100.0,
      handler: handler,
      rightHandler: handler,
      handlerWidth: _sliderHeight * 2,
      handlerHeight: _sliderHeight * 2,
      step: const FlutterSliderStep(step: 1),
      tooltip: FlutterSliderTooltip(disabled: true),
      handlerAnimation: const FlutterSliderHandlerAnimation(scale: 1.0),
      onDragging: (handlerIndex, lowerValue, upperValue) {
        onRangesChanged?.call(getRangesByValues([lowerValue, upperValue]));
      },
      trackBar: FlutterSliderTrackBar(
        activeTrackBarHeight: _sliderHeight,
        inactiveTrackBarHeight: _sliderHeight,
        inactiveTrackBar: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(_sliderHeight)),
          gradient: LinearGradient(colors: colors, stops: stops),
          color: Colors.black,
        ),
        activeTrackBar: BoxDecoration(color: sliceColors[1]),
      ),
    ).withPadding(const EdgeInsets.symmetric(horizontal: 16, vertical: 12));
  }

  Widget getMoreThan3RangesSlider(BuildContext context, List<double> values) {
    final colors = <Color>[];
    final stops = <double>[];
    values.asMap().forEach((idx, value) {
      colors.addAll([sliceColors[idx], sliceColors[idx]]);
      final tempValue = value / 100;
      final finalValue = (tempValue + .001).clamp(0.0, 1.0);
      stops.addAll([tempValue, finalValue]);
    });
    colors.addAll([sliceColors[values.length], sliceColors[values.length]]);
    stops.insert(0, 0.0);
    stops.add(1.0);
    return MultiThumbSlider(
      initalSliderValues: values.map((e) => e / 100).toList(),
      lockBehaviour: ThumbLockBehaviour.none,
      overdragBehaviour: ThumbOverdragBehaviour.move,
      valuesChanged: (newValues) {
        onRangesChanged?.call(getRangesByValues(
          newValues.map((e) => e * 100).toList(),
        ));
      },
      thumbBuilder: (_, __) => Container(
        width: _sliderHeight * 2,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
      ),
      background: Container(
        height: _sliderHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_sliderHeight),
          gradient: LinearGradient(colors: colors, stops: stops),
        ),
      ),
    ).withPadding(const EdgeInsets.symmetric(horizontal: 24, vertical: 12));
  }

  @override
  Widget build(BuildContext context) {
    final values = getInitValues();
    if (values.length > 2) {
      return getMoreThan3RangesSlider(context, values);
    } else if (values.length > 1) {
      get3RangesSlider(context, values);
    }
    return get2RangesSlider(context, values);
  }
}
