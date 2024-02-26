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

class EventDetailsScreen extends StatefulWidget {
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
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  String _selectedTimeRange = 'Today';

  @override
  Widget build(BuildContext context) {
    final totalParticipants = widget.officeParticipants +
        widget.wfhParticipants +
        widget.absentParticipants;
    final presentParticipants =
        widget.officeParticipants + widget.wfhParticipants;
    final presentPercentage = (presentParticipants / totalParticipants) * 100;
    final absentPercentage =
        (widget.absentParticipants / totalParticipants) * 100;

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
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Aligns children to the start and end of the row
                children: [
                  Text(
                    '${widget.eventName} - ${widget.category}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  DropdownButton<String>(
                    value: _selectedTimeRange,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedTimeRange = newValue!;
                      });
                    },
                    items: <String>[
                      'Today',
                      'This Week',
                      'This Month',
                      'Custom'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(11),
              child: Table(
                border: TableBorder.all(),
                children: [
                  const TableRow(
                    children: [
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              'Present',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              'Not attended',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
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
                              padding: EdgeInsets.all(5.0),
                              child: ModeIcon(
                                icon: Icons.home,
                                color: Colors.green,
                                label: 'WFH',
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child:
                                  Text('${widget.wfhParticipants.toString()}'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: ModeIcon(
                                icon: Icons.work,
                                color: Colors.blue,
                                label: 'Office',
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                  '${widget.officeParticipants.toString()}'),
                            ),
                          ],
                        ),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child:
                                Text('${widget.absentParticipants.toString()}'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
                              return SizedBox();
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
                          toY: widget.wfhParticipants.toDouble(),
                          color: Colors.green,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: widget.officeParticipants.toDouble(),
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
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
                    swapAnimationDuration: Duration(milliseconds: 150),
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
        SizedBox(width: 5),
        Text(label),
      ],
    );
  }
}
