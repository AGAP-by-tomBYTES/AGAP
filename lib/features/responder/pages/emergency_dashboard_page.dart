import 'package:flutter/material.dart';

import 'package:agap/features/responder/data/responder_dashboard_data.dart';
import 'package:agap/features/responder/pages/emergency_map_page.dart';
import 'package:agap/features/responder/widgets/dashboard_section_card.dart';
import 'package:agap/features/responder/widgets/emergency_map_panel.dart';
import 'package:agap/features/responder/widgets/incident_status_card.dart';
import 'package:agap/features/responder/widgets/responder_status_widget.dart';
import 'package:agap/theme/color.dart';

class ResponderEmergencyDashboardPage extends StatefulWidget {
  const ResponderEmergencyDashboardPage({
    super.key,
    required this.data,
  });

  final ResponderDashboardData data;

  @override
  State<ResponderEmergencyDashboardPage> createState() =>
      _ResponderEmergencyDashboardPageState();
}

class _ResponderEmergencyDashboardPageState
    extends State<ResponderEmergencyDashboardPage> {
  late IncidentProgressStatus _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus =
        widget.data.emergencyDispatch?.incidentStatus.status ??
        IncidentProgressStatus.enRoute;
  }

  @override
  Widget build(BuildContext context) {
    final emergencyDispatch = widget.data.emergencyDispatch;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EC),
      body: SafeArea(
        child: emergencyDispatch == null
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Emergency dispatch data is not available.',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      color: AppColors.agapOrangeDeep,
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          _HeaderMetaRow(
                            liveDispatchLabel: emergencyDispatch.liveDispatchLabel,
                            reportedAt: emergencyDispatch.resident.reportedAt,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            emergencyDispatch.dispatchTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            emergencyDispatch.locationSummary,
                            style: const TextStyle(
                              color: Color(0xFFFFD8CB),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    EmergencyMapPanel(
                      data: emergencyDispatch.map,
                      onOpenMap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => EmergencyMapPage(
                              mapData: emergencyDispatch.map,
                              title: emergencyDispatch.locationSummary,
                            ),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
                      child: Column(
                        children: [
                          _ResidentInfoCard(data: emergencyDispatch.resident),
                          const SizedBox(height: 18),
                          ResponderStatusWidget(
                            data: _buildIncidentStatusData(
                              emergencyDispatch.incidentStatus,
                            ),
                            onPressed: _handleStatusAdvance,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  IncidentStatusData _buildIncidentStatusData(IncidentStatusData baseData) {
    switch (_currentStatus) {
      case IncidentProgressStatus.enRoute:
        return IncidentStatusData(
          status: IncidentProgressStatus.enRoute,
          badgeLabel: 'EN ROUTE',
          title: "YOU'RE EN ROUTE",
          subtitle: "You're on the way. Tap when you arrive.",
          timestampText: baseData.timestampText,
          actionLabel: 'ARRIVED',
        );
      case IncidentProgressStatus.arrived:
        return const IncidentStatusData(
          status: IncidentProgressStatus.arrived,
          badgeLabel: 'ARRIVED',
          title: "YOU'VE ARRIVED",
          subtitle: 'Confirm arrival to update status.',
          timestampText: 'Arrived 2:50 PM PST',
          actionLabel: 'RESOLVE INCIDENT',
        );
      case IncidentProgressStatus.resolved:
        return const IncidentStatusData(
          status: IncidentProgressStatus.resolved,
          badgeLabel: 'RESOLVED',
          title: 'INCIDENT RESOLVED',
          subtitle: 'Well done.',
          timestampText: 'Resolved 3:43 PM',
          actionLabel: 'MARK AS DONE',
        );
    }
  }

  void _handleStatusAdvance() {
    setState(() {
      switch (_currentStatus) {
        case IncidentProgressStatus.enRoute:
          _currentStatus = IncidentProgressStatus.arrived;
          break;
        case IncidentProgressStatus.arrived:
          _currentStatus = IncidentProgressStatus.resolved;
          break;
        case IncidentProgressStatus.resolved:
          _currentStatus = IncidentProgressStatus.resolved;
          break;
      }
    });
  }
}

class _LiveDispatchChip extends StatelessWidget {
  const _LiveDispatchChip({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.overlayWhiteStrong,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.circle, color: Colors.white, size: 10),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderMetaRow extends StatelessWidget {
  const _HeaderMetaRow({
    required this.liveDispatchLabel,
    required this.reportedAt,
  });

  final String liveDispatchLabel;
  final String reportedAt;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      runSpacing: 8,
      children: [
        _LiveDispatchChip(label: liveDispatchLabel),
        Text(
          'Reported by: $reportedAt',
          style: const TextStyle(
            color: Color(0xFFFFD8CB),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ResidentInfoCard extends StatelessWidget {
  const _ResidentInfoCard({
    required this.data,
  });

  final ResidentIncidentData data;

  @override
  Widget build(BuildContext context) {
    return DashboardSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'RESIDENT INFO',
                  style: TextStyle(
                    color: Color(0xFFB0B0B0),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.agapOrange, width: 1.3),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  data.category,
                  style: const TextStyle(
                    color: AppColors.agapOrange,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Text(
                  data.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _DetailLine(label: 'Gender', value: data.gender),
          const SizedBox(height: 6),
          _DetailLine(label: 'Age', value: data.age),
          const SizedBox(height: 6),
          _DetailLine(label: 'Address', value: data.address),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.uploadPreviewSurface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.agapOrange.withValues(alpha: 0.75),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.detailsTitle,
                  style: const TextStyle(
                    color: AppColors.agapOrange,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: data.details
                            .map(
                              (detail) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  detail.label,
                                  style: const TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: data.details
                          .map(
                            (detail) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                detail.value,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
