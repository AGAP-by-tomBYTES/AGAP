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
        'PAGASA: Moderate rain expected in Cebu City. Signal 1 in effect until 6PM.',
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
    locationSummary: 'Brgy. Igtuba, Miagao  •  0.8 km away',
    map: EmergencyMapData(
      openMapLabel: 'Open map',
      residentLegendLabel: 'Resident',
      responderLegendLabel: 'You',
      distanceLabel: '1.2 km away',
      initialCenter: MapCoordinate(
        latitude: 10.6408,
        longitude: 122.2358,
      ),
      residentPosition: MapCoordinate(
        latitude: 10.6408,
        longitude: 122.2358,
      ),
      responderPosition: MapCoordinate(
        latitude: 10.6377,
        longitude: 122.2311,
      ),
    ),
    resident: ResidentIncidentData(
      category: 'MEDICAL',
      name: 'Rosa Manalo',
      reportedAt: 'Mar-26-26 • 2:14 PM',
      gender: 'F',
      age: '67 years old',
      address: 'Brgy. Igtuba, Miagao',
      detailsTitle: 'MEDICAL INFO',
      details: [
        ResidentDetailData(
          label: 'Allergies',
          value: 'Penicillin',
        ),
        ResidentDetailData(
          label: 'Modification',
          value: 'Losartan',
        ),
      ],
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
