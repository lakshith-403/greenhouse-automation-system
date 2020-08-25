import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_database/firebase_database.dart';

class Database extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Plant stat',
        home: Center(
          child: data_table(),
        ));
  }
}

class data_table extends StatefulWidget {
  data_table({Key key}) : super(key: key);

  @override
  _data_table createState() => _data_table();
}

class _data_table extends State<data_table> {
  final fb = FirebaseDatabase.instance;
  final myController = TextEditingController();

  Widget createTable() {
    List<DataRow> ro = [];
    int Count = 0;
    String _temp = "NA";
    String _humidity = "NA";
    String _ph = 'NA';
    String _stat = 'Inactive';
    String _moist = 'NA';
    final ref = fb.reference();
    ref.child("/dp/count/").once().then((DataSnapshot data) {
      Count = data.value;
      print(data.value);
      print(data.key);
    });
    for (int i = 0; i < Count; ++i) {
      ref.child("hum " + i.toString()).once().then((DataSnapshot data) {
        _humidity = data.value.toString();
        print(data.value);
        print(data.key);
      });
      ref.child("temp " + i.toString()).once().then((DataSnapshot data) {
        _temp = data.value.toString();
        print(data.value);
        print(data.key);
      });
      ref.child("ph " + i.toString()).once().then((DataSnapshot data) {
        _ph = data.value.toString();
        _stat = "Active";
        print(data.value);
        print(data.key);
      });
      ref.child("moist " + i.toString()).once().then((DataSnapshot data) {
        _moist = data.value.toString();
        _stat = "Active";
        print(data.value);
        print(data.key);
      });
      ro.add(DataRow(
        cells: <DataCell>[
          DataCell(Text('$_temp')),
          DataCell(Text('$_humidity')),
          DataCell(Text('$_ph')),
          DataCell(Text('$_moist')),
        ],
      ));
    }
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Text(
                'Temperature',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                'Humidity',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                'PH',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                'Soil Moisture',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
          rows: ro,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: createTable(),
      ),
    );
  }
}
