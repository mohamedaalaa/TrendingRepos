// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home:MyApp()));
}

class MyApp extends StatefulWidget {
  //const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  List listOfFaoct;
  Map ownersMAp;
  Future _getData() async{
    var url="https://api.github.com/search/repositories?q=created:%3E2017-10-22&sort=stars&order=desc";
    var response=  await http.get(Uri.parse(url));
    var resbonsBody=jsonDecode(response.body);
    listOfFaoct=resbonsBody['items'];
    return listOfFaoct;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Trending Repos",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            centerTitle: true,
          ),
        body: FutureBuilder(future: _getData(),builder: (BuildContext context,AsyncSnapshot snapshot) {
          if (snapshot.hasData) {

            return ListView.builder(
              itemCount: snapshot.data.length, itemBuilder: (context, index) {
                return SizedBox(
                  height: 170,
                  child: Card(
                    child: Container(padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                        Text(snapshot.data[index]["name"],style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.black),),
                        Padding(
                          padding: const EdgeInsets.only(top:15),
                          child: Text(snapshot.data[index]["description"]??'description is not available',style: TextStyle(fontWeight: FontWeight.normal,color: Colors.black),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:<Widget>[

                              Text(snapshot.data[index]["name"],style: TextStyle(fontWeight: FontWeight.normal,color: Colors.black)),
                              Row(children:<Widget>[
                                Icon(Icons.star),
                                Text(snapshot.data[index]["watchers"].toString()),
                              ],)
                          ],),
                        )
                      ],),
                    ),
                  )
                );
            },);
          }
          return CircularProgressIndicator();
        })
    )
    );
  }
}
