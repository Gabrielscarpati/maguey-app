import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../provider/dashboard_provider.dart';

class LoadMap extends StatelessWidget {
  const LoadMap({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position>(
      future: _fetchLocation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        if (snapshot.hasData) {
          return MapPage(
            latitude: snapshot.data?.latitude ?? 33.99788550112016,
            longitude: snapshot.data?.longitude ?? -118.2565948739648,
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

Future<bool> _requestPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return false;
    }
  }
  return permission == LocationPermission.whileInUse || permission == LocationPermission.always;
}

Future<Position> _getCurrentLocation() async {
  if (await _requestPermission()) {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }
  throw Exception('Location permission not granted');
}

Future<Position> _fetchLocation() async {
  try {
    Position position = await _getCurrentLocation();
    return position;
  } catch (e) {
    throw Exception('Unable to fetch location: $e');
  }
}

class MapPage extends StatefulWidget {
  final double latitude;
  final double longitude;
  const MapPage({super.key, required this.latitude, required this.longitude});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late DashboardProvider dashboardProvider;
  late ShopEventEntity currentShopEvent;

  @override
  void initState() {
    super.initState();

    dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);
    populateListMarkersList();
  }

  Set<Marker> markers = {};
  void populateListMarkersList() {
    if (dashboardProvider.shopEventList.isEmpty) return;
    List<ShopEventEntity> shopEventList = dashboardProvider.shopEventList;
    currentShopEvent = shopEventList[0];
    for (int i = 0; i < shopEventList.length; i++) {
      ShopEventEntity shopEvent = shopEventList[i];
      markers.add(Marker(
          markerId: MarkerId('${shopEvent.latitude}-${shopEvent.longitude}_$i'),
          position: LatLng(shopEvent.latitude!, shopEvent.longitude!),
          onTap: () {
            currentShopEvent = shopEvent;
          }));
    }
  }

  final Duration animationDuration = const Duration(milliseconds: 500);
  final Curve curve = Curves.fastEaseInToSlowEaseOut;

  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    LatLng currentLocation = LatLng(widget.latitude, widget.longitude);
    double _latitude = currentLocation.latitude;
    double _longitude = currentLocation.longitude;
    return Stack(
      children: [
        Scaffold(
          body: GoogleMap(
            zoomControlsEnabled: false,
            onMapCreated: _controller.complete,
            initialCameraPosition: CameraPosition(
              target: currentLocation,
              zoom: 12.0,
            ),
            mapType: MapType.hybrid,
            markers: markers,
            onCameraMove: (CameraPosition position) {
              setState(() {
                currentLocation = position.target;
                _latitude = currentLocation.latitude;
                _longitude = currentLocation.longitude;
              });
            },
          ),
        ),
        if (currentShopEvent != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      height: 88,
                      width: 88,
                      decoration: currentShopEvent.imageUrl == ''
                          ? const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            )
                          : BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(currentShopEvent.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 130,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentShopEvent.type.toUpperCase(),
                            style: const TextStyle(
                              color: Color(0xFFFB5944),
                              fontSize: 13,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            currentShopEvent.name,
                            style: const TextStyle(
                              color: Color(0xFF908C00),
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          if (currentShopEvent.type == 'event')
                            Text(
                              DateFormat('MMMM dd yyyy').format(currentShopEvent.createDate!),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          Text(
                            currentShopEvent.address,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
