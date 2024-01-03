import 'dart:convert';
import 'package:http/http.dart' as httpClient;
import 'package:flutter/material.dart';
import 'package:wallpaper_app/wallpapermodel.dart';

class WallpaperApp extends StatefulWidget {
  const WallpaperApp({super.key});

  @override
  State<WallpaperApp> createState() => _WallpaperAppState();
}

class _WallpaperAppState extends State<WallpaperApp> {
  var mykey = "Qqzuq9h6sffSXTcQfE1RWPwLcsfQTxnEe9ZmwqxgXKoDYxPxvHNYGE2y";
  TextEditingController searchController = TextEditingController();
  late Future<WallpaperModel> wallpaper;

  @override
  void initState() {
    super.initState();
    wallpaper = getWallpaper('Lion');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wallpaper App"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          FutureBuilder<WallpaperModel>(
              future: wallpaper,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: snapshot.data!.photos!
                              .map(
                                (photoData) => Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      start: 20, end: 4),
                                  child: Card(
                                    elevation: 20,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Container(
                                        clipBehavior: Clip.antiAlias,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.3,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Image.network(
                                            '${photoData.src!.portrait}',
                                            fit: BoxFit.fill)),
                                  ),
                                ),
                              )
                              .toList()));
                } else if (snapshot.hasError) {
                  print('Error${snapshot.hasError}');
                }
                return CircularProgressIndicator();
              }),
        ],
      ),
    );
  }

  Future<WallpaperModel> getWallpaper(String mysearch) async {
    var myURL = "https://api.pexels.com/v1/search?query=$mysearch";
    var response = await httpClient
        .get(Uri.parse(myURL), headers: {'Authorization': mykey});
    if (response.statusCode == 200) {
      var wallpapers = jsonDecode(response.body);
      return WallpaperModel.fromJson(wallpapers);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext Context) {
            return AlertDialog(
              title: Text('Cant Fetch The API${response.statusCode}'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Ok'))
              ],
            );
          });
      return WallpaperModel();
    }
  }
}
