import 'dart:async';
import 'dart:math';

import 'package:advanced_skill_exam/controllers/map_controller.dart';
import 'package:advanced_skill_exam/models/marker_model.dart';
import 'package:advanced_skill_exam/screens/maps/maps_single_page.dart';
import 'package:advanced_skill_exam/widgets/painter/marker_bitmap_painter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapsView extends StatefulWidget {
  MapsView({Key key}) : super(key: key);

  @override
  _MapsViewState createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  final Location location = Location();

  LocationData clocation;

  StreamSubscription<LocationData> _locationSubscription;

  Completer<GoogleMapController> _controller = Completer();

  ClusterManager _manager;

  Set<Marker> markers = Set();

  String error;

  int indexMapType = 0;

  List<MapType> mapType = [MapType.hybrid, MapType.normal, MapType.satellite];

  List<ClusterItem<MarkerModel>> items = [];

  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};

  List<LatLng> points = <LatLng>[];

  @override
  void initState() {
    _listenLocation();
    _manager = _initClusterManager();

    super.initState();
  }

  ClusterManager _initClusterManager() {
    return ClusterManager<MarkerModel>(items, _updateMarkers,
        markerBuilder: _markerBuilder, initialZoom: 5);
  }

  void _updateMarkers(Set<Marker> markers) {
    setState(() {
      this.markers = markers;
    });
  }

  _listenLocation() async {
    _locationSubscription =
        location.onLocationChanged.handleError((dynamic err) {
      error = err.code;

      _locationSubscription.cancel();
    }).listen((LocationData currentLocation) {
      error = null;

      clocation = currentLocation;
    });
  }

  void addPolyline() {
    final PolylineId polylineId = PolylineId('mapsline');

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      color: Theme.of(context).accentColor,
      width: 3,
      points: points,
    );
    if (mounted) {
      setState(() {
        polylines[polylineId] = polyline;
      });
    }
  }

  final GMapController mapController = GMapController();

  // ignore: avoid_void_async
  void add() async {
    GeoPoint north;
    GeoPoint south;

    points.clear();
    final GoogleMapController controller = await _controller.future;
    await controller.getVisibleRegion().then((value) {
      points.add(LatLng(value.northeast.latitude, value.northeast.longitude));
      points.add(LatLng(value.northeast.latitude, value.southwest.longitude));
      points.add(LatLng(value.southwest.latitude, value.southwest.longitude));
      points.add(LatLng(value.southwest.latitude, value.northeast.longitude));
      points.add(LatLng(value.northeast.latitude, value.northeast.longitude));

      north = GeoPoint(value.northeast.latitude, value.northeast.longitude);

      south = GeoPoint(value.southwest.latitude, value.southwest.longitude);
    });
    addPolyline();
    _manager.setItems(await mapController.getMapMarkerList(north, south));
    // print(controller.getLatLng(screenCoordinate));

    // _manager.setItems(<ClusterItem<MarkerModel>>[
    //   for (int i = 0; i < 30; i++)
    //     ClusterItem<MarkerModel>(LatLng(51.858265 + i * 0.01, 4.450107),
    //         item: MarkerModel(name: 'New Place $i ${DateTime.now()}'))
    // ]);
  }

  Future<Marker> Function(Cluster<MarkerModel>) get _markerBuilder =>
      (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          icon: await getMarkerBitmap(cluster.isMultiple ? 125 : 75, context,
              text: cluster.isMultiple ? cluster.count.toString() : null),
          infoWindow: cluster.isMultiple
              ? null
              : InfoWindow(
                  title: "Press me ",
                  onTap: () {
                    cluster.items.forEach(
                      (p) {
                        if (!cluster.isMultiple) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapsSinglePage(place: p),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
        );
      };

  void changeStyle() {
    if (mounted) {
      setState(() {
        if (indexMapType < mapType.length - 1) {
          indexMapType++;
        } else {
          indexMapType = 0;
        }
      });
    }
  }

  LatLng middlePoint;

  Future<LatLng> centerMark() async {
    // final GoogleMapController controller = await _controller.future;

    // double screenWidth = MediaQuery.of(context).size.width *
    //     MediaQuery.of(context).devicePixelRatio;
    // double screenHeight = MediaQuery.of(context).size.height *
    //     MediaQuery.of(context).devicePixelRatio;

    // double middleX = screenWidth / 2;
    // double middleY = screenHeight / 2;

    // ScreenCoordinate screenCoordinate =
    //     ScreenCoordinate(x: middleX.round(), y: middleY.round());

    // return middlePoint = await controller.getLatLng(screenCoordinate);
  }

  @override
  Widget build(BuildContext context) {
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
                    onCameraMove: _manager.onCameraMove,
                    onCameraIdle: _manager.updateMap,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      _manager.setMapController(controller);
                    },
                    polylines: Set<Polyline>.of(polylines.values),
                    cameraTargetBounds: CameraTargetBounds(
                      LatLngBounds(
                        northeast: const LatLng(54.01786, 7.230455),
                        southwest: const LatLng(50.74753, 3.992192),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: FlatButton(
                        onPressed: () => add(), child: Text("Press me")),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 60.0),
                    child: FlatButton(
                        onPressed: () => centerMark(),
                        child: Text("center view")),
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

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            //  bearing: 192.8334901395799,
            target: LatLng(clocation.latitude, clocation.longitude),
            tilt: 59.440717697143555,
            zoom: 19.151926040649414)));
  }

  _stopListen() async {
    await _locationSubscription.cancel();
  }

  @override
  void dispose() {
    _stopListen();
    super.dispose();
  }
}
