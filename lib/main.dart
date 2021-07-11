import 'dart:math';

import 'package:f1_drivers/model/driver.dart';
import 'package:f1_drivers/utils/f1_scroll_physics.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.black,
        fontFamily: 'PTMono',
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

const String kAllChars = 'abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController _scrollController = ScrollController();

  int driverNumber = 0;
  String firstName = '';
  String lastName = '';
  String team = '';
  double pageFraction = 0.0;

  @override
  void initState() {
    super.initState();

    driverNumber = drivers[0].driverNumber;
    team = drivers[0].team;
    firstName = drivers[0].firstName;
    lastName = drivers[0].lastName;

    _scrollController.addListener(() {
      setState(() {
        pageFraction = _scrollController.offset / (MediaQuery.of(context).size.width * 2);

        driverNumber = _calculateDriverNumber(pageFraction);
        firstName = _calculateCharacters(pageFraction, StringType.firstName);
        lastName = _calculateCharacters(pageFraction, StringType.lastName);
        team = _calculateCharacters(pageFraction, StringType.team);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox(
          width: MediaQuery.of(context).size.width * 2,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              ListView.builder(
                  controller: _scrollController,
                  physics: const F1ScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: drivers.length,
                  itemBuilder: (context, position) {
                    return _getImage(position);
                  }),
              _getInfo()
            ],
          ),
        ));
  }

  Widget _getInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                  width: 30,
                  child: Text(
                    driverNumber.toString(),
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  )),
              const SizedBox(width: 16),
              Image.asset(
                'assets/${drivers[pageFraction.round() < drivers.length ? pageFraction.round() : drivers.length - 1].nationality}.png',
                height: 32,
                width: 32,
              )
            ],
          ),
          Text(
            firstName,
            style: const TextStyle(fontSize: 32, color: Colors.white),
          ),
          Text(
            lastName,
            style: const TextStyle(fontSize: 32, color: Colors.white),
          ),
          Text(
            team,
            style: const TextStyle(fontSize: 20, color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _getImage(int position) {
    return Image.asset(
      'assets/${drivers[position].image}.jpg',
      width: MediaQuery.of(context).size.width * 2,
      fit: BoxFit.cover,
    );
  }

  int _calculateDriverNumber(double pageFraction) {
    final floor = pageFraction.floor();
    final ceil = pageFraction.ceil();
    final lastIndex = floor < drivers.length ? floor : drivers.length - 1;
    final nextIndex = ceil < drivers.length ? ceil : drivers.length - 1;

    final lastDriverNumber = drivers[lastIndex].driverNumber;
    final nextDriverNumber = drivers[nextIndex].driverNumber;

    final currentFraction = pageFraction % 1;
    final current = lastDriverNumber - ((lastDriverNumber - nextDriverNumber) * currentFraction).round();

    return current;
  }

  String _calculateCharacters(double pageFraction, StringType stringType) {
    var last = '';
    var next = '';

    final floor = pageFraction.floor();
    final ceil = pageFraction.ceil();
    final lastIndex = floor < drivers.length ? floor : drivers.length - 1;
    final nextIndex = ceil < drivers.length ? ceil : drivers.length - 1;
    switch (stringType) {
      case StringType.firstName:
        {
          last = drivers[lastIndex].firstName;
          next = drivers[nextIndex].firstName;
          break;
        }
      case StringType.lastName:
        {
          last = drivers[lastIndex].lastName;
          next = drivers[nextIndex].lastName;
          break;
        }
      default:
        {
          last = drivers[lastIndex].team;
          next = drivers[nextIndex].team;
          break;
        }
    }

    final longestTeam = max(last.length, next.length);

    var currentTeam = '';

    for (var i = 0; i < longestTeam; i++) {
      var lastTeamChar = ' ';
      var nextTeamChar = ' ';

      lastTeamChar = i < last.length ? last[i] : ' ';
      nextTeamChar = i < next.length ? next[i] : ' ';

      final lastIndex = kAllChars.indexOf(lastTeamChar);
      final nextIndex = kAllChars.indexOf(nextTeamChar);

      final currentFraction = pageFraction % 1;

      final currentIndex = lastIndex - ((lastIndex - nextIndex) * currentFraction).round();

      currentTeam = currentTeam + kAllChars[currentIndex];
    }

    return currentTeam;
  }
}
