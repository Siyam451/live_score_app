import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController _mapController;
  //custom vabe map e ekta marker set kora
  Set<Marker>_marker = <Marker>{
    Marker(
      markerId: MarkerId("Office"),//jaiga tar name
      position: LatLng(22.284950044663685, 91.78421762442431),//kon kane dewa hbe marker ta
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),//marker er colour
      onTap: (){
        print('Tapped on my office');
      }

    ),
    Marker(
        markerId: MarkerId("Home"),//jaiga tar name
        position: LatLng(22.286607926034325, 91.78315546973),//kon kane dewa hbe marker ta
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),//marker er colour
        onTap: (){
          print('Tapped on my Home');
        }

    ),


  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home screen'),
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

    markers: _marker,
        circles: <Circle>{
            Circle(
              circleId: CircleId('Home Circle'),
              center: LatLng(22.286607926034325, 91.78315546973),
              radius: 120,
              strokeColor: Colors.pink,
              strokeWidth: 3,
              fillColor: Colors.pink.withOpacity(0.1),
              visible: true,//aita dite hbe
              onTap: (){
                print('Tapped on my home circle');
              },
              consumeTapEvents: true,
            ),

          Circle(
            circleId: CircleId('Office Circle'),
            center: LatLng(22.284950044663685, 91.78421762442431),
            radius: 120,
            strokeColor: Colors.red,
            strokeWidth:
            3,
            fillColor: Colors.red.withOpacity(0.1),
            visible: true,
            onTap: (){
              print('my office circle');
            },
            consumeTapEvents: true,
          )
        },
          //line create kore
        polylines: <Polyline>{
            Polyline(
            polylineId: PolylineId('Home to office line'),
              points: [
                LatLng(22.286607926034325, 91.78315546973),
                LatLng(22.284950044663685, 91.78421762442431),
              ],
              color: Colors.purple,
              width: 5,
              startCap: Cap.roundCap,//round shape korbe line
              endCap: Cap.roundCap,
              onTap: (){
              print('tapped on my line');
              },
              consumeTapEvents: true,
            )
      },
      polygons: <Polygon>{
            Polygon(
            polygonId: PolygonId('random polygone'),
              points: [
                LatLng(22.287223888465967, 91.78054992109537),
                LatLng(22.282292710082427, 91.78323414176702),
                LatLng(22.287050780525462, 91.78582079708576),

              ],
              fillColor: Colors.red.withOpacity(0.1),
              strokeWidth: 2,
              strokeColor: Colors.red,

            )
      }
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(onPressed: (){
            _mapController.animateCamera(
              CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(22.284950044663685, 91.78421762442431),
                  zoom: 16,
                  ))
            );
          },child: Icon(Icons.factory),),
          //button e click korle map er jeikane amra thaki na keno aita amder k jeitar Latlan disi aita te ni jabe ga
          FloatingActionButton(onPressed: (){
            _mapController.animateCamera(//animation hbe sundor ekta
                CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: LatLng(22.286607926034325, 91.78315546973),
                    zoom: 16,)));
          },child: Icon(Icons.home),),
        ],
      ),
    );

  }
}
