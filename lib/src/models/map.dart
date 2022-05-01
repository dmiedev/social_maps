import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:social_maps/src/models/location.dart';
import 'package:social_maps/src/models/place.dart';

class SocialMap with ChangeNotifier {
  GoogleMapController _mapController;
  String _mapStyle;

  bool _addNewPlaceModeOn = false;
  bool get addNewPlaceModeOn => _addNewPlaceModeOn;

  bool get myLocationEnabled => !_addNewPlaceModeOn;

  final _newPlaceMarker = Set<Marker>();

  CameraPosition _cameraPosition;

  LatLng get cameraLocation => _cameraPosition.target;

  static const _defaultMinZoom = 2.0;
  static const _addNewPlaceMinZoom = 17.0;
  static const _defaultZoom = 15.0;
  static const _maxZoom = 21.0;
  double _zoomBeforeAddNewPlaceMode;

  MinMaxZoomPreference get zoomPreference => MinMaxZoomPreference(
      !_addNewPlaceModeOn ? _defaultMinZoom : _addNewPlaceMinZoom, _maxZoom);

  SocialMap() {
    _loadMapStyle();
  }

  Future<void> _loadMapStyle() async {
    _mapStyle = await rootBundle.loadString('assets/map_style.json');
  }

  void onMapCreated(GoogleMapController mapController) {
    _mapController = mapController;
    _mapController.setMapStyle(_mapStyle);
  }

  void onCameraMove(CameraPosition newPosition) {
    _cameraPosition = newPosition;
  }

  void onCameraIdle() {
    if (_addNewPlaceModeOn) {
      _addNewPlaceMarker();
    }
  }

  Future<void> switchAddNewPlaceMode() async {
    _addNewPlaceModeOn = !_addNewPlaceModeOn;
    if (_addNewPlaceModeOn) {
      newPlaceZoomIn();
    } else {
      newPlaceZoomOut();
      notifyListeners();
    }
  }

  void newPlaceZoomIn() {
    _zoomBeforeAddNewPlaceMode = _cameraPosition.zoom;
    if (_zoomBeforeAddNewPlaceMode < _addNewPlaceMinZoom) {
      _mapController.animateCamera(CameraUpdate.zoomTo(_addNewPlaceMinZoom));
    } else {
      _addNewPlaceMarker();
    }
  }

  void newPlaceZoomOut() async {
    if (_zoomBeforeAddNewPlaceMode < _addNewPlaceMinZoom) {
      _mapController
          .animateCamera(CameraUpdate.zoomTo(_zoomBeforeAddNewPlaceMode));
    }
  }

  void _addNewPlaceMarker() {
    _newPlaceMarker
      ..clear()
      ..add(
        Marker(
          markerId: MarkerId('New Place Marker'),
          position: _cameraPosition.target,
        ),
      );
    notifyListeners();
  }

  Set<Marker> getMarkers(List<Place> places) {
    if (!_addNewPlaceModeOn) {
      return places != null
          ? Set.from(
              places.map((place) => Marker(
                    markerId: MarkerId(place.id),
                    position: LatLng.fromJson(place.location),
                    infoWindow: InfoWindow(title: place.name),
                  )),
            )
          : Set<Marker>();
    } else {
      return _newPlaceMarker;
    }
  }

  CameraPosition getInitialCameraPosition(Location location) {
    _cameraPosition = CameraPosition(
      target: location != null
          ? LatLng(location.latitude, location.longitude)
          : LatLng(37.42796133580664, -122.085749655962),
      zoom: _defaultZoom,
    );
    return _cameraPosition;
  }
}
