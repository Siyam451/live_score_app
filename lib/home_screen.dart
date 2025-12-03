
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? _currentPosition;
late GoogleMapController  _mapController;

//for geo location
  Future<void> _handleLocationPermission(VoidCallback isSuccess)async{
    LocationPermission permissionstatus=await Geolocator.checkPermission();
    if(_PermissionGranted(permissionstatus)){
      //gps service enable
      bool isServiceEnable = await Geolocator.isLocationServiceEnabled();
      if(isServiceEnable){
        // current listen location
        isSuccess();
      } else{
        //request service
        Geolocator.openLocationSettings();

      }
    }
    else{
      //reqest location permisson
      LocationPermission permissionstatus = await Geolocator.requestPermission();
      if(_PermissionGranted(permissionstatus)){
        _getCurrentLocation();
      }
    }
  }

  Future<void> _getCurrentLocation()async{
   await _handleLocationPermission(()async{
     _currentPosition = await Geolocator.getCurrentPosition();
     print(_currentPosition);
     setState(() {});
   });
  }


  Future<void> _ListenCuurentLocation()async{
    await _handleLocationPermission(()async{
      Geolocator.getPositionStream().listen((position) {
        _currentPosition = position;
        setState(() {});
      });
    });

  }

  bool _PermissionGranted(LocationPermission permissionStatus){
    return permissionStatus == LocationPermission.always ||
    permissionStatus == LocationPermission.whileInUse;

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Real-Time Location Tracker'),
      ),
      body:GoogleMap(
          mapType: MapType.normal,//kon type er dekhabe view ta
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
    },


markers: <Marker>{
  Marker(
      markerId: MarkerId('My Location'),
      position: LatLng(22.284483918274677, 91.78442303091288),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(
          title: 'My Previous Loaction'
      ),
      onTap: (){
        print('Tapped on my Previous Location');
      }
  ),
  Marker(
      markerId: MarkerId('My Location'),
      position: LatLng(22.288500475350244, 91.78343363106251),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(
          title: 'My Current Loaction',
          snippet: '$_currentPosition'
      ),
      onTap: (){
        print('Tapped on my current Location');
      }
  )
},
        polylines: <Polyline>{
            Polyline(
              polylineId: PolylineId('Current to previous location'),
              points: [
                LatLng(22.284950044663685, 91.78421762442431),
                LatLng(22.288500475350244, 91.78343363106251),
              ],
              color: Colors.purple,
              width: 5,
              startCap: Cap.roundCap,
              endCap: Cap.roundCap,
              onTap: (){
                print('tapped on my polyline');
              },
              consumeTapEvents: true,
            ),
        }

      ),
      floatingActionButton:
     Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FloatingActionButton(onPressed: (){
              _mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                      CameraPosition(target: LatLng(22.284483918274677, 91.78442303091288),
                      zoom: 16,
                      )));
              },
              child: Icon(Icons.location_on_outlined),
            ),
        
            Expanded(
              child: TextButton.icon(onPressed: (){
                _getCurrentLocation();
                //snackbar for notification
                if (_currentPosition != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Lat: ${_currentPosition!.latitude}, "
                            "Long: ${_currentPosition!.longitude}",
                      ),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              }, icon: Icon(Icons.home,color: Colors.red,size: 20,),
              label: Text('Current Location'),),
            ),
        
            Expanded(
              child: TextButton.icon(onPressed: (){
                _ListenCuurentLocation();
                //snackbar e msg show korbe
                if (_currentPosition != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Lat: ${_currentPosition!.latitude}, "
                            "Long: ${_currentPosition!.longitude}",),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              }, icon:  Icon(Icons.location_city,color: Colors.purple,size: 20,),
                label: Text('Listen current Location'),

              ),
            )
        
        
          ],
        ),



    );

  }
}
