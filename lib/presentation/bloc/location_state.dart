import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

enum LocationStatus { initial, loading, success, failure }

class LocationState extends Equatable {
  final LocationStatus status;
  final Position? position;
  final Placemark? placemark;
  final String? errorMessage;

  const LocationState({
    this.status = LocationStatus.initial,
    this.position,
    this.placemark,
    this.errorMessage,
  });

  LocationState copyWith({
    LocationStatus? status,
    Position? position,
    Placemark? placemark,
    String? errorMessage,
  }) {
    return LocationState(
      status: status ?? this.status,
      position: position ?? this.position,
      placemark: placemark ?? this.placemark,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, position, placemark, errorMessage];
}
