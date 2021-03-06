import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:waktu_sholat/logo.dart';
import 'package:shimmer/shimmer.dart';
import 'package:simplehttpconnection/simplehttpconnection.dart';

const String serverAPI = "http://api.aladhan.com/";

void main() {
  return runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Waktu Sholat",

    home: Main(),
  ));
}

class Main extends StatefulWidget {
  @override
  MainState createState() => MainState();
}

class MainState extends State<Main> {
  JadwalSholat selected;
  Map<String, dynamic> data = {};
  bool error = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      backgroundColor: Colors.black,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: customFloatButton(context),
      body: Container(

        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,

        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/kabah.jpg"), fit: BoxFit.cover)),
        child: Stack(
          children: <Widget>[
            //blurBackground(),
            SafeArea(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  selected == null
                      ? Container()
                      : !error ? detailJadwal() : Container(),
                  data.length == 0
                      ? !error ? listShimmer() : errorNotValid()
                      : !error ? listviewData() : errorNotValid(),
                  SizedBox(
                    height: 80.0,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // detail jadwal
  Widget detailJadwal() {
    return Container(
      height: 150.0,
      color: Colors.black.withOpacity(.2),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 50.0,
            width: 50.0,
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              child: selected.icon,
            ),
          ),
          Text(
            selected.waktu,
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 25.0),
          ),
          Text(selected.judul,
              style: TextStyle(color: Colors.white, fontSize: 20.0)),
          Text(
            selected.tanggal,
            style: TextStyle(color: Colors.white, fontSize: 15.0),
          ),
        ],
      ),
    );
  }
//shimmer data
  Widget listShimmer() {
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(vertical: 5.0),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.withOpacity(.1),
          highlightColor: Colors.white.withOpacity(.3),
          child: ListTile(
            title: shimmerObject(
                width: 100.0, height: 20.0, radius: BorderRadius.circular(3.0)),
            leading: shimmerObject(
                width: 40.0, height: 40.0, radius: BorderRadius.circular(50.0)),
            trailing: shimmerObject(
                width: 50.0, height: 20.0, radius: BorderRadius.circular(3.0)),
          ),
        );
      },
      itemCount: 9,
    );
  }

  Widget errorNotValid() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Text(
        "Sepertinya terjadi sesuatu, Response tidak valid",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 18.0),
      ),
    );
  }

  Widget listviewData() {
    return ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(vertical: 5.0),
      itemBuilder: (context, index) {
        Map<String, dynamic> dataWaktu = data["data"]["timings"];
        Icon logo ;
        switch (dataWaktu.keys.toList()[index].toLowerCase()) {
          case "fajr":
            logo = Icon(Icons.timer);
            break;
          case "sunrise":
            logo = Icon(Icons.timer);
            break;
          case "dhuhr":
            logo = Icon(Icons.timer);
            break;
          case "asr":
            logo = Icon(Icons.timer);
            break;
          case "sunset":
            logo = Icon(Icons.timer);
            break;
          case "maghrib":
            logo = Icon(Icons.timer);
            break;
          case "isha":
            logo = Icon(Icons.timer);
            break;
          case "imsak":
            logo = Icon(Icons.timer);
            break;
          case "midnight":
            logo = Icon(Icons.timer);
            break;
          default:
            logo = Icon(Icons.timer);

            break;
        }
        //Biar ada ripple effectnya
        return Material(
          color: Colors.transparent,
          child: ListTile(
            onTap: () {
              setState(() {
                selected = JadwalSholat(
                    logo,
                    dataWaktu.keys.toList()[index],
                    dataWaktu.values.toList()[index],
                    data["data"]["date"]["readable"]);
              });
            },
            leading: CircleAvatar(
              child: logo,
              backgroundColor: Colors.blue,
            ),
            title: Text(
              dataWaktu.keys.toList()[index],
              style: TextStyle(color: Colors.white),
            ),
            trailing: Text(
              dataWaktu.values.toList()[index],
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: 20.0),
            ),
          ),
        );
      },
      itemCount: data["data"]["timings"].length,
    );
  }

  Widget blurBackground({Widget child, double sigmaX, double sigmaY}) {
    return BackdropFilter(
    //  filter: ImageFilter.blur(sigmaX: sigmaX ?? 4, sigmaY: sigmaY ?? 4),
      child: child ??
          Container(
            color: Colors.black.withOpacity(.5),
          ),
    );
  }

  Widget customFloatButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 40,
      height: 50.0,
      child: FlatButton(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        color: Colors.blue,
        child: Text(
          "Refresh Data",
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        onPressed: () {
          initPosition();
          setState(() {});
        },
      ),
    );
  }

  Widget shimmerObject(
      {BorderRadius radius,
        double width,
        double height,
        EdgeInsetsGeometry margin}) {
    return Container(
      margin: margin ?? EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: radius ?? BorderRadius.circular(.3)),
      height: height,
      width: width,
    );
  }

  @override
  void initState() {
    super.initState();
    initPosition();
  }


  //Disini bagian backend =========================================================
  void reset() {
    setState(() {
      data = {};
      error = false;
      selected = null;
    });
  }

  Future initPosition() async {
    reset();
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    await getJadwalSholat(position.latitude, position.longitude);
    setState(() {});
  }

  //get data time dengan fetch api
  Future<Map<String, dynamic>> getJadwalSholat(double lat, double lng) async {
    if (lat == null || lng == null) return null;
    Map<String, String> paramsJadwal = {
      "latitude": lat.toString(),
      "longitude": lng.toString(),
      "method": "1"
    };
    ResponseHttp resp = await HttpConnection.doConnection(
        serverAPI +
            "timings/" +
            DateTime.now().microsecondsSinceEpoch.toString().substring(0, 10),
        method: Method.get,
        body: paramsJadwal);
    data = resp.content.asJson();
    if (data["code"] != 200) error = true;
    return resp.content.asJson();
  }
}

class JadwalSholat {
  final Icon icon;
  final String judul, waktu, tanggal;

  JadwalSholat(this.icon, this.judul, this.waktu, this.tanggal);
}
