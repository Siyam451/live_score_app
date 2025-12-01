import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GeoHomeScreen extends StatefulWidget {
  const GeoHomeScreen({super.key});

  @override
  State<GeoHomeScreen> createState() => _GeoHomeScreenState();
}

class _GeoHomeScreenState extends State<GeoHomeScreen> {
  Position? _currentPoision;
   Future<void> _getcurrentlocation() async{
    //access permission given or not
    LocationPermission permissionstatus = await Geolocator.checkPermission();
    if(_ispermissionGranted(permissionstatus)) {
      //GPS service enable or not
      bool isServiceEnable = await Geolocator.isLocationServiceEnabled();
      if (isServiceEnable) {
        //get current location
        _currentPoision = await Geolocator.getCurrentPosition();
        print(_currentPoision);
        setState(() {

        });
      } else {
        // reqest service
        Geolocator.openLocationSettings();
      }
    }
    else{
      //request location permission
      LocationPermission permissionstatus = await Geolocator.requestPermission();
      if(_ispermissionGranted(permissionstatus)){
        //call this method again
        _getcurrentlocation();

      }
    }
  }
  //use to see real time change ..mae user kkhn koi jacce tao dekte parbo
   Future<void> _Listencurrentlocation()async{
    //access given or not
    LocationPermission permissionstatus=await Geolocator.checkPermission();
    if(_ispermissionGranted(permissionstatus)){
      //gps service enable
      bool isServiceEnable = await Geolocator.isLocationServiceEnabled();
      if(isServiceEnable){
        // current listen location
        Geolocator.getPositionStream().listen((position){
          _currentPoision = position;
          setState(() {

          });
        });
      } else{
        //request service
        Geolocator.openLocationSettings();

      }
    }
    else{
      //reqest location permisson
      LocationPermission permissionstatus = await Geolocator.requestPermission();
      if(_ispermissionGranted(permissionstatus)){
        _getcurrentlocation();
      }
    }

  }



  bool _ispermissionGranted(LocationPermission permissionstatus){
    return permissionstatus == LocationPermission.always ||
        permissionstatus == LocationPermission.whileInUse;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gps Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Current Location :$_currentPoision'),

            TextButton(onPressed: (){
              _getcurrentlocation();
            }, child: Text('Current location:')),

            TextButton(onPressed: (){
              _Listencurrentlocation();
            }, child: Text(' Listen Current location:'))
          ],
        ),
      ),
    );
  }
}
