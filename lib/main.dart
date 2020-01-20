import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission/permission.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  final Set<Polyline> polylines = {};
  List<LatLng> routeCoords;
  GoogleMapPolyline googleMapPolyline =
      GoogleMapPolyline(apiKey: "AIzaSyCWAVTMZ1zzSMJ6m5KzV0QLtOZRUag6MEI");
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

  _addNewMarker(latLng) {
    setState(() {
      if (_markers.length >= 2) _markers.remove(_markers.last);
      _markers.add(Marker(
          markerId: MarkerId(latLng.toString()),
          position: latLng,
          infoWindow: InfoWindow(
            title: "This is a title",
            snippet: "This is a snippet",
          ),
          icon: BitmapDescriptor.defaultMarker));
    });
  }

  // _drawPolyLine() {
  //   setState(() {
  //      _getSomePoints();
  //   });
  // }
  
  // _getSomePoints() async {
  //   print('23142352524235232§');
  //   print('23142352524235232§');
  //   print('23142352524235232§');
  //   print('23142352524235232§');
  //   var permissions =
  //       await Permission.getPermissionsStatus([PermissionName.Location]);
  //   if (permissions[0].permissionStatus == PermissionStatus.notAgain) {
  //     var askPermission =
  //         await Permission.requestPermissions([PermissionName.Location]);
  //   } else {
  //     if (_markers.length >= 2)
  //       routeCoords = await googleMapPolyline.getCoordinatesWithLocation(
  //           origin: _markers.first.position,
  //           destination: _markers.last.position,
  //           mode: RouteMode.driving);
  //       print(routeCoords);
  //   }
  // }

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
          title: Text("maps"),
          backgroundColor: Colors.blue,
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: _mapType,
              initialCameraPosition: _kGooglePlex,
              onTap: _addNewMarker,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                // setState(() {
                //   polylines.add(Polyline(
                //       polylineId: PolylineId("route1"),
                //       visible: true,
                //       points: routeCoords,
                //       width: 4,
                //       color: Colors.blue,
                //       startCap: Cap.roundCap,
                //       endCap: Cap.buttCap));
                // });
              },
              onCameraMove: _onCameraMove,
              markers: _markers,
             // polylines: polylines,
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
              ),
            ),
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
                    SizedBox(
                      height: 10,
                    ),
                    createCustomFloatButton(
                        _goToPos_1, Icons.location_searching),
                    // SizedBox(height: 10,),
                    // createCustomFloatButton(
                    //   _drawPolyLine, Icons.router),
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
