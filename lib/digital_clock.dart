// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:async';
import 'dart:math' as math;
import 'package:digital_clock/utils/text_styles.dart';
import 'package:digital_clock/utils/themes.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock>
    with SingleTickerProviderStateMixin {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
    super.initState();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(
      () {
        // Cause the clock to rebuild when the model changes.
      },
    );
  }

/* This function is called to update the current time ,
 and to call the timers of [Minutes] and [Hours].*/

  void _updateTime() {
    setState(
      () {
        _dateTime = DateTime.now();
        _timer = Timer(
            Duration(seconds: 3) -
                Duration(milliseconds: _dateTime.millisecond),
            _updateTime);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final second = DateFormat('ss').format(_dateTime);
    final fontSize = MediaQuery.of(context).size.width / 5;

    return Container(
      color: clockTheme.accentColor,
      child: Center(
        child: Stack(
          children: [
            Positioned(
              top: 0.0,
              left: 110.0,
              child: Container(
                width: 150,
                height: 250,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: clockTheme.primaryColor,
                      width: 1.0,
                    ),
                    color: clockTheme.accentColor,
                    backgroundBlendMode: BlendMode.saturation),
              ),
            ),
            Positioned(
              right: 20.0,
              child: divider(),
            ),
            Positioned(
              left: 20.0,
              child: divider(),
            ),
            Positioned(
              top: 100.0,
              left: 130.0,
              child: Text(
                '$hour : $minute',
                style: TextureStyles.clockTextStyle,
              ),
            ),
            Positioned(
              top: 45,
              left: 25,
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 3,
                child: LiquidLinearProgressIndicator(
                  value: int.parse(hour) / 24,
                  valueColor: AlwaysStoppedAnimation(clockTheme.primaryColor),
                  backgroundColor: clockTheme.accentColor,
                  direction: Axis.horizontal,
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              right: 25,
              child: Transform.rotate(
                angle: math.pi,
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 2,
                  child: LiquidLinearProgressIndicator(
                    value: int.parse(second) / 60,
                    valueColor: AlwaysStoppedAnimation(clockTheme.primaryColor),
                    backgroundColor: clockTheme.accentColor,
                    direction: Axis.horizontal,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget divider() {
    return Container(
      width: 4,
      height: MediaQuery.of(context).size.height / 3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: clockTheme.accentColor,
        border: Border.all(
            color: clockTheme.primaryColor, width: 0.6, style: BorderStyle.solid),
      ),
      child: LiquidLinearProgressIndicator(
        value: 0.9,
        valueColor: AlwaysStoppedAnimation(clockTheme.primaryColor),
        backgroundColor: clockTheme.accentColor,
        direction: Axis.vertical,
      ),
    );
  }
}
