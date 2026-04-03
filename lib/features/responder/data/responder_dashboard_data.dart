import 'package:agap/features/responder/widgets/incident_status_card.dart';

class ResponderDashboardData {
  const ResponderDashboardData({
    required this.profile,
    required this.alertSummary,
    required this.teamStation,
    required this.resolvedAlerts,
    this.weatherAdvisory,
    this.emergencyDispatch,
  });

  final ResponderProfileData profile;
  final AlertSummaryData alertSummary;
  final TeamStationData teamStation;
  final WeatherAdvisoryData? weatherAdvisory;
  final List<ResolvedAlertData> resolvedAlerts;
  final EmergencyDispatchData? emergencyDispatch;
}

class ResponderProfileData {
  const ResponderProfileData({
    required this.name,
    required this.teamAndStationLabel,
  });

  final String name;
  final String teamAndStationLabel;
}

class AlertSummaryData {
  const AlertSummaryData({
    required this.activeCount,
    required this.totalCount,
    required this.resolvedCount,
  });

  final int activeCount;
  final int totalCount;
  final int resolvedCount;
}

class TeamStationData {
  const TeamStationData({
    required this.team,
    required this.station,
  });

  final String team;
  final String station;
}

class WeatherAdvisoryData {
  const WeatherAdvisoryData({
    required this.title,
    required this.message,
  });

  final String title;
  final String message;
}

class ResolvedAlertData {
  const ResolvedAlertData({
    required this.name,
    required this.type,
    required this.location,
    required this.time,
  });

  final String name;
  final String type;
  final String location;
  final String time;
}

class EmergencyDispatchData {
  const EmergencyDispatchData({
    required this.dispatchTitle,
    required this.locationSummary,
    required this.map,
    required this.resident,
    required this.incidentStatus,
    this.liveDispatchLabel = 'LIVE DISPATCH',
  });

  final String liveDispatchLabel;
  final String dispatchTitle;
  final String locationSummary;
  final EmergencyMapData map;
  final ResidentIncidentData resident;
  final IncidentStatusData incidentStatus;
}

class EmergencyMapData {
  const EmergencyMapData({
    required this.openMapLabel,
    required this.residentLegendLabel,
    required this.responderLegendLabel,
    required this.distanceLabel,
    required this.initialCenter,
    required this.residentPosition,
    required this.responderPosition,
    this.initialZoom = 15.5,
    this.offlineTileAssetTemplate,
  });

  final String openMapLabel;
  final String residentLegendLabel;
  final String responderLegendLabel;
  final String distanceLabel;
  final MapCoordinate initialCenter;
  final MapCoordinate residentPosition;
  final MapCoordinate responderPosition;
  final double initialZoom;
  final String? offlineTileAssetTemplate;
}

class MapCoordinate {
  const MapCoordinate({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;
}

class ResidentIncidentData {
  const ResidentIncidentData({
    required this.category,
    required this.name,
    required this.reportedAt,
    required this.gender,
    required this.age,
    required this.address,
    required this.detailsTitle,
    required this.details,
  });

  final String category;
  final String name;
  final String reportedAt;
  final String gender;
  final String age;
  final String address;
  final String detailsTitle;
  final List<ResidentDetailData> details;
}

class ResidentDetailData {
  const ResidentDetailData({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}

class IncidentStatusData {
  const IncidentStatusData({
    required this.status,
    required this.badgeLabel,
    required this.title,
    required this.subtitle,
    required this.timestampText,
    required this.actionLabel,
  });

  final IncidentProgressStatus status;
  final String badgeLabel;
  final String title;
  final String subtitle;
  final String timestampText;
  final String actionLabel;
}
