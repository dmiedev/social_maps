import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import 'package:social_maps/src/constants.dart';
import 'package:social_maps/src/models/location.dart';
import 'package:social_maps/src/models/map.dart';
import 'package:social_maps/src/models/place.dart';
import 'package:social_maps/src/models/user.dart';
import 'package:social_maps/src/services/firebase_auth_service.dart';
import 'package:social_maps/src/services/firestore_database.dart';
import 'package:social_maps/src/services/geolocator_service.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<SocialMap>(
          builder: (_, socialMap, __) => Text(
            !socialMap.addNewPlaceModeOn
                ? 'SocialMaps Alpha'
                : 'Let\'s add a new place!',
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => _logOut(context),
          ),
        ],
      ),
      body: FutureBuilder(
        future: GeolocatorService().getLocation(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? Provider<Location>.value(
                  value: snapshot.data,
                  child: _MapWidget(),
                )
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _logOut(BuildContext context) {
    Provider.of<FirebaseAuthService>(context, listen: false).signOut();
  }
}

class _MapWidget extends StatefulWidget {
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<_MapWidget> {
  final _newPlaceNameController = TextEditingController();
  bool _showLoadingIndicator = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _showLoadingIndicator,
      color: Colors.white,
      opacity: 0.5,
      child: StreamBuilder(
        stream: Provider.of<FirestoreDatabase>(context).placesStream,
        builder: (context, placesSnapshot) {
          if (placesSnapshot.hasError) {
            return Center(
              child: Text(
                'An error occurred while loading data',
                style: TextStyle(fontSize: 20.0),
              ),
            );
          }
          if (placesSnapshot.hasData == false) {
            return Center(child: CircularProgressIndicator());
          }
          return Consumer<SocialMap>(
            builder: (_, socialMap, __) => Stack(
              children: <Widget>[
                GoogleMap(
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  onCameraMove: socialMap.onCameraMove,
                  onCameraIdle: socialMap.onCameraIdle,
                  onMapCreated: socialMap.onMapCreated,
                  myLocationEnabled: socialMap.myLocationEnabled,
                  minMaxZoomPreference: socialMap.zoomPreference,
                  markers: socialMap.getMarkers(placesSnapshot.data),
                  initialCameraPosition: socialMap.getInitialCameraPosition(
                    Provider.of<Location>(context),
                  ),
                ),
                if (socialMap.addNewPlaceModeOn)
                  Center(
                    child: Container(
                      height: 7.0,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                if (socialMap.addNewPlaceModeOn)
                  Material(
                    elevation: 5.0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                      width: double.infinity,
                      height: 80.0,
                      alignment: Alignment.center,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: _newPlaceNameController,
                              decoration: getInputDecoration(color: Colors.blue)
                                  .copyWith(labelText: 'Place Name'),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          FlatButton(
                            color: Colors.blue,
                            textColor: Colors.white,
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.add),
                                Text('ADD'),
                              ],
                            ),
                            onPressed: () =>
                                _onAddNewPlaceButtonPressed(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(20.0),
                  child: !socialMap.addNewPlaceModeOn
                      ? FloatingActionButton(
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.add),
                          onPressed: socialMap.switchAddNewPlaceMode,
                        )
                      : FloatingActionButton(
                          backgroundColor: Colors.red,
                          child: Icon(Icons.close),
                          onPressed: socialMap.switchAddNewPlaceMode,
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _newPlaceNameController.dispose();
    super.dispose();
  }

  Future<void> _onAddNewPlaceButtonPressed(BuildContext context) async {
    FocusScope.of(context).unfocus();
    setState(() => _showLoadingIndicator = true);
    await context.read<FirestoreDatabase>().createPlace(
          Place(
            name: _newPlaceNameController.text,
            location: context.read<SocialMap>().cameraLocation.toJson(),
            createdBy: context.read<User>().uid,
          ),
        );
    context.read<SocialMap>().switchAddNewPlaceMode();
    _newPlaceNameController.clear();
    setState(() => _showLoadingIndicator = false);
  }
}
