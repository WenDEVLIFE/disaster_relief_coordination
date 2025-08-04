class AlertModel {
  final String id;
  final String alertname;
  final String description;
  final String status;
  final String address;
  final String timestamp;
  final String disasterType;

  AlertModel({
    required this.id,
    required this.alertname,
    required this.description,
    required this.status,
    required this.address,
    required this.timestamp,
    required this.disasterType,
  });


}