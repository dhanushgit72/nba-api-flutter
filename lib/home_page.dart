import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nba_app/models/team.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  List<Team> teams = [];
  Future getTeams() async{
    var url=Uri.https("api.balldontlie.io","/v1/teams");
    var response=await http.get(url,headers: {
      "Authorization": "8a4cee95-63a6-48d8-817d-e228bf5a89c0"
    });
    var jsonData=jsonDecode(response.body);
    for (var eachTeam in jsonData['data']) {
      final team = Team(
        abbreviation: eachTeam['abbreviation'],
        city: eachTeam['city'],
      );
      teams.add(team);
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NBA Teams",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
        backgroundColor: CupertinoColors.activeBlue,
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: getTeams(),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.done){
            return ListView.builder(
                itemCount: teams.length,
                itemBuilder: (context,index){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                    decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                  title: Text(teams[index].abbreviation),
                  subtitle: Text(teams[index].city),
                  )
                  ));
                }
            );
          }else{
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
