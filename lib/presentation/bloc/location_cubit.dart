import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/location_service.dart';
import 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final LocationService _locationService;

  LocationCubit({required LocationService locationService})
    : _locationService = locationService,
      super(const LocationState());

  Future<void> getCurrentLocation() async {
    emit(state.copyWith(status: LocationStatus.loading));

    try {
      final position = await _locationService.determinePosition();
      final placemark = await _locationService.getPlacemarkFromPosition(
        position,
      );

      emit(
        state.copyWith(
          status: LocationStatus.success,
          position: position,
          placemark: placemark,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: LocationStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
