import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LineChartSample1 extends StatefulWidget {
  List<FlSpot> renderList;
  int currentDay;
  LineChartSample1({this.renderList, this.currentDay});
  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    print("\n\n\n" + widget.currentDay.toString() + "\n\n\n");
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0.0,
        height * 0.01,
        width * 0.01,
        0,
      ),
      child: AbsorbPointer(
        absorbing: true,
        child: LineChart(
          sampleData1(
            height: height,
            width: width,
          ),
          swapAnimationDuration: const Duration(milliseconds: 250),
        ),
      ),
    );
  }

  LineChartData sampleData1({double height, double width}) {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => TextStyle(
            color: Colors.white60,
            fontSize: height / 48,
          ),
          getTitles: (value) {
            print(value);
            print("\n\n");
            switch (value.toInt()) {
              // case 0:
              //   {
              //     print("printing 0 $value");
              //     String a = getDay(((widget.currentDay + 1) % 7).abs());
              //     return a;
              //   }
              case 140:
                {
                  return "12 pm";
                }
              case 290:
                {
                  print("printing 287");
                  String a = getDay(((widget.currentDay + 2) % 7).abs());
                  return a;
                }
              case 440:
                {
                  return "12 pm";
                }
              case 580:
                {
                  print("printing 575");
                  String a = getDay(((widget.currentDay + 3) % 7).abs());
                  return a;
                }
              case 720:
                {
                  return "12 pm";
                }
              case 860:
                {
                  print("printing 863");
                  String a = getDay(((widget.currentDay + 4) % 7).abs());
                  return a;
                }
              case 1000:
                {
                  return "12 pm";
                }
              case 1150:
                {
                  print("printing 1151");
                  String a = getDay(((widget.currentDay + 5) % 7).abs());
                  return a;
                }
              case 1290:
                {
                  return "12 pm";
                }
              case 1440:
                {
                  print("printing 1439");
                  String a = getDay(((widget.currentDay + 6) % 7).abs());
                  return a;
                }
              case 1580:
                {
                  return "12 pm";
                }
              case 1730:
                {
                  print("printing 1727");
                  String a = getDay(((widget.currentDay + 7) % 7).abs());
                  return a;
                }
              case 1870:
                {
                  return "12 pm";
                }
              case 2020:
                {
                  print("printing 2015");
                  String a = getDay(((widget.currentDay + 8) % 7).abs());
                  return a;
                }
            }
            return "";
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
          reservedSize: 0.0,
          getTextStyles: (value) => TextStyle(
            color: Colors.white60,
            fontSize: height / 48,
          ),
          getTitles: (value) {
            // switch (value.toInt()) {
            //   case 40:
            //     {
            //       return "Good";
            //     }
            //   case 150:
            //     {
            //       return "Medium";
            //     }
            //
            //   case 280:
            //     {
            //       return "Poor";
            //     }
            // }
            return "";
          },
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,
      maxX: 2100,
      maxY: 300,
      minY: 0,
      lineBarsData: linesBarData1(),
      extraLinesData: ExtraLinesData(
        verticalLines: [
          // VerticalLine(
          //   x: 0,
          //   color: Colors.white60,
          // ),
          VerticalLine(
            x: 287,
            color: Colors.white60,
          ),
          VerticalLine(
            x: 575,
            color: Colors.white60,
          ),
          VerticalLine(
            x: 863,
            color: Colors.white60,
          ),
          VerticalLine(
            x: 1151,
            color: Colors.white60,
          ),
          VerticalLine(
            x: 1439,
            color: Colors.white60,
          ),
          VerticalLine(
            x: 1727,
            color: Colors.white60,
          ),
          VerticalLine(
            x: 2015,
            color: Colors.white60,
          ),
        ],
        horizontalLines: [
          HorizontalLine(
            y: 0.0,
            color: Colors.white60,
          ),
          // HorizontalLine(
          //   y: 150.0,
          //   color: Colors.orangeAccent,
          // ),
          // HorizontalLine(
          //   y: 280.0,
          //   color: Colors.redAccent,
          // ),
        ],
      ),
    );
  }

  List<LineChartBarData> linesBarData1() {
    final lineChartBarData1 = LineChartBarData(
      spots: widget.renderList,
      isCurved: true,
      colors: [
        Color(0xffeae8e8),
      ],
      barWidth: 1,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    return [
      lineChartBarData1,
    ];
  }
}

String getDay(int day) {
  print(day);
  switch (day) {
    case 0:
      return "Sunday";
    case 1:
      return "Monday";
    case 2:
      return "Tuesday";
    case 3:
      return "Wednesday";
    case 4:
      return "Thursday";
    case 5:
      return "Friday";
    case 6:
      return "Saturday";
    case 7:
      return "Sunday";
    default:
      return "Not a Day";
  }
}
