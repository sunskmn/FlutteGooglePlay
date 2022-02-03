import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/temperature_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart' show rootBundle;
//import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class Charts extends StatefulWidget {
  //const Charts({Key? key}) : super(key: key);

  late DatabaseReference? dataDayRef;
  DatabaseError? error1;
  List<TemperatureModel>? modelList;

  Charts({this.dataDayRef, this.error1, this.modelList});

  @override
  _ChartsState createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {
  String dropdownValue = 'Day';
  List<SalesData> chartData = [];

  Future loadSalesData() async {
    final String jsonString = await getJsonFromAssets();
    final dynamic jsonResponse = json.decode(jsonString);
    for (Map<String, dynamic> i in jsonResponse) {
      chartData.add(SalesData.fromJson(i));
    }
  }

  Future<String> getJsonFromAssets() async {
    return await rootBundle.loadString('assets/data.json');
  }

  @override
  void initState() {
    loadSalesData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Chart'),
          ),
        ),
        body: SafeArea(
          child: Container(
            child: Stack(
              children: <Widget>[
                Container(
                  child: FutureBuilder(
                      future: getJsonFromAssets(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return SfCartesianChart(primaryXAxis: CategoryAxis(),
                              // Chart title
                              //title: ChartTitle(text: 'Half yearly sales analysis'),
                              series: <ChartSeries<TemperatureModel, String>>[
                                LineSeries<TemperatureModel, String>(
                                  dataSource: widget.modelList!
                                      .where((element) =>
                                          element.Day == '2022-1-25')
                                      .toList(),
                                  xValueMapper: (TemperatureModel model, _) =>
                                      model.time,
                                  yValueMapper: (TemperatureModel model, _) =>
                                      model.temperature,
                                )
                              ]);
                        } else {
                          return Card(
                            elevation: 5.0,
                            child: Container(
                              height: 100,
                              width: 400,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('Retriving JSON data...',
                                        style: TextStyle(fontSize: 20.0)),
                                    Container(
                                      height: 40,
                                      width: 40,
                                      child: CircularProgressIndicator(
                                        semanticsLabel: 'Retriving JSON data',
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.blueAccent),
                                        backgroundColor: Colors.grey[300],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      }),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.topCenter,
                ),
              ],
            ),
          ),
        ));
  }
}

class SalesData {
  SalesData(this.month, this.sales);

  final String month;
  final double sales;

  factory SalesData.fromJson(Map<String, dynamic> parsedJson) {
    return SalesData(
      parsedJson['month'].toString(),
      parsedJson['sales'],
    );
  }
}





//  DropdownButton<String>(
//           value: dropdownValue,
//           icon: const Icon(Icons.arrow_drop_down_outlined),
//           iconSize: 36,
//           borderRadius: BorderRadius.circular(15),
//           elevation: 16,
//           style: const TextStyle(
//               color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
//           underline: Container(
//             height: 1,
//             color: Colors.blue,
//           ),
//           onChanged: (String? newValue) {
//             setState(() {
//               dropdownValue = newValue!;
//             });
//           },
//           items: <String>['Day', 'Month', 'Year']
//               .map<DropdownMenuItem<String>>((String value) {
//             return DropdownMenuItem<String>(
//               value: value,
//               child: Text(value),
//             );
//           }).toList(),
//         ),
       