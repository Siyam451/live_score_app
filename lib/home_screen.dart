import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController _mapController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home screen'),
      ),
      body:GoogleMap(
          mapType: MapType.hybrid,//kon type er dekhabe view ta
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: true,
          zoomGesturesEnabled: true, // zoom button diye korar tar kaj
          trafficEnabled: true,//traffic ase naki dekhabe
          //screen e tap korle dekhabe
          onTap: (LatLng latlng){
            print('tapped on : $latlng');
          },
          //screen e long press korle dekhabe
          onLongPress: (LatLng latlng){
            print('long pressed on: $latlng');
          },
          initialCameraPosition: CameraPosition(
            zoom: 16,// koto tuko theke dekhabe ta
          target: LatLng(22.284950044663685, 91.78421762442431),//camera initial vabe kon jaiga theke dekhano shuru korbe ta

      ),
      onMapCreated: (GoogleMapController controller){
            _mapController = controller;
    }
      )
    );
  }
}
