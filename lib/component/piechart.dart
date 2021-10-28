import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

// ignore: must_be_immutable
class Piechart extends StatelessWidget {
  double cases = 0, deaths = 0, active = 0, recovered = 0, tests = 0;
  String country = "";
  Color bgcolor = Colors.white54;
  Piechart(
      {Key key,
      this.cases,
      this.deaths,
      this.active,
      this.recovered,
      this.tests,
      this.country,
      this.bgcolor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: bgcolor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            margin: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
                side: BorderSide(
              color: Colors.grey.withOpacity(0.4),
              width: 0.5,
            )),
            //decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),border: Border.all(color:Colors.black),color: Colors.white),
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.only(
                        top: 15, left: 5, right: 5, bottom: 20),
                    child: Text("Pie chart of " + country + " Covid19 datas",
                        style: TextStyle(fontSize: 18))),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: PieChart(
                    dataMap: {
                      "Deaths": deaths,
                      "Active": active,
                      "Cases": cases,
                      "Recovered": recovered,
                    },
                    colorList: [
                      Colors.red,
                      Colors.grey,
                      Colors.blue,
                      Colors.green
                    ],
                    animationDuration: Duration(milliseconds: 800),
                    chartRadius: height / 3,
                    chartType: ChartType.disc,
                    chartLegendSpacing: 20,
                    chartValuesOptions: ChartValuesOptions(
                      showChartValueBackground: true,
                      showChartValues: true,
                      showChartValuesInPercentage: true,
                      showChartValuesOutside: false,
                      decimalPlaces: 1,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
