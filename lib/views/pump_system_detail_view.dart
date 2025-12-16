// lib/views/pump_system_detail_view.dart
// ignore_for_file: deprecated_member_use

import 'dart:math';
import 'package:flutter/material.dart';
import '../models/pump_system_data.dart';

class PumpSystemDetailView extends StatelessWidget {
  final PumpSystemData pumpSystemData;

  const PumpSystemDetailView({super.key, required this.pumpSystemData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          return const SizedBox.shrink();
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
          children: [
            _buildInfoRow('Remarks On Test', form.remarksOnTest),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  flex: 1,
                  child: Text(
                    'PDF Path',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: SelectableText(
                    form.pdfPath.isEmpty ? 'N/A' : form.pdfPath,
                    style: const TextStyle(color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
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
    
    // AUTO-SCALING X-AXIS: Calculate max flow from all data points
    final maxFlow = _calculateMaxFlow(data.allPoints);
    
    // AUTO-SCALING X-AXIS: Generate dynamic N^1.85 and flow values based on maxFlow
    final nPowerValues = _generateNPowerValues(maxFlow);
    final flowValues = _generateFlowValues(maxFlow);
    
    // AUTO-SCALING Y-AXIS: Calculate max PSI from all data points
    final maxPsi = _calculateMaxPsi(data.allPoints);
    
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
    
    // AUTO-SCALING X-AXIS: Calculate X scaling factor based on dynamic nPowerValues
    final totalSpan = nPowerValues.isEmpty ? 1.0 : nPowerValues.last - nPowerValues.first;
    final xScaleFactor = gridWidth / totalSpan;
    
    // AUTO-SCALING Y-AXIS: Use calculated maxPsi
    final yScaleFactor = gridHeight / maxPsi;
    
    // AUTO-SCALING X-AXIS: Calculate X positions dynamically
    final xPositions = nPowerValues.map((val) => 
        margin + (val - nPowerValues.first) * xScaleFactor).toList();
    
    // Draw vertical grid line at zero
    canvas.drawLine(
      Offset(margin, margin),
      Offset(margin, size.height - margin),
      boldPaint,
    );
    
    // Draw vertical grid lines
    for (int i = 0; i < xPositions.length; i++) {
      Paint linePaintToUse;
      if ((i + 1) % 10 == 0) {
        linePaintToUse = boldPaint;
      } else if ((i + 1) % 5 == 0) {
        linePaintToUse = Paint()..color = Colors.grey.shade500..strokeWidth = 1.5;
      } else {
        linePaintToUse = paint;
      }
      
      canvas.drawLine(
        Offset(xPositions[i], margin),
        Offset(xPositions[i], size.height - margin),
        linePaintToUse,
      );
    }
    
    // AUTO-SCALING Y-AXIS: Dynamic PSI step based on maxPsi
    int psiStep = maxPsi <= 200 ? 10 : (maxPsi <= 400 ? 20 : 50);
    
    // Draw horizontal grid lines with dynamic spacing
    for (int psi = 0; psi <= maxPsi.toInt(); psi += psiStep) {
      final y = size.height - margin - (psi * yScaleFactor);
      bool isBold = psi % (psiStep * 5) == 0 || psi == 0;
      canvas.drawLine(
        Offset(margin, y),
        Offset(size.width - margin, y),
        isBold ? boldPaint : paint,
      );
    }
    
    // Draw labels
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    
    // AUTO-SCALING X-AXIS: Draw dynamic X-axis labels
    // Label 0
    textPainter.text = TextSpan(
      text: '0',
      style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(margin - textPainter.width / 2, size.height - margin + 8));
    
    // Adaptive labeling based on flow range
    int labelStep;
    if (maxFlow <= 500) {
      labelStep = 1; // Label every 100 GPM (indices 0, 1, 2, 3, 4)
    } else if (maxFlow <= 1000) {
      labelStep = 2; // Label every 200 GPM (indices 1, 3, 5, 7, 9)
    } else if (maxFlow <= 2000) {
      labelStep = 5; // Label every 500 GPM (indices 4, 9, 14, 19)
    } else {
      labelStep = 10; // Label every 1000 GPM (indices 9, 19, 29)
    }
    
    for (int i = labelStep - 1; i < xPositions.length; i += labelStep) {
      final x = xPositions[i];
      textPainter.text = TextSpan(
        text: '${flowValues[i].toInt()}',
        style: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 12,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, size.height - margin + 8));
    }
    
    // AUTO-SCALING Y-AXIS: Dynamic Y-axis label step
    int yLabelStep = maxPsi <= 200 ? 20 : (maxPsi <= 400 ? 50 : 100);
    
    // Y-axis labels with dynamic spacing
    for (int psi = 0; psi <= maxPsi.toInt(); psi += yLabelStep) {
      final y = size.height - margin - (psi * yScaleFactor);
      
      textPainter.text = TextSpan(
        text: '$psi',
        style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(margin - textPainter.width - 8, y - textPainter.height / 2));
    }
    
    // X-axis title
    textPainter.text = TextSpan(
      text: 'Flow (GPM) N^1.85 [0-${maxFlow.toInt()}]',
      style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width / 2 - textPainter.width / 2, size.height - 15));
    
    // Y-axis title
    canvas.save();
    canvas.translate(15, size.height / 2);
    canvas.rotate(-3.14159 / 2);
    textPainter.text = TextSpan(
      text: 'Pressure (PSI) [0-${maxPsi.toInt()}]',
      style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(-textPainter.width / 2, 0));
    canvas.restore();
    
    // Plot curves
    if (data.testPoints.isNotEmpty) {
      _drawCurve(canvas, data.testPoints, nPowerValues, yScaleFactor, 
                  size, margin, testPointPaint, testLinePaint, textPainter, 'Test', xScaleFactor);
    }
    
    if (data.ratedPoints.isNotEmpty) {
      _drawCurve(canvas, data.ratedPoints, nPowerValues, yScaleFactor, 
                  size, margin, ratedPointPaint, ratedLinePaint, textPainter, 'Rated', xScaleFactor);
    }
  }
  
  // AUTO-SCALING X-AXIS: Calculate max flow from all points
  double _calculateMaxFlow(List<FlowCurvePoint> allPoints) {
    if (allPoints.isEmpty) return 500.0; // Default to 500 GPM
    double maxFlow = allPoints.map((p) => p.flow).reduce(max);
    if (maxFlow <= 500) return 500.0;
    if (maxFlow <= 1000) return 1000.0;
    // Round up to next 1000 after that
    return ((maxFlow / 1000).ceil() * 1000).toDouble();
  }
  
  // AUTO-SCALING X-AXIS: Generate N^1.85 values up to maxFlow
  List<double> _generateNPowerValues(double maxFlow) {
    List<double> values = [];
    int maxN = (maxFlow / 100).ceil();
    for (int n = 1; n <= maxN; n++) {
      values.add(pow(n, 1.85).toDouble());
    }
    return values;
  }
  
  // AUTO-SCALING X-AXIS: Generate flow labels up to maxFlow
  List<double> _generateFlowValues(double maxFlow) {
    List<double> values = [];
    int maxN = (maxFlow / 100).ceil();
    for (int n = 1; n <= maxN; n++) {
      values.add(n * 100.0);
    }
    return values;
  }
  
  // AUTO-SCALING Y-AXIS: Calculate max PSI from all points
  double _calculateMaxPsi(List<FlowCurvePoint> allPoints) {
    if (allPoints.isEmpty) return 150.0;
    double maxPsi = allPoints.map((p) => p.psi).reduce(max);
    // Round up to nearest 50, clamped between 150 and 1000
    return ((maxPsi / 50).ceil() * 50).toDouble().clamp(150, 1000);
  }
  
  void _drawCurve(Canvas canvas, List<FlowCurvePoint> points, List<double> nPowerValues,
                  double yScaleFactor, Size size, double margin,
                  Paint pointPaint, Paint linePaint, TextPainter textPainter, 
                  String curveType, double xScaleFactor) {
    
    // Draw fill under curve - ONLY for Test curve (blue)
    if (points.length > 1 && curveType == 'Test') {
      final fillPath = Path();
      final firstX = _flowToX(points.first.flow, nPowerValues, margin, xScaleFactor);
      fillPath.moveTo(firstX, size.height - margin);
      
      for (final point in points) {
        final plotX = _flowToX(point.flow, nPowerValues, margin, xScaleFactor);
        final plotY = size.height - margin - (point.psi * yScaleFactor);
        fillPath.lineTo(plotX, plotY);
      }
      
      // Close the path
      final lastX = _flowToX(points.last.flow, nPowerValues, margin, xScaleFactor);
      fillPath.lineTo(lastX, size.height - margin);
      fillPath.close();
      
      final fillPaint = Paint()
        ..color = Colors.blue.shade800.withOpacity(0.1)
        ..style = PaintingStyle.fill;
      
      canvas.drawPath(fillPath, fillPaint);
    }
    
    // Draw connecting lines
    if (points.length > 1) {
      final path = Path();
      bool firstPoint = true;
      
      for (final point in points) {
        final plotX = _flowToX(point.flow, nPowerValues, margin, xScaleFactor);
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
      final plotX = _flowToX(point.flow, nPowerValues, margin, xScaleFactor);
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
  
  // AUTO-SCALING X-AXIS: Convert flow to X position using dynamic N^1.85
  double _flowToX(double flow, List<double> nPowerValues, double margin, double xScaleFactor) {
    if (flow <= 0) return margin; // Zero flow at left edge
    double n = flow / 100.0;
    double nPower = pow(n, 1.85).toDouble();
    double nFirst = nPowerValues.isNotEmpty ? nPowerValues.first : 1.0;
    return margin + (nPower - nFirst) * xScaleFactor;
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
          if (netPsi > 1000 || totalFlow > 10000) continue;
          
          testPoints.add(FlowCurvePoint(totalFlow, netPsi));
        } catch (e) {
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
        if (ratedGPM > 0 && ratedPSI > 0 && ratedGPM < 10000 && ratedPSI < 1000) {
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