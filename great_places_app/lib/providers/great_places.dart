import 'package:flutter/cupertino.dart';
import 'package:great_places_app/helpers/db_helper.dart';
import 'package:great_places_app/helpers/location_helper.dart';
import 'package:great_places_app/models/place.dart';
import 'dart:io';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place findById(String id) {
    return _items.firstWhere((place) => place.id == id);
  }

  Future<void> addPlace(
    String title,
    File image,
    PlaceLocation pickedLocation,
  ) async {
    final address = await LocationHelper.getPlaceAddress(
      pickedLocation.latitude,
      pickedLocation.longitude,
    );

    final updateLocation = PlaceLocation(
      latitude: pickedLocation.latitude,
      longitude: pickedLocation.longitude,
      address: address,
    );

    final newPlace = Place(
      id: DateTime.now().toString(),
      image: image,
      title: title,
      location: updateLocation,
    );

    _items.add(newPlace);
    notifyListeners();

    DbHelper.insert(
      'user_places',
      {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image.path,
        'loc_lat': newPlace.location!.latitude,
        'loc_lng': newPlace.location!.longitude,
        'address': newPlace.location!.address!,
      },
    );
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DbHelper.getData('user_places');

    _items = dataList
        .map(
          (data) => Place(
            id: data['id'],
            title: data['title'],
            image: File(data['image']),
            location: PlaceLocation(
              latitude: data['loc_lat'],
              longitude: data['loc_lng'],
              address: data['address'],
            ),
          ),
        )
        .toList();

    notifyListeners();
  }
}
