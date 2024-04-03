import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:opscheck/services/analytics_service.dart';
import 'package:opscheck/models/analytics_data.dart'; // Import the AnalyticsData model

class ModeIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const ModeIcon({
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }
}

class EventDetailsScreen extends StatefulWidget {
  final String eventName;
  final String category;
  final int eventId;
  final DateTime selectedDate;

  EventDetailsScreen({
    required this.eventName,
    required this.category,
    required this.eventId,
    required this.selectedDate,
  });

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late String _selectedTimeRange;
  late DateTime _startDate;
  late DateTime _endDate;
  late List<String> _dates;
  late List<double> _officeCounts;
  late List<double> _wfhCounts;
  late List<double> _absentCounts;

  @override
  void initState() {
    super.initState();
    _dates = [];
    _officeCounts = [];
    _wfhCounts = [];
    _absentCounts = [];
    _selectedTimeRange = 'Day';
    _calculateDateRange(_selectedTimeRange);
  }

  void _calculateDateRange(String selectedTimeRange) {
    switch (selectedTimeRange) {
      case 'This Week':
        _startDate = widget.selectedDate
            .subtract(Duration(days: widget.selectedDate.weekday - 1));
        _endDate = widget.selectedDate;
        break;
      case 'This Month':
        DateTime firstDayOfMonth =
            DateTime(widget.selectedDate.year, widget.selectedDate.month, 1);
        _startDate = firstDayOfMonth;
        _endDate = widget.selectedDate;
        break;
      case 'Custom':
        // Implement custom date range selection logic if needed
        break;
      default:
        _startDate = widget.selectedDate;
        _endDate = widget.selectedDate;
        break;
    }
    String formattedStartDate = DateFormat('yyyy-MM-dd').format(_startDate);
    String formattedEndDate = DateFormat('yyyy-MM-dd').format(_endDate);

    // Call fetchDataFromService() with formatted dates
    _fetchDataFromService(formattedStartDate, formattedEndDate);
  }

  Future<void> _fetchDataFromService(String startDate, String endDate) async {
    try {
      AnalyticsData data =
          await AnalyticsService.fetchData(startDate, endDate, widget.eventId);
      _dates = data.dates;
      _officeCounts = data.officeCounts;
      _wfhCounts = data.wfhCounts;
      _absentCounts = data.absentCounts;
      setState(() {});
    } catch (e) {
      print('Failed to load data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize variables
    double presentCount = 0;
    double totalParticipants = 0;
    double presentPercentage = 0;
    double absentPercentage = 0;

    // Check if _wfhCounts and _officeCounts are not null and not empty before calculating presentCount
    if (_wfhCounts.isNotEmpty == true && _officeCounts.isNotEmpty == true) {
      // Calculate presentCount by summing elements in _wfhCounts and _officeCounts
      presentCount = _wfhCounts.reduce((a, b) => (a) + (b)) +
          _officeCounts.reduce((a, b) => (a) + (b));
    }

    // Check if _absentCounts is not null and not empty before calculating totalParticipants and percentages
    if (_absentCounts.isNotEmpty == true) {
      // Calculate totalParticipants by adding presentCount and sum of elements in _absentCounts
      totalParticipants =
          presentCount + _absentCounts.reduce((a, b) => (a) + (b));

      // Calculate presentPercentage
      if (totalParticipants != 0) {
        presentPercentage = (presentCount / totalParticipants) * 100;

        // Calculate absentPercentage
        double totalAbsentCount =
            _absentCounts.fold(0, (prev, count) => (prev) + (count));
        absentPercentage = (totalAbsentCount / totalParticipants) * 100;
      }
    }

    // Print results
    print('Present Count: $presentCount');
    print('Total Participants: $totalParticipants');
    print('Present Percentage: $presentPercentage');
    print('Absent Percentage: $absentPercentage');

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.eventName} - ${widget.category}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10), // Add padding to center text
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        style: BorderStyle.solid,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedTimeRange,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedTimeRange = newValue!;
                          if (_selectedTimeRange == 'Day') {
                            _calculateDateRange('Day');
                          } else if (_selectedTimeRange == 'This Week') {
                            _calculateDateRange('This Week');
                          } else if (_selectedTimeRange == 'This Month') {
                            _calculateDateRange('This Month');
                          } else if (_selectedTimeRange == 'Custom') {
                            // _calculateDateRange('Custom');
                          }
                        });
                      },
                      items: <String>[
                        'Day',
                        'This Week',
                        'This Month',
                        'Custom'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Align(
                            // Align text to the center
                            alignment: Alignment.center,
                            child: Text(value),
                          ),
                        );
                      }).toList(),
                      style: const TextStyle(color: Colors.black),
                      underline: Container(), // Remove underline
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCountContainer('Present', presentCount.toInt()),
                _buildCountContainer(
                  'Absent',
                  _absentCounts.isNotEmpty
                      ? _absentCounts.reduce((a, b) => (a) + (b)).toInt()
                      : 0,
                ),
                _buildCountContainer(
                  'WFH',
                  _wfhCounts.isNotEmpty
                      ? _wfhCounts.reduce((a, b) => (a) + (b)).toInt()
                      : 0,
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              height: 250,
              width: 400,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _calculateMaxY(),
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (value, _) {
                            switch (_selectedTimeRange) {
                              case 'Day':
                                int index = value.toInt();
                                switch (index) {
                                  case 0:
                                    return const Text('WFH');
                                  case 1:
                                    return const Text('Office');
                                  case 2:
                                    return const Text('Not attended');
                                  default:
                                    break; // Return an empty string for other values
                                }
                              // return SizedBox();
                              case 'This Week':
                                DateTime date = DateTime.parse(
                                    _dates.reversed.toList()[value
                                        .toInt()]); // Get the date for the index
                                return Text(DateFormat('E').format(
                                    date)); // Return the day name (e.g., Mon, Tue)
                              default:
                                break;
                            }
                            return const SizedBox();
                          }),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: _buildBarGroups(),
                ),
              ),
            ),
            // SizedBox(height: 10),
            Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          color: Colors.blue,
                          value: presentPercentage,
                          title: presentPercentage.toStringAsFixed(2) + '%',
                          titleStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PieChartSectionData(
                          color: Colors.red,
                          value: absentPercentage,
                          title: absentPercentage.toStringAsFixed(2) + '%',
                          titleStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                    ),
                    swapAnimationDuration: const Duration(milliseconds: 150),
                    swapAnimationCurve: Curves.linear,
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: LegendWidget(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    List<BarChartGroupData> barsGroups =
        []; // List to hold BarChartGroupData objects

    switch (_selectedTimeRange) {
      case 'Day':
        for (int i = 0; i < _dates.length; i++) {
          // Create a BarChartGroupData object for each mode
          BarChartGroupData wfhBarGroup = BarChartGroupData(
            x: 0, // Assigning index i to each bar group
            // barsSpace: 3,
            barRods: [
              BarChartRodData(
                  toY: _wfhCounts[i] == 0 ? 0.001 : _wfhCounts[i],
                  color: Colors.green,
                  width: 16,
                  borderRadius: BorderRadius.circular(2)),
            ],
          );

          BarChartGroupData officeBarGroup = BarChartGroupData(
            x: 1, // Assigning index i to each bar group
            // barsSpace: 3,
            barRods: [
              BarChartRodData(
                  toY: _officeCounts[i] == 0 ? 0.001 : _officeCounts[i],
                  color: Colors.blue,
                  width: 16,
                  borderRadius: BorderRadius.circular(2))
            ],
          );

          BarChartGroupData absentBarGroup = BarChartGroupData(
            x: 2, // Assigning index i to each bar group
            // barsSpace: 3,
            barRods: [
              BarChartRodData(
                  toY: _absentCounts[i] == 0 ? 0.001 : _absentCounts[i],
                  color: Colors.red,
                  width: 16,
                  borderRadius: BorderRadius.circular(2))
            ],
          );

          barsGroups.add(wfhBarGroup); // Add the WFH bar group to the list
          barsGroups
              .add(officeBarGroup); // Add the Office bar group to the list
          barsGroups
              .add(absentBarGroup); // Add the Absent bar group to the list
        }
        break;
      case 'This Week':
        for (int i = _dates.length - 1; i >= 0; i--) {
          double wfhCount = _wfhCounts[i];
          double officeCount = _officeCounts[i];
          double absentCount = _absentCounts[i];
          double totalcount = wfhCount + officeCount + absentCount;

          // Create BarChartRodStackItem for each category
          List<BarChartRodStackItem> rodStackItems = [
            BarChartRodStackItem(0, wfhCount, Colors.green),
            BarChartRodStackItem(wfhCount, wfhCount + officeCount, Colors.blue),
            BarChartRodStackItem(wfhCount + officeCount,
                wfhCount + officeCount + absentCount, Colors.red),
          ];

          // Create BarChartRodData for the stacked bar
          BarChartRodData barData = BarChartRodData(
            toY: totalcount,
            rodStackItems: rodStackItems,
            width: 16,
            borderRadius: BorderRadius.circular(2),
          );

          // Create BarChartGroupData for each day
          BarChartGroupData barGroup = BarChartGroupData(
            x: _dates.length - 1 - i,
            barRods: [barData],
            // showingTooltipIndicators: [0, 1, 2],
          );

          barsGroups.add(barGroup);
        }
        break;
    }
    return barsGroups;
  }

  double _calculateMaxY() {
    switch (_selectedTimeRange) {
      case 'Day':
        double maxCount = _wfhCounts.isNotEmpty
            ? _wfhCounts.reduce((a, b) => max(a ?? 0, b ?? 0))
            : 0; // Finding the maximum count among all categories
        maxCount = maxCount;
        if (_officeCounts.isNotEmpty) {
          maxCount = max(maxCount, _officeCounts.reduce((a, b) => max(a, b)));
        } // Comparing with the maximum count from the office category
        if (_absentCounts.isNotEmpty) {
          maxCount = max(maxCount, _absentCounts.reduce((a, b) => max(a, b)));
        } // Comparing with the maximum count from the absent category
        return maxCount.toDouble();
      case 'This Week':
        double maxTotal = 0;
        // Iterate through each day to find the maximum total
        for (int i = 0; i < _dates.length; i++) {
          double total =
              (_wfhCounts[i]) + (_officeCounts[i]) + (_absentCounts[i]);
          if (total > maxTotal) {
            maxTotal = total;
          }
        }
        return maxTotal;
      // Add cases for other time ranges if needed
      default:
        return 0; // Default to 0 if time range is not recognized
    }
  }

  Widget _buildCountContainer(String label, int count) {
    Color textColor;
    if (label == 'Present') {
      textColor = Colors.blue;
    } else if (label == 'Absent') {
      textColor = Colors.red;
    } else {
      textColor = Colors.green;
    }

    return SizedBox(
      width: 115, // Adjust width according to your design
      height: 80, // Adjust height according to your design
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LegendWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LegendItem(color: Colors.blue, label: 'Present'),
        SizedBox(
          height: 10,
        ),
        LegendItem(color: Colors.red, label: 'Not attended'),
      ],
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 15,
          height: 15,
          color: color,
        ),
        const SizedBox(width: 5),
        Text(label),
      ],
    );
  }
}
