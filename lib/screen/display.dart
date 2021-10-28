import 'dart:async';
import 'dart:convert';
import 'package:covid19/model/model.dart';
import 'package:covid19/component/worlddata.dart';
import 'package:covid19/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pie_chart/pie_chart.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

// ignore: must_be_immutable
class Display extends StatefulWidget {
  @override
  _DisplayState createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  bool colorchange = false;
  List<Api> user = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  StreamSubscription<DataConnectionStatus> listener;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var fontsize = 15.0;
    var title = 20.0;
    return DoubleBack(
      message: "press back again to close",
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(child: Text("Nepal Covid19 datas")),
          backgroundColor: barcolor,
          actions: [
            Container(
                margin: const EdgeInsets.only(right: 10),
                child: colorchange == false
                    ? InkWell(
                        child: Icon(Icons.dark_mode),
                        onTap: () {
                          _colorchange();
                          bgcolor = darkmodeb;
                          textcolor = Colors.white;
                          barcolor = darkmodeba;
                        },
                      )
                    : InkWell(
                        child: Icon(Icons.brightness_1_sharp),
                        onTap: () {
                          _colorchange();
                          bgcolor = Colors.white;
                          textcolor = Colors.black;
                          barcolor = Colors.blueAccent;
                        },
                      ))
          ],
        ),
        backgroundColor: colorchange == false ? bgcolor : darkmodeb,
        body: SmartRefresher(
          enablePullDown: true,
          controller: _refreshController,
          onRefresh: _onRefresh,
          header: WaterDropMaterialHeader(
            backgroundColor: Colors.green,
          ),
          child: Column(
            children: [
              Expanded(
                  flex: 4,
                  child: FutureBuilder(
                    future: getdatan(),
                    initialData: [],
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.pink,
                          ),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Text("error in snapshot");
                        } else {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                    height: 250,
                                    width: width * 0.9,
                                    margin: const EdgeInsets.only(top: 10),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.black),
                                        color: Colors.white),
                                    child: Column(
                                      children: [
                                        Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            alignment: Alignment.center,
                                            child: Text(
                                              snapshot.data[0].country,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black),
                                            )),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                    width: width * 0.4,
                                                    child: Text(
                                                      "Cases",
                                                      style: TextStyle(
                                                          fontSize: fontsize,
                                                          color: Colors.blue),
                                                    )),
                                                Container(
                                                    width: width * 0.4,
                                                    child: Text("Deaths",
                                                        style: TextStyle(
                                                            fontSize: fontsize,
                                                            color:
                                                                Colors.red))),
                                                Container(
                                                    width: width * 0.4,
                                                    child: Text(
                                                      "Today Deaths",
                                                      style: TextStyle(
                                                          fontSize: fontsize,
                                                          color: Colors.red),
                                                    )),
                                                Container(
                                                    width: width * 0.4,
                                                    child: Text(
                                                      "Recovered",
                                                      style: TextStyle(
                                                          fontSize: fontsize,
                                                          color: Colors.green),
                                                    )),
                                                Container(
                                                    width: width * 0.4,
                                                    child: Text(
                                                      "Today Recovered",
                                                      style: TextStyle(
                                                          fontSize: fontsize,
                                                          color: Colors.green),
                                                    )),
                                                Container(
                                                    width: width * 0.4,
                                                    child: Text(
                                                      "Active",
                                                      style: TextStyle(
                                                          fontSize: fontsize,
                                                          color: Colors.grey),
                                                    )),
                                                Container(
                                                    width: width * 0.4,
                                                    child: Text(
                                                      "Critical",
                                                      style: TextStyle(
                                                          fontSize: fontsize,
                                                          color:
                                                              Colors.redAccent),
                                                    )),
                                                Container(
                                                    width: width * 0.4,
                                                    child: Text(
                                                      "Tests",
                                                      style: TextStyle(
                                                          fontSize: fontsize,
                                                          color: Colors.teal),
                                                    )),
                                                Container(
                                                    width: width * 0.4,
                                                    child: Text(
                                                      "Updated",
                                                      style: TextStyle(
                                                          fontSize: fontsize,
                                                          color: Colors.black),
                                                    )),
                                                Container(
                                                    width: width * 0.4,
                                                    child: Text(
                                                      "TotalPopulation",
                                                      style: TextStyle(
                                                        fontSize: fontsize,
                                                        color: Colors.black,
                                                      ),
                                                    )),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Container(
                                                    width: width * 0.4,
                                                    child: Text(
                                                        ":  " +
                                                            snapshot
                                                                .data[0].cases
                                                                .toString(),
                                                        style: TextStyle(
                                                            fontSize: fontsize,
                                                            color:
                                                                Colors.blue))),
                                                Container(
                                                    width: width * 0.4,
                                                    child: Text(
                                                      ":  " +
                                                          snapshot
                                                              .data[0].deaths
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: fontsize,
                                                          color: Colors.red),
                                                    )),
                                                Container(
                                                    width: width * 0.4,
                                                    child: Text(
                                                      ":  " +
                                                          snapshot.data[0]
                                                              .todayDeaths
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: fontsize,
                                                          color: Colors.red),
                                                    )),
                                                Container(
                                                    width: width * 0.4,
                                                    child: Text(
                                                      ":  " +
                                                          snapshot
                                                              .data[0].recovered
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: fontsize,
                                                          color: Colors.green),
                                                    )),
                                                Container(
                                                    width: width * 0.4,
                                                    child: Text(
                                                      ":  " +
                                                          snapshot.data[0]
                                                              .todayRecovered
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: fontsize,
                                                          color: Colors.green),
                                                    )),
                                                Container(
                                                    width: width * 0.4,
                                                    child: Text(
                                                      ":  " +
                                                          snapshot
                                                              .data[0].active
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: fontsize,
                                                          color: Colors.grey),
                                                    )),
                                                Container(
                                                    width: width * 0.4,
                                                    child: Text(
                                                      ":  " +
                                                          snapshot
                                                              .data[0].critical
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: fontsize,
                                                          color:
                                                              Colors.redAccent),
                                                    )),
                                                Container(
                                                    width: width * 0.4,
                                                    child: Text(
                                                      ":  " +
                                                          snapshot.data[0].tests
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: fontsize,
                                                          color: Colors.teal),
                                                    )),
                                                Container(
                                                    width: width * 0.4,
                                                    child: Text(
                                                      ":  " +
                                                          snapshot
                                                              .data[0].updated
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: fontsize,
                                                          color: Colors.black),
                                                    )),
                                                Container(
                                                    width: width * 0.4,
                                                    child: Text(
                                                      ":  " +
                                                          snapshot.data[0]
                                                              .population
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: fontsize,
                                                          color: Colors.black),
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                                Column(
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.only(top: 15),
                                        child: Text(
                                          "Pie chart of Nepal Covid19 datas",
                                          style: TextStyle(
                                              fontSize: title,
                                              color: textcolor),
                                        )),
                                    Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      width: width * 0.9,
                                      child: FutureBuilder(
                                        future: getdatan(),
                                        initialData: [],
                                        builder: (context, snapshot) {
                                          if (snapshot.data == null) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        color: Colors.pink));
                                          } else if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            if (snapshot.hasError) {
                                              return Text("error in snapshot");
                                            } else {
                                              return Card(
                                                child: PieChart(
                                                  dataMap: {
                                                    "Deaths": snapshot
                                                        .data[0].deaths
                                                        .toDouble(),
                                                    "Active": snapshot
                                                        .data[0].active
                                                        .toDouble(),
                                                    "Cases": snapshot
                                                        .data[0].cases
                                                        .toDouble(),
                                                    "Recovered": snapshot
                                                        .data[0].recovered
                                                        .toDouble(),
                                                  },
                                                  colorList: [
                                                    Colors.red,
                                                    Colors.grey,
                                                    Colors.blue,
                                                    Colors.green
                                                  ],
                                                  animationDuration: Duration(
                                                      milliseconds: 800),
                                                  chartRadius: height / 3,
                                                  chartType: ChartType.disc,
                                                  chartLegendSpacing: 30,
                                                  initialAngleInDegree: 0,
                                                  chartValuesOptions:
                                                      ChartValuesOptions(
                                                    showChartValueBackground:
                                                        true,
                                                    showChartValues: true,
                                                    showChartValuesInPercentage:
                                                        true,
                                                    showChartValuesOutside:
                                                        false,
                                                    decimalPlaces: 1,
                                                  ),
                                                ),
                                              );
                                            }
                                          } else {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        color: Colors.pink));
                                          }
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(20),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: buttoncolor),
                                        child: Text("world covid datas"),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => World(
                                                        bgcolor: bgcolor,
                                                        textcolor: textcolor,
                                                        appbarcolor: barcolor,
                                                      )));
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                      } else {
                        return Center(
                            child:
                                CircularProgressIndicator(color: Colors.pink));
                      }
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future getdatan() async {
    try {
      DataConnectionStatus status = await internetcheck();
      if (status == DataConnectionStatus.connected) {
        var uri = Uri.parse("https://disease.sh/v3/covid-19/countries/nepal");
        var response = await http.get(uri);
        var data = jsonDecode(response.body);
        user.add(Api(
            data["updated"],
            data["cases"],
            data["todayCases"],
            data["deaths"],
            data["todayDeaths"],
            data["recovered"],
            data["todayRecovered"],
            data["active"],
            data["country"],
            data["tests"],
            data["population"],
            data["critical"]));
        return user;
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Center(child: Text("No internet connection")),
                content: SingleChildScrollView(
                    child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text("check your internet connection"),
                    SizedBox(height: 15),
                    Center(
                      child: ElevatedButton(
                        child: Text("OK"),
                        onPressed: () => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Display()),
                            (r) => false),
                      ),
                    )
                  ],
                )),
              );
            });
        return null;
      }
    } catch (e) {
      return "error";
    }
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  internetcheck() async {
    return await DataConnectionChecker().connectionStatus;
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  void _colorchange() {
    setState(() {
      colorchange = !colorchange;
    });
  }
}
