import 'package:flutter/material.dart';

import 'package:agap/features/responder/data/responder_dashboard_data.dart';
import 'package:agap/features/responder/pages/emergency_map_page.dart';
import 'package:agap/features/responder/pages/incident_report_page.dart';
import 'package:agap/features/responder/pages/normal_dashboard_page.dart';
import 'package:agap/features/responder/pages/profile_page.dart';
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
                    Builder(
                      builder: (context) {
                        final locationSummary = _buildLocationSummary(
                          emergencyDispatch,
                        );
                        final reportedAt = _buildReportedAtLabel(
                          emergencyDispatch.resident.reportedAt,
                        );

                        return Column(
                          children: [
                            Container(
                              width: double.infinity,
                              color: AppColors.agapOrangeDeep,
                              padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _LiveDispatchChip(
                                              label: emergencyDispatch
                                                  .liveDispatchLabel,
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              'Reported by: $reportedAt',
                                              style: const TextStyle(
                                                color: Color(0xFFFFD8CB),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute<void>(
                                                builder: (_) =>
                                                    ResponderProfilePage(
                                                  data: widget.data,
                                                ),
                                              ),
                                            );
                                          },
                                          borderRadius:
                                              BorderRadius.circular(999),
                                          child: const CircleAvatar(
                                            radius: 24,
                                            backgroundColor: Colors.white24,
                                            child: Icon(
                                              Icons.person,
                                              color: Colors.white,
                                              size: 26,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              emergencyDispatch.dispatchTitle,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 26,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      OutlinedButton.icon(
                                        onPressed: _exitEmergencyMode,
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          side: const BorderSide(
                                            color: Colors.white54,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(999),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 10,
                                          ),
                                          visualDensity: VisualDensity.compact,
                                        ),
                                        icon: const Icon(
                                          Icons.close_rounded,
                                          size: 16,
                                        ),
                                        label: const Text(
                                          'EXIT',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (locationSummary.trim().isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      locationSummary,
                                      style: const TextStyle(
                                        color: Color(0xFFFFD8CB),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
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
                              title: locationSummary,
                            ),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
                      child: Column(
                        children: [
                          const _ResidentInfoCard(),
                          const SizedBox(height: 18),
                          ResponderStatusWidget(
                            data: _buildIncidentStatusData(
                              emergencyDispatch.incidentStatus,
                              emergencyDispatch,
                            ),
                            onPressed: _handleStatusAdvance,
                          ),
                        ],
                      ),
                    ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  IncidentStatusData _buildIncidentStatusData(
    IncidentStatusData baseData,
    EmergencyDispatchData dispatch,
  ) {
    switch (_currentStatus) {
      case IncidentProgressStatus.enRoute:
        return IncidentStatusData(
          status: IncidentProgressStatus.enRoute,
          badgeLabel: 'EN ROUTE',
          title: "YOU'RE EN ROUTE",
          subtitle: "You're on the way. Tap when you arrive.",
          timestampText: _buildDispatchWindow(dispatch.resident.reportedAt),
          actionLabel: 'ARRIVED',
        );
      case IncidentProgressStatus.arrived:
        return const IncidentStatusData(
          status: IncidentProgressStatus.arrived,
          badgeLabel: 'ARRIVED',
          title: "YOU'VE ARRIVED",
          subtitle: 'Complete the digital incident report before closing this call.',
          timestampText: 'Arrival time will appear once this response is updated.',
          actionLabel: 'OPEN INCIDENT REPORT',
        );
      case IncidentProgressStatus.resolved:
        return const IncidentStatusData(
          status: IncidentProgressStatus.resolved,
          badgeLabel: 'RESOLVED',
          title: 'INCIDENT RESOLVED',
          subtitle: 'This incident has been closed.',
          timestampText: 'Resolution time will appear once this report is completed.',
          actionLabel: 'MARK AS DONE',
        );
    }
  }

  void _handleStatusAdvance() {
    switch (_currentStatus) {
      case IncidentProgressStatus.enRoute:
        setState(() {
          _currentStatus = IncidentProgressStatus.arrived;
        });
        break;
      case IncidentProgressStatus.arrived:
        _openIncidentReport();
        break;
      case IncidentProgressStatus.resolved:
        Navigator.of(context).popUntil((route) => route.isFirst);
        break;
    }
  }

  Future<void> _openIncidentReport() async {
    final emergencyDispatch = widget.data.emergencyDispatch;
    if (emergencyDispatch == null) return;

    final reportSubmitted = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => IncidentReportPage(
          resident: emergencyDispatch.resident,
          locationSummary: emergencyDispatch.locationSummary,
          profile: widget.data.profile,
          teamStation: widget.data.teamStation,
          incidentStatus: emergencyDispatch.incidentStatus,
        ),
      ),
    );

    if (reportSubmitted == true && mounted) {
      setState(() {
        _currentStatus = IncidentProgressStatus.resolved;
      });
    }
  }

  void _exitEmergencyMode() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => ResponderNormalDashboardPage(data: widget.data),
      ),
    );
  }

  String _buildLocationSummary(EmergencyDispatchData dispatch) {
    final address = dispatch.resident.address.trim();
    final distance = dispatch.map.distanceLabel.trim();
    if (address.isEmpty) return distance;
    if (distance.isEmpty) return address;
    return '$address  •  $distance';
  }

  String _buildReportedAtLabel(String reportedAt) {
    return reportedAt.trim().isEmpty ? 'Waiting for resident report' : reportedAt;
  }

  String _buildDispatchWindow(String reportedAt) {
    final parts = reportedAt.split('•').map((part) => part.trim()).toList();
    final started = parts.length > 1 ? parts[1] : '';
    if (started.isEmpty) {
      return 'Started time will appear once the resident report is received';
    }

    final eta = _addMinutesToTime(started, 16);
    return 'Started: $started   •   ETA: $eta';
  }

  String _addMinutesToTime(String timeText, int minutesToAdd) {
    final match = RegExp(r'^(\d{1,2}):(\d{2})\s*(AM|PM)$', caseSensitive: false)
        .firstMatch(timeText.trim());
    if (match == null) return timeText;

    final hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);
    final meridiem = match.group(3)!.toUpperCase();

    var hour24 = hour % 12;
    if (meridiem == 'PM') {
      hour24 += 12;
    }

    final totalMinutes = hour24 * 60 + minute + minutesToAdd;
    final normalizedMinutes = ((totalMinutes % 1440) + 1440) % 1440;
    final newHour24 = normalizedMinutes ~/ 60;
    final newMinute = normalizedMinutes % 60;
    final newMeridiem = newHour24 >= 12 ? 'PM' : 'AM';
    final newHour12 = switch (newHour24 % 12) {
      0 => 12,
      final value => value,
    };

    final paddedMinute = newMinute.toString().padLeft(2, '0');
    return '$newHour12:$paddedMinute $newMeridiem';
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
  const _ResidentInfoCard();

  @override
  Widget build(BuildContext context) {
    return const DashboardSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RESIDENT INFO',
            style: TextStyle(
              color: Color(0xFFB0B0B0),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 18),
          Text(
            'Patient details will appear here once the SOS record is connected.',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
