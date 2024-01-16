import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  LocationData? userLocation;
  List<Marker> _markers = [];
  Marker? _nearestHospitalMarker; // En yakın hastaneyi tutacak değişken
  final double _zoomLevel = 13.0; // Mahalleyi gösterecek zoom seviyesi

  List<String> hospitalAddresses = [];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _getUserLocation() async {
    var locationService = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationService.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationService.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await locationService.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationService.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    userLocation = await locationService.getLocation();
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(40.9799, 29.0269), // Belirli bir konumu göster
          zoom: _zoomLevel,
        ),
      ),
    );
    _getNearbyHospitals(userLocation!);
    _updateCameraPosition(userLocation!);
  }

  void _updateCameraPosition(LocationData userLocation) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(userLocation.latitude!, userLocation.longitude!),
          zoom: _zoomLevel,
        ),
      ),
    );
  }

  Future<void> _getNearbyHospitals(LocationData userLocation) async {
    var response = await http.get(Uri.parse(
        "https://data.ibb.gov.tr/tr/dataset/bd3b9489-c7d5-4ff3-897c-8667f57c70bb/resource/6800ea2d-371b-4b90-9cf1-994a467145fd/download/salk-kurum-ve-kurulularna-ait-bilgiler.json"));
    if (response.statusCode == 200) {
      var decodedData = utf8.decode(response.bodyBytes);
      List<dynamic> data = json.decode(decodedData);

      double nearestDistance = double.infinity;

      for (var item in data) {
        double lat = double.parse(item['ENLEM'].toString());
        double lng = double.parse(item['BOYLAM'].toString());
        double distance = _calculateDistance(
          userLocation.latitude!,
          userLocation.longitude!,
          lat,
          lng,
        );

        if (distance < nearestDistance) {
          nearestDistance = distance;
          _nearestHospitalMarker = Marker(
            markerId: MarkerId(item['ADI']),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(
              title: item['ADI'],
              snippet: "Mesafe: ${distance.toStringAsFixed(2)} km",
            ),
          );

          setState(() {
            _markers.add(_nearestHospitalMarker!);
            hospitalAddresses.add(item['ADRES']);
          });
        }
      }
    } else {
      print("Hastane bilgileri alınamadı: ${response.statusCode}");
    }
  }

  Future<void> _launchMapsUrl() async {
    if (_nearestHospitalMarker != null) {
      final url =
          'https://www.google.com/maps/dir/?api=1&origin=${userLocation!.latitude},${userLocation!.longitude}&destination=${_nearestHospitalMarker!.position.latitude},${_nearestHospitalMarker!.position.longitude}&travelmode=driving';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Harita başlatılamadı $url';
      }
    }
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    var earthRadius = 6371; // Dünya'nın yarıçapı kilometre cinsinden
    var dLat = _toRadians(lat2 - lat1);
    var dLon = _toRadians(lon2 - lon1);
    lat1 = _toRadians(lat1);
    lat2 = _toRadians(lat2);

    var a = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  int _getRandomDolulukOrani() {
    // Rasgele bir doluluk oranı oluşturmak için 0 ile 100 arasında bir sayı döndürür.
    return Random().nextInt(101);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("En Yakın Hastane"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _HospitalSearchDelegate(hospitalAddresses),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(40.9798,
                  29.0205), // Beşiktaş/Istanbul bölgesi // İlk başlangıç için varsayılan konum
              zoom: 15.0,
            ),
            markers: Set<Marker>.of(_markers),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _nearestHospitalMarker != null
                      ? () => _launchMapsUrl()
                      : null,
                  child: const Text('En Yakın Hastaneyi Bul'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Butonun arkaplan rengi
                    onPrimary: Colors.white, // Butonun yazı rengi
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                    // Buton padding'i
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "En Yakın Hastane:",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  _nearestHospitalMarker == null
                      ? "-"
                      : _nearestHospitalMarker!.infoWindow.title!,
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "Doluluk Oranı: ${_getRandomDolulukOrani()}%",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hastane Adresi:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          _nearestHospitalMarker == null
                              ? "-"
                              : _nearestHospitalMarker!.infoWindow.snippet ??
                                  "Bilgi bulunamadı",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      width:
                          20), // İki alan arasında bir boşluk ekleyebilirsiniz
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Doluluk Bilgisi:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Doluluk Oranı: ${_getRandomDolulukOrani()}%",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HospitalSearchDelegate extends SearchDelegate<String> {
  final List<String> hospitalAddresses;

  _HospitalSearchDelegate(this.hospitalAddresses);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final filteredList = hospitalAddresses
        .where((address) => address.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final address = filteredList[index];
        return ListTile(
          title: Text(address),
          onTap: () {
            // Burada hastane adresine tıklandığında ne yapılacağını belirleyebilirsiniz.
            // Örneğin, haritada bu hastanenin konumunu gösterebilirsiniz.
            close(context, address);
          },
        );
      },
    );
  }
}
