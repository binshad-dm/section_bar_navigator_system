import 'package:flutter/material.dart';

class PreAnestheticEvaluationPage extends StatefulWidget {
	const PreAnestheticEvaluationPage({super.key});

	@override
	State<PreAnestheticEvaluationPage> createState() => _PreAnestheticEvaluationPageState();
}

enum YesNo { yes, no, unset }

class _PreAnestheticEvaluationPageState extends State<PreAnestheticEvaluationPage> {
	// Controllers for long text sections
	final TextEditingController medicationHistoryController = TextEditingController();
	final TextEditingController anestheticHistoryController = TextEditingController();
	final TextEditingController chestExamController = TextEditingController();
	final TextEditingController cvsExamController = TextEditingController();
	final TextEditingController ekgController = TextEditingController();
	final TextEditingController echoCagController = TextEditingController();
	final TextEditingController additionalInfoNpoController = TextEditingController();
	final TextEditingController additionalInfoIvAccessController = TextEditingController();
	final TextEditingController additionalInfoPtInstructionsController = TextEditingController();
	final TextEditingController investigationBloodGroupController = TextEditingController();
	final TextEditingController investigationHeightController = TextEditingController();
	final TextEditingController investigationWeightController = TextEditingController();
	final TextEditingController anestheticPlanController = TextEditingController();
	final TextEditingController anesthesiologistNameController = TextEditingController();
	final TextEditingController adviceNpoFromController = TextEditingController();
	final TextEditingController advicePleaseCheckController = TextEditingController();
	final TextEditingController adviceGetOpinionOfController = TextEditingController();
	final TextEditingController adviceArrangeBloodController = TextEditingController();
	final TextEditingController advicePremedController = TextEditingController();
	final TextEditingController adviceOtherController = TextEditingController();
	final TextEditingController summaryController = TextEditingController();

	// Airway
	YesNo difficultAirwayHistory = YesNo.unset;
	final TextEditingController airwayRemarksController = TextEditingController();
	final TextEditingController teethController = TextEditingController();
	final TextEditingController neckController = TextEditingController();
	final TextEditingController chinController = TextEditingController();
	int airwayClass = 0; // 1..4

	// Respiratory system checks
	final Map<String, bool> respiratoryChecks = {
		'WNL': false,
		'Asthma': false,
		'Bronchitis': false,
		'COPD': false,
		'Pneumonia': false,
		'TB': false,
		'Pneumothorax': false,
		'Recent URI': false,
		'Dyspnea': false,
		'Required O2': false,
		'Steroids': false,
		'Snoring/Sleep Apnea': false,
		'Cough': false,
	};

	// Cardio vascular system
	final Map<String, bool> cardioChecks = {
		'WNL': false,
		'CHD': false,
		'HTN': false,
		'CAD': false,
		'MI': false,
		'Valve Disease': false,
		'Cardio Myopathy': false,
		'CHF': false,
		'RHD': false,
		'Pacer': false,
		'Dysrhythmia': false,
		'PVD': false,
		'Angina': false,
		'DOE': false,
		'Orthopnoea': false,
		'Murmur': false,
	};
	final TextEditingController exerciseToleranceController = TextEditingController();

	// CNS checks
	final Map<String, bool> cnsChecks = {
		'WNL': false,
		'CVA': false,
		'TIA': false,
		'LOC': false,
		'Seizure': false,
		'Increased ICP': false,
		'HA': false,
		'NM Disease': false,
		'Weakness': false,
		'Paresthesia': false,
		'Psych': false,
		'Altered MS/GCS': false,
		'Spinal Cord Injury': false,
	};

	// GI/Hepatic checks
	final Map<String, bool> giHepaticChecks = {
		'WNL': false,
		'Liver Disease': false,
		'Hepatitis': false,
		'Bowel Obstruction': false,
		'N/V': false,
		'Reflux': false,
	};
	final TextEditingController etohDrinksController = TextEditingController();

	// Endocrine/Other
	final Map<String, bool> endocrineOtherChecks = {
		'WNL': false,
		'Diabetes': false,
		'ThyroidDisease': false,
		'RA': false,
		'Steroids': false,
		'Coagulopathy': false,
		'Chemotherapy': false,
		'Sickle Cell': false,
		'Pregnant': false,
		'Anemia': false,
		'HIV': false,
		'MRSA': false,
		'VRE': false,
	};

	// Risk/Consent
	bool riskDiscussed = false;

	// ASA grade
	int asaClass = 0; // 1..5, with potential ICU admission checkbox below
	bool potentialIcuAdmission = false;

	@override
	void dispose() {
		medicationHistoryController.dispose();
		anestheticHistoryController.dispose();
		chestExamController.dispose();
		cvsExamController.dispose();
		ekgController.dispose();
		echoCagController.dispose();
		additionalInfoNpoController.dispose();
		additionalInfoIvAccessController.dispose();
		additionalInfoPtInstructionsController.dispose();
		investigationBloodGroupController.dispose();
		investigationHeightController.dispose();
		investigationWeightController.dispose();
		anestheticPlanController.dispose();
		anesthesiologistNameController.dispose();
		adviceNpoFromController.dispose();
		advicePleaseCheckController.dispose();
		adviceGetOpinionOfController.dispose();
		adviceArrangeBloodController.dispose();
		advicePremedController.dispose();
		adviceOtherController.dispose();
		summaryController.dispose();
		airwayRemarksController.dispose();
		teethController.dispose();
		neckController.dispose();
		chinController.dispose();
		exerciseToleranceController.dispose();
		etohDrinksController.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return SingleChildScrollView(
			padding: const EdgeInsets.all(12),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					_buildSection('Allergic To', _buildAllergyPlaceholder()),
					const SizedBox(height: 12),
					_buildSection('Medication History', _buildMultiline(medicationHistoryController)),
					const SizedBox(height: 12),
					_buildSection('Anesthetic History', _buildMultiline(anestheticHistoryController)),
					const SizedBox(height: 12),
					_buildAirwaySection(),
					const SizedBox(height: 12),
					_buildRespiratorySection(),
					const SizedBox(height: 12),
					_buildCardioSection(),
					const SizedBox(height: 12),
					_buildCnsSection(),
					const SizedBox(height: 12),
					_buildGiHepaticSection(),
					const SizedBox(height: 12),
					_buildEndocrineSection(),
					const SizedBox(height: 12),
					_buildAdditionalInfoSection(),
					const SizedBox(height: 12),
					_buildInvestigationSection(),
					const SizedBox(height: 12),
					_buildSection('Anesthetic Plan', _buildMultiline(anestheticPlanController)),
					const SizedBox(height: 12),
					_buildRiskAndSignatureRow(),
					const SizedBox(height: 12),
					_buildAdviceSection(),
					const SizedBox(height: 12),
					_buildAsaSection(),
					const SizedBox(height: 12),
					_buildSection('Summary', _buildMultiline(summaryController, maxLines: 4)),
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

	// Sections builders
	Widget _buildSection(String title, Widget child) {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
				const SizedBox(height: 6),
				Container(padding: const EdgeInsets.all(12), decoration: _box(), child: child),
			],
		);
	}

	Widget _buildAllergyPlaceholder() {
		return Container(
			height: 140,
			alignment: Alignment.center,
			decoration: BoxDecoration(
				border: Border.all(color: Colors.grey.shade400),
				borderRadius: BorderRadius.circular(4),
				color: Colors.grey.shade50,
			),
			child: const Text('Allergy grid (placeholder)'),
		);
	}

	Widget _buildAirwaySection() {
		return _buildSection(
			'Airway',
			Column(
				children: [
					Row(children: [
						Expanded(child: const Text('History of Difficult Airway')),
						Row(children: [
							Radio<YesNo>(value: YesNo.yes, groupValue: difficultAirwayHistory, onChanged: (v) => setState(() => difficultAirwayHistory = v ?? YesNo.unset)),
							const Text('Yes'),
							const SizedBox(width: 12),
							Radio<YesNo>(value: YesNo.no, groupValue: difficultAirwayHistory, onChanged: (v) => setState(() => difficultAirwayHistory = v ?? YesNo.unset)),
							const Text('No'),
						]),
					]),
					const SizedBox(height: 8),
					Wrap(spacing: 12, runSpacing: 8, children: [
						SizedBox(width: 220, child: _tf('Teeth', teethController)),
						SizedBox(width: 220, child: _tf('Neck', neckController)),
						SizedBox(width: 220, child: _tf('Chin', chinController)),
						Row(mainAxisSize: MainAxisSize.min, children: [
							const Text('Class :'),
							const SizedBox(width: 8),
							for (int i = 1; i <= 4; i++)
								Row(children: [
									Radio<int>(value: i, groupValue: airwayClass, onChanged: (v) => setState(() => airwayClass = v ?? 0)),
									Text(['I','II','III','IV'][i-1]),
									const SizedBox(width: 8),
								]),
						]),
					]),
					const SizedBox(height: 8),
					_tf('Remarks', airwayRemarksController, maxLines: 2),
				],
			),
		);
	}

	Widget _buildRespiratorySection() {
		return _buildSection(
			'Respiratory System',
			Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Wrap(
						spacing: 16,
						runSpacing: 6,
						children: respiratoryChecks.entries
							.map((e) => _check(e.key, e.value, (v) => setState(() => respiratoryChecks[e.key] = v)))
							.toList(),
					),
					const SizedBox(height: 8),
					Wrap(spacing: 12, runSpacing: 8, children: [
						Expanded(child: _tf('Chest Exam', chestExamController)),
						SizedBox(width: 200, child: _tf('Tobacco Smoking', TextEditingController())),
						SizedBox(width: 120, child: _tf('PPD /day', TextEditingController())),
						SizedBox(width: 120, child: _tf('Years', TextEditingController())),
					]),
				],
			),
		);
	}

	Widget _buildCardioSection() {
		return _buildSection(
			'Cardio Vascular System',
			Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Wrap(
						spacing: 16,
						runSpacing: 6,
						children: cardioChecks.entries
							.map((e) => _check(e.key, e.value, (v) => setState(() => cardioChecks[e.key] = v)))
							.toList(),
					),
					const SizedBox(height: 8),
					Wrap(spacing: 12, runSpacing: 8, children: [
						Expanded(child: _tf('Exercise Tolerance', exerciseToleranceController)),
						SizedBox(width: 200, child: _tf('EKG', ekgController)),
						Expanded(child: _tf('CVS Exam', cvsExamController)),
						Expanded(child: _tf('ECHO/CAG', echoCagController)),
					]),
				],
			),
		);
	}

	Widget _buildCnsSection() {
		return _buildSection(
			'Central Nervous System',
			Wrap(
				spacing: 16,
				runSpacing: 6,
				children: cnsChecks.entries
					.map((e) => _check(e.key, e.value, (v) => setState(() => cnsChecks[e.key] = v)))
					.toList(),
			),
		);
	}

	Widget _buildGiHepaticSection() {
		return _buildSection(
			'GI,Hepatic',
			Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Wrap(
						spacing: 16,
						runSpacing: 6,
						children: giHepaticChecks.entries
							.map((e) => _check(e.key, e.value, (v) => setState(() => giHepaticChecks[e.key] = v)))
							.toList(),
					),
					const SizedBox(height: 8),
					_tf('E TOH- drinks', etohDrinksController),
				],
			),
		);
	}

	Widget _buildEndocrineSection() {
		return _buildSection(
			'Endocrine, Metabolic Infections, Other',
			Wrap(
				spacing: 16,
				runSpacing: 6,
				children: endocrineOtherChecks.entries
					.map((e) => _check(e.key, e.value, (v) => setState(() => endocrineOtherChecks[e.key] = v)))
					.toList(),
			),
		);
	}

	Widget _buildAdditionalInfoSection() {
		return _buildSection(
			'Additional Information',
			Wrap(spacing: 12, runSpacing: 8, children: [
				SizedBox(width: 220, child: _tf('NPO Status', additionalInfoNpoController)),
				SizedBox(width: 220, child: _tf('IV Access', additionalInfoIvAccessController)),
				SizedBox(width: 220, child: _tf('PT Instructions', additionalInfoPtInstructionsController)),
			]),
		);
	}

	Widget _buildInvestigationSection() {
		return _buildSection(
			'Investigation',
			Wrap(spacing: 12, runSpacing: 8, children: [
				SizedBox(width: 200, child: _tf('Blood Group', investigationBloodGroupController)),
				SizedBox(width: 120, child: _tf('Height', investigationHeightController)),
				SizedBox(width: 120, child: _tf('Weight', investigationWeightController)),
				Container(
					height: 180,
					width: double.infinity,
					alignment: Alignment.center,
					decoration: BoxDecoration(
						border: Border.all(color: Colors.grey.shade400),
						borderRadius: BorderRadius.circular(4),
						color: Colors.grey.shade50,
					),
					child: const Text('Lab tables (placeholder)'),
				),
			]),
		);
	}

	Widget _buildRiskAndSignatureRow() {
		return Container(
			padding: const EdgeInsets.all(12),
			decoration: _box(),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Row(children: [
						Checkbox(value: riskDiscussed, onChanged: (v) => setState(() => riskDiscussed = v ?? false)),
						const Expanded(child: Text('Risk discussed with and patient/Relative understands')),
					]),
					const SizedBox(height: 8),
					Row(children: [
						Expanded(child: _tf("Anesthesiologist's Name", anesthesiologistNameController)),
						const SizedBox(width: 12),
						Container(height: 60, width: 160, alignment: Alignment.center, decoration: _sigBox(), child: const Text('Signature')),
						const SizedBox(width: 12),
						ConstrainedBox(constraints: const BoxConstraints(maxWidth: 140), child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.calendar_today, size: 16), label: const Text('Date'))),
						const SizedBox(width: 8),
						ConstrainedBox(constraints: const BoxConstraints(maxWidth: 120), child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.access_time, size: 16), label: const Text('--:--'))),
					]),
				],
			),
		);
	}

	Widget _buildAdviceSection() {
		return _buildSection(
			'Advice',
			Column(children: [
				Wrap(spacing: 12, runSpacing: 8, children: [
					_check('NPO From', false, (_) {}),
					SizedBox(width: 220, child: _tf('', adviceNpoFromController)),
					_check('Please Check', false, (_) {}),
					SizedBox(width: 220, child: _tf('', advicePleaseCheckController)),
				]),
				const SizedBox(height: 8),
				Wrap(spacing: 12, runSpacing: 8, children: [
					_check('Get Opinion of:', false, (_) {}),
					SizedBox(width: 220, child: _tf('', adviceGetOpinionOfController)),
					_check('Arrange Blood:', false, (_) {}),
					SizedBox(width: 220, child: _tf('', adviceArrangeBloodController)),
					_check('Premed:', false, (_) {}),
					SizedBox(width: 220, child: _tf('', advicePremedController)),
				]),
			],),
		);
	}

	Widget _buildAsaSection() {
		return _buildSection(
			'ASA',
			Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Wrap(spacing: 12, children: [
						for (int i = 1; i <= 5; i++)
							Row(children: [
								Radio<int>(value: i, groupValue: asaClass, onChanged: (v) => setState(() => asaClass = v ?? 0)),
								Text(['I','II','III','IV','V'][i-1]),
							]),
						Row(children: [
							Checkbox(value: potentialIcuAdmission, onChanged: (v) => setState(() => potentialIcuAdmission = v ?? false)),
							const Text('POTENTIAL FOR ICU ADMISSION'),
						]),
					]),
					const SizedBox(height: 8),
					_tf('Other', adviceOtherController, maxLines: 3),
				],
			),
		);
	}

	// Helpers
	Widget _tf(String label, TextEditingController controller, {int maxLines = 1}) {
		return TextField(
			controller: controller,
			maxLines: maxLines,
			decoration: InputDecoration(
				labelText: label.isEmpty ? null : label,
				isDense: maxLines == 1,
				border: const OutlineInputBorder(),
			),
		);
	}

	Widget _check(String label, bool value, ValueChanged<bool> onChanged) {
		return InkWell(
			onTap: () => onChanged(!value),
			child: Row(mainAxisSize: MainAxisSize.min, children: [
				Checkbox(value: value, onChanged: (v) => onChanged(v ?? false)),
				Text(label),
			]),
		);
	}

	Widget _buildMultiline(TextEditingController controller, {int maxLines = 3}) =>
		TextField(controller: controller, maxLines: maxLines, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Type here'));

	BoxDecoration _box() => BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(4), color: Colors.white);

	BoxDecoration _sigBox() => BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(4), color: Colors.grey.shade50);
}


