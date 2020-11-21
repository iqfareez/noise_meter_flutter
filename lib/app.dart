// https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/dynamic_updates/live_update/real_time_line_chart.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:noise_meter_flutter/main.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class NoiseApp extends StatefulWidget {
  @override
  _NoiseAppState createState() => _NoiseAppState();
}

class _NoiseAppState extends State<NoiseApp> {
  bool _isRecording = false;
  StreamSubscription<NoiseReading> _noiseSubscription;
  NoiseMeter _noiseMeter = NoiseMeter();
  double maxDB;
  double meanDB;
  List<_ChartData> chartData = <_ChartData>[];
  ChartSeriesController _chartSeriesController;
  int previousMillis;

  @override
  void initState() {
    super.initState();
  }

  void onData(NoiseReading noiseReading) {
    this.setState(() {
      if (!this._isRecording) this._isRecording = true;
    });
    maxDB = noiseReading.maxDecibel;
    meanDB = noiseReading.meanDecibel;

    chartData.add(_ChartData(
        maxDB,
        meanDB,
        ((DateTime.now().millisecondsSinceEpoch - previousMillis) / 1000)
            .toDouble()));

    // print(noiseReading);
  }

  void start() async {
    previousMillis = DateTime.now().millisecondsSinceEpoch;
    try {
      _noiseSubscription = _noiseMeter.noiseStream.listen(onData);
    } catch (e) {
      print(e);
    }
  }

  void stop() async {
    try {
      if (_noiseSubscription != null) {
        _noiseSubscription.cancel();
        _noiseSubscription = null;
      }
      this.setState(() {
        this._isRecording = false;
      });
    } catch (e) {
      print('stopRecorder error: $e');
    }
    previousMillis = 0;
    chartData.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (chartData.length >= 25) {
      chartData.removeAt(0);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('dB Meter'),
        actions: [
          IconButton(
            icon: Icon(Icons.copy),
            onPressed: maxDB != null
                ? () {
                    Clipboard.setData(ClipboardData(
                        text:
                            'It\'s about ${maxDB.toStringAsFixed(1)}dB loudness'));
                  }
                : null,
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: Text(_isRecording ? 'Stop' : 'Start'),
        onPressed: _isRecording ? stop : start,
        icon: !_isRecording ? Icon(Icons.circle) : null,
        backgroundColor: _isRecording ? Colors.red : Colors.green,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  maxDB != null ? maxDB.toStringAsFixed(2) : 'Press start',
                  style: TextStyle(fontSize: 76, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Text(
              meanDB != null
                  ? 'Mean: ${meanDB.toStringAsFixed(2)}'
                  : 'Awaiting data',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
            ),
            Expanded(
              child: SfCartesianChart(
                series: <LineSeries<_ChartData, double>>[
                  LineSeries<_ChartData, double>(
                      onRendererCreated: (ChartSeriesController controller) {
                        _chartSeriesController = controller;
                      },
                      dataSource: chartData,
                      xAxisName: 'Time',
                      yAxisName: 'dB',
                      name: 'dB values over time',
                      xValueMapper: (_ChartData value, _) => value.frames,
                      yValueMapper: (_ChartData value, _) => value.maxDB,
                      animationDuration: 0),
                ],
              ),
            ),
            SizedBox(
              height: 68,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartData {
  final double maxDB;
  final double meanDB;
  final double frames;

  _ChartData(this.maxDB, this.meanDB, this.frames);
}
