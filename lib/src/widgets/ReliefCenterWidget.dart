import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class ReliefCenter {
  final String id;
  final String name;
  final LatLng location;
  final String address;
  final int capacity;
  final int currentOccupancy;

  ReliefCenter({
    required this.id,
    required this.name,
    required this.location,
    required this.address,
    required this.capacity,
    required this.currentOccupancy,
  });

  double get occupancyPercentage => (currentOccupancy / capacity) * 100;
}

class ReliefCenterWidget extends StatelessWidget {
  final ReliefCenter center;
  final VoidCallback? onTap;

  const ReliefCenterWidget({super.key, required this.center, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.local_hospital,
                  color: Colors.blue,
                  size: 24.0,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    center.name,
                    style: const TextStyle(
                      fontFamily: 'GoogleSansCode',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.grey, size: 16.0),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    center.address,
                    style: const TextStyle(
                      fontFamily: 'GoogleSansCode',
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: center.occupancyPercentage / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                center.occupancyPercentage > 80
                    ? Colors.red
                    : center.occupancyPercentage > 50
                    ? Colors.orange
                    : Colors.green,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Occupancy: ${center.currentOccupancy}/${center.capacity} people (${center.occupancyPercentage.toStringAsFixed(1)}%)',
              style: const TextStyle(
                fontFamily: 'GoogleSansCode',
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
