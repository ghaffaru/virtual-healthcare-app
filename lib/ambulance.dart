//import 'package:flutter/material.dart';
//import 'package:map_view/map_view.dart';
//import 'package:http/http.dart' as http;
//import 'dart:convert';
//
//class Ambulance extends StatefulWidget {
//  @override
//  _AmbulanceState createState() => _AmbulanceState();
//}
//
//class _AmbulanceState extends State<Ambulance> {
//  final FocusNode _addressInputFocusNode = FocusNode();
//  Uri _staticMapUri;
//  final TextEditingController _addressInputController = TextEditingController();
//
//  @override
//  void initState() {
//    _addressInputFocusNode.addListener(_updateLocation);
////    getStaticMap();
//    super.initState();
//  }
//
//  void _updateLocation() {
//    if (!_addressInputFocusNode.hasFocus) {
//      getStaticMap(_addressInputController.text);
//    }
//  }
//
//  @override
//  void dispose() {
//    _addressInputFocusNode.removeListener(_updateLocation);
//    super.dispose();
//  }
//
//  void getStaticMap(String address) async {
//    if (address.isEmpty) {
//      setState(() {
//        _staticMapUri = null;
//      });
//      return;
//    }
//    final Uri uri = Uri.https('maps.googleapis.com', '/maps/api/geocode/json',
//        {'address': address, 'key': 'AIzaSyAhcJZADKIAEThe8qWVQn6S2f9nBvfF-qo'});
//
//    final http.Response response = await http.get(uri);
//
//    final decodedResponse = json.decode(response.body);
//    final formattedResponse =
//        decodedResponse['results'][0]['formatted_address'];
//
//    final coords = decodedResponse['results'][0]['geometry']['location'];
//
//    final StaticMapProvider staticMapProvider =
//        StaticMapProvider('AIzaSyAhcJZADKIAEThe8qWVQn6S2f9nBvfF-qo');
//
//    final Uri staticMapUri = staticMapProvider.getStaticUriWithMarkers(
//        [Marker('position', 'Position', coords['lat'], coords['lng'])],
//        center: Location(coords['lat'], coords['lng']),
//        width: 500,
//        height: 300,
//        maptype: StaticMapViewType.roadmap);
//
//    setState(() {
//      _addressInputController.text = formattedResponse;
//      _staticMapUri = staticMapUri;
//    });
//
//    print(_staticMapUri);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Emergency'),
//      ),
//      body: Column(
//        children: <Widget>[
//          SizedBox(
//            height: 10,
//          ),
//          TextField(
////          onChanged: ,
//            focusNode: _addressInputFocusNode,
//            controller: _addressInputController,
//            decoration: InputDecoration(labelText: 'Your Address'),
////            onSubmitted: ,
//          ),
//          SizedBox(height: 10),
//          Image.network(_staticMapUri.toString())
//        ],
//      ),
//    );
//  }
//}
