import 'package:flutter/material.dart';

const cities = [
  'Silverstone, UK',
  'Sao Paulo, Brazil',
  'Melbourne, Australia',
  'Monte Carlo, Monaco'
];

class ConcertsPage extends StatelessWidget {
  const ConcertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Concerts List'),
        centerTitle: false,
        backgroundColor: Colors.lightBlue.shade200,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.lightBlue.shade200, Colors.blue.shade800]),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: cities.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.lightBlue.shade50,
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.sunny),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(cities[index]),
                  )
                ]
              )
            );
          }
        ),
      ),
    );
  }
}
