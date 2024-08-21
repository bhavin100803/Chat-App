import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetUserPosition extends StatefulWidget {
  const GetUserPosition({super.key});

  @override
  State<GetUserPosition> createState() => _GetUserPositionState();
}

class _GetUserPositionState extends State<GetUserPosition> {

  final Completer<GoogleMapController> _controller = Completer();

  static const  CameraPosition _initialPosition = CameraPosition(target: LatLng(double.maxFinite, double.infinity),zoom: 14);

  final List<Marker> myMarker = [];
  final List<Marker> markerList = const [
    Marker(markerId: MarkerId("first"),
    position: LatLng(double.maxFinite, double.infinity),
        infoWindow: InfoWindow(
          title: "my home"
        )
    )
  ];

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   myMarker.addAll(markerList);
  //   packData();
  // }

  // Future<Position> getUserLocation() async{
  //   await Geolocator.requestPermission().then((value){
  //
  //   }).onError((error , stackTrace){print("error$error");});
  //
  //   return await Geolocator.getCurrentPosition();
  // }
  //
  //  packData(){
  //   getUserLocation().then((value)async{
  // print("may location");
  // print('${value.latitude} ${value.longitude}');
  //
  // myMarker.add(
  //   Marker(markerId: const MarkerId('second'),
  //   position: LatLng(value.latitude , value.longitude),
  //     infoWindow: const InfoWindow(
  //       title: 'my location'
  //     )
  //   )
  // );
  // CameraPosition cameraPosition = CameraPosition(target: LatLng(value.latitude , value.longitude),zoom: 14 );
  //
  // final GoogleMapController controller = await _controller.future;
  //
  // controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  // setState(() {
  //
  // });
  //   });
  //  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _initialPosition,
          mapType: MapType.normal,
          markers:  Set<Marker>.of(markerList),
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){

      },child: Icon(Icons.radio_button_off),),
    );
  }
}
