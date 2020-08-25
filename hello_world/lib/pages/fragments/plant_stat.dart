import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PlantStat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Plant stat',
        home: Center(
          child: MyHomePage(),
        ));
  }

  Row _buildButtonColumn(Color color, IconData icon, String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 33, top: 5),
          child: Icon(icon, color: color),
        ),
        Container(
          margin: const EdgeInsets.only(left: 15, top: 5),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.black.withOpacity(0.7),
            ),
          ),
        ),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _temp = "NA";
  String _humidity = "NA";
  String _ph = 'NA';
  String _stat = 'Inactive';
  String _moist = 'NA';
  int _fert = -1;
  int _fan = 0;
  int _pump = 0;
  bool _isSwitched = false;

  final fb = FirebaseDatabase.instance;
  final myController = TextEditingController();

  void _getServerData() {
    final ref = fb.reference();
    ref.child("hum").once().then((DataSnapshot data) {
      _humidity = data.value.toString();
      print(data.value);
      print(data.key);
    });
    ref.child("temp").once().then((DataSnapshot data) {
      _temp = data.value.toString();
      print(data.value);
      print(data.key);
    });
    ref.child("ph").once().then((DataSnapshot data) {
      _ph = data.value.toString();
      _stat = "Active";
      print(data.value);
      print(data.key);
    });
    ref.child("moist").once().then((DataSnapshot data) {
      _moist = data.value.toString();
      _stat = "Active";
      print(data.value);
      print(data.key);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Text(
                  'Variable',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  'Value',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  'Status',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
            rows: <DataRow>[
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Temperature')),
                  DataCell(Text('$_temp')),
                  DataCell(Text('$_stat')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Humidity')),
                  DataCell(Text('$_humidity')),
                  DataCell(Text('$_stat')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Soil PH')),
                  DataCell(Text('$_ph')),
                  DataCell(Text('$_stat')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Soil Moisture')),
                  DataCell(Text('$_moist')),
                  DataCell(Text('$_stat')),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Mechanical Fan :'),
              Switch(
                value: _isSwitched,
                onChanged: (value) {
                  setState(() {
                    _isSwitched = value;
                    print(_isSwitched);
                  });
                },
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              )
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("refresh"),
        onPressed: _getServerData,
        tooltip: 'refresh',
        backgroundColor: Colors.lightGreen,
        icon: Icon(Icons.refresh),
      ),
    );
  }
}
