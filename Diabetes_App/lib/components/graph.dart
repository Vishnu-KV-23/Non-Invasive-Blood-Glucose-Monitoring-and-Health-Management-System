import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

class LineChartWidget extends StatefulWidget {
  const LineChartWidget({super.key});

  @override
  _LineChartWidgetState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget>
    with AutomaticKeepAliveClientMixin {
  final List<FlSpot> _spots = [];
  final int maxPoints = 10;
  DateTime now = DateTime.now();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    refreshTime(); // Load initial data
  }

  void refreshTime() async {
    var newReading = await _fetchNumber();
    setState(() {
      now = DateTime.now();
      _spots.add(FlSpot(_spots.length.toDouble(), newReading.toDouble()));
      if (_spots.length > maxPoints) {
        _spots.removeAt(0);
      }
    });
  }

  Future<int> _fetchNumber() async {
    try {
      var url =
          "http://192.168.231.185:5001/conc_number"; // URL to your Flask server to be updated according to IP address
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        int number =
            json.decode(response.body)['concentration_reading'] as int? ?? 0;
        return number;
      } else {
        return -1;
      }
    } catch (e) {
      print('Error: $e');
      return -1;
    }
  }

  void _showLatestReading() {
    if (_spots.isNotEmpty) {
      final latestReading = _spots.last.y;
      final currentTime = DateFormat.jm().format(DateTime.now());

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Latest Glucose Reading"),
            content: Text(
                "The latest Glucose Reading is $latestReading at $currentTime"),
            actions: [
              TextButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("No Readings"),
            content: Text("No glucose readings are available yet."),
            actions: [
              TextButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = DateFormat.yMd().format(now);
    final time = DateFormat.jm().format(now);
    String latestReading =
        _spots.isNotEmpty ? '${_spots.last.y} mg/dL' : 'No Data';

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Your Glucose Readings',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: refreshTime,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text(
                    'Refresh',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(width: 10), // Add spacing between buttons
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: _showLatestReading,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    'Display',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        Stack(
          alignment: Alignment.topRight,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.20,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildChart(),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Current Reading: $latestReading',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Row(
            children: [
              Icon(FontAwesomeIcons.calendar),
              SizedBox(width: 5),
              Text(date),
              SizedBox(width: 10),
              Icon(FontAwesomeIcons.clock),
              SizedBox(width: 5),
              Text(time),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChart() {
    if (_spots.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    double minY = _spots.map((spot) => spot.y).reduce(min);
    double maxY = _spots.map((spot) => spot.y).reduce(max);
    minY = minY - 5;
    maxY = maxY + 5;

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF004D40),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          gridData: FlGridData(
            show: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.white24,
                strokeWidth: 1,
              );
            },
            drawVerticalLine: true,
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.white24,
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Color(0xFF004D40), width: 1),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: _spots,
              isCurved: true,
              color: Colors.lightGreen,
              barWidth: 3,
              belowBarData:
                  BarAreaData(show: true, color: Colors.white.withOpacity(0.2)),
            ),
          ],
          titlesData: FlTitlesData(show: false),
        ),
      ),
    );
  }
}
