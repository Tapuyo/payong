import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:payong/utils/themes.dart';

class RainFallLineChart extends StatelessWidget {
  double d0;
  double d1;
  double d2;
  double d3;
  double d4;
  double d5;
  double d6;
  double d7;
  double d8;
  double d9;

   RainFallLineChart({required this.d0,required this.d1,required this.d2,required this.d3,required this.d4,required this.d5,required this.d6,required this.d7,required this.d8,required this.d9, Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return LineChart(
       sampleData1 ,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
      
      );

  
  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: null,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
       
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
      ];

 

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '1mm';
        break;
      case 2:
        text = '2mm';
        break;
      case 3:
        text = '3mm';
        break;
      case 4:
        text = '4mm';
        break;
      case 5:
        text = '5mm';
        break;
     
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('Apr 19', style: style);
        break;
      case 3:
        text = const Text('Mar 21', style: style);
        break;
      case 6:
        text = const Text('Mar 22', style: style);
        break;
      case 9:
        text = const Text('Mar 23', style: style);
        break;
      case 12:
        text = const Text('Mar 24', style: style);
        break;
      case 15:
        text = const Text('Mar 25', style: style);
        break;
      case 18:
        text = const Text('Mar 26', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: kColorBlue, width: 4),
          left:  BorderSide(color: Colors.transparent),
          right:  BorderSide(color: Colors.transparent),
          top:  BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        color: kColorBlue,
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots:  [
          FlSpot(1, d0),
          FlSpot(2, d1),
          FlSpot(3, d2),
          FlSpot(4, d3),
          FlSpot(5, d4),
          FlSpot(6, d5),
          FlSpot(7, d6),
          FlSpot(8, d7),
          FlSpot(9, d8),
          FlSpot(10, d9),
        ],
      );

 

 
}

// ignore: must_be_immutable
class LineChartSample1 extends StatefulWidget {
  double d0;
  double d1;
  double d2;
  double d3;
  double d4;
  double d5;
  double d6;
  double d7;
  double d8;
  double d9;

  LineChartSample1({required this.d0,required this.d1,required this.d2,required this.d3,required this.d4,required this.d5,required this.d6,required this.d7,required this.d8,required this.d9, Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  late bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 37,
              ),
              const Text(
                '10 Days Rainfall Chart',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 37,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, left: 6),
                  child:
                      RainFallLineChart(d0:widget.d0,d1:widget.d1,d2:widget.d2,d3:widget.d3,d4:widget.d4,d5:widget.d5,d6:widget.d6,d7:widget.d7,d8:widget.d8,d9:widget.d9),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white.withOpacity(isShowingMainData ? 1.0 : 0.5),
            ),
            onPressed: () {
              setState(() {
                isShowingMainData = !isShowingMainData;
              });
            },
          )
        ],
      ),
    );
  }
}
