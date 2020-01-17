import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  static const _zoom = 11.0;
  static const _center = LatLng(36.750610, 3.048451);
  MapType _mapType = MapType.normal;
  LatLng _lastMapPosition = _center;
  final Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: _center,
    zoom: _zoom,
  );

  static final CameraPosition _pos_1 = CameraPosition(
   //   bearing: 192.8334901395799,
      target: LatLng(36.770610, 3.058451),
    //  tilt: 59.440717697143555,
      zoom: _zoom);


  Future<void> _goToInitialPos() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
  }

  Future<void> _goToPos_1() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_pos_1));
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  _onMapTypeButtonPressed() {
    setState(() {
      print(_mapType == MapType.normal);
      this._mapType =
          _mapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          infoWindow: InfoWindow(
            title: "This is a title",
            snippet: "This is a snippet",
          ),
          icon: BitmapDescriptor.defaultMarker));
    });
  }

  Widget createCustomFloatButton(Function func, IconData icon) {
    return FloatingActionButton(
      onPressed: func,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: Icon(
        icon,
        size: 36,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Google Mpas"),
          backgroundColor: Colors.blue,
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: _mapType,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onCameraMove: _onCameraMove,
              markers: _markers,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  children: <Widget>[
                    createCustomFloatButton(_goToInitialPos, Icons.my_location),
                  ],
                ),
              ),),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: <Widget>[
                    createCustomFloatButton(_onMapTypeButtonPressed, Icons.map),
                    SizedBox(
                      height: 10,
                    ),
                    createCustomFloatButton(
                        _onAddMarkerButtonPressed, Icons.add_location),
                    SizedBox(height: 10,),
                    createCustomFloatButton(_goToPos_1, Icons.location_searching)
                  ],
                ),
               ),
            )
          ],
        )

        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: _goToTheLake,
        //   label: Text('To the lake!'),
        //   icon: Icon(Icons.directions_boat),
        // ),
        );
  }

  
  // @override
  // void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  //   super.debugFillProperties(properties);
  //   properties.add(DoubleProperty('zoom', zoom));
  // }
}
