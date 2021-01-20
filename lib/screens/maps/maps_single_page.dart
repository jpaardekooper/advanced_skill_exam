import 'package:advanced_skill_exam/controllers/map_controller.dart';
import 'package:advanced_skill_exam/models/marker_model.dart';
import 'package:advanced_skill_exam/widgets/button/confirm_orange_button.dart';
import 'package:advanced_skill_exam/widgets/painter/bottom_large_wave_painter.dart';
import 'package:advanced_skill_exam/widgets/theme/color_theme.dart';
import 'package:advanced_skill_exam/widgets/theme/h1_text.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';

class MapsSinglePage extends StatefulWidget {
  MapsSinglePage({Key key, @required this.id, @required this.place})
      : super(key: key);
  final MarkerModel place;
  final String id;

  @override
  _MapsSinglePageState createState() => _MapsSinglePageState();
}

class _MapsSinglePageState extends State<MapsSinglePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 1,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 250.0,
                floating: false,
                pinned: true,
                backgroundColor: ColorTheme.accentOrange,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(widget.place.company,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      )),
                  background: CachedNetworkImage(
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    imageUrl: widget.place.url ?? widget.place.firebase_url,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelColor: Colors.black87,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(
                          icon: Icon(Icons.info),
                          text: "${widget.place.id ?? ""}"),
                    ],
                  ),
                ),
                pinned: false,
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Hero(
                  tag: 'background',
                  child: CustomPaint(
                    size: Size(MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height),
                    painter: BottomLargeWavePainter(
                      color: ColorTheme.extraLightGreen,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Center(child: H1Text(text: widget.place.info)),
                    ListTile(
                      leading: Icon(
                        Icons.circle,
                        color:
                            widget.place.isClosed ? Colors.red : Colors.green,
                      ),
                      title: widget.place.isClosed
                          ? Text("Gesloten")
                          : Text("Open"),
                      subtitle: Text(widget.place.code),
                    ),
                    ListTile(
                      leading: Icon(Icons.info),
                      title: Text(widget.place.company),
                      subtitle: Text(widget.place.name),
                    ),
                    ListTile(
                      leading: Icon(Icons.gps_fixed),
                      title: Text(widget.place.location.latitude.toString()),
                      subtitle:
                          Text(widget.place.location.longitude.toString()),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text("Reserveer nu een afspraak"),
                      subtitle: Text(widget.place.email),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80.0, vertical: 60),
                      child: ConfirmOrangeButton(
                        onTap: () async {
                          await GMapController()
                              .addMarkerInfo(widget.id, widget.place)
                              .then((value) => Navigator.pop(context));
                        },
                        text: "Voeg toe aan favorieten",
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
