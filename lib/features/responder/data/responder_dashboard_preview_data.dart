import 'package:agap/features/responder/data/responder_dashboard_data.dart';
import 'package:agap/features/responder/widgets/incident_status_card.dart';

const responderDashboardPreviewData = ResponderDashboardData(
  profile: ResponderProfileData(
    name: 'Juan Dela Cruz',
    teamAndStationLabel: 'Team Alpha - Miagao Station',
  ),
  alertSummary: AlertSummaryData(
    activeCount: 3,
    totalCount: 12,
    resolvedCount: 9,
  ),
  teamStation: TeamStationData(
    team: 'Team Alpha',
    station: 'Station 3 - Banwa, Miagao',
  ),
  weatherAdvisory: WeatherAdvisoryData(
    title: 'Weather advisory',
    message:
        'PAGASA advisory details will appear here once the live weather report is connected.',
  ),
  resolvedAlerts: [
    ResolvedAlertData(
      name: 'Rosa M. Manalo',
      type: 'Medical',
      location: 'Brgy. Igtuba',
      time: 'Mar 28, 2:14 PM',
    ),
    ResolvedAlertData(
      name: 'Carlos Bautista',
      type: 'Flood',
      location: 'Brgy. Sapa',
      time: 'Mar 27, 8:10 PM',
    ),
    ResolvedAlertData(
      name: 'Lita Reyes',
      type: 'Earthquake',
      location: 'Brgy. Bagumbayan',
      time: 'Mar 27, 2:14 PM',
    ),
    ResolvedAlertData(
      name: 'Robert Reyes',
      type: 'Earthquake',
      location: 'Brgy. Bagumbayan',
      time: 'Mar 27, 3:18 PM',
    ),
  ],
  emergencyDispatch: EmergencyDispatchData(
    dispatchTitle: 'Emergency Mode',
    locationSummary: '',
    map: EmergencyMapData(
      openMapLabel: 'Open map',
      residentLegendLabel: 'Resident',
      responderLegendLabel: 'You',
      distanceLabel: '',
      initialCenter: MapCoordinate(
        latitude: 10.6448,
        longitude: 122.2352,
      ),
      residentPosition: MapCoordinate(
        latitude: 0,
        longitude: 0,
      ),
      responderPosition: MapCoordinate(
        latitude: 0,
        longitude: 0,
      ),
    ),
    resident: ResidentIncidentData(
      category: 'MEDICAL',
      name: '',
      reportedAt: '',
      gender: '',
      age: '',
      address: '',
      detailsTitle: 'MEDICAL INFO',
      details: [],
    ),
    incidentStatus: IncidentStatusData(
      status: IncidentProgressStatus.enRoute,
      badgeLabel: 'EN ROUTE',
      title: "YOU'RE EN ROUTE",
      subtitle: "You're on the way. Tap when you arrive.",
      timestampText: 'Started: 2:34 PM PST   •   ETA: 2:50 PM PST',
      actionLabel: 'ARRIVED',
    ),
  ),
);
