import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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

class EventDetailsScreen extends StatelessWidget {
  final String eventName;
  final String category;
  final int officeParticipants;
  final int wfhParticipants;
  final int absentParticipants;

  EventDetailsScreen({
    required this.eventName,
    required this.category,
    required this.officeParticipants,
    required this.wfhParticipants,
    required this.absentParticipants,
  });

  @override
  Widget build(BuildContext context) {
    final totalParticipants =
        officeParticipants + wfhParticipants + absentParticipants;
    final presentParticipants = officeParticipants + wfhParticipants;
    final presentPercentage = (presentParticipants / totalParticipants) * 100;
    final absentPercentage = (absentParticipants / totalParticipants) * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Summary Report',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // margin: EdgeInsets.symmetric(horizontal: 10.0),
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Text(
                  '$eventName - $category',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.all(11),
              padding: const EdgeInsets.all(7),
              child: Table(
                border: TableBorder.all(),
                children: [
                  const TableRow(
                    children: [
                      TableCell(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              'Present',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        verticalAlignment: TableCellVerticalAlignment.middle,
                      ),
                      TableCell(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              'Absent',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        verticalAlignment: TableCellVerticalAlignment.middle,
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ModeIcon(
                                icon: Icons.home,
                                color: Colors.green,
                                label: 'WFH',
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                '${wfhParticipants.toString()}',
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ModeIcon(
                                icon: Icons.work,
                                color: Colors.blue,
                                label: 'Office',
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                '${officeParticipants.toString()}',
                              ),
                            ),
                          ],
                        ),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              '${absentParticipants.toString()}',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // SizedBox(height: 8),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15.0),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: totalParticipants.toDouble(),
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, _) {
                          // Define your widget or use a function to generate the widget here
                          const TextStyle textStyle =
                              TextStyle(color: Colors.black, fontSize: 14);
                          switch (value.toInt()) {
                            case 0:
                              return Text(
                                'WFH',
                                style: textStyle,
                              );
                            case 1:
                              return Text(
                                'Office',
                                style: textStyle,
                              );
                            default:
                              return const SizedBox(); // Return an empty SizedBox for other values
                          }
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: wfhParticipants.toDouble(),
                          color: Colors.green,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: officeParticipants.toDouble(),
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Stack(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                  height: 250,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          color: Colors.blue,
                          value: presentPercentage,
                          title: presentPercentage.toStringAsFixed(2) + '%',
                          titleStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PieChartSectionData(
                          color: Colors.red,
                          value: absentPercentage,
                          title: absentPercentage.toStringAsFixed(2) + '%',
                          titleStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                    ),
                    swapAnimationDuration:
                        Duration(milliseconds: 150), // Optional
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

            // SizedBox(height: 20),
            // LegendWidget(),
            // SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class LegendWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LegendItem(color: Colors.blue, label: 'Present'),
        SizedBox(
          height: 10,
        ),
        LegendItem(color: Colors.red, label: 'Absent'),
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
        SizedBox(width: 5),
        Text(label),
      ],
    );
  }
}
