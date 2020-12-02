import 'dart:async';

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart' show rootBundle;

class Place {
  final String name;
  final bool isClosed;

  const Place({this.name, this.isClosed = false});

  @override
  String toString() {
    // TODO: implement toString
    return 'Place $name (closed : $isClosed)';
  }
}

class MapsView extends StatefulWidget {
  MapsView({Key key}) : super(key: key);

  @override
  _MapsViewState createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  final Location location = Location();

  LocationData _location;
  StreamSubscription<LocationData> _locationSubscription;
  String _error;

  Completer<GoogleMapController> _controller = Completer();
  ClusterManager _manager;
  Set<Marker> markers = Set();

  @override
  void initState() {
    _manager = _initClusterManager();
    _listenLocation();
    super.initState();
  }

  ClusterManager _initClusterManager() {
    return ClusterManager<Place>(items, _updateMarkers,
        markerBuilder: _markerBuilder, initialZoom: _kLake.zoom);
  }

  void _updateMarkers(Set<Marker> markers) {
    print('Updated ${markers.length} markers');
    setState(() {
      this.markers = markers;
    });
  }

  Future<Marker> Function(Cluster<Place>) get _markerBuilder =>
      (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () {
            print('---- $cluster');
            cluster.items.forEach((p) => print(p));
          },
          infoWindow:
              cluster.isMultiple ? null : InfoWindow(title: cluster.getId()),
          icon: await _getMarkerBitmap(cluster.isMultiple ? 125 : 75,
              text: cluster.isMultiple ? cluster.count.toString() : null),
        );
      };

  Future<BitmapDescriptor> _getMarkerBitmap(int size, {String text}) async {
    assert(size != null);

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = Colors.red;
    final Paint paint2 = Paint()..color = Colors.white;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);

    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
            fontSize: size / 3,
            color: Colors.white,
            fontWeight: FontWeight.normal),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  _listenLocation() async {
    _locationSubscription =
        location.onLocationChanged.handleError((dynamic err) {
      _error = err.code;

      _locationSubscription.cancel();
    }).listen((LocationData currentLocation) {
      _error = null;

      _location = currentLocation;
    });
  }

  _stopListen() async {
    await _locationSubscription.cancel();
  }

  void add() {
    _manager.setItems(<ClusterItem<Place>>[
      for (int i = 0; i < 30; i++)
        ClusterItem<Place>(LatLng(51.858265 + i * 0.01, 4.450107),
            item: Place(name: 'New Place ${DateTime.now()}'))
    ]);
  }

  List<ClusterItem<Place>> items = [
    for (int i = 0; i < 10; i++)
      ClusterItem(LatLng(51.848200 + i * 0.001, 4.419124 + i * 0.001),
          item: Place(name: 'Place $i')),
    for (int i = 0; i < 10; i++)
      ClusterItem(LatLng(51.858265 - i * 0.001, 4.450107 + i * 0.001),
          item: Place(name: 'Restaurant $i', isClosed: i % 2 == 0)),
    for (int i = 0; i < 10; i++)
      ClusterItem(LatLng(51.858265 + i * 0.01, 4.450107 - i * 0.01),
          item: Place(name: 'Bar $i')),
    for (int i = 0; i < 10; i++)
      ClusterItem(LatLng(51.858265 - i * 0.1, 4.450107 - i * 0.01),
          item: Place(name: 'Hotel $i')),
    for (int i = 0; i < 10; i++)
      ClusterItem(LatLng(51.858265 + i * 0.1, 4.450107 + i * 0.1)),
    for (int i = 0; i < 10; i++)
      ClusterItem(LatLng(51.858265 + i * 1, 4.450107 + i * 1)),
  ];

  @override
  void dispose() {
    _stopListen();
    super.dispose();
  }

  int indexMapType = 0;

  List<MapType> mapType = [MapType.hybrid, MapType.normal, MapType.satellite];

  void changeStyle() {
    setState(() {
      if (indexMapType < mapType.length - 1) {
        indexMapType++;
      } else {
        indexMapType = 0;
      }
    });
    print(indexMapType);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Google Mapss"),
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    mapType: mapType[indexMapType],
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    initialCameraPosition: _kGooglePlex,
                    markers: markers,
                    // onCameraMove: _manager.onCameraMove,
                    // onCameraIdle: _manager.updateMap,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      _manager.setMapController(controller);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: FlatButton(
                        onPressed: () => add(), child: Text("Press me")),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 90.0,
                        right: 15,
                      ),
                      child: MaterialButton(
                          color: Colors.grey[100],
                          onPressed: () => changeStyle(),
                          child: Icon(Icons.map_outlined)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _goToTheLake,
          label: Text('To the lake!'),
          icon: Icon(Icons.directions_boat),
        ),
      ),
    );
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(52.0787398, 4.4017642),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      //  bearing: 192.8334901395799,
      target: LatLng(52.0787398, 4.4017642),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
