import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:agap/features/responder/data/responder_dashboard_data.dart';
import 'package:agap/theme/color.dart';
import 'package:agap/theme/typography.dart';

class IncidentReportPage extends StatefulWidget {
  const IncidentReportPage({
    super.key,
    required this.resident,
    required this.locationSummary,
    required this.profile,
    required this.teamStation,
    required this.incidentStatus,
  });

  final ResidentIncidentData resident;
  final String locationSummary;
  final ResponderProfileData profile;
  final TeamStationData teamStation;
  final IncidentStatusData incidentStatus;

  @override
  State<IncidentReportPage> createState() => _IncidentReportPageState();
}

class _IncidentReportPageState extends State<IncidentReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  final _dateOfCallController = TextEditingController(); //this should be automatic when resident sends SOS
  final _timeOfCallController = TextEditingController();  //this should be automatic when resident sends SOS
  final _mobileController = TextEditingController();
  final _atSceneController = TextEditingController();
  final _atPatientController = TextEditingController();
  final _departSceneController = TextEditingController();
  final _atArrivalController = TextEditingController();
  final _atHandoverController = TextEditingController();
  final _clearController = TextEditingController();
  final _locationController = TextEditingController();
  final _destinationController = TextEditingController();
  final _stationCodeController = TextEditingController();
  final _ambulanceUnitController = TextEditingController();
  final _patientNoController = TextEditingController();
  final _patientNameController = TextEditingController();
  final _patientFirstNameController = TextEditingController();
  final _patientMiController = TextEditingController();
  final _addressController = TextEditingController();
  final _ageController = TextEditingController();
  final _sexController = TextEditingController();
  final _contactController = TextEditingController();
  final _nextOfKinController = TextEditingController();
  final _nokContactController = TextEditingController();
  final _signsSymptomsController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _medicationsController = TextEditingController();
  final _historyController = TextEditingController();
  final _lastIntakeController = TextEditingController();
  final _eventController = TextEditingController();
  final _narrativeController = TextEditingController();
  final _providerController = TextEditingController();
  final _receivingProviderController = TextEditingController();
  final _vitalsTimeOneController = TextEditingController();
  final _vitalsTimeTwoController = TextEditingController();
  final _pulseController = TextEditingController();
  final _respiratoryController = TextEditingController();
  final _saturationController = TextEditingController();
  final _bloodPressureController = TextEditingController();
  final _temperatureController = TextEditingController();
  final _painController = TextEditingController();
  final _gcsController = TextEditingController();

  int _currentStep = 0;
  bool _markAddressSame = true;
  bool _isExportingPdf = false;
  String _incidentCategory = 'Emergency';
  String _incidentType = 'Medical';
  String _destinationType = 'Clinic';
  String _consciousnessLevel = 'Alert';
  String _airwayStatus = 'Clear';
  String _breathingStatus = 'Normal';
  String _circulationStatus = 'Present';
  final Set<String> _refusalActions = {'Treatment Refused'};
  final Set<String> _natureOfIllness = {'Medical'};
  final Set<String> _mechanismOfInjury = {'Others'};
  final Set<String> _injuryFindings = {'Pain'};
  final Set<String> _recognitionOfDeath = {};
  final Set<String> _cessationOfResuscitation = {};

  @override
  void initState() {
    super.initState();
    final reportedAt = _extractReportedAt(widget.resident.reportedAt);
    final patientName = _splitPatientName(widget.resident.name);

    _dateOfCallController.text = reportedAt.date;
    _timeOfCallController.text = reportedAt.time;
    _mobileController.text = reportedAt.time;
    _atSceneController.text = reportedAt.time;
    _atPatientController.text = reportedAt.time;
    _patientNameController.text = patientName.lastName;
    _patientFirstNameController.text = patientName.firstName;
    _patientMiController.text = patientName.middleInitial;
    _addressController.text = widget.resident.address;
    _ageController.text = widget.resident.age.replaceAll(' years old', '');
    _sexController.text = widget.resident.gender;
    _contactController.text = widget.resident.details
      .firstWhere((d) => d.label.toLowerCase().contains('contact'),
          orElse: () => const ResidentDetailData(label: '', value: ''))
      .value;
    _nextOfKinController.text = widget.resident.details
        .firstWhere((d) => d.label.toLowerCase().contains('guardian'),
            orElse: () => const ResidentDetailData(label: '', value: ''))
        .value;
    _nokContactController.text = widget.resident.details
        .firstWhere((d) => d.label.toLowerCase().contains('nok'),
            orElse: () => const ResidentDetailData(label: '', value: ''))
        .value;
    _signsSymptomsController.text = widget.resident.detailsTitle;
    _historyController.text = widget.resident.details
        .map((detail) => '${detail.label}: ${detail.value}')
        .join('\n');
    _eventController.text = widget.resident.category;
    _providerController.text = widget.profile.name;
    _receivingProviderController.text = widget.teamStation.station;
    _vitalsTimeOneController.text = reportedAt.time;
    _vitalsTimeTwoController.text = reportedAt.time;
    _pulseController.text = widget.incidentStatus.timestampText;
    _atArrivalController.text = reportedAt.time;
    _atHandoverController.text = reportedAt.time;
    _clearController.text = reportedAt.time;
    _locationController.text = widget.locationSummary.split('•').first.trim();
    _destinationController.text = widget.teamStation.station;
    _stationCodeController.text = widget.teamStation.team;
    _ambulanceUnitController.text = widget.profile.teamAndStationLabel;
    _patientNoController.text = 'INC-${reportedAt.compactStamp}';
    _searchController.text = widget.resident.name;
    _allergiesController.text = widget.resident.details
        .where((detail) => detail.label.toLowerCase().contains('allerg'))
        .map((detail) => detail.value)
        .join(', ');
    _medicationsController.text = widget.resident.details
        .where((detail) => detail.label.toLowerCase().contains('med'))
        .map((detail) => detail.value)
        .join(', ');
  }

  @override
  void dispose() {
    for (final controller in [
      _searchController,
      _dateOfCallController,
      _timeOfCallController,
      _mobileController,
      _atSceneController,
      _atPatientController,
      _departSceneController,
      _atArrivalController,
      _atHandoverController,
      _clearController,
      _locationController,
      _destinationController,
      _stationCodeController,
      _ambulanceUnitController,
      _patientNoController,
      _patientNameController,
      _patientFirstNameController,
      _patientMiController,
      _addressController,
      _ageController,
      _sexController,
      _contactController,
      _nextOfKinController,
      _nokContactController,
      _signsSymptomsController,
      _allergiesController,
      _medicationsController,
      _historyController,
      _lastIntakeController,
      _eventController,
      _narrativeController,
      _providerController,
      _receivingProviderController,
      _vitalsTimeOneController,
      _vitalsTimeTwoController,
      _pulseController,
      _respiratoryController,
      _saturationController,
      _bloodPressureController,
      _temperatureController,
      _painController,
      _gcsController,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final steps = _steps;
    final current = steps[_currentStep];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EC),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Digital Incident Report',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.locationSummary,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _StepHeader(
                        currentStep: _currentStep + 1,
                        totalSteps: steps.length,
                        sectionLabel: current.sectionLabel,
                        title: current.title,
                        description: current.description,
                      ),
                      const SizedBox(height: 16),
                      current.builder(),
                      const SizedBox(height: 18),
                      _FooterActions(
                        currentStep: _currentStep,
                        totalSteps: steps.length,
                        onBack: _handleBack,
                        onContinue: _handleContinue,
                        exportChild: _currentStep == steps.length - 1
                            ? _buildExportCard()
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_ReportStep> get _steps => [
        _ReportStep(
          sectionLabel: 'INCIDENT INFORMATION',
          title: 'Capture the dispatch timeline',
          description:
              'Record key dispatch times and scene details so the team can track the response clearly and accurately.',
          builder: _buildIncidentInformationStep,
        ),
        _ReportStep(
          sectionLabel: 'PATIENT INFORMATION',
          title: 'Identify the patient and refusal flags',
          description:
              'Confirm the patient identity, contact details, and refusal or non-transport decisions for proper documentation.',
          builder: _buildPatientInformationStep,
        ),
        _ReportStep(
          sectionLabel: 'PATIENT ASSESSMENT',
          title: 'Document condition and scene findings',
          description:
              'Capture the primary survey, secondary findings, and likely cause of illness or injury while details are still fresh.',
          builder: _buildAssessmentStep,
        ),
        _ReportStep(
          sectionLabel: 'VITALS AND NARRATIVE',
          title: 'Finish the clinical handoff report',
          description:
              'Complete the vital signs, responder narrative, and handoff details, then export a PDF record for turnover and filing.',
          builder: _buildVitalsAndNarrativeStep,
        ),
      ];

  Widget _buildIncidentInformationStep() {
    return _ReportCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Incident Information'),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Emergency', 'Conduction', 'Medical', 'Trauma']
                .map(
                  (option) => _ChoiceChipButton(
                    label: option,
                    selected: _incidentCategory == option,
                    onTap: () => setState(() => _incidentCategory = option),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _ReportTextField(
                  label: 'Date of Call',
                  controller: _dateOfCallController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ReportTextField(
                  label: 'Time of Call',
                  controller: _timeOfCallController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ReportTextField(
                  label: 'Mobile',
                  controller: _mobileController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ReportTextField(
                  label: 'At Scene',
                  controller: _atSceneController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ReportTextField(
                  label: 'At Patient',
                  controller: _atPatientController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 3,
                child: _ReportTextField(
                  label: 'Location',
                  hint: 'Site of incident',
                  controller: _locationController,
                  validator: _requiredValidator,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _DropdownField<String>(
                  label: 'Type',
                  value: _incidentType,
                  items: const ['Medical', 'Trauma', 'General'],
                  onChanged: (value) =>
                      setState(() => _incidentType = value ?? _incidentType),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Mark if same as address',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              Switch.adaptive(
                value: _markAddressSame,
                activeThumbColor: AppColors.agapOrangeDeep,
                onChanged: (value) {
                  setState(() {
                    _markAddressSame = value;
                    if (value && _addressController.text.trim().isNotEmpty) {
                      _locationController.text = _addressController.text.trim();
                    }
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          const _SectionTitle('Transport Timeline'),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _ReportTextField(
                  label: 'Depart Scene',
                  controller: _departSceneController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ReportTextField(
                  label: 'At Arrival',
                  controller: _atArrivalController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ReportTextField(
                  label: 'Destination',
                  hint: 'Name of facility',
                  controller: _destinationController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DropdownField<String>(
                  label: 'Type',
                  value: _destinationType,
                  items: const ['Clinic', 'Hospital', 'Home', 'Other'],
                  onChanged: (value) => setState(
                    () => _destinationType = value ?? _destinationType,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ReportTextField(
                  label: 'At Handover',
                  controller: _atHandoverController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ReportTextField(
                  label: 'Clear',
                  controller: _clearController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ReportTextField(
                  label: 'Station Code',
                  controller: _stationCodeController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ReportTextField(
                  label: 'Ambulance Unit',
                  controller: _ambulanceUnitController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ReportTextField(
                  label: 'Patient No.',
                  controller: _patientNoController,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPatientInformationStep() {
    return _ReportCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Patient Information'),
          const SizedBox(height: 14),
          _ReportTextField(
            label: 'Search patient name',
            hint: 'Search patient name',
            controller: _searchController,
            prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted),
          ),
          const SizedBox(height: 18),
          _ReportTextField(
            label: 'Patient Name',
            hint: 'Surname',
            controller: _patientNameController,
            validator: _requiredValidator,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ReportTextField(
                  label: 'First Name',
                  hint: 'First name',
                  controller: _patientFirstNameController,
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 82,
                child: _ReportTextField(
                  label: 'MI',
                  hint: 'MI',
                  controller: _patientMiController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ReportTextField(
            label: 'Permanent Address',
            hint: 'House no, street, city, country',
            controller: _addressController,
            validator: _requiredValidator,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ReportTextField(
                  label: 'Age',
                  hint: 'Age',
                  controller: _ageController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ReportTextField(
                  label: 'Sex',
                  hint: 'Sex',
                  controller: _sexController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _ReportTextField(
                  label: 'Contact No.',
                  controller: _contactController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ReportTextField(
                  label: 'Next of Kin',
                  hint: 'Guardian/companion',
                  controller: _nextOfKinController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ReportTextField(
                  label: 'NOK Contact No.',
                  controller: _nokContactController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const _SectionTitle('Disposition Flags'),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Treatment Refused',
              'Treat At Scene-No Trans',
              'Transport Refused',
              'Stood Down/Cancelled',
            ]
                .map(
                  (label) => _ChoiceChipButton(
                    label: label,
                    selected: _refusalActions.contains(label),
                    onTap: () => _toggleSetValue(_refusalActions, label),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAssessmentStep() {
    return Column(
      children: [
        _ReportCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle('Primary Survey'),
              const SizedBox(height: 14),
              _ToggleField(
                title: 'Consciousness Upon Arrival',
                selectedValue: _consciousnessLevel,
                options: const ['Alert', 'Verbal Response', 'Painful Stimuli', 'Unresponsive'],
                onChanged: (value) =>
                    setState(() => _consciousnessLevel = value),
              ),
              const SizedBox(height: 18),
              _ToggleField(
                title: 'Airway',
                selectedValue: _airwayStatus,
                options: const ['Clear', 'Partially Obstructed', 'Obstructed'],
                onChanged: (value) => setState(() => _airwayStatus = value),
              ),
              const SizedBox(height: 18),
              _ToggleField(
                title: 'Breathing',
                selectedValue: _breathingStatus,
                options: const ['Normal', 'Fast', 'Slow', 'Absent'],
                onChanged: (value) => setState(() => _breathingStatus = value),
              ),
              const SizedBox(height: 18),
              _ToggleField(
                title: 'Circulation',
                selectedValue: _circulationStatus,
                options: const ['Present', 'Absent', 'Haemorrhage'],
                onChanged: (value) => setState(() => _circulationStatus = value),
              ),
              const SizedBox(height: 18),
              const Text(
                'Body Findings',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'Burn',
                  'Contusion',
                  'Dislocation',
                  'Fracture',
                  'Numbness',
                  'Pain',
                  'Rash',
                  'Swelling',
                  'Wound',
                ]
                    .map(
                      (label) => _ChoiceChipButton(
                        label: label,
                        selected: _injuryFindings.contains(label),
                        onTap: () => _toggleSetValue(_injuryFindings, label),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _ReportCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle('Secondary Survey'),
              const SizedBox(height: 14),
              _ReportTextField(
                label: 'Signs and Symptoms',
                hint: 'Describe patient complaints and observations',
                controller: _signsSymptomsController,
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              _ReportTextField(
                label: 'Allergies',
                controller: _allergiesController,
              ),
              const SizedBox(height: 12),
              _ReportTextField(
                label: 'Medications',
                controller: _medicationsController,
              ),
              const SizedBox(height: 12),
              _ReportTextField(
                label: 'Past Medical History',
                controller: _historyController,
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              _ReportTextField(
                label: 'Last Intake',
                controller: _lastIntakeController,
              ),
              const SizedBox(height: 12),
              _ReportTextField(
                label: 'Event',
                controller: _eventController,
                maxLines: 2,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _ReportCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle('Classification'),
              const SizedBox(height: 14),
              const Text(
                'Nature of Illness',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'Cardiac',
                  'Neurological',
                  'OB/Gynae',
                  'Respiratory',
                  'Trauma',
                  'Medical',
                  'General',
                ]
                    .map(
                      (label) => _ChoiceChipButton(
                        label: label,
                        selected: _natureOfIllness.contains(label),
                        onTap: () => _toggleExclusiveValue(_natureOfIllness, label),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 18),
              const Text(
                'Mechanism of Injury',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'Assault',
                  'Chemical Poisoning',
                  'Drowning',
                  'Electrocution',
                  'Excessive Heat',
                  'Fall',
                  'Firearm Injury',
                  'RTA Vehicle',
                  'RTA Pedestrian',
                  'Machinery Accidents',
                  'Others',
                ]
                    .map(
                      (label) => _ChoiceChipButton(
                        label: label,
                        selected: _mechanismOfInjury.contains(label),
                        onTap: () => _toggleExclusiveValue(_mechanismOfInjury, label),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVitalsAndNarrativeStep() {
    return Column(
      children: [
        _ReportCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle('Vital Signs'),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _ReportTextField(
                      label: 'Time (1)',
                      controller: _vitalsTimeOneController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ReportTextField(
                      label: 'Time (2)',
                      controller: _vitalsTimeTwoController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ReportTextField(
                      label: 'Pulse Rate & Rhythm',
                      controller: _pulseController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ReportTextField(
                      label: 'Respiratory Rate',
                      controller: _respiratoryController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ReportTextField(
                      label: 'Oxygen Saturation',
                      controller: _saturationController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ReportTextField(
                      label: 'Blood Pressure',
                      controller: _bloodPressureController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ReportTextField(
                      label: 'Temperature',
                      controller: _temperatureController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ReportTextField(
                      label: 'Pain Score',
                      controller: _painController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ReportTextField(
                      label: 'Total GCS',
                      controller: _gcsController,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _ReportCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle('Narrative Notes'),
              const SizedBox(height: 14),
              _ReportTextField(
                label: 'Narrative',
                hint: 'Document care management, timeline, interventions, and patient response.',
                controller: _narrativeController,
                maxLines: 6,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _ReportCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionTitle('Recognition of Death'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'Decomposition',
                  'Rigor Mortis',
                  'Incineration',
                  'Decapitation',
                  'Pooling',
                  'Other injuries incompatible with life',
                ]
                    .map(
                      (label) => _ChoiceChipButton(
                        label: label,
                        selected: _recognitionOfDeath.contains(label),
                        onTap: () => _toggleSetValue(_recognitionOfDeath, label),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 18),
              const _SectionTitle('Cessation of Resuscitation'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'History of Coronary Disease',
                  'Undetermined',
                  'Collapse Witnessed',
                  'Spontaneous Pulse Returned',
                  'Transferred to Hospital CPR in Progress',
                  'Spontaneous Circulation On',
                ]
                    .map(
                      (label) => _ChoiceChipButton(
                        label: label,
                        selected: _cessationOfResuscitation.contains(label),
                        onTap: () => _toggleSetValue(
                          _cessationOfResuscitation,
                          label,
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _ReportTextField(
                      label: 'Provider Information',
                      controller: _providerController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ReportTextField(
                      label: 'Receiving Provider',
                      controller: _receivingProviderController,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleBack() {
    if (_currentStep == 0) {
      Navigator.of(context).maybePop();
      return;
    }

    setState(() {
      _currentStep -= 1;
    });
  }

  void _handleContinue() {
    if (_currentStep == _steps.length - 1) {
      if (_formKey.currentState?.validate() != true) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incident report captured and ready for submission.'),
        ),
      );
      Navigator.of(context).pop(true);
      return;
    }

    if (_currentStep == 0 || _currentStep == 1) {
      if (_formKey.currentState?.validate() != true) {
        return;
      }
    }

    setState(() {
      _currentStep += 1;
    });
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    return null;
  }

  void _toggleSetValue(Set<String> target, String value) {
    setState(() {
      if (target.contains(value)) {
        target.remove(value);
      } else {
        target.add(value);
      }
    });
  }

  void _toggleExclusiveValue(Set<String> target, String value) {
    setState(() {
      target
        ..clear()
        ..add(value);
    });
  }

  Future<void> _handleExportPdf() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    setState(() {
      _isExportingPdf = true;
    });

    try {
      final pdf = pw.Document();
      final report = _buildPdfReportData();

      pdf.addPage(
        pw.MultiPage(
          margin: const pw.EdgeInsets.all(28),
          build: (context) => [
            pw.Text(
              'AGAP Incident Report',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              'Responder export for emergency documentation',
              style: const pw.TextStyle(fontSize: 11),
            ),
            pw.SizedBox(height: 18),
            _pdfSection(
              'Incident Information',
              [
                ['Category', report.incidentCategory],
                ['Type', report.incidentType],
                ['Date of Call', report.dateOfCall],
                ['Time of Call', report.timeOfCall],
                ['Mobile', report.mobileTime],
                ['At Scene', report.atSceneTime],
                ['At Patient', report.atPatientTime],
                ['Location', report.location],
                ['Destination', report.destination],
                ['Destination Type', report.destinationType],
                ['At Handover', report.atHandoverTime],
                ['Clear', report.clearTime],
                ['Station Code', report.stationCode],
                ['Ambulance Unit', report.ambulanceUnit],
                ['Patient No.', report.patientNumber],
              ],
            ),
            _pdfSection(
              'Patient Information',
              [
                ['Patient Name', report.patientFullName],
                ['Address', report.address],
                ['Age / Sex', '${report.age} / ${report.sex}'],
                ['Contact No.', report.contactNumber],
                ['Next of Kin', report.nextOfKin],
                ['NOK Contact', report.nokContactNumber],
                ['Disposition', report.dispositionFlags],
              ],
            ),
            _pdfSection(
              'Assessment Summary',
              [
                ['Consciousness', report.consciousnessLevel],
                ['Airway', report.airwayStatus],
                ['Breathing', report.breathingStatus],
                ['Circulation', report.circulationStatus],
                ['Body Findings', report.bodyFindings],
                ['Nature of Illness', report.natureOfIllness],
                ['Mechanism of Injury', report.mechanismOfInjury],
              ],
            ),
            _pdfSection(
              'SAMPLE / Secondary Survey',
              [
                ['Signs and Symptoms', report.signsAndSymptoms],
                ['Allergies', report.allergies],
                ['Medications', report.medications],
                ['Past Medical History', report.pastMedicalHistory],
                ['Last Intake', report.lastIntake],
                ['Event', report.event],
              ],
            ),
            _pdfSection(
              'Vital Signs',
              [
                [
                  'Observation Times',
                  '${report.vitalsTimeOne} / ${report.vitalsTimeTwo}',
                ],
                ['Pulse Rate & Rhythm', report.pulseRate],
                ['Respiratory Rate', report.respiratoryRate],
                ['Oxygen Saturation', report.oxygenSaturation],
                ['Blood Pressure', report.bloodPressure],
                ['Temperature', report.temperature],
                ['Pain Score', report.painScore],
                ['Total GCS', report.totalGcs],
              ],
            ),
            _pdfSection(
              'Narrative and Handover',
              [
                ['Narrative', report.narrative],
                ['Recognition of Death', report.recognitionOfDeath],
                [
                  'Cessation of Resuscitation',
                  report.cessationOfResuscitation,
                ],
                ['Provider Information', report.providerInformation],
                ['Receiving Provider', report.receivingProvider],
              ],
            ),
          ],
        ),
      );

      final bytes = await pdf.save();
      final filename = _buildPdfFileName(report.patientFullName);

      await Printing.layoutPdf(
        name: filename,
        onLayout: (_) async => bytes,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF export is ready for saving or printing.'),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not export PDF: $error'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isExportingPdf = false;
        });
      }
    }
  }

  _PdfReportData _buildPdfReportData() {
    final patientFullName = [
      _patientNameController.text.trim(),
      _patientFirstNameController.text.trim(),
      _patientMiController.text.trim(),
    ].where((value) => value.isNotEmpty).join(', ');

    return _PdfReportData(
      incidentCategory: _incidentCategory,
      incidentType: _incidentType,
      dateOfCall: _displayValue(_dateOfCallController.text),
      timeOfCall: _displayValue(_timeOfCallController.text),
      mobileTime: _displayValue(_mobileController.text),
      atSceneTime: _displayValue(_atSceneController.text),
      atPatientTime: _displayValue(_atPatientController.text),
      location: _displayValue(_locationController.text),
      destination: _displayValue(_destinationController.text),
      destinationType: _destinationType,
      atHandoverTime: _displayValue(_atHandoverController.text),
      clearTime: _displayValue(_clearController.text),
      stationCode: _displayValue(_stationCodeController.text),
      ambulanceUnit: _displayValue(_ambulanceUnitController.text),
      patientNumber: _displayValue(_patientNoController.text),
      patientFullName: patientFullName.isEmpty ? widget.resident.name : patientFullName,
      address: _displayValue(_addressController.text),
      age: _displayValue(_ageController.text),
      sex: _displayValue(_sexController.text),
      contactNumber: _displayValue(_contactController.text),
      nextOfKin: _displayValue(_nextOfKinController.text),
      nokContactNumber: _displayValue(_nokContactController.text),
      dispositionFlags: _joinSet(_refusalActions),
      consciousnessLevel: _consciousnessLevel,
      airwayStatus: _airwayStatus,
      breathingStatus: _breathingStatus,
      circulationStatus: _circulationStatus,
      bodyFindings: _joinSet(_injuryFindings),
      natureOfIllness: _joinSet(_natureOfIllness),
      mechanismOfInjury: _joinSet(_mechanismOfInjury),
      signsAndSymptoms: _displayValue(_signsSymptomsController.text),
      allergies: _displayValue(_allergiesController.text),
      medications: _displayValue(_medicationsController.text),
      pastMedicalHistory: _displayValue(_historyController.text),
      lastIntake: _displayValue(_lastIntakeController.text),
      event: _displayValue(_eventController.text),
      vitalsTimeOne: _displayValue(_vitalsTimeOneController.text),
      vitalsTimeTwo: _displayValue(_vitalsTimeTwoController.text),
      pulseRate: _displayValue(_pulseController.text),
      respiratoryRate: _displayValue(_respiratoryController.text),
      oxygenSaturation: _displayValue(_saturationController.text),
      bloodPressure: _displayValue(_bloodPressureController.text),
      temperature: _displayValue(_temperatureController.text),
      painScore: _displayValue(_painController.text),
      totalGcs: _displayValue(_gcsController.text),
      narrative: _displayValue(_narrativeController.text),
      recognitionOfDeath: _joinSet(_recognitionOfDeath),
      cessationOfResuscitation: _joinSet(_cessationOfResuscitation),
      providerInformation: _displayValue(_providerController.text),
      receivingProvider: _displayValue(_receivingProviderController.text),
    );
  }

  pw.Widget _pdfSection(String title, List<List<String>> rows) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 14),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            color: pdf.PdfColor.fromInt(AppColors.agapOrangeDeep.toARGB32()),
            child: pw.Text(
              title.toUpperCase(),
              style: pw.TextStyle(
                color: pdf.PdfColor.fromInt(Colors.white.toARGB32()),
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Table(
            border: pw.TableBorder.all(
              color: pdf.PdfColor.fromInt(
                const Color(0xFFD7D7D7).toARGB32(),
              ),
              width: 0.6,
            ),
            columnWidths: const {
              0: pw.FlexColumnWidth(1.6),
              1: pw.FlexColumnWidth(3),
            },
            children: rows
                .map(
                  (row) => pw.TableRow(
                    children: [
                      _pdfCell(
                        row.first,
                        isLabel: true,
                      ),
                      _pdfCell(row.last),
                    ],
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  pw.Widget _pdfCell(String text, {bool isLabel = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: isLabel ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  String _joinSet(Set<String> values) {
    if (values.isEmpty) return 'None recorded';
    return values.join(', ');
  }

  String _displayValue(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? 'Not provided' : trimmed;
  }

  String _buildPdfFileName(String patientName) {
    final sanitized = patientName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    final name = sanitized.isEmpty ? 'incident_report' : sanitized;
    return '${name}_incident_report.pdf';
  }

  _ReportedAtData _extractReportedAt(String reportedAtText) {
    final parts = reportedAtText.split('•').map((part) => part.trim()).toList();
    final date = parts.isNotEmpty && parts.first.isNotEmpty
        ? parts.first.replaceAll('-', '/')
        : 'Auto-filled';
    final time = parts.length > 1 && parts[1].isNotEmpty
        ? parts[1]
        : 'Auto-filled';
    final compactStamp = '$date$time'
        .replaceAll(RegExp(r'[^0-9A-Za-z]'), '')
        .toUpperCase();

    return _ReportedAtData(
      date: date,
      time: time,
      compactStamp: compactStamp.isEmpty ? 'REPORT' : compactStamp,
    );
  }

  _PatientNameParts _splitPatientName(String fullName) {
    final parts = fullName
        .split(RegExp(r'\s+'))
        .where((part) => part.trim().isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return const _PatientNameParts(
        firstName: '',
        middleInitial: '',
        lastName: '',
      );
    }

    if (parts.length == 1) {
      return _PatientNameParts(
        firstName: parts.first,
        middleInitial: '',
        lastName: parts.first,
      );
    }

    return _PatientNameParts(
      firstName: parts.first,
      middleInitial: parts.length > 2 ? parts[1].substring(0, 1) : '',
      lastName: parts.last,
    );
  }

  Widget _buildExportCard() {
    return _ReportCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Export Incident Report'),
          const SizedBox(height: 10),
          const Text(
            'Generate a PDF summary with the most important dispatch, patient, assessment, and handoff information for endorsement and records.',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _isExportingPdf ? null : _handleExportPdf,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(54),
                side: const BorderSide(
                  color: AppColors.agapOrangeDeep,
                  width: 1.2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              icon: _isExportingPdf
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: AppColors.agapOrangeDeep,
                      ),
                    )
                  : const Icon(
                      Icons.picture_as_pdf_rounded,
                      color: AppColors.agapOrangeDeep,
                    ),
              label: Text(
                _isExportingPdf ? 'Preparing PDF...' : 'EXPORT TO PDF',
                style: const TextStyle(
                  color: AppColors.agapOrangeDeep,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportedAtData {
  const _ReportedAtData({
    required this.date,
    required this.time,
    required this.compactStamp,
  });

  final String date;
  final String time;
  final String compactStamp;
}

class _PatientNameParts {
  const _PatientNameParts({
    required this.firstName,
    required this.middleInitial,
    required this.lastName,
  });

  final String firstName;
  final String middleInitial;
  final String lastName;
}

class _PdfReportData {
  const _PdfReportData({
    required this.incidentCategory,
    required this.incidentType,
    required this.dateOfCall,
    required this.timeOfCall,
    required this.mobileTime,
    required this.atSceneTime,
    required this.atPatientTime,
    required this.location,
    required this.destination,
    required this.destinationType,
    required this.atHandoverTime,
    required this.clearTime,
    required this.stationCode,
    required this.ambulanceUnit,
    required this.patientNumber,
    required this.patientFullName,
    required this.address,
    required this.age,
    required this.sex,
    required this.contactNumber,
    required this.nextOfKin,
    required this.nokContactNumber,
    required this.dispositionFlags,
    required this.consciousnessLevel,
    required this.airwayStatus,
    required this.breathingStatus,
    required this.circulationStatus,
    required this.bodyFindings,
    required this.natureOfIllness,
    required this.mechanismOfInjury,
    required this.signsAndSymptoms,
    required this.allergies,
    required this.medications,
    required this.pastMedicalHistory,
    required this.lastIntake,
    required this.event,
    required this.vitalsTimeOne,
    required this.vitalsTimeTwo,
    required this.pulseRate,
    required this.respiratoryRate,
    required this.oxygenSaturation,
    required this.bloodPressure,
    required this.temperature,
    required this.painScore,
    required this.totalGcs,
    required this.narrative,
    required this.recognitionOfDeath,
    required this.cessationOfResuscitation,
    required this.providerInformation,
    required this.receivingProvider,
  });

  final String incidentCategory;
  final String incidentType;
  final String dateOfCall;
  final String timeOfCall;
  final String mobileTime;
  final String atSceneTime;
  final String atPatientTime;
  final String location;
  final String destination;
  final String destinationType;
  final String atHandoverTime;
  final String clearTime;
  final String stationCode;
  final String ambulanceUnit;
  final String patientNumber;
  final String patientFullName;
  final String address;
  final String age;
  final String sex;
  final String contactNumber;
  final String nextOfKin;
  final String nokContactNumber;
  final String dispositionFlags;
  final String consciousnessLevel;
  final String airwayStatus;
  final String breathingStatus;
  final String circulationStatus;
  final String bodyFindings;
  final String natureOfIllness;
  final String mechanismOfInjury;
  final String signsAndSymptoms;
  final String allergies;
  final String medications;
  final String pastMedicalHistory;
  final String lastIntake;
  final String event;
  final String vitalsTimeOne;
  final String vitalsTimeTwo;
  final String pulseRate;
  final String respiratoryRate;
  final String oxygenSaturation;
  final String bloodPressure;
  final String temperature;
  final String painScore;
  final String totalGcs;
  final String narrative;
  final String recognitionOfDeath;
  final String cessationOfResuscitation;
  final String providerInformation;
  final String receivingProvider;
}

class _ReportStep {
  const _ReportStep({
    required this.sectionLabel,
    required this.title,
    required this.description,
    required this.builder,
  });

  final String sectionLabel;
  final String title;
  final String description;
  final Widget Function() builder;
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({
    required this.currentStep,
    required this.totalSteps,
    required this.sectionLabel,
    required this.title,
    required this.description,
  });

  final int currentStep;
  final int totalSteps;
  final String sectionLabel;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFEFE9), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFFFD4C6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STEP $currentStep OF $totalSteps',
            style: const TextStyle(
              color: AppColors.agapOrangeDeep,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            sectionLabel,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(
              totalSteps,
              (index) => Expanded(
                child: Container(
                  height: 6,
                  margin: EdgeInsets.only(right: index == totalSteps - 1 ? 0 : 6),
                  decoration: BoxDecoration(
                    color: index < currentStep
                        ? AppColors.agapOrangeDeep
                        : const Color(0xFFFFD8CB),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        color: AppColors.agapOrangeDeep,
        fontSize: 15,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.6,
      ),
    );
  }
}

class _ReportTextField extends StatelessWidget {
  const _ReportTextField({
    required this.label,
    required this.controller,
    this.hint,
    this.validator,
    this.maxLines = 1,
    this.prefixIcon,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final String? Function(String?)? validator;
  final int maxLines;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon,
            hintStyle: const TextStyle(
              color: AppColors.inputHint,
              fontWeight: FontWeight.w600,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.border, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.agapOrangeDeep,
                width: 1.4,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.red, width: 1.4),
            ),
          ),
        ),
      ],
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<T> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          initialValue: value,
          onChanged: onChanged,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.border, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: AppColors.agapOrangeDeep,
                width: 1.4,
              ),
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(item.toString()),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _ChoiceChipButton extends StatelessWidget {
  const _ChoiceChipButton({
    required this.label,
    required this.selected,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFF6D45) : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? const Color(0xFFFF6D45) : const Color(0xFFD8D8D8),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ToggleField extends StatelessWidget {
  const _ToggleField({
    required this.title,
    required this.selectedValue,
    required this.options,
    required this.onChanged,
  });

  final String title;
  final String selectedValue;
  final List<String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options
              .map(
                (option) => _ChoiceChipButton(
                  label: option,
                  selected: selectedValue == option,
                  onTap: () => onChanged(option),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _FooterActions extends StatelessWidget {
  const _FooterActions({
    required this.currentStep,
    required this.totalSteps,
    required this.onBack,
    required this.onContinue,
    this.exportChild,
  });

  final int currentStep;
  final int totalSteps;
  final VoidCallback onBack;
  final VoidCallback onContinue;
  final Widget? exportChild;

  @override
  Widget build(BuildContext context) {
    final isLastStep = currentStep == totalSteps - 1;

    return Column(
      children: [
        if (exportChild != null) ...[
          exportChild!,
          const SizedBox(height: 16),
        ],
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onBack,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  side: const BorderSide(color: AppColors.agapOrangeDeep, width: 1.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: Text(
                  currentStep == 0 ? 'BACK' : 'PREVIOUS',
                  style: const TextStyle(
                    color: AppColors.agapOrangeDeep,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: onContinue,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.agapOrangeDeep,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: Text(
                  isLastStep ? 'SUBMIT REPORT' : 'CONTINUE',
                  style: isLastStep
                      ? const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        )
                      : AppTypography.buttonPrimary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
