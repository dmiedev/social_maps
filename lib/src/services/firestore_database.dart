import 'package:social_maps/src/models/place.dart';

import 'package:social_maps/src/services/firestore_service.dart';

class FirestoreDatabase {
  final _service = FirestoreService();

  Future<void> createPlace(Place place) {
    return _service.createDocument(
      collectionPath: FirestorePath.places,
      data: place.toMap(),
    );
  }

  Future<void> deletePlace(String placeId) {
    return _service.deleteDocument(documentPath: FirestorePath.place(placeId));
  }

  Stream<List<Place>> get placesStream {
    return _service.collectionStream(
      path: FirestorePath.places,
      builder: (data, id) => Place.fromMap(id, data),
    );
  }
}

class FirestorePath {
  static String get places => 'places';
  static String place(String placeId) => 'places/$placeId';
}
