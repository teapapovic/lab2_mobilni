import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jokes/services/api_services.dart';

class MyHomePage extends StatefulWidget {
  final String navBarTitle;

  const MyHomePage({super.key, required this.navBarTitle});

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> jokeTypes = [];

  @override
  void initState() {
    super.initState();
    getJokeTypesAPI();
  }

  void getJokeTypesAPI() async {
    ApiService.getJokeTypesFromAPI().then((response) {
      var data = json.decode(response.body) as List<dynamic>;
      setState(() {
        jokeTypes = data.cast<String>();
      });
    }).catchError((error) {
      print('Error fetching joke types: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Explore Jokes",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 8,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.yellow],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.orange],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: jokeTypes.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
          padding: const EdgeInsets.all(15.0),
          itemCount: jokeTypes.length,
          itemBuilder: (context, index) {
            String jokeType = jokeTypes[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/details',
                  arguments: jokeType,
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 8,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade200, Colors.yellow],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ListTile(
                    leading: Text(
                      "😂",
                      style: TextStyle(
                        fontSize: 28,
                      ),
                    ),
                    title: Text(
                      jokeType,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      "Get your dose of $jokeType jokes!",
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
