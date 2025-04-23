// lib/views/pump_system_detail_view.dart
// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/pump_system_data.dart';

class PumpSystemDetailView extends StatelessWidget {
  final PumpSystemData pumpSystemData;

  const PumpSystemDetailView({super.key, required this.pumpSystemData});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Pump System Details - ${pumpSystemData.displayLocation}',
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSectionHeader('Fire Pump Test Report'),
                _buildBasicInfoCard(),

                _buildSectionHeader('Pump Information'),
                _buildPumpInfoCard(),

                _buildSectionHeader('Pump Controller Information'),
                _buildPumpControlerInfoCard(),

                if (pumpSystemData.form.pumpPower == " Diesel") ...[
                  _buildSectionHeader('Diesel Engine Information'),
                  _buildDieselEngineInfoCard(),
                ],

                _buildSectionHeader('Flow Test'),
                _buildFlowTestCard(),
                SizedBox(
                  height: 500,
                  child: PumpCurveChart(pumpSystemData: pumpSystemData),
                ),

                _buildSectionHeader('Notes'),
                _buildRemarksCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _buildBasicInfoCard() {
    final form = pumpSystemData.form;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Report To', form.reportTo),
                          _buildInfoRow('Attention', form.attention),
                          _buildInfoRow('Street', form.street),
                          _buildInfoRow('City & State', form.cityState),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Building', form.building),
                          _buildInfoRow('Inspector', form.inspector),
                          _buildInfoRow('Date', pumpSystemData.formattedDate),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPumpInfoCard() {
    final form = pumpSystemData.form;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Make', form.pumpMake),
            _buildInfoRow('Model', form.pumpModel),
            _buildInfoRow('Serial Number', form.pumpSerialNumber),
            _buildInfoRow('Power', form.pumpPower),
            _buildInfoRow('Water Supply', form.pumpWaterSupply),
            _buildInfoRow('Rated RPM', form.pumpRatedRPM),
            _buildInfoRow('Rated GPM', form.pumpRatedGPM),
            _buildInfoRow('Max PSI', form.pumpMaxPSI),
            _buildInfoRow('Rated PSI', form.pumpRatedPSI),
            _buildInfoRow('PSI @ 150%', form.pumpPSIAt150Percent),
          ],
        ),
      ),
    );
  }

  Widget _buildPumpControlerInfoCard() {
    final form = pumpSystemData.form;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Make', form.pumpControllerMake),
            _buildInfoRow('Model', form.pumpControllerModel),
            _buildInfoRow('Serial Number', form.pumpControllerSerialNumber),
            _buildInfoRow('Voltage', form.pumpControllerVoltage),
            _buildInfoRow('HP', form.pumpControllerHorsePower),
            _buildInfoRow('Supervision', form.pumpControllerSupervision),
          ],
        ),
      ),
    );
  }

  Widget _buildFlowTestCard() {
    final flowtest = pumpSystemData.getFlowTests();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              flowtest.isEmpty
                  ? [const Text('No Flow Tests Recorded')]
                  : flowtest.map((test) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Suction PSI', test['suctionPSI'] ?? ''),
                        _buildInfoRow(
                          'Discharge PSI',
                          test['dischargePSI'] ?? '',
                        ),
                        _buildInfoRow('Net PSI', test['netPSI'] ?? ''),
                        _buildInfoRow('RPM', test['rpm'] ?? ''),
                        _buildInfoRow('Total Flow', test['totalFlow'] ?? ''),
                        SizedBox(height: 50.0),

                        // Dynamically build orifice, pitot, and GPM rows
                        ...List.generate(7, (index) {
                          final orificeSize =
                              test['orificeSize${index + 1}'] ?? '';
                          final pitot = test['pitot${index + 1}'] ?? '';
                          final gpm = test['gpm${index + 1}'] ?? '';

                          // Only add widgets if at least one value is non-empty
                          if (orificeSize.isNotEmpty ||
                              pitot.isNotEmpty ||
                              gpm.isNotEmpty) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (orificeSize.isNotEmpty)
                                  _buildInfoRow(
                                    'Orifice Size ${index + 1}',
                                    orificeSize,
                                  ),
                                _buildInfoRow('Pitot ${index + 1}', pitot),
                                _buildInfoRow('GPM ${index + 1}', gpm),
                              ],
                            );
                          }
                          return const SizedBox.shrink(); // Return empty widget if no data
                        }),
                        const Divider(),
                        const Divider(),
                      ],
                    );
                  }).toList(),
        ),
      ),
    );
  }

  Widget _buildDieselEngineInfoCard() {
    final form = pumpSystemData.form;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Make', form.dieselEngineMake),
            _buildInfoRow('Model', form.dieselEngineModel),
            _buildInfoRow('Serial Number', form.dieselEngineSerialNumber),
            _buildInfoRow('Hours', form.dieselEngineHours),
          ],
        ),
      ),
    );
  }

  Widget _buildRemarksCard() {
    final form = pumpSystemData.form;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildInfoRow('Remarks On Test', form.remarksOnTest)],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    // Skip empty rows if the label is also empty
    if (label.isEmpty && (value.isEmpty || value == 'N/A')) {
      return const SizedBox.shrink();
    }

    // Determine the value widget
    Widget valueWidget;
    if (value.isEmpty) {
      valueWidget = Text(
        'N/A',
        style: const TextStyle(color: Colors.black87),
        textAlign: TextAlign.center,
      );
    } else if (value.toUpperCase() == 'NO') {
      valueWidget = _conditionalTextRed(value);
    } else {
      valueWidget = Text(
        value,
        style: const TextStyle(color: Colors.black87),
        textAlign: TextAlign.center,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label.isEmpty ? '' : label,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(flex: 2, child: valueWidget),
        ],
      ),
    );
  }

  Widget _conditionalTextRed(String data) {
    return Text(
      data,
      style: const TextStyle(color: Colors.red),
      textAlign: TextAlign.center,
    );
  }
}

class PumpCurveChart extends StatelessWidget {
  final PumpSystemData pumpSystemData;

  const PumpCurveChart({super.key, required this.pumpSystemData});

  @override
  Widget build(BuildContext context) {
    // Get flow tests and prepare data
    final flowTests = pumpSystemData.getFlowTests();
    
    // If no flow tests, show message
    if (flowTests.isEmpty) {
      return const Center(child: Text('No flow test data available'));
    }

    // Extract data points for the test curve
    final testSpots = <FlSpot>[];
    
    // Track min/max values for better scaling
    double minFlow = double.infinity;
    double maxFlow = 0;
    double minPressure = double.infinity;
    double maxPressure = 0;
    
    // Add a point for each flow test
    for (var test in flowTests) {
      // Only add points that have both net PSI and total flow
      if (test['netPSI']?.isNotEmpty == true && 
          test['totalFlow']?.isNotEmpty == true) {
        try {
          final netPsi = double.parse(test['netPSI']!);
          final totalFlow = double.parse(test['totalFlow']!);
          
          // Skip points where both net PSI and total flow are zero
          if (netPsi == 0 && totalFlow == 0) {
            continue;
          }
          
          // Add the data point
          testSpots.add(FlSpot(totalFlow, netPsi));
          
          // Update min/max values
          if (totalFlow < minFlow) minFlow = totalFlow;
          if (totalFlow > maxFlow) maxFlow = totalFlow;
          if (netPsi < minPressure) minPressure = netPsi;
          if (netPsi > maxPressure) maxPressure = netPsi;
        } catch (e) {
          // Skip points that can't be parsed as numbers
          continue;
        }
      }
    }

    // Sort spots by x value (flow rate)
    testSpots.sort((a, b) => a.x.compareTo(b.x));
    
    if (testSpots.isEmpty) {
      return const Center(child: Text('No valid flow test data for chart'));
    }
    
    // Generate NFPA standard curve if we have rated values
    List<FlSpot> ratedSpots = [];
    List<FlSpot> minAcceptableSpots = [];
    
    double? ratedGPM;
    double? ratedPSI;
    
    if (pumpSystemData.form.pumpRatedGPM.isNotEmpty && 
        pumpSystemData.form.pumpRatedPSI.isNotEmpty) {
      try {
        // Parse rated values
        ratedGPM = double.parse(pumpSystemData.form.pumpRatedGPM);
        ratedPSI = double.parse(pumpSystemData.form.pumpRatedPSI);
        
        // Calculate shutoff head using NFPA 20 guidelines (typically 120-140% of rated)
        final shutoffPSI = ratedPSI * 1.3; // Using 130% as typical
        
        // Calculate the constant K for the pump curve equation: H = Hs - K × Q²
        // Where H is head at flow Q, Hs is shutoff head
        final k = (shutoffPSI - ratedPSI) / (ratedGPM * ratedGPM);
        
        // Generate rated curve with many points
        for (double flow = 0; flow <= ratedGPM * 1.5; flow += ratedGPM / 20) {
          // Use pump curve equation
          double pressure = shutoffPSI - (k * flow * flow);
          
          // Special point at rated flow to ensure accuracy
          if ((flow - ratedGPM).abs() < 0.1) {
            flow = ratedGPM;
            pressure = ratedPSI;
          }
          
          // Special point at 150% flow - ensure meets NFPA 20 (at least 65% of rated pressure)
          if ((flow - ratedGPM * 1.5).abs() < 0.1) {
            flow = ratedGPM * 1.5;
            // Use the greater of the calculated value or 65% of rated pressure
            pressure = max(pressure, ratedPSI * 0.65);
          }
          
          ratedSpots.add(FlSpot(flow, pressure));
          
          // Also add point to minimum acceptable curve (95% of rated per NFPA 25)
          minAcceptableSpots.add(FlSpot(flow, pressure * 0.95));
        }
        
        // Ensure the lists are properly sorted
        ratedSpots.sort((a, b) => a.x.compareTo(b.x));
        minAcceptableSpots.sort((a, b) => a.x.compareTo(b.x));
        
        // Update min/max for scaling
        if (ratedGPM * 1.5 > maxFlow) maxFlow = ratedGPM * 1.5;
        if (shutoffPSI > maxPressure) maxPressure = shutoffPSI;
      } catch (e) {
        // Just use test curve if we can't parse rated values
        ratedSpots = [];
        minAcceptableSpots = [];
      }
    }
    
    // Calculate nice rounded min/max values for better scales
    // Round down minFlow to nearest 100, round up maxFlow to nearest 100
    minFlow = max(0, (minFlow / 100).floor() * 100); // Ensure min flow is not negative
    maxFlow = (maxFlow / 100).ceil() * 100;
    
    // Round down minPressure to nearest 10, round up maxPressure to nearest 10
    minPressure = max(0, (minPressure / 10).floor() * 10); // Ensure min pressure is not negative 
    maxPressure = (maxPressure / 10).ceil() * 10;
    
    // Add some padding to the max values
    maxFlow = maxFlow * 1.1;
    maxPressure = maxPressure * 1.1;

    // Create intervals for the axis - fewer intervals for better readability
    final flowInterval = ((maxFlow - minFlow) / 4).roundToDouble();
    final pressureInterval = ((maxPressure - minPressure) / 4).roundToDouble();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(128, 128, 128, 0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Fire Pump Performance Curve',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            pumpSystemData.form.building.isNotEmpty 
                ? pumpSystemData.form.building 
                : 'Test Data: ${pumpSystemData.formattedDate}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          // Legend
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 20,
                    height: 4,
                    color: Colors.blue.shade800,
                  ),
                  const SizedBox(width: 4),
                  const Text('Test Results', style: TextStyle(fontSize: 14)),
                ],
              ),
              if (ratedSpots.isNotEmpty) ...[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 20,
                      height: 4,
                      color: Colors.red.shade700,
                    ),
                    const SizedBox(width: 4),
                    const Text('Rated Curve', style: TextStyle(fontSize: 14)),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 20,
                      height: 4,
                      color: Colors.orange,
                      child: const Center(
                        child: Text('...', 
                          style: TextStyle(fontSize: 6, color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text('Min Acceptable (95%)', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 8.0, top: 8.0, bottom: 24.0),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: const Color.fromRGBO(128, 128, 128, 0.3),
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: const Color.fromRGBO(128, 128, 128, 0.3),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: flowInterval,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          );
                        },
                      ),
                      axisNameWidget: const Padding(
                        padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                        child: Text(
                          'Flow Rate (GPM)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60,
                        interval: pressureInterval,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          );
                        },
                      ),
                      axisNameWidget: const Padding(
                        padding: EdgeInsets.only(bottom: 16.0, right: 16.0),
                        child: Text(
                          'Pressure (PSI)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.shade400, width: 2),
                  ),
                  minX: minFlow,
                  maxX: maxFlow,
                  minY: minPressure,
                  maxY: maxPressure,
                  lineBarsData: [
                    // Minimum acceptable curve (if we have rated data)
                    if (minAcceptableSpots.isNotEmpty) LineChartBarData(
                      spots: minAcceptableSpots,
                      isCurved: true,
                      color: Colors.orange,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dashArray: [3, 3], // Small dashes for min acceptable
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                    
                    // Rated curve (if we have data)
                    if (ratedSpots.isNotEmpty) LineChartBarData(
                      spots: ratedSpots,
                      isCurved: true,
                      color: Colors.red.shade700,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dashArray: [5, 5], // Make it dashed
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          // Only show dots at key points: 0%, 100%, and 150%
                          final isKeyPoint = spot.x == 0 || 
                                            (ratedGPM != null && (spot.x == ratedGPM || spot.x == ratedGPM * 1.5));
                          
                          if (isKeyPoint) {
                            return FlDotCirclePainter(
                              radius: 6,
                              color: Colors.red.shade700,
                              strokeWidth: 2,
                              strokeColor: Colors.white,
                            );
                          } else {
                            return FlDotCirclePainter(
                              radius: 0,
                              color: Colors.transparent,
                              strokeWidth: 0,
                              strokeColor: Colors.transparent,
                            );
                          }
                        },
                      ),
                      belowBarData: BarAreaData(show: false),
                    ),
                    
                    // Test curve
                    LineChartBarData(
                      spots: testSpots,
                      isCurved: true,
                      color: Colors.blue.shade800,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          // Determine if this test point falls below minimum acceptable performance
                          bool isBelowMinimum = false;
                          if (minAcceptableSpots.isNotEmpty) {
                            // Find the closest point on the min acceptable curve by flow rate
                            for (int i = 0; i < minAcceptableSpots.length - 1; i++) {
                              if (spot.x >= minAcceptableSpots[i].x && 
                                  spot.x <= minAcceptableSpots[i + 1].x) {
                                // Interpolate to find the minimum acceptable pressure at this flow
                                final ratio = (spot.x - minAcceptableSpots[i].x) / 
                                            (minAcceptableSpots[i + 1].x - minAcceptableSpots[i].x);
                                final minPressure = minAcceptableSpots[i].y + 
                                                  ratio * (minAcceptableSpots[i + 1].y - minAcceptableSpots[i].y);
                                
                                if (spot.y < minPressure) {
                                  isBelowMinimum = true;
                                }
                                break;
                              }
                            }
                          }
                          
                          return FlDotCirclePainter(
                            radius: 6,
                            color: isBelowMinimum ? Colors.red : Colors.blue.shade900,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: const Color.fromRGBO(33, 150, 243, 0.1),
                      ),
                    ),
                  ],
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [],
                    verticalLines: [
                      if (ratedGPM != null) ...[
                        // Line at 100% rated flow
                        VerticalLine(
                          x: ratedGPM,
                          color: Colors.green.withOpacity(0.5),
                          strokeWidth: 1,
                          dashArray: [5, 5],
                          label: VerticalLineLabel(
                            show: true,
                            alignment: Alignment.topCenter,
                            padding: const EdgeInsets.only(bottom: 8),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                            labelResolver: (line) => '100%',
                          ),
                        ),
                        // Line at 150% rated flow
                        VerticalLine(
                          x: ratedGPM * 1.5,
                          color: Colors.green.withOpacity(0.5),
                          strokeWidth: 1,
                          dashArray: [5, 5],
                          label: VerticalLineLabel(
                            show: true,
                            alignment: Alignment.topCenter,
                            padding: const EdgeInsets.only(bottom: 8),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                            labelResolver: (line) => '150%',
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Add information about pump rated values if available
          if (pumpSystemData.form.pumpRatedGPM.isNotEmpty ||
              pumpSystemData.form.pumpRatedPSI.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (pumpSystemData.form.pumpRatedGPM.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Chip(
                        label: Text(
                          'Rated GPM: ${pumpSystemData.form.pumpRatedGPM}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        backgroundColor: Colors.blue.shade100,
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                  if (pumpSystemData.form.pumpRatedPSI.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Chip(
                        label: Text(
                          'Rated PSI: ${pumpSystemData.form.pumpRatedPSI}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        backgroundColor: Colors.blue.shade100,
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                ],
              ),
            ),
            
          // Show NFPA compliance indicator
          if (testSpots.isNotEmpty && minAcceptableSpots.isNotEmpty)
            _buildComplianceIndicator(testSpots, minAcceptableSpots),
        ],
      ),
    );
  }
  
  Widget _buildComplianceIndicator(List<FlSpot> testSpots, List<FlSpot> minAcceptableSpots) {
    // Check if all test points meet NFPA requirements (above 95% of rated)
    bool isCompliant = true;
    
    // For each test point, check if it's above minimum acceptable curve
    for (final spot in testSpots) {
      // Find the closest point on the min acceptable curve by flow rate
      for (int i = 0; i < minAcceptableSpots.length - 1; i++) {
        if (spot.x >= minAcceptableSpots[i].x && 
            spot.x <= minAcceptableSpots[i + 1].x) {
          // Interpolate to find the minimum acceptable pressure at this flow
          final ratio = (spot.x - minAcceptableSpots[i].x) / 
                      (minAcceptableSpots[i + 1].x - minAcceptableSpots[i].x);
          final minPressure = minAcceptableSpots[i].y + 
                            ratio * (minAcceptableSpots[i + 1].y - minAcceptableSpots[i].y);
          
          if (spot.y < minPressure) {
            isCompliant = false;
            break;
          }
        }
      }
      if (!isCompliant) break;
    }
    
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: isCompliant ? Colors.green.shade100 : Colors.red.shade100,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: isCompliant ? Colors.green.shade700 : Colors.red.shade700,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isCompliant ? Icons.check_circle : Icons.warning,
              color: isCompliant ? Colors.green.shade700 : Colors.red.shade700,
            ),
            const SizedBox(width: 8),
            Text(
              isCompliant 
                ? 'NFPA 25 Compliant: All test points meet requirements'
                : 'NFPA 25 Warning: Some test points below 95% of rated curve',
              style: TextStyle(
                color: isCompliant ? Colors.green.shade900 : Colors.red.shade900,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}