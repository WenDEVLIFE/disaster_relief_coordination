import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ReliefCenterScreen extends StatefulWidget {
  const ReliefCenterScreen({super.key});

  @override
  State<ReliefCenterScreen> createState() => _ReliefCenterScreenState();
}

class _ReliefCenterScreenState extends State<ReliefCenterScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  // Sample relief center data
  final List<ReliefCenter> _reliefCenters = [
    ReliefCenter(
      id: '1',
      name: 'Dacudao Relief Center',
      location: LatLng(7.215508397624287, 125.47460872970882), // Manila coordinates
      address: 'Manila, Philippines',
      capacity: 500,
      currentOccupancy: 320,
    ),
  ];

  List<ReliefCenter> _filteredCenters = [];

  @override
  void initState() {
    super.initState();
    _filteredCenters = _reliefCenters;
  }

  void _searchReliefCenters(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCenters = _reliefCenters;
      } else {
        _filteredCenters = _reliefCenters
            .where(
              (center) =>
                  center.name.toLowerCase().contains(query.toLowerCase()) ||
                  center.address.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  void _goToReliefCenter(ReliefCenter center) {
    _mapController.move(center.location, 15.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Relief Centers',
          style: TextStyle(
            fontFamily: 'GoogleSansCode',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search relief centers...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 15.0,
                ),
              ),
              onChanged: _searchReliefCenters,
            ),
          ),

          // Map
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(7.21919328760695, 125.46491229398096),
                initialZoom: 12.0,
                maxZoom: 18.0,
                minZoom: 5.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'disaster_relief_coordination',
                ),
                MarkerLayer(
                  markers: _filteredCenters
                      .map(
                        (center) => Marker(
                          width: 80.0,
                          height: 80.0,
                          point: center.location,
                          child: GestureDetector(
                            onTap: () => _goToReliefCenter(center),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4.0,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.local_hospital,
                                color: Colors.white,
                                size: 30.0,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),

          // Relief center list
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filteredCenters.length,
              itemBuilder: (context, index) {
                final center = _filteredCenters[index];
                return ReliefCenterCard(
                  center: center,
                  onTap: () => _goToReliefCenter(center),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

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

class ReliefCenterCard extends StatelessWidget {
  final ReliefCenter center;
  final VoidCallback onTap;

  const ReliefCenterCard({
    super.key,
    required this.center,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250,
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(12.0),
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
            Text(
              center.name,
              style: const TextStyle(
                fontFamily: 'GoogleSansCode',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              center.address,
              style: const TextStyle(
                fontFamily: 'GoogleSansCode',
                fontSize: 14,
                color: Colors.grey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
              '${center.currentOccupancy}/${center.capacity} people',
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
