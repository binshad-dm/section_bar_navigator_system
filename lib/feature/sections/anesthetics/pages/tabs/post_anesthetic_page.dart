import 'package:flutter/material.dart';

class PostAnestheticPage extends StatefulWidget {
	const PostAnestheticPage({super.key});

	@override
	State<PostAnestheticPage> createState() => _PostAnestheticPageState();
}

enum YesNo { yes, no, unset }

class _PostAnestheticPageState extends State<PostAnestheticPage> {
	// Evaluation
	final TextEditingController evaluationController = TextEditingController();

	// Instructions
	YesNo oxygenMaskRequired = YesNo.unset;
	final TextEditingController ivFluids1Controller = TextEditingController();
	final TextEditingController ivFluids1RateController = TextEditingController();
	bool ivFluids1TillOral = false;
	final TextEditingController ivFluids2Controller = TextEditingController();
	final TextEditingController ivFluids2RateController = TextEditingController();
	bool ivFluids2TillOral = false;
	final TextEditingController analgesicsOtherDrugsController = TextEditingController();
	final TextEditingController epiduralInfusionController = TextEditingController();
	bool watchoutAirwayObstruction = false;
	bool watchoutRespiratoryFailure = false;
	bool watchoutBleeding = false;
	bool watchoutArrhythmias = false;
	final TextEditingController watchoutOtherController = TextEditingController();
	bool checkHb = false;
	bool checkGlucose = false;
	final TextEditingController checkOthersController = TextEditingController();
	bool icuCare = false;
	bool monitoring = false;
	bool ventilation = false;
	bool oralFeedsAfter = false;
	bool oralFeedsLiquidsFirst = false;
	bool oralFeedsSeeSurgeonOrders = false;
	final TextEditingController otherInstructionsController = TextEditingController();

	// VAS Score
	final List<TextEditingController> vasScores =
		List.generate(4, (_) => TextEditingController());
	final List<TextEditingController> vasDrugsGiven =
		List.generate(4, (_) => TextEditingController());

	// Additional
	final TextEditingController modifiedAldreteScoreController = TextEditingController();
	final TextEditingController commentController = TextEditingController();
	final TextEditingController anesthetistNameController = TextEditingController();
	DateTime? selectedDate;
	TimeOfDay? selectedTime;

	@override
	void dispose() {
		evaluationController.dispose();
		ivFluids1Controller.dispose();
		ivFluids1RateController.dispose();
		ivFluids2Controller.dispose();
		ivFluids2RateController.dispose();
		analgesicsOtherDrugsController.dispose();
		epiduralInfusionController.dispose();
		watchoutOtherController.dispose();
		checkOthersController.dispose();
		otherInstructionsController.dispose();
		for (final c in vasScores) {
		  c.dispose();
		}
		for (final c in vasDrugsGiven) {
		  c.dispose();
		}
		modifiedAldreteScoreController.dispose();
		commentController.dispose();
		anesthetistNameController.dispose();
		super.dispose();
	}

	Widget _buildSectionHeader(String title) {
		return Padding(
			padding: const EdgeInsets.only(bottom: 6),
			child: Text(
				title,
				style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
			),
		);
	}

	@override
	Widget build(BuildContext context) {
		return SingleChildScrollView(
			padding: const EdgeInsets.all(12),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					_buildSectionHeader('Evaluation'),
					Container(
						padding: const EdgeInsets.all(12),
						decoration: _boxDecoration(),
						child: TextField(
							controller: evaluationController,
							maxLines: 4,
							decoration: const InputDecoration(
								border: OutlineInputBorder(),
								hintText: 'Type here',
							),
						),
					),

					const SizedBox(height: 16),
					_buildSectionHeader('Instructions'),
					Container(
						padding: const EdgeInsets.all(12),
						decoration: _boxDecoration(),
						child: Column(
							children: [
								_rowLabel('1. O2 by mask to keep SpO2 > 95%, as long as required',
									trailing: Row(children: [
										Radio<YesNo>(value: YesNo.yes, groupValue: oxygenMaskRequired, onChanged: (v) => setState(() => oxygenMaskRequired = v ?? YesNo.unset)),
										const Text('Yes'),
										const SizedBox(width: 12),
										Radio<YesNo>(value: YesNo.no, groupValue: oxygenMaskRequired, onChanged: (v) => setState(() => oxygenMaskRequired = v ?? YesNo.unset)),
										const Text('No'),
									])),
								const SizedBox(height: 8),
								_ivFluidRow(index: '2.', controller: ivFluids1Controller, rateController: ivFluids1RateController, tillOral: ivFluids1TillOral, onTillOralChanged: (v) => setState(() => ivFluids1TillOral = v)),
								const SizedBox(height: 8),
								_ivFluidRow(index: '', controller: ivFluids2Controller, rateController: ivFluids2RateController, tillOral: ivFluids2TillOral, onTillOralChanged: (v) => setState(() => ivFluids2TillOral = v)),
								const SizedBox(height: 8),
								_rowWithTextField('3. Analgesics/other drugs', analgesicsOtherDrugsController),
								const SizedBox(height: 8),
								_rowWithTextField('4. Epidural Infusion', epiduralInfusionController),
								const SizedBox(height: 8),
								// Watchout Row
								Container(
									padding: const EdgeInsets.symmetric(vertical: 6),
									decoration: _rowBorder(),
									child: Row(
										crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											SizedBox(
												width: 90,
												child: const Text('5. Watchout', style: TextStyle(fontWeight: FontWeight.w500)),
											),
											Expanded(
												child: Wrap(
													spacing: 16,
													runSpacing: 8,
													children: [
														_filterCheck('Airway obstruction', watchoutAirwayObstruction, (v) => setState(() => watchoutAirwayObstruction = v)),
														_filterCheck('Respiratory Failure', watchoutRespiratoryFailure, (v) => setState(() => watchoutRespiratoryFailure = v)),
														_filterCheck('Bleeding', watchoutBleeding, (v) => setState(() => watchoutBleeding = v)),
														_filterCheck('Arrhythmias', watchoutArrhythmias, (v) => setState(() => watchoutArrhythmias = v)),
													],
												),
											),
											const SizedBox(width: 12),
											Expanded(
												child: TextField(
													controller: watchoutOtherController,
													maxLines: 3,
													decoration: const InputDecoration(
														labelText: 'Other',
														border: OutlineInputBorder(),
													),
												),
											),
										],
									),
								),
								const SizedBox(height: 8),
								// Check Row
								Container(
									padding: const EdgeInsets.symmetric(vertical: 6),
									decoration: _rowBorder(),
									child: Wrap(
									  children: [
									    Row(
									    	children: [
									    		SizedBox(
									    			width: 90,
									    			child: const Text('6. Check', style: TextStyle(fontWeight: FontWeight.w500)),
									    		),
									    		Expanded(
									    			child: Wrap(
									    				spacing: 16,
									    				children: [
									    					_filterCheck('Hb', checkHb, (v) => setState(() => checkHb = v)),
									    					_filterCheck('Glucose', checkGlucose, (v) => setState(() => checkGlucose = v)),
									    				
									    				],
									    			),
									    		),
									    	],
									    ),
                      	SizedBox(
															width: 220,
															child: TextField(
																controller: checkOthersController,
																decoration: const InputDecoration(
																	labelText: 'Others',
																	border: OutlineInputBorder(),
																),
															),
														),
									  ],
									),
								),
								const SizedBox(height: 8),
								// ICU/Monitoring/Ventilation Row
								_rowOfChecks('7. ICU care', [
									_CheckItem('ICU care', icuCare, (v) => setState(() => icuCare = v)),
									_CheckItem('Monitoring', monitoring, (v) => setState(() => monitoring = v)),
									_CheckItem('Ventilation', ventilation, (v) => setState(() => ventilation = v)),
								]),
								const SizedBox(height: 8),
								_rowOfChecks('8. Oral feeds', [
									_CheckItem('After', oralFeedsAfter, (v) => setState(() => oralFeedsAfter = v)),
									_CheckItem('Liquids first', oralFeedsLiquidsFirst, (v) => setState(() => oralFeedsLiquidsFirst = v)),
									_CheckItem('See surgeons orders', oralFeedsSeeSurgeonOrders, (v) => setState(() => oralFeedsSeeSurgeonOrders = v)),
								]),
							],
						),
					),

					const SizedBox(height: 16),
					_buildSectionHeader('Other Instructions'),
					Container(
						padding: const EdgeInsets.all(12),
						decoration: _boxDecoration(),
						child: TextField(
							controller: otherInstructionsController,
							maxLines: 6,
							decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Type here'),
						),
					),

					const SizedBox(height: 16),
					_buildSectionHeader('VAS Score'),
					Container(
						padding: const EdgeInsets.all(12),
						decoration: _boxDecoration(),
						child: _buildVasTable(),
					),

					const SizedBox(height: 16),
					_buildSectionHeader('Modified aldrette Score'),
					Container(
						padding: const EdgeInsets.all(12),
						decoration: _boxDecoration(),
						child: TextField(
							controller: modifiedAldreteScoreController,
							maxLines: 3,
							decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Type here'),
						),
					),

					const SizedBox(height: 16),
					_buildSectionHeader('Comment'),
					Container(
						padding: const EdgeInsets.all(12),
						decoration: _boxDecoration(),
						child: TextField(
							controller: commentController,
							maxLines: 4,
							decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Type here'),
						),
					),

					const SizedBox(height: 16),
					// Name, Date, Time and Signature placeholder
					Container(
						padding: const EdgeInsets.all(12),
						decoration: _boxDecoration(),
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Row(
									children: [
										Flexible(
											child: TextField(
												controller: anesthetistNameController,
												decoration: const InputDecoration(
													labelText: 'Anesthetist Name',
													border: OutlineInputBorder(),
												),
											),
										),
										const SizedBox(width: 8),
										ConstrainedBox(
											constraints: const BoxConstraints(maxWidth: 180),
											child: OutlinedButton.icon(
												icon: const Icon(Icons.calendar_today, size: 16),
												label: Text(selectedDate == null ? 'Pick date' : _formatDate(selectedDate!)),
												onPressed: () async {
													final now = DateTime.now();
													final d = await showDatePicker(context: context, firstDate: DateTime(now.year - 5), lastDate: DateTime(now.year + 5), initialDate: selectedDate ?? now);
													if (d != null) setState(() => selectedDate = d);
												},
											),
										),
										const SizedBox(width: 8),
										ConstrainedBox(
											constraints: const BoxConstraints(maxWidth: 140),
											child: OutlinedButton.icon(
												icon: const Icon(Icons.access_time, size: 16),
												label: Text(selectedTime == null ? '--:--' : selectedTime!.format(context)),
												onPressed: () async {
													final t = await showTimePicker(context: context, initialTime: selectedTime ?? TimeOfDay.now());
													if (t != null) setState(() => selectedTime = t);
												},
											),
										),
									],
								),
								const SizedBox(height: 12),
								Container(
									height: 80,
									width: 220,
									alignment: Alignment.center,
									decoration: BoxDecoration(
										border: Border.all(color: Colors.grey.shade400),
										borderRadius: BorderRadius.circular(4),
										color: Colors.grey.shade100,
									),
									child: const Text('Anesthetist Signature (placeholder)'),
								),
							],
						),
					),

					const SizedBox(height: 16),
					Align(
						alignment: Alignment.center,
						child: Wrap(
							spacing: 8,
							children: [
								_outlinedSmallButton('New', () {}),
								_outlinedSmallButton('Edit', () {}),
								_outlinedSmallButton('Delete', () {}),
								_outlinedSmallButton('Preview', () {}),
								_outlinedSmallButton('Cancel', () {}),
								_outlinedSmallButton('Final Approval', () {}),

							],
						),
					),
				],
			),
		);
	}

	Widget _buildVasTable() {
		final headersStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600);
		return Column(
			children: [
				Row(
					children: const [
						Expanded(child: Text('Hour')),
						Expanded(child: Text('Score')),
						Expanded(child: Text('Drugs Given')),
					],
				),
				const Divider(height: 12),
				for (var i = 0; i < 4; i++)
					Padding(
						padding: const EdgeInsets.symmetric(vertical: 6),
						child: Row(
							children: [
								Expanded(child: Text(_hourLabel(i), style: headersStyle)),
								Expanded(
									child: TextField(
										controller: vasScores[i],
										decoration: const InputDecoration(isDense: true, border: OutlineInputBorder()),
									),
								),
								Expanded(
									child: TextField(
										controller: vasDrugsGiven[i],
										decoration: const InputDecoration(isDense: true, border: OutlineInputBorder()),
									),
								),
							],
						),
					),
			],
		);
	}

	String _hourLabel(int index) {
		switch (index) {
			case 0:
				return '0 hr';
			case 1:
				return '8 hr';
			case 2:
				return '16 hr';
			default:
				return '24 hr';
		}
	}

	Widget _rowLabel(String text, {Widget? trailing}) {
		return Container(
			padding: const EdgeInsets.symmetric(vertical: 6),
			decoration: _rowBorder(),
			child: Row(
				children: [
					Expanded(child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500))),
					if (trailing != null) trailing,
				],
			),
		);
	}

	Widget _ivFluidRow({
		required String index,
		required TextEditingController controller,
		required TextEditingController rateController,
		required bool tillOral,
		required ValueChanged<bool> onTillOralChanged,
	}) {
		return Container(
			padding: const EdgeInsets.symmetric(vertical: 6),
			decoration: _rowBorder(),
			child: Row(
				crossAxisAlignment: CrossAxisAlignment.center,
				children: [
					SizedBox(width: 24, child: Text(index)),
					Expanded(
						child: TextField(
							controller: controller,
							decoration: const InputDecoration(isDense: true, border: OutlineInputBorder()),
						),
					),
					const SizedBox(width: 8),
					SizedBox(
						width: 120,
						child: TextField(
							controller: rateController,
							keyboardType: TextInputType.number,
							decoration: const InputDecoration(isDense: true, border: OutlineInputBorder(), suffixText: 'ml/hr'),
						),
					),
					const SizedBox(width: 8),
					Row(
						mainAxisSize: MainAxisSize.min,
						children: [
							Checkbox(value: tillOral, onChanged: (v) => onTillOralChanged(v ?? false)),
							const Text('Till taking orally'),
						],
					),
				],
			),
		);
	}

	Widget _rowWithTextField(String title, TextEditingController controller) {
		return Container(
			padding: const EdgeInsets.symmetric(vertical: 6),
			decoration: _rowBorder(),
			child: Row(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					SizedBox(width: 140, child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500))),
					Expanded(
						child: TextField(
							controller: controller,
							maxLines: 3,
							decoration: const InputDecoration(isDense: true, border: OutlineInputBorder()),
						),
					),
				],
			),
		);
	}

	Widget _rowOfChecks(String title, List<_CheckItem> checks) {
		return Container(
			padding: const EdgeInsets.symmetric(vertical: 6),
			decoration: _rowBorder(),
			child: Row(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					SizedBox(width: 140, child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500))),
					Expanded(
						child: Wrap(
							spacing: 16,
							runSpacing: 8,
							children: checks
								.map((c) => _filterCheck(c.label, c.value, (v) => c.onChanged(v)))
								.toList(),
						),
					),
				],
			),
		);
	}

	Widget _filterCheck(String label, bool value, ValueChanged<bool> onChanged) {
		return InkWell(
			onTap: () => onChanged(!value),
			child: Row(
				mainAxisSize: MainAxisSize.min,
				children: [
					Checkbox(value: value, onChanged: (v) => onChanged(v ?? false)),
					Text(label),
				],
			),
		);
	}

	BoxDecoration _boxDecoration() {
		return BoxDecoration(
			border: Border.all(color: Colors.grey.shade400),
			borderRadius: BorderRadius.circular(4),
			color: Colors.white,
		);
	}

	Decoration _rowBorder() {
		return BoxDecoration(
			border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
		);
	}

	Widget _outlinedSmallButton(String label, VoidCallback onPressed) {
		return OutlinedButton(
			onPressed: onPressed,
			style: OutlinedButton.styleFrom(minimumSize: const Size(72, 36)),
			child: Text(label),
		);
	}

	String _formatDate(DateTime d) => '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';
}

class _CheckItem {
	final String label;
	final bool value;
	final ValueChanged<bool> onChanged;

	_CheckItem(this.label, this.value, this.onChanged);
}


