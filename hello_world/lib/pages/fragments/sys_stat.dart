import 'package:flutter/material.dart';

class SysStat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;

    Widget buttonSection = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(color, Icons.done_outline, 'System is Online'),
          Divider()
        ],
      ),
    );

    return Scaffold(
      body: Column(
        children: <Widget>[
          Divider(),
          buttonSection,
          Text(
            "\nLast Checked: 45 seconds ago",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Text(
                  'Hardware Component',
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
            rows: const <DataRow>[
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('ESP32 wifi')),
                  DataCell(Text('Active')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('DHT_ll sensor')),
                  DataCell(Text('Active')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Soil Moisture Sensor')),
                  DataCell(Text('Active')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Water Pump')),
                  DataCell(Text('Active (off)')),
                ],
              ),
            ],
          ),
          Text(
            "\nServer Time: 12 : 00 : 53",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
        },
        label: Text('Refresh'),
        icon: Icon(Icons.refresh),
        backgroundColor: Colors.lightGreen,
      ),
    );
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
