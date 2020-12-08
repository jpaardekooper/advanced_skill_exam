import 'dart:async';
import 'package:advanced_skill_exam/controllers/map_controller.dart';
import 'package:advanced_skill_exam/models/marker_model.dart';
import 'package:advanced_skill_exam/screens/maps/maps_single_page.dart';

import 'package:advanced_skill_exam/widgets/painter/marker_bitmap_painter.dart';
import 'package:advanced_skill_exam/widgets/theme/color_theme.dart';
import 'package:advanced_skill_exam/widgets/theme/h1_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'add_new_marker.dart';

class MapsView extends StatefulWidget {
  MapsView({Key key, this.id}) : super(key: key);
  final String id;

  @override
  _MapsViewState createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  final Location location = Location();
  final GMapController mapController = GMapController();

  LocationData clocation;
  StreamSubscription<LocationData> _locationSubscription;
  Completer<GoogleMapController> _controller = Completer();
  ClusterManager _manager;
  Set<Marker> markers = Set();
  String error;
  int indexMapType;
  List<MapType> mapType;
  List<ClusterItem<MarkerModel>> items = [];
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  List<LatLng> points = <LatLng>[];
  GeoPoint topLeft, topright, bottomLeft, bottomRight;
  bool loading;

  @override
  void initState() {
    indexMapType = 0;
    mapType = [MapType.hybrid, MapType.normal, MapType.satellite];
    loading = false;

    _listenLocation();
    _manager = _initClusterManager();

    super.initState();
  }

  ClusterManager _initClusterManager() {
    if (mounted) {
      return ClusterManager<MarkerModel>(items, _updateMarkers,
          markerBuilder: _markerBuilder, initialZoom: 5);
    } else {
      return null;
    }
  }

  void _updateMarkers(Set<Marker> markers) {
    if (mounted) {
      setState(() {
        this.markers = markers;
        loading = false;
      });
    }
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
      color: ColorTheme.accentOrange,
      width: 3,
      points: points,
    );
    if (mounted) {
      setState(() {
        polylines[polylineId] = polyline;
      });
    }
  }

  void addMarker(MarkerModel data) {
    LatLng loc = LatLng(data.lat, data.long);

    items.add(ClusterItem(loc, item: data));

    _manager.setItems(items);

    Navigator.pop(context);
  }

  // ignore: avoid_void_async
  void add() async {
    loading = true;
    points.clear();
    final GoogleMapController controller = await _controller.future;
    await controller.getVisibleRegion().then((value) {
      points.add(LatLng(value.northeast.latitude, value.northeast.longitude));
      points.add(LatLng(value.northeast.latitude, value.southwest.longitude));
      points.add(LatLng(value.southwest.latitude, value.southwest.longitude));
      points.add(LatLng(value.southwest.latitude, value.northeast.longitude));
      points.add(LatLng(value.northeast.latitude, value.northeast.longitude));

      topLeft = GeoPoint(value.northeast.latitude, value.northeast.longitude);
      topright = GeoPoint(value.northeast.latitude, value.southwest.longitude);
      bottomLeft =
          GeoPoint(value.southwest.latitude, value.southwest.longitude);
      bottomRight =
          GeoPoint(value.southwest.latitude, value.northeast.longitude);
    });

    addPolyline();
    _manager.setItems(await mapController.getMapMarkerList(
        topLeft, topright, bottomLeft, bottomRight));
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
                              builder: (context) =>
                                  MapsSinglePage(id: widget.id, place: p),
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

  Future<void> _refreshData() async {
    return GMapController().getFavoriteListOnce(widget.id).then((value) {
      setState(() {
        return value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Google Mapss"),
        ),
        endDrawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    H1Text(text: "Geschiedenis"),
                    IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () {
                          _refreshData();
                        })
                  ],
                ),
                FutureBuilder<List<MarkerModel>>(
                  future: GMapController().getFavoriteListOnce(widget.id),
                  builder: (context, snapshot) {
                    List<MarkerModel> _favoriteList = snapshot.data;
                    if (_favoriteList == null || _favoriteList.isEmpty) {
                      return Text("geen data gevonden");
                    } else {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: _favoriteList.length,
                          itemBuilder: (BuildContext context, int index) {
                            MarkerModel marker = _favoriteList[index];
                            return ListTile(
                              leading: Container(
                                constraints:
                                    BoxConstraints(maxHeight: 50, maxWidth: 50),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  imageUrl: marker.url,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                marker.name,
                                style: TextStyle(color: Colors.red),
                              ),
                              subtitle: Text(marker.time.toDate().toString()),
                              trailing: Icon(
                                Icons.circle,
                                color:
                                    marker.isClosed ? Colors.red : Colors.green,
                              ),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MapsSinglePage(
                                      id: widget.id, place: marker),
                                ),
                              ),
                            );
                          });
                    }
                  },
                )
              ],
            ),
          ),
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
                    zoomControlsEnabled: false,
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
                  loading
                      ? Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: 140,
                            //   color: Colors.blue,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 50,
                                ),
                                Text("Markers worden opgehaald"),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: LinearProgressIndicator(),
                                ),
                              ],
                            ),
                          ))
                      : Container(),
                  Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.close,
                      color: ColorTheme.accentOrange,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 70),
                      child: Material(
                        //    radius: 25,
                        color: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: BorderSide(color: Colors.grey)),
                        child: IconButton(
                          icon: Icon(
                            Icons.search,
                          ),
                          onPressed: () {
                            add();
                          },
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 140),
                      child: Material(
                        //    radius: 25,
                        color: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: BorderSide(color: Colors.grey)),
                        child: IconButton(
                          icon: Icon(
                            Icons.map_outlined,
                          ),
                          onPressed: () {
                            changeStyle();
                          },
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 220),
                      child: Material(
                        //    radius: 25,
                        color: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: BorderSide(color: Colors.grey)),
                        child: IconButton(
                          icon: Icon(
                            Icons.clear,
                          ),
                          onPressed: () {
                            setState(() {
                              items.clear();
                              _manager.setItems(items);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0, top: 70),
                      child: Material(
                        //    radius: 25,
                        color: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            side: BorderSide(color: Colors.grey)),
                        child: IconButton(
                          icon: Icon(
                            Icons.zoom_in,
                          ),
                          onPressed: () async {
                            await _goToTheLake();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final GoogleMapController controller = await _controller.future;
            double screenWidth = MediaQuery.of(context).size.width *
                MediaQuery.of(context).devicePixelRatio;
            double screenHeight = (MediaQuery.of(context).size.height - 37.5) *
                MediaQuery.of(context).devicePixelRatio;

            double middleX = screenWidth / 2;
            double middleY = screenHeight / 2;

            ScreenCoordinate screenCoordinate =
                ScreenCoordinate(x: middleX.round(), y: middleY.round());

            LatLng middlePoint = await controller.getLatLng(screenCoordinate);

            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddNewMarker(
                    onTap: addMarker, viewLocation: middlePoint);
              },
            );
          },
          label: Text('Voeg marker toe'),
          icon: Icon(Icons.add),
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
    if (mounted) {
      await _locationSubscription.cancel();
    }
  }

  @override
  void dispose() {
    _stopListen();
    super.dispose();
  }
}
