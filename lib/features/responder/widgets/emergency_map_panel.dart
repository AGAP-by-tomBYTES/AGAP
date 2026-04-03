import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:agap/features/responder/data/responder_dashboard_data.dart';
import 'package:agap/theme/color.dart';

class EmergencyMapPanel extends StatelessWidget {
  const EmergencyMapPanel({
    super.key,
    required this.data,
    this.onOpenMap,
    this.height = 184,
    this.showOpenMapButton = true,
    this.borderRadius = BorderRadius.zero,
  });

  final EmergencyMapData data;
  final VoidCallback? onOpenMap;
  final double? height;
  final bool showOpenMapButton;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final hasRouteLine = _hasValidRoute(
      data.responderPosition,
      data.residentPosition,
    );
    final hasDistanceLabel = data.distanceLabel.trim().isNotEmpty;

    final mapStack = DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.mapGrass,
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          children: [
            Positioned.fill(
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(
                    data.initialCenter.latitude,
                    data.initialCenter.longitude,
                  ),
                  initialZoom: data.initialZoom,
                  backgroundColor: AppColors.mapGrass,
                ),
                children: [
                  if (data.offlineTileAssetTemplate != null)
                    TileLayer(
                      tileProvider: AssetTileProvider(),
                      urlTemplate: data.offlineTileAssetTemplate!,
                    )
                  else
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.agap',
                      maxZoom: 19,
                    ),
                  if (hasRouteLine)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: [
                            LatLng(
                              data.responderPosition.latitude,
                              data.responderPosition.longitude,
                            ),
                            LatLng(
                              data.residentPosition.latitude,
                              data.residentPosition.longitude,
                            ),
                          ],
                          strokeWidth: 5,
                          color: AppColors.infoBlue,
                          borderStrokeWidth: 2,
                          borderColor: Colors.white.withValues(alpha: 0.85),
                        ),
                      ],
                    ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(
                          data.residentPosition.latitude,
                          data.residentPosition.longitude,
                        ),
                        width: 32,
                        height: 32,
                        child: const _MapMarker(
                          color: AppColors.agapOrange,
                          size: 26,
                        ),
                      ),
                      Marker(
                        point: LatLng(
                          data.responderPosition.latitude,
                          data.responderPosition.longitude,
                        ),
                        width: 18,
                        height: 18,
                        child: const _MapMarker(
                          color: AppColors.agapNavy,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (showOpenMapButton)
              Positioned(
                right: 14,
                top: 14,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onOpenMap,
                    borderRadius: BorderRadius.circular(12),
                    child: Ink(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.map_outlined,
                            color: AppColors.agapOrange,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            data.openMapLabel,
                            style: const TextStyle(
                              color: AppColors.agapOrange,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              left: 14,
              bottom: 18,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.82),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LegendRow(
                      color: AppColors.agapOrange,
                      label: data.residentLegendLabel,
                    ),
                    const SizedBox(height: 6),
                    _LegendRow(
                      color: AppColors.agapNavy,
                      label: data.responderLegendLabel,
                    ),
                  ],
                ),
              ),
            ),
            if (hasDistanceLabel)
              Positioned(
                right: 16,
                bottom: 26,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    data.distanceLabel,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    if (height == null) {
      return SizedBox.expand(child: mapStack);
    }

    return SizedBox(
      height: height,
      width: double.infinity,
      child: mapStack,
    );
  }

  bool _hasValidRoute(
    MapCoordinate responder,
    MapCoordinate resident,
  ) {
    final hasResponderLocation =
        responder.latitude != 0 && responder.longitude != 0;
    final hasResidentLocation =
        resident.latitude != 0 && resident.longitude != 0;
    final samePoint = responder.latitude == resident.latitude &&
        responder.longitude == resident.longitude;

    return hasResponderLocation && hasResidentLocation && !samePoint;
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.color,
    required this.label,
  });

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _MapMarker extends StatelessWidget {
  const _MapMarker({
    required this.color,
    required this.size,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
          ),
        ),
      ],
    );
  }
}
