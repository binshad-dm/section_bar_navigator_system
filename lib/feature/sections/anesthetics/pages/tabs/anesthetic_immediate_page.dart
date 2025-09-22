import 'package:flutter/material.dart';

class AnestheticImmediatePage extends StatefulWidget {
	const AnestheticImmediatePage({super.key});

	@override
	State<AnestheticImmediatePage> createState() => _AnestheticImmediatePageState();
}

enum YesNo { yes, no, unset }

class _AnestheticImmediatePageState extends State<AnestheticImmediatePage> {
	final TextEditingController bloodUnitsController = TextEditingController();

	// Reviewed
	bool reviewedNpoStatus = false;
	bool reviewedInvestigations = false;
	bool reviewedMedications = false;

	// Arranged
	bool arrangedIcuBed = false;
	bool arrangedBlood = false;

	// Pre Induction Checklist - individual checks
	bool checklistIdentityProcedureConsentConfirmed = false;
	bool checklistMachineMonitorsMedicationChecked = false;

	YesNo difficultAirwayOrAspirationRisk = YesNo.unset;
	YesNo riskOfBloodLoss = YesNo.unset;
	YesNo hypotensionOrImpairedCoagulation = YesNo.unset;

	final TextEditingController changeInAnesthesiaController = TextEditingController();

	@override
	void dispose() {
		bloodUnitsController.dispose();
		changeInAnesthesiaController.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return SingleChildScrollView(
			padding: const EdgeInsets.all(12),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: <Widget>[
					_buildSectionHeader('Reviewed'),
					Container(
						padding: const EdgeInsets.all(12),
						decoration: _boxDecoration(),
						child: Wrap(
							spacing: 16,
							runSpacing: 8,
							children: [
								_filterCheck('NPO Status', reviewedNpoStatus, (v) => setState(() => reviewedNpoStatus = v)),
								_filterCheck('Investigations', reviewedInvestigations, (v) => setState(() => reviewedInvestigations = v)),
								_filterCheck('Medications', reviewedMedications, (v) => setState(() => reviewedMedications = v)),
							],
						),
					),

					const SizedBox(height: 16),
					_buildSectionHeader('Arranged'),
					Container(
						padding: const EdgeInsets.all(12),
						decoration: _boxDecoration(),
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								_filterCheck('ICU Bed', arrangedIcuBed, (v) => setState(() => arrangedIcuBed = v)),
								const SizedBox(height: 8),
								Row(
									children: [
										Checkbox(
											value: arrangedBlood,
											onChanged: (v) => setState(() => arrangedBlood = v ?? false),
										),
										const Text('Blood:'),
										const SizedBox(width: 8),
										SizedBox(
											width: 220,
											child: TextField(
												controller: bloodUnitsController,
												decoration: const InputDecoration(
													isDense: true,
													border: OutlineInputBorder(),
													hintText: 'Type here',
												),
											),
										),
									],
								),
							],
						),
					),

					const SizedBox(height: 16),
					_buildSectionHeader('Pre Induction Checklist'),
					Container(
						padding: const EdgeInsets.all(12),
						decoration: _boxDecoration(),
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								_filterCheck(
									'Identity, Procedure & Consent Confirmed',
									checklistIdentityProcedureConsentConfirmed,
									(v) => setState(() => checklistIdentityProcedureConsentConfirmed = v),
								),
								_filterCheck(
									'Machine, Monitors And Medication Checked',
									checklistMachineMonitorsMedicationChecked,
									(v) => setState(() => checklistMachineMonitorsMedicationChecked = v),
								),
								const SizedBox(height: 8),
								_buildYesNoRow(
									label: 'Difficult Airway / Aspiration Risk',
									groupValue: difficultAirwayOrAspirationRisk,
									onChanged: (v) => setState(() => difficultAirwayOrAspirationRisk = v),
								),
								_buildYesNoRow(
									label: 'Risk of Blood loss (>500ml)',
									groupValue: riskOfBloodLoss,
									onChanged: (v) => setState(() => riskOfBloodLoss = v),
								),
								_buildYesNoRow(
									label: 'Hypotension risk / impaired coagulation',
									groupValue: hypotensionOrImpairedCoagulation,
									onChanged: (v) => setState(() => hypotensionOrImpairedCoagulation = v),
								),
							],
						),
					),

					const SizedBox(height: 16),
					_buildSectionHeader('Change in Anesthesia'),
					Container(
						padding: const EdgeInsets.all(12),
						decoration: _boxDecoration(),
						child: TextField(
							controller: changeInAnesthesiaController,
							maxLines: 6,
							decoration: const InputDecoration(
								border: OutlineInputBorder(),
								hintText: 'Type here',
							),
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

	Widget _buildSectionHeader(String title) {
		return Padding(
			padding: const EdgeInsets.only(bottom: 6),
			child: Text(
				title,
				style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
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

	Widget _buildYesNoRow({
		required String label,
		required YesNo groupValue,
		required ValueChanged<YesNo> onChanged,
	}) {
		return Padding(
			padding: const EdgeInsets.symmetric(vertical: 4),
			child: Row(
				children: [
					Expanded(child: Text(label)),
					Row(
						children: [
							Radio<YesNo>(
								value: YesNo.yes,
								groupValue: groupValue,
								onChanged: (v) => onChanged(v ?? YesNo.unset),
							),
							const Text('Yes'),
							const SizedBox(width: 12),
							Radio<YesNo>(
								value: YesNo.no,
								groupValue: groupValue,
								onChanged: (v) => onChanged(v ?? YesNo.unset),
							),
							const Text('No'),
						],
					),
				],
			),
		);
	}

	Widget _outlinedSmallButton(String label, VoidCallback onPressed) {
		return OutlinedButton(
			onPressed: onPressed,
			style: OutlinedButton.styleFrom(minimumSize: const Size(72, 36)),
			child: Text(label),
		);
	}
}


