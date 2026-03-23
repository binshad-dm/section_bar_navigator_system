import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnestheticTab extends StatefulWidget {
	const AnestheticTab({super.key});

	@override
	State<AnestheticTab> createState() => _AnestheticTabState();
}

class _AnestheticTabState extends State<AnestheticTab> {
	// Simple controllers for text fields; this screen is UI-only.
	final Map<String, TextEditingController> _c = {};

	TextEditingController ctrl(String key) => _c.putIfAbsent(key, () => TextEditingController());

	@override
	void dispose() {
		for (final controller in _c.values) {
			controller.dispose();
		}
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return SingleChildScrollView(
			padding: const EdgeInsets.all(12),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					_buildSection('Type of Anesthesia', _buildTypeOfAnesthesia()),
					const SizedBox(height: 12),
					_buildSection('Airway', _buildAirwayTop()),
					const SizedBox(height: 12),
					_buildSection('Maintenance', _buildMaintenance()),
					const SizedBox(height: 12),
					_buildSection('Ventilation', _buildVentilation()),
					const SizedBox(height: 12),
					_buildSection('Monitoring', _buildMonitoring()),
					const SizedBox(height: 12),
					_buildSection('Lines', _buildLines()),
					const SizedBox(height: 12),
					_buildSection('Spinal', _buildSpinal()),
					const SizedBox(height: 12),
					_buildSection('Epidural', _buildEpidural()),
					const SizedBox(height: 12),
					_buildSection('Nerve Blocks', _buildMultiline('nerveBlocks', maxLines: 3)),
					const SizedBox(height: 12),
					_buildSection('Respiratory Management', _buildRespiratoryManagement()),
					const SizedBox(height: 12),
					_buildSection('Patient Position', _buildPatientPosition()),
					const SizedBox(height: 12),
					_buildSection('Peripheral/truncal nerve block', _buildPeripheralBlock()),
					const SizedBox(height: 12),
					_buildSection('Local Anesthetics Used', _buildLocalAnesthetics()),
					const SizedBox(height: 12),
					_buildSection('Central Nerve Block', _buildCentralNerveBlock()),
					const SizedBox(height: 12),
					_buildSection('Adverse Anesthesia event/CAPA', _buildMultiline('capa', maxLines: 3)),
					const SizedBox(height: 16),
					_buildSection('Saturation', _buildSaturationPlaceholder()),
					const SizedBox(height: 12),
					_buildSection('Circuit', _buildCircuit()),
					const SizedBox(height: 12),
					_buildSection('Notes', _buildNotes()),
					const SizedBox(height: 16),
					Align(
						alignment: Alignment.center,
						child: Wrap(
							spacing: 8,
							children: [
								OutlinedButton(onPressed: () {}, child: const Text('New')),
								OutlinedButton(onPressed: () {}, child: const Text('Edit')),
								OutlinedButton(onPressed: () {}, child: const Text('Delete')),
								OutlinedButton(onPressed: () {}, child: const Text('Preview')),
								OutlinedButton(onPressed: () {}, child: const Text('Cancel')),
								OutlinedButton(onPressed: () {}, child: const Text('Final Approval')),
							],
						),
					),
				],
			),
		);
	}

	Widget _buildTypeOfAnesthesia() {
		return Wrap(spacing: 12, runSpacing: 8, children: [
			_toggle('Anesthetic'), _toggle('GA'), _toggle('RA'), _toggle('LA'), _toggle('Sedation'),
			_toggle('Induction'), _toggle('IV'), _toggle('Gas'), _toggle('RSI'), _toggle('Cricoids pr.'),
		]);
	}

	Widget _buildAirwayTop() {
		return Column(
			children: [
				Wrap(spacing: 12, runSpacing: 8, children: [
					_toggle('Mask'), _toggle('LMA'), _toggle('ETT'), _toggle('Nasal'), _toggle('Trach'), _toggle('Cuffed'),
				]),
				const SizedBox(height: 8),
				Wrap(spacing: 12, runSpacing: 8, children: [
					SizedBox(width: 120, child: _tf('Size', 'airwaySize')),
					SizedBox(width: 160, child: _tf('Type', 'airwayType')),
					SizedBox(width: 180, child: _tf('Mask Ventilation', 'maskVentilation')),
					_toggle('Easy'), _toggle('Difficult'),
				]),
				const SizedBox(height: 8),
				Wrap(spacing: 12, runSpacing: 8, children: [
					Expanded(child: _tf('Laryngoscopy CL grade', 'laryngoscopy')),
					Expanded(child: _tf('Aids to intubation', 'aidsToIntubation')),
				]),
			],
		);
	}

	Widget _buildMaintenance() {
		return Column(children: [
			Wrap(spacing: 12, runSpacing: 8, children: [
				Expanded(child: _tf('Agent', 'agent')),
				SizedBox(width: 180, child: _tf('O2/N2O/Air Total Gas Flow', 'gasFlow')),
				SizedBox(width: 140, child: _tf('L/min', 'lpm')),
			]),
			const SizedBox(height: 8),
			Wrap(spacing: 12, runSpacing: 8, children: [
				_toggle('System'), _toggle('Circle'), _toggle('Brain'), _toggle('JR'),
			]),
		]);
	}

	Widget _buildVentilation() {
		return Column(children: [
			Wrap(spacing: 12, runSpacing: 8, children: [
				_toggle('Spont'), _toggle('Manual'), _toggle('V Mode'), _toggle('P Mode'),
			]),
			const SizedBox(height: 8),
			Wrap(spacing: 12, runSpacing: 8, children: [
				SizedBox(width: 140, child: _tf('Vt', 'vt')),
				SizedBox(width: 140, child: _tf('RR', 'rr')),
				SizedBox(width: 140, child: _tf('Paw', 'paw')),
				SizedBox(width: 140, child: _tf('PEEP', 'peep')),
			]),
		]);
	}

	Widget _buildMonitoring() {
		final items = [
			'ECG','ETCO2','Temp','Vapor Analyzer','NIBP','CVP/PAC','Fluid Warmer','Vent.Alarm','SpO2','TECO','Warm Blanket','PNS','FIO2','Inv BP','Urinary Catheter','BIS',
		];
		return Column(children: [
			Wrap(spacing: 16, runSpacing: 6, children: items.map((e) => _toggle(e)).toList()),
			const SizedBox(height: 8),
			Wrap(spacing: 12, runSpacing: 8, children: [
				SizedBox(width: 160, child: _tf('Eyes', 'eyes')),
				_toggle('Taped'),
				_toggle('Padded'),
				_toggle('Lubricant'),
			]),
			const SizedBox(height: 8),
			Wrap(spacing: 12, runSpacing: 8, children: [
				Expanded(child: _tf('Position', 'position')),
				_toggle('Asepsis for invasive procedures'),
				_toggle('TEDs/SCD/Heparin/LMWH'),
				_toggle('NG/OG tube inserted/in situ'),
				_toggle('Pressure Points Protected'),
				_toggle('LA infiltration by Surgeon'),
			]),
		]);
	}

	Widget _buildLines() {
		return Wrap(spacing: 12, runSpacing: 8, children: [
			SizedBox(width: 220, child: _tf('IV Access', 'ivAccess')),
			SizedBox(width: 220, child: _tf('Art Line', 'artLine')),
			SizedBox(width: 220, child: _tf('CVP Line', 'cvpLine')),
		]);
	}

	Widget _buildSpinal() {
		return Column(children: [
			Wrap(spacing: 12, runSpacing: 8, children: [
				SizedBox(width: 140, child: _tf('Time', 'spinalTime')),
				SizedBox(width: 160, child: _tf('Level', 'spinalLevel')),
				Expanded(child: _tf('Needle', 'spinalNeedle')),
			]),
			const SizedBox(height: 8),
			Wrap(spacing: 12, runSpacing: 8, children: [
				Expanded(child: _tf('Drugs', 'spinalDrugs')),
			]),
		]);
	}

	Widget _buildEpidural() {
		return Column(children: [
			Wrap(spacing: 12, runSpacing: 8, children: [
				SizedBox(width: 140, child: _tf('Time', 'epiTime')),
				SizedBox(width: 160, child: _tf('Level', 'epiLevel')),
				SizedBox(width: 160, child: _tf('Epidural Depth (cm)', 'epiDepth')),
				SizedBox(width: 160, child: _tf('Catheter at skin (cm)', 'epiCatheterSkin')),
			]),
			const SizedBox(height: 8),
			Wrap(spacing: 12, runSpacing: 8, children: [
				Expanded(child: _tf('Drugs', 'epiDrugs')),
			]),
		]);
	}

	Widget _buildRespiratoryManagement() {
		return Column(children: [
			Wrap(spacing: 12, runSpacing: 8, children: [
				Expanded(child: _tf('Guedel Airway', 'guedel')),
				Expanded(child: _tf('Mask', 'rmMask')),
				Expanded(child: _tf('Other', 'rmOther')),
			]),
			const SizedBox(height: 8),
			Wrap(spacing: 12, runSpacing: 8, children: [
				SizedBox(width: 200, child: _tf('LMA Size', 'lmaSize')),
				Expanded(child: _tf('ETT Oral (mm)', 'ettOral')),
				Expanded(child: _tf('ETT Nasal (mm)', 'ettNasal')),
				SizedBox(width: 160, child: _tf('Type', 'ettType')),
			]),
			const SizedBox(height: 8),
			Wrap(spacing: 12, runSpacing: 8, children: [
				SizedBox(width: 160, child: _tf('Taped at (cm)', 'tapedAt')),
				Expanded(child: _tf('Double Lumen', 'doubleLumen')),
				Expanded(child: _tf('PreO2', 'preo2')),
				Expanded(child: _tf('Cricoids', 'cricoids')),
			]),
			const SizedBox(height: 8),
			Wrap(spacing: 12, runSpacing: 8, children: [
				Expanded(child: _tf('Rapid Sequence Induction', 'rsiDetails')),
			]),
		]);
	}

	Widget _buildPatientPosition() {
		final positions = ['Supine','Lateral','Prone','Trendelenberg','Lithotomy','Eyes Protected'];
		return Column(children: [
			Wrap(spacing: 16, runSpacing: 6, children: positions.map((e) => _toggle(e)).toList()),
			const SizedBox(height: 8),
			Wrap(spacing: 12, children: [
				_toggle('Pressure areas padded'),
				const Text('Laryngoscopy grade'),
				for (final g in ['1','2','3','4']) Row(children: [Radio<String>(value: g, groupValue: null, onChanged: (_) {}), Text(g)]),
			]),
		]);
	}

	Widget _buildPeripheralBlock() {
		return Column(children: [
			Wrap(spacing: 12, runSpacing: 8, children: [
				Expanded(child: _tf('Type of Block', 'pType')),
				Expanded(child: _tf('Approach', 'pApproach')),
				Expanded(child: _tf('Asepsis', 'pAsepsis')),
			]),
			const SizedBox(height: 8),
			Wrap(spacing: 12, runSpacing: 8, children: [
				_toggle('Nerve Stimulator'),
				SizedBox(width: 140, child: _tf('Current (mA)', 'pCurrent')),
				SizedBox(width: 140, child: _tf('Initial', 'pInitial')),
				SizedBox(width: 140, child: _tf('Threshold', 'pThreshold')),
				_toggle('Paresthesia'), _toggle('Other'), _toggle('LOR(sheath)'),
			]),
			const SizedBox(height: 8),
			Wrap(spacing: 12, runSpacing: 8, children: [
				SizedBox(width: 180, child: _tf('Needle Type', 'pNeedleType')),
				SizedBox(width: 140, child: _tf('Size', 'pNeedleSize')),
				_toggle('Catheter Yes'), _toggle('Catheter No'), SizedBox(width: 160, child: _tf('If Yes, depth (cm)', 'pCathDepth')),
			]),
			const SizedBox(height: 8),
			Wrap(spacing: 12, runSpacing: 8, children: [
				_toggle('Presence of Paresthesia'), _toggle('Pain on Injection'), _toggle('Blood'), _toggle('CSF'),
			]),
		]);
	}

	Widget _buildLocalAnesthetics() {
		final agents = ['Bupivacaine','Lignocaine','Plain','Ropivacaine','Hyperparic','L-Bupivacaine','Other'];
		return Column(children: [
			Wrap(spacing: 16, runSpacing: 6, children: agents.map((e) => _toggle(e)).toList()),
			const SizedBox(height: 8),
			Wrap(spacing: 12, runSpacing: 8, children: [
				Expanded(child: _tf('Cone', 'laCone')),
				SizedBox(width: 120, child: _tf('%', 'laPercent')),
				Expanded(child: _tf('Volume (ml)', 'laVolume')),
			]),
			const SizedBox(height: 8),
			Wrap(spacing: 16, runSpacing: 6, children: ['Adrenaline','Clonidine','Fentanyl','Bicarbonate','Morphine','Other'].map((e) => _toggle(e)).toList()),
		]);
	}

	Widget _buildCentralNerveBlock() {
		return Column(children: [
			Wrap(spacing: 16, runSpacing: 6, children: [
				_toggle('Intrathecal'), _toggle('Epidural'), _toggle('Combined'), _toggle('Asepsis'), _toggle('Lateral'), _toggle('Pencil Point'), _toggle('Tuohy Other'),
			]),
			const SizedBox(height: 8),
			Wrap(spacing: 12, runSpacing: 8, children: [
				SizedBox(width: 180, child: _tf('Needle Size', 'cnNeedleSize')),
				SizedBox(width: 180, child: _tf('Needle Size (No.)', 'cnNeedleNo')),
				SizedBox(width: 160, child: _tf('Level Inserted', 'cnLevel')),
				SizedBox(width: 160, child: _tf('No. of attempts', 'cnAttempts')),
				SizedBox(width: 180, child: _tf('LOR depth (cm)', 'cnLorDepth')),
				SizedBox(width: 200, child: _tf('Catheter at skin (cm)', 'cnCathSkin')),
			]),
			const SizedBox(height: 8),
			Wrap(spacing: 16, runSpacing: 6, children: [_toggle('Presence of CSF'), _toggle('Blood')]),
		]);
	}

	Widget _buildSaturationPlaceholder() {
		return Column(children: [
			Wrap(spacing: 12, runSpacing: 8, children: [
				SizedBox(width: 160, child: _tf('Mode', 'satMode')),
				SizedBox(width: 160, child: _tf('FiO2', 'satFio2')),
				SizedBox(width: 160, child: _tf('RR', 'satRR')),
				SizedBox(width: 160, child: _tf('A/w pressure', 'satAw')),
				SizedBox(width: 160, child: _tf('TV', 'satTv')),
				SizedBox(width: 160, child: _tf('PEEP', 'satPeep')),
			]),
			const SizedBox(height: 8),
			// Dummy multi-line graph similar to the screenshot
			Container(
				width: double.infinity,
				height: 200,
				padding: const EdgeInsets.all(8),
				decoration: _box(),
				child: CustomPaint(
					painter: _SimpleLineChartPainter([
						List<double>.generate(120, (i) => 100 + 10 * math.sin(i / 6)), // pulse
						List<double>.generate(120, (i) => 98 + 2 * math.cos(i / 9)), // saturation
						List<double>.generate(120, (i) => 85 + 8 * math.sin(i / 11 + 1)), // bp
					]),
				),
			),
			const SizedBox(height: 8),
			// Tabular vitals placeholder grid
			Container(
				decoration: _box(),
				padding: const EdgeInsets.all(8),
				child: _VitalsTablePlaceholder(),
			),
		]);
	}

	Widget _buildCircuit() {
		return Wrap(spacing: 12, runSpacing: 8, children: [
			SizedBox(width: 160, child: _tf('Circle', 'cCircle')),
			SizedBox(width: 160, child: _tf('Brain', 'cBrain')),
			SizedBox(width: 160, child: _tf('T Piece', 'cTPiece')),
			SizedBox(width: 160, child: _tf('CO2', 'cCO2')),
			SizedBox(width: 160, child: _tf('Absorption', 'cAbsorption')),
			SizedBox(width: 160, child: _tf('HME', 'cHme')),
			SizedBox(width: 160, child: _tf('Ventilator V', 'cVentV')),
			SizedBox(width: 160, child: _tf('ml', 'cVentMl')),
			SizedBox(width: 160, child: _tf('F /min', 'cVentF')),
			SizedBox(width: 160, child: _tf('PAR cm H2G', 'cPar')),
			SizedBox(width: 160, child: _tf('', 'cPar2')),
			Expanded(child: _tf('IPPV/Assisted Resp.', 'cIppv')),
			Expanded(child: _tf('Spontaneous Resp.', 'cSpont')), 
		]);
	}

	Widget _buildNotes() {
		return Column(children: [
			Wrap(spacing: 12, runSpacing: 8, children: [
				Expanded(child: _multilabel('Operation Done')),
				Expanded(child: _multilabel('Anesthetists')),
			]),
			const SizedBox(height: 8),
			Wrap(spacing: 12, runSpacing: 8, children: [
				Expanded(child: _multilabel('Surgeons')),
				SizedBox(width: 200, child: _tf('Technician', 'technician')),
			]),
			const SizedBox(height: 8),
			Wrap(spacing: 12, runSpacing: 8, children: [
				Expanded(child: _multilabel('Events')),
				Expanded(child: _multilabel('Critical Events')),
			]),
		]);
	}

	// UI helpers
	Widget _buildSection(String title, Widget child) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)), const SizedBox(height: 6), Container(padding: const EdgeInsets.all(12), decoration: _box(), child: child)]);

	Widget _tf(String label, String key, {int maxLines = 1}) => TextField(controller: ctrl(key), maxLines: maxLines, decoration: InputDecoration(labelText: label.isEmpty ? null : label, isDense: maxLines == 1, border: const OutlineInputBorder()));

	Widget _multilabel(String title) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title), const SizedBox(height: 6), _buildMultiline(title)]);

	Widget _buildMultiline(String key, {int maxLines = 4}) => TextField(controller: ctrl(key), maxLines: maxLines, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Type here'));

	Widget _toggle(String label) => InkWell(onTap: () => setState(() {}), child: Row(mainAxisSize: MainAxisSize.min, children: [Checkbox(value: false, onChanged: (_) {}), Text(label)]));

	BoxDecoration _box() => BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(4), color: Colors.white);
}

class _SimpleLineChartPainter extends CustomPainter {
	final List<List<double>> series;

	_SimpleLineChartPainter(this.series);

	@override
	void paint(Canvas canvas, Size size) {
		final rect = Offset.zero & size;
		final bg = Paint()..color = Colors.white;
		canvas.drawRect(rect, bg);

		const left = 36.0;
		const top = 12.0;
		final width = size.width - left - 12;
		final height = size.height - top - 28;
		final plotRect = Rect.fromLTWH(left, top, width, height);

		final borderPaint = Paint()
			..color = Colors.grey.shade400
			..style = PaintingStyle.stroke
			..strokeWidth = 1;
		canvas.drawRect(plotRect, borderPaint);

		final gridPaint = Paint()
			..color = Colors.grey.shade300
			..style = PaintingStyle.stroke
			..strokeWidth = 1;
		for (int i = 1; i < 5; i++) {
			final y = top + height * i / 5;
			canvas.drawLine(Offset(left, y), Offset(left + width, y), gridPaint);
		}

		if (series.isEmpty) return;
		double minV = series.first.first, maxV = series.first.first;
		for (final s in series) {
			for (final v in s) {
				if (v < minV) minV = v;
				if (v > maxV) maxV = v;
			}
		}
		if (maxV == minV) maxV = minV + 1;

		double xFor(int i, int len) => left + width * i / (len - 1);
		double yFor(double v) => top + height * (1 - (v - minV) / (maxV - minV));

		final colors = [Colors.red, Colors.blue, Colors.green];
		for (int s = 0; s < series.length; s++) {
			final values = series[s];
			if (values.length < 2) continue;
			final path = Path();
			for (int i = 0; i < values.length; i++) {
				final p = Offset(xFor(i, values.length), yFor(values[i]));
				if (i == 0) {
					path.moveTo(p.dx, p.dy);
				} else {
					path.lineTo(p.dx, p.dy);
				}
			}
			canvas.drawPath(
				path,
				Paint()
					..color = colors[s % colors.length]
					..style = PaintingStyle.stroke
					..strokeWidth = 2,
			);
		}

		// Legend
		final labels = ['pulse', 'saturation', 'bp'];
		double lx = left + 8;
		for (int i = 0; i < labels.length && i < series.length; i++) {
			canvas.drawCircle(Offset(lx, top + height + 14), 4, Paint()..color = colors[i]);
			final tp = TextPainter(
				text: TextSpan(text: labels[i], style: const TextStyle(fontSize: 10, color: Colors.black87)),
				textDirection: TextDirection.ltr,
			);
			tp.layout();
			tp.paint(canvas, Offset(lx + 8, top + height + 8));
			lx += tp.width + 40;
		}
	}

	@override
	bool shouldRepaint(covariant _SimpleLineChartPainter oldDelegate) => true;
}

class _VitalsTablePlaceholder extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		final headers = ['SpO2', 'ETCO2', 'ECG', 'Est. Blood Loss', 'Urine', 'IV Fluids'];
		return Column(
			children: [
				Container(
					padding: const EdgeInsets.symmetric(vertical: 6),
					child: Row(children: headers.map((h) => Expanded(child: Text(h, style: const TextStyle(fontWeight: FontWeight.w600)))).toList()),
				),
				const Divider(height: 1),
				for (int r = 0; r < 5; r++)
					Padding(
						padding: const EdgeInsets.symmetric(vertical: 6),
						child: Row(
							children: [
								for (int c = 0; c < headers.length; c++)
									Expanded(
										child: TextField(
											decoration: const InputDecoration(isDense: true, border: OutlineInputBorder()),
										),
									),
							],
						),
					),
			],
		);
	}
}


