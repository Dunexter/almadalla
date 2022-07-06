import 'package:almadalla/apiaccess/RestDatasource.dart';
import 'package:almadalla/screens/DashBoardScreen.dart';
import 'package:almadalla/screens/ResetPasswordScreen.dart';
import 'package:almadalla/translation/local_keys.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';

class HealthCareProviderLocationMap extends StatefulWidget {
  HealthCareProviderLocationMap({
    Key? key,
    required this.title,
    required this.healthCareName,
    required this.address,
    //required this.latitude,
    //required this.longitude
  }) : super(key: key);

  final String title;
  final String healthCareName;
  final String address;
  //final double latitude;
  //final double longitude;

  @override
  _HealthCareProviderLocationMapState createState() =>
      _HealthCareProviderLocationMapState();
}

class _HealthCareProviderLocationMapState
    extends State<HealthCareProviderLocationMap> {
  late Future<List> latLongFuture;

  @override
  void initState() {
    latLongFuture = getLatLong();

    super.initState();
  }

  void _onSignInEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DashBoardPage(title: 'Dashboard')),
    );
  }

  void _onResetPassword(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ResetPasswordPage(title: '')),
    );
  }

  GoogleMapController? controller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId? selectedMarker;
  int _markerIdCounter = 1;

  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }

  Map<MarkerId, Marker> _addMarker(lat, long) {
    /*final int markerCount = markers.length;

    if (markerCount == 12) {
      return;
    }*/

    final String markerIdVal = '${widget.healthCareName}';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        lat, //+ sin(_markerIdCounter * pi / 6.0) / 20.0,
        long, //+ cos(_markerIdCounter * pi / 6.0) / 20.0,
      ),
      infoWindow: InfoWindow(title: markerIdVal, snippet: ''),
      onTap: () {
        //_onMarkerTapped(markerId);
      },
      onDragEnd: (LatLng position) {
        //_onMarkerDragEnd(markerId, position);
      },
    );

    //setState(() {
    markers[markerId] = marker;
    return markers;
    //});
    //controller!.moveCamera(CameraUpdate.newLatLng(LatLng(9.931233, 76.267303)));
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _checkbox = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFeeede7),
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color(0xFFeeede7),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      //drawer: CustomDrawer(),
      body: Container(
          //color: Colors.blue,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            // borderRadius: BorderRadius.all(Radius.circular(100.0)),
            image: DecorationImage(
              image: AssetImage("assets/login.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  widget.healthCareName,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Align(
                //alignment: LocaleKeys.language.tr()=="arabic" ? Alignment.topRight:Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    LocaleKeys.locations.tr(),
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * .7,
                  child: FutureBuilder<List?>(
                    future: latLongFuture, // async work
                    builder:
                        (BuildContext context, AsyncSnapshot<List?> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Container(
                              child:
                                  Center(child: CupertinoActivityIndicator()));
                        default:
                          if (snapshot.hasError)
                            return Text(LocaleKeys.try_again);
                          else {
                            double lat = snapshot.data![0];
                            double long = snapshot.data![1];
                            Map<MarkerId, Marker> marker = snapshot.data![2];

                            /*setState(() {

                              latitude = latitude;

                              longitude = longitude;
                            });*/

                            //_addMarker(lat, long);

                            return GoogleMap(
                              onMapCreated: _onMapCreated,
                              myLocationButtonEnabled: false,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(lat, long),
                                //target: LatLng(9.931233, 76.267303), // kochi
                                zoom: 11.0,
                              ),
                              markers: Set<Marker>.of(marker.values),
                            );
                          }
                      }
                    },
                  )
                  /* GoogleMap(
                  onMapCreated: _onMapCreated,
                  myLocationButtonEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(latitude, longitude),
                    //target: LatLng(9.931233, 76.267303), // kochi
                    zoom: 11.0,
                  ),
                  markers: Set<Marker>.of(markers.values),
                )*/

                  ),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        // isExtended: true,
        child: Icon(Icons.navigation),
        //backgroundColor: Colors.black,
        backgroundColor: new Color(0xFF70b0c2),
        onPressed: () async {
           List latLong =  await getLatLong();
          _launchMaps(latLong[0], latLong[1],widget.healthCareName.replaceAll(" ", "+"));
        },
      ),
    );
  }

  Future<List> getLatLong() async {
    List latLong =
        await RestDatasource().getGoogleLocationFromAdress(widget.address);

    latLong.add(_addMarker(latLong[0], latLong[1]));

    return latLong;
  }

  _launchMaps(double lat, double lon, String name) async {
    print("name = $name");
    //String googleUrl = 'comgooglemaps://?q=$lat,$lon';
    String googleUrl = 'comgooglemaps://?q=$lat,$lon($name)';
    String appleUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
    if (await canLaunch("comgooglemaps://")) {
      print('launching com googleUrl');
      await launch(googleUrl);
    } else if (await canLaunch(appleUrl)) {
      print('launching apple url');
      await launch(appleUrl);
    } else {
      throw 'Could not launch url';
    }
  }
}
