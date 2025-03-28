import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class JsonTableScreen extends StatefulWidget {
  const JsonTableScreen({super.key});

  @override
  JsonTableScreenState createState() => JsonTableScreenState();
}

class JsonTableScreenState extends State<JsonTableScreen> {
  List<Map<String, dynamic>> _data = [];

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.37:8081/inspections'),
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = jsonDecode(response.body);
        setState(() {
          _data = jsonResponse.map((e) => e as Map<String, dynamic>).toList();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        _data = [];
      });
      debugPrint("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Fetch Test',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // backgroundColor: Colors.green,
          actions: [
            ElevatedButton.icon(
              onPressed: fetchData,
              label: Text('Download'),
              icon: Icon(Icons.download_for_offline_rounded),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return _data.isEmpty
                      ? const Center(child: Text('No data'))
                      : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth:
                                constraints.maxWidth, // Ensures full width
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text('Date')),
                                DataColumn(label: Text('Inspector')),
                                DataColumn(label: Text('Location')),
                                DataColumn(label: Text('Location City State')),
                                DataColumn(label: Text('PDF')),
                              ],
                              rows:
                                  _data.map((item) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(item['date'] ?? 'N/A')),
                                        DataCell(
                                          Text(item['inspector'] ?? 'N/A'),
                                        ),
                                        DataCell(
                                          Text(item['location'] ?? 'N/A'),
                                        ),
                                        DataCell(
                                          Text(item['location_city_state'] ?? 'N/A'),
                                        ),
                                        DataCell(
                                          Text(item['pdf'] ?? 'N/A'),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),
                      );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
