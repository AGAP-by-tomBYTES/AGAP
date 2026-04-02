import 'package:flutter/material.dart';

import 'package:agap/features/responder/data/responder_dashboard_data.dart';
import 'package:agap/features/responder/widgets/incident_status_card.dart';

class ResponderStatusWidget extends StatelessWidget {
  const ResponderStatusWidget({
    super.key,
    required this.data,
    this.onPressed,
  });

  final IncidentStatusData data;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IncidentStatusCard(
      data: data,
      onPressed: onPressed ?? () {},
    );
  }
}

const responderEnRouteStatusPreviewData = IncidentStatusData(
  status: IncidentProgressStatus.enRoute,
  badgeLabel: 'EN ROUTE',
  title: "YOU'RE EN ROUTE",
  subtitle: "You're on the way. Tap when you arrive.",
  timestampText: 'Started: 2:34 PM PST   •   ETA: 2:50 PM PST',
  actionLabel: 'ARRIVED',
);

const responderArrivedStatusPreviewData = IncidentStatusData(
  status: IncidentProgressStatus.arrived,
  badgeLabel: 'ARRIVED',
  title: "YOU'VE ARRIVED",
  subtitle: 'Confirm arrival to update status.',
  timestampText: 'Arrived 2:50 PM PST',
  actionLabel: 'RESOLVE INCIDENT',
);

const responderResolvedStatusPreviewData = IncidentStatusData(
  status: IncidentProgressStatus.resolved,
  badgeLabel: 'RESOLVED',
  title: 'INCIDENT RESOLVED',
  subtitle: 'Well done.',
  timestampText: 'Resolved 3:43 PM',
  actionLabel: 'MARK AS DONE',
);
