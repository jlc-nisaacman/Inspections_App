// lib/views/pump_system_detail_view.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
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
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FlowCurveGrid(pumpSystemData: pumpSystemData),
            ),
          ),
        ],
      ),
    );
  }
}

class FlowCurveGrid extends StatelessWidget {
  final PumpSystemData pumpSystemData;
  
  const FlowCurveGrid({super.key, required this.pumpSystemData});
  
  // Scale definitions
  static const Map<String, List<double>> scales = {
    'A': [100, 200, 300, 400, 500],
    'B': [200, 400, 600, 800, 1000],
    'C': [400, 800, 1200, 1600, 2000],
    'D': [800, 1600, 2400, 3200, 4000],
  };
  
  // N^1.85 base values
  static const List<double> nPowerValues = [1.0, 3.6, 7.6, 13.0, 19.7];
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: FlowCurveGridPainter(pumpSystemData: pumpSystemData),
        );
      },
    );
  }
}

class FlowCurveGridPainter extends CustomPainter {
  final PumpSystemData pumpSystemData;
  
  FlowCurveGridPainter({required this.pumpSystemData});
  
  @override
  void paint(Canvas canvas, Size size) {
    // Prepare data
    final data = _prepareChartData();
    final selectedScale = _determineOptimalScale(data.allPoints);
    
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1;
    
    final boldPaint = Paint()
      ..color = Colors.grey.shade600
      ..strokeWidth = 2;
    
    final testPointPaint = Paint()
      ..color = Colors.blue.shade800
      ..strokeWidth = 3;
    
    final ratedPointPaint = Paint()
      ..color = Colors.red.shade700
      ..strokeWidth = 3;
    
    final testLinePaint = Paint()
      ..color = Colors.blue.shade800
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    
    final ratedLinePaint = Paint()
      ..color = Colors.red.shade700
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    
    // Calculate margins
    final margin = 80.0;
    final gridWidth = size.width - 2 * margin;
    final gridHeight = size.height - 2 * margin;
    
    // Calculate scaling factors
    final totalSpan = FlowCurveGrid.nPowerValues.last - FlowCurveGrid.nPowerValues.first;
    final xScaleFactor = gridWidth / totalSpan;
    final yScaleFactor = gridHeight / 150; // 150 PSI range
    
    // Calculate X positions
    final xPositions = FlowCurveGrid.nPowerValues.map((val) => 
        margin + (val - FlowCurveGrid.nPowerValues.first) * xScaleFactor).toList();
    
    // Draw vertical grid lines
    for (int i = 0; i < xPositions.length; i++) {
      canvas.drawLine(
        Offset(xPositions[i], margin),
        Offset(xPositions[i], size.height - margin),
        boldPaint,
      );
    }
    
    // Draw horizontal grid lines (every 10 PSI)
    for (int psi = 0; psi <= 150; psi += 10) {
      final y = size.height - margin - (psi * yScaleFactor);
      canvas.drawLine(
        Offset(margin, y),
        Offset(size.width - margin, y),
        psi % 50 == 0 ? boldPaint : paint,
      );
    }
    
    // Draw labels
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    
    // X-axis labels (show only selected scale, highlighted)
    for (int i = 0; i < xPositions.length; i++) {
      final x = xPositions[i];
      final scaleValues = FlowCurveGrid.scales[selectedScale]!;
      
      textPainter.text = TextSpan(
        text: '${scaleValues[i].toInt()}',
        style: TextStyle(
          color: Colors.blue.shade700,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, size.height - margin + 15));
    }
    
    // Y-axis labels
    for (int psi = 0; psi <= 150; psi += 20) {
      final y = size.height - margin - (psi * yScaleFactor);
      
      textPainter.text = TextSpan(
        text: '$psi',
        style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(margin - textPainter.width - 8, y - textPainter.height / 2));
    }
    
    // Axis labels
    textPainter.text = TextSpan(
      text: 'Flow GPM N^1.85 (Scale: $selectedScale)',
      style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width / 2 - textPainter.width / 2, size.height - 15));
    
    // Rotate and draw Y-axis label
    canvas.save();
    canvas.translate(15, size.height / 2);
    canvas.rotate(-3.14159 / 2);
    textPainter.text = TextSpan(
      text: 'Pressure (PSI)',
      style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(-textPainter.width / 2, 0));
    canvas.restore();
    
    // Draw curves and points
    _drawCurve(canvas, data.testPoints, selectedScale, xPositions, size, margin, yScaleFactor, 
               testLinePaint, testPointPaint, 'Test', fillArea: true);
    _drawCurve(canvas, data.ratedPoints, selectedScale, xPositions, size, margin, yScaleFactor, 
               ratedLinePaint, ratedPointPaint, 'Rated');
  }
  
  void _drawCurve(Canvas canvas, List<FlowCurvePoint> points, String selectedScale, 
                  List<double> xPositions, Size size, double margin, double yScaleFactor,
                  Paint linePaint, Paint pointPaint, String curveType, {bool fillArea = false}) {
    if (points.isEmpty) return;
    
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    
    // Sort points by flow value for line drawing
    points.sort((a, b) => a.flow.compareTo(b.flow));
    
    // Draw area fill first (if requested)
    if (fillArea && points.length > 1) {
      final fillPaint = Paint()
        ..color = Colors.blue.shade800.withOpacity(0.1)
        ..style = PaintingStyle.fill;
      
      final fillPath = Path();
      
      // Start at bottom left of first point
      final firstX = _plotXPosition(points.first.flow, selectedScale, xPositions);
      fillPath.moveTo(firstX, size.height - margin);
      
      // Draw up to first point
      final firstY = size.height - margin - (points.first.psi * yScaleFactor);
      fillPath.lineTo(firstX, firstY);
      
      // Follow the curve
      for (final point in points) {
        final plotX = _plotXPosition(point.flow, selectedScale, xPositions);
        final plotY = size.height - margin - (point.psi * yScaleFactor);
        fillPath.lineTo(plotX, plotY);
      }
      
      // Close the path by going down to bottom and back to start
      final lastX = _plotXPosition(points.last.flow, selectedScale, xPositions);
      fillPath.lineTo(lastX, size.height - margin);
      fillPath.close();
      
      canvas.drawPath(fillPath, fillPaint);
    }
    
    // Draw connecting lines
    if (points.length > 1) {
      final path = Path();
      bool firstPoint = true;
      
      for (final point in points) {
        final plotX = _plotXPosition(point.flow, selectedScale, xPositions);
        final plotY = size.height - margin - (point.psi * yScaleFactor);
        
        if (firstPoint) {
          path.moveTo(plotX, plotY);
          firstPoint = false;
        } else {
          path.lineTo(plotX, plotY);
        }
      }
      canvas.drawPath(path, linePaint);
    }
    
    // Draw points
    for (final point in points) {
      final plotX = _plotXPosition(point.flow, selectedScale, xPositions);
      final plotY = size.height - margin - (point.psi * yScaleFactor);
      
      canvas.drawCircle(Offset(plotX, plotY), 4, pointPaint);
      
      // Draw point label
      textPainter.text = TextSpan(
        text: '(${point.flow.toInt()}, ${point.psi.toInt()})',
        style: TextStyle(
          color: curveType == 'Test' ? Colors.blue.shade700 : Colors.red.shade700, 
          fontSize: 10
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(plotX + 6, plotY - 15));
    }
  }
  
  double _plotXPosition(double flowValue, String scale, List<double> xPositions) {
    final scaleValues = FlowCurveGrid.scales[scale]!;
    
    // Clamp flowValue to reasonable bounds (0 to 150% of max scale)
    final clampedFlow = flowValue.clamp(0, scaleValues.last * 1.5);
    
    // Find which interval the flowValue falls in
    for (int i = 0; i < scaleValues.length - 1; i++) {
      if (clampedFlow >= scaleValues[i] && clampedFlow <= scaleValues[i + 1]) {
        // Linear interpolation between grid positions
        final ratio = (clampedFlow - scaleValues[i]) / (scaleValues[i + 1] - scaleValues[i]);
        return xPositions[i] + (xPositions[i + 1] - xPositions[i]) * ratio;
      }
    }
    
    // If still outside range after clamping, handle edge cases
    if (clampedFlow <= scaleValues.first) {
      // For values at or below the first scale value, place at the first position
      return xPositions.first;
    } else {
      // For values above the last scale value, extrapolate but keep within reasonable bounds
      final lastIndex = scaleValues.length - 1;
      final ratio = (clampedFlow - scaleValues[lastIndex - 1]) / (scaleValues[lastIndex] - scaleValues[lastIndex - 1]);
      final position = xPositions[lastIndex - 1] + (xPositions[lastIndex] - xPositions[lastIndex - 1]) * ratio;
      
      // Ensure we don't go beyond the right margin
      final margin = 80.0;
      return position.clamp(margin, xPositions.last + 50); // Allow slight overflow for visibility
    }
  }
  
  String _determineOptimalScale(List<FlowCurvePoint> allPoints) {
    if (allPoints.isEmpty) return 'A';
    
    // Filter out zero/negative values for scale calculation
    final validPoints = allPoints.where((p) => p.flow > 0).toList();
    if (validPoints.isEmpty) return 'A';
    
    // Find the maximum flow value from valid data points
    double maxFlow = validPoints.map((p) => p.flow).reduce((a, b) => a > b ? a : b);
    
    // Select the smallest scale that can accommodate the max flow
    for (var entry in FlowCurveGrid.scales.entries) {
      if (maxFlow <= entry.value.last) {
        return entry.key;
      }
    }
    
    // If all scales are too small, use the largest one (D)
    return 'D';
  }
  
  ChartData _prepareChartData() {
    final testPoints = <FlowCurvePoint>[];
    final ratedPoints = <FlowCurvePoint>[];
    
    // Extract test data points
    final flowTests = pumpSystemData.getFlowTests();
    for (var test in flowTests) {
      if (test['netPSI']?.isNotEmpty == true && test['totalFlow']?.isNotEmpty == true) {
        try {
          final netPsi = double.parse(test['netPSI']!);
          final totalFlow = double.parse(test['totalFlow']!);
          
          // Filter out invalid data points
          if (netPsi < 0 || totalFlow < 0 || (netPsi == 0 && totalFlow == 0)) continue;
          if (netPsi > 200 || totalFlow > 10000) continue; // Filter out unreasonable values
          
          testPoints.add(FlowCurvePoint(totalFlow, netPsi));
        } catch (e) {
          // Skip points that can't be parsed
          continue;
        }
      }
    }
    
    // Generate rated curve if we have rated values
    if (pumpSystemData.form.pumpRatedGPM.isNotEmpty && 
        pumpSystemData.form.pumpRatedPSI.isNotEmpty) {
      try {
        final ratedGPM = double.parse(pumpSystemData.form.pumpRatedGPM);
        final ratedPSI = double.parse(pumpSystemData.form.pumpRatedPSI);
        
        // Validate rated values
        if (ratedGPM > 0 && ratedPSI > 0 && ratedGPM < 10000 && ratedPSI < 200) {
          // Get actual shutoff pressure from database (Max PSI)
          double shutoffPSI;
          if (pumpSystemData.form.pumpMaxPSI.isNotEmpty) {
            shutoffPSI = double.parse(pumpSystemData.form.pumpMaxPSI);
          } else {
            shutoffPSI = ratedPSI * 1.3; // Fallback estimate
          }
          
          // Use only exact manufacturer data points
          ratedPoints.add(FlowCurvePoint(0.0, shutoffPSI)); // Shutoff point
          ratedPoints.add(FlowCurvePoint(ratedGPM, ratedPSI)); // Rated point
          
          // Add 150% point if available in database
          if (pumpSystemData.form.pumpPSIAt150Percent.isNotEmpty) {
            final psi150 = double.parse(pumpSystemData.form.pumpPSIAt150Percent);
            ratedPoints.add(FlowCurvePoint(ratedGPM * 1.5, psi150)); // 150% point
          }
        }
      } catch (e) {
        // If we can't parse rated values, just use test curve
        ratedPoints.clear();
      }
    }
    
    return ChartData(testPoints, ratedPoints);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class FlowCurvePoint {
  final double flow;
  final double psi;
  
  FlowCurvePoint(this.flow, this.psi);
}

class ChartData {
  final List<FlowCurvePoint> testPoints;
  final List<FlowCurvePoint> ratedPoints;
  
  ChartData(this.testPoints, this.ratedPoints);
  
  List<FlowCurvePoint> get allPoints => [...testPoints, ...ratedPoints];
}