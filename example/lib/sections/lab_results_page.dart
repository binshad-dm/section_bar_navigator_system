import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LabResultPage extends StatefulWidget {
  const LabResultPage({super.key});

  @override
  State<LabResultPage> createState() => _LabResultPageState();
}

class _LabResultPageState extends State<LabResultPage> {
  int currentPageIndex = 0;
  late final PageController _pageController;
  List<Widget> screens = [
    LabResultsTab(),
    //  PDFView(
    //   filePath: "assets/pdf_file/bill-clearance_15-Jul-2025 (2).pdf",
    //   enableSwipe: true,
    //   swipeHorizontal: true,
    //   autoSpacing: false,
    //   pageFling: false,
    //   backgroundColor: Colors.grey,

    //   onError: (error) {
    //     print(error.toString());
    //   },
    // ),
    // PDFView(
    //   filePath: "assets/pdf_file/15-Jan-2020 (Thyroid and Vitamin D).pdf",
    //   enableSwipe: true,
    //   swipeHorizontal: true,
    //   autoSpacing: false,
    //   pageFling: false,
    //   backgroundColor: Colors.grey,

    //   onError: (error) {
    //     print(error.toString());
    //   },
    // ),
    
    //  PDFView(
    //   filePath: "assets/pdf_file/19-Nov-2023 (Sodium potasium).pdf",
    //   enableSwipe: true,
    //   swipeHorizontal: true,
    //   autoSpacing: false,
    //   pageFling: false,
    //   backgroundColor: Colors.grey,

    //   onError: (error) {
    //     print(error.toString());
    //   },
    // ),
  ];
  @override
  void initState() {
    _pageController = PageController(initialPage: currentPageIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: screens.length,
      onPageChanged: (idx) => setState(() => currentPageIndex = idx),
      itemBuilder: (context, index) => Scaffold(
        backgroundColor: Colors.grey[50],
        body: screens[index]),
    );
  }
}







class LabResultsTab extends StatefulWidget {
  const LabResultsTab({super.key});

  @override
  State<LabResultsTab> createState() => _LabResultsTabState();
}

class _LabResultsTabState extends State<LabResultsTab> {
  String _selectedRange = 'Last 6 Months';
  late final PatientLabData _patientData;

  @override
  void initState() {
    _patientData = _generateDummyPatient();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          ..._patientData.series.map((s) => _LabAnalyteCard(series: s)),
        ],
      );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.blue[100],
            child: Text(
              'SJ',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.blue[700],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _patientData.name,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${_patientData.age} yrs • ${_patientData.gender}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 180,
            child: DropdownButtonFormField<String>(
              value: _selectedRange,
              items: const [
                'Last 3 Months',
                'Last 6 Months',
                'Last Year',
                'All Time',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => _selectedRange = v!),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Range',
              ),
            ),
          ),
        ],
      ),
    );
  }

  PatientLabData _generateDummyPatient() {
    final now = DateTime.now();
    List<Point> series(int days, double base, double amp, double freq) =>
        List.generate(
          days,
          (i) => Point(
            now.subtract(Duration(days: days - i)),
            base + amp * math.sin(i / freq),
          ),
        );

    return PatientLabData(
      name: 'Sarah Johnson',
      age: 34,
      gender: 'Female',
      series: [
        LabSeries(
          'Hemoglobin',
          'g/dL',
          '12.0 - 15.5',
          series(60, 13.4, 0.6, 4),
        ),
        LabSeries('WBC', 'K/µL', '4.5 - 11.0', series(60, 7.2, 2.5, 5)),
        LabSeries('Platelets', 'K/µL', '150 - 450', series(60, 220, 40, 8)),
        LabSeries('Glucose (FBS)', 'mg/dL', '70 - 100', series(60, 95, 20, 6)),
        LabSeries('Creatinine', 'mg/dL', '0.7 - 1.3', series(60, 0.9, 0.2, 10)),
        LabSeries('BUN', 'mg/dL', '7 - 20', series(60, 14, 6, 7)),
        LabSeries('Sodium', 'mEq/L', '135 - 145', series(60, 139, 3, 9)),
        LabSeries('Potassium', 'mEq/L', '3.5 - 5.0', series(60, 4.2, 0.5, 11)),
        LabSeries('ALT', 'U/L', '7 - 56', series(60, 32, 12, 12)),
        LabSeries('AST', 'U/L', '10 - 40', series(60, 28, 10, 13)),
      ],
    );
  }
}

class _LabAnalyteCard extends StatelessWidget {
  final LabSeries series;
  const _LabAnalyteCard({required this.series});

  Color _statusColor(double v, String ref) {
    final parts = ref.replaceAll(' ', '').split('-');
    if (parts.length == 2) {
      final lo = double.tryParse(parts.first) ?? double.negativeInfinity;
      final hi = double.tryParse(parts.last) ?? double.infinity;
      if (v < lo) return Colors.orange;
      if (v > hi) return Colors.red;
      return Colors.green;
    }
    return Colors.blueGrey;
  }

  @override
  Widget build(BuildContext context) {
    final latest = series.points.last.value;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  series.name,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor(
                    latest,
                    series.reference,
                  ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _statusColor(latest, series.reference),
                  ),
                ),
                child: Text(
                  '${latest.toStringAsFixed(1)} ${series.unit}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: _statusColor(latest, series.reference),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Ref: ${series.reference}',
            style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 130,
            width: double.infinity,
            child: CustomPaint(painter: _Sparkline(series.points)),
          ),
        ],
      ),
    );
  }
}

class _Sparkline extends CustomPainter {
  final List<Point> pts;
  _Sparkline(this.pts);

  @override
  void paint(Canvas canvas, Size size) {
    if (pts.length < 2) return;
    // Expanded margins to fit axis labels
    final left = 44.0, top = 8.0, right = 8.0, bottom = 28.0;
    final w = size.width - left - right;
    final h = size.height - top - bottom;
    final rect = Rect.fromLTWH(left, top, w, h);

    final border = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke;
    canvas.drawRect(rect, border);

    double minV = pts.first.value, maxV = pts.first.value;
    for (final p in pts) {
      minV = math.min(minV, p.value);
      maxV = math.max(maxV, p.value);
    }
    if (maxV == minV) maxV = minV + 1;

    final minT = pts.first.time.millisecondsSinceEpoch.toDouble();
    final maxT = pts.last.time.millisecondsSinceEpoch.toDouble();
    double xFor(DateTime t) =>
        left + w * (t.millisecondsSinceEpoch - minT) / (maxT - minT);
    double yFor(double v) => top + h * (1 - (v - minV) / (maxV - minV));

    // --- Y Axis ticks and grid ---
    const int yTicks = 4;
    final gridPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke;
    for (int i = 0; i <= yTicks; i++) {
      final t = i / yTicks;
      final y = top + h * (1 - t);
      // grid line
      canvas.drawLine(Offset(left, y), Offset(left + w, y), gridPaint);
      // tick label
      final val = (minV + (maxV - minV) * t);
      final textSpan = TextSpan(
        text: val.toStringAsFixed(1),
        style: TextStyle(fontSize: 10, color: Colors.grey[700]),
      );
      final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      tp.layout(maxWidth: left - 6);
      tp.paint(canvas, Offset(left - tp.width - 6, y - tp.height / 2));
    }

    // --- X Axis ticks and grid ---
    const int xTicks = 4;
    for (int i = 0; i <= xTicks; i++) {
      final t = i / xTicks;
      final xEpoch = minT + (maxT - minT) * t;
      final x = left + w * t;
      // grid line
      canvas.drawLine(Offset(x, top), Offset(x, top + h), gridPaint);
      // tick label (date)
      final dt = DateTime.fromMillisecondsSinceEpoch(xEpoch.round());
      final label = _formatDateTick(dt);
      final textSpan = TextSpan(
        text: label,
        style: TextStyle(fontSize: 10, color: Colors.grey[700]),
      );
      final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      tp.layout(maxWidth: 60);
      tp.paint(canvas, Offset(x - tp.width / 2, top + h + 4));
    }

    final path = Path();
    for (int i = 0; i < pts.length; i++) {
      final p = Offset(xFor(pts[i].time), yFor(pts[i].value));
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    for (final p in [pts.first, pts.last]) {
      final off = Offset(xFor(p.time), yFor(p.value));
      canvas.drawCircle(off, 2.5, Paint()..color = Colors.blue);
    }
  }

  String _formatDateTick(DateTime dt) {
    // Compact date for axis: e.g., 12 Jan or Jan '25
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    return '${dt.day} ${months[dt.month - 1]}';
  }

  @override
  bool shouldRepaint(covariant _Sparkline oldDelegate) => true;
}

class PatientLabData {
  final String name;
  final int age;
  final String gender;
  final List<LabSeries> series;
  PatientLabData({
    required this.name,
    required this.age,
    required this.gender,
    required this.series,
  });
}

class LabSeries {
  final String name;
  final String unit;
  final String reference;
  final List<Point> points;
  LabSeries(this.name, this.unit, this.reference, this.points);
}

class Point {
  final DateTime time;
  final double value;
  Point(this.time, this.value);
}
