import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key, required this.mapKey}) : super(key: key);
  final String mapKey;
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  CameraPosition? _cameraPosition;
  GoogleMapController? _controller;

  @override
  void initState() {
    // TODO: implement initState
    // getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: const CameraPosition(
              target: LatLng(22.746944, 75.898016),
              zoom: 15,
            ),
            zoomControlsEnabled: false,
            compassEnabled: false,
            indoorViewEnabled: true,
            mapToolbarEnabled: true,
            onCameraIdle: () {
              updatePosition(_cameraPosition);
            },
            onCameraMove: ((position) {
              _cameraPosition = position;
            }),
            // markers: Set<Marker>.of(locationProvider.markers),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
          ),
          Positioned(
            top: 40,
            left: 10,
            right: 10,
            child: InkWell(
              onTap: () => _openSearchDialog(context, _controller),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18.0),
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 23.0),
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(children: [
                  Expanded(
                      child: Text(
                          (placemarks?.length ?? 0) > 1 &&
                                  placemarks?[0].name != null
                              ? '${placemarks?[0].name}, ${placemarks?[0].subLocality}, ${placemarks?[0].locality}, ${placemarks?.first.postalCode}'
                              : '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis)),
                  InkWell(
                      onTap: () {
                        if (placemarks != null) {
                          Navigator.pop(context, [
                            _cameraPosition?.target.latitude,
                            _cameraPosition?.target.longitude,
                            searchController.text
                          ]);
                        }
                      },
                      child: Icon(
                          placemarks != null ? Icons.check : Icons.search,
                          size: 20)),
                ]),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 0,
            left: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () async {
                    getCurrentLocation();
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.blueAccent,
                      size: 35,
                    ),
                  ),
                ),
                /*SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: CustomButton(
                      buttonText: getTranslated('select_location', context),
                      onTap: () {
                        if (widget.googleMapController != null) {
                          widget.googleMapController!.moveCamera(
                              CameraUpdate.newCameraPosition(CameraPosition(
                                  target: LatLng(
                                    locationProvider.pickPosition.latitude,
                                    locationProvider.pickPosition.longitude,
                                  ),
                                  zoom: 15)));
                          locationProvider.setAddAddressData();
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),*/
              ],
            ),
          ),
          Center(
              child: Icon(
            Icons.location_on,
            color: Theme.of(context).primaryColor,
            size: 50,
          )),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor)))
              : const SizedBox()
        ],
      ),
    );
  }

  TextEditingController searchController = TextEditingController();
  List<Placemark>? placemarks;
  List<Prediction> _predictionList = [];
  Position? newLocalData;

  updatePosition(CameraPosition? position) async {
    setState(() {
      isLoading = true;
    });

    List<Placemark> placemarks2 = await placemarkFromCoordinates(
        position?.target.latitude ?? 22.7435893,
        position?.target.longitude ?? 75.8957605);

    searchController.text =
        '${placemarks2.first.name}, ${placemarks2.first.subLocality},${placemarks2.first.locality}';

    placemarks = placemarks2;

    setState(() {
      isLoading = false;
    });
  }

  ///search dialog
  void _openSearchDialog(
      BuildContext context, GoogleMapController? mapController) async {
    showDialog(context: context, builder: (context) => locationSearch());
  }

  bool isLoading = false;

  final TextEditingController searchLcontroller = TextEditingController();

  ///Dialog widget
  Widget locationSearch() {
    return Container(
      margin: const EdgeInsets.only(top: 80, left: 20, right: 20),
      alignment: Alignment.topCenter,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SizedBox(
            width: double.infinity,
            child: TypeAheadField(
              controller: searchLcontroller,
              builder: (context, controller, focusNode) {
                return TextFormField(
                  controller: controller, // note how the controller is passed
                  focusNode: focusNode,
                  textInputAction: TextInputAction.search,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.streetAddress,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Search Location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(style: BorderStyle.none, width: 0),
                    ),
                    hintStyle:
                        Theme.of(context).textTheme.displayMedium!.copyWith(
                              fontSize: 16,
                              color: Theme.of(context).disabledColor,
                            ),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                  ),
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        fontSize: 16,
                      ),
                );
              },
              // textFieldConfiguration: TextFieldConfiguration(
              //   controller: searchLcontroller,
              //   textInputAction: TextInputAction.search,
              //   autofocus: true,
              //   textCapitalization: TextCapitalization.words,
              //   keyboardType: TextInputType.streetAddress,
              //   decoration: InputDecoration(
              //     hintText: 'Search Location',
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10),
              //       borderSide:
              //           const BorderSide(style: BorderStyle.none, width: 0),
              //     ),
              //     hintStyle:
              //         Theme.of(context).textTheme.displayMedium!.copyWith(
              //               fontSize: 16,
              //               color: Theme.of(context).disabledColor,
              //             ),
              //     filled: true,
              //     fillColor: Theme.of(context).cardColor,
              //   ),
              //   style: Theme.of(context).textTheme.displayMedium!.copyWith(
              //         color: Theme.of(context).textTheme.bodyLarge!.color,
              //         fontSize: 16,
              //       ),
              // ),
              suggestionsCallback: (pattern) async {
                return searchLocation(context, pattern);
              },
              itemBuilder: (context, Prediction suggestion) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(children: [
                    const Icon(Icons.location_on),
                    Expanded(
                      child: Text(
                        suggestion.description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                              fontSize: 16,
                            ),
                      ),
                    ),
                  ]),
                );
              },
              onSelected: (Prediction suggestion) {
                setLocation(
                    suggestion.placeId, suggestion.description, context);
                Navigator.pop(context);
              },
            )),
      ),
    );
  }

  ///For search places
  Future<List<Prediction>> searchLocation(
      BuildContext context, String text) async {
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$text&key=${widget.mapKey}');

    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (text.isNotEmpty) {
      if (response.statusCode == 200) {
        _predictionList = [];
        var result = jsonDecode(response.body);

        if (result['status'] == 'OK') {
          result['predictions'].forEach((prediction) =>
              _predictionList.add(Prediction.fromJson(prediction)));
        }
      } else {
        if (context.mounted) {}
        //ApiChecker.checkApi(response);
      }
    }
    return _predictionList;
  }

  ///For Set Location through search

  void setLocation(
      String? placeID, String? address, BuildContext context) async {
    PlacesDetailsResponse detail;

    setState(() {
      isLoading = true;
    });

    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=${widget.mapKey}');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    detail = PlacesDetailsResponse.fromJson(jsonDecode(response.body));

    List<Placemark> placemarks2 = await placemarkFromCoordinates(
        detail.result.geometry!.location.lat,
        detail.result.geometry!.location.lng);

    placemarks = placemarks2;

    if (_controller != null) {
      _controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(
            detail.result.geometry!.location.lat,
            detail.result.geometry!.location.lng,
          ),
          zoom: 17)));

      setState(() {
        isLoading = false;
      });
    }
  }

  getCurrentLocation() async {
    setState(() {
      isLoading = true;
    });
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    } else if (permission == LocationPermission.deniedForever) {
      Navigator.pop(context);
      await Geolocator.openAppSettings();
    } else {
      newLocalData = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      placemarks = await placemarkFromCoordinates(
          newLocalData!.latitude, newLocalData!.longitude);

      print(
          "getcurrentlocation------${newLocalData!.latitude},${newLocalData!.longitude}");
      _controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(
            newLocalData!.latitude,
            newLocalData!.longitude,
          ),
          zoom: 17)));
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller!.dispose();
    searchController.dispose();
  }
}
