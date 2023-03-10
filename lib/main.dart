import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<void> postData() async {
    String username = 'pms_user';
    String password = 'pmsuser';
    // Encode the username and password using base64
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    HttpClient client = HttpClient();
    //certification disabled
    client.badCertificateCallback =
    ((X509Certificate cert, String host, int port) => true);
    var url = Uri.parse('https://18.222.19.76/accuapiSqm/Sync-API/index.php/datalayer/magiclight');

    String data = jsonEncode(<String, dynamic>{
      'username': 'value1',
      'password': 'value2',
    });
    var request = await client.postUrl(url);
    request.headers.set('content-type', 'application/json');
    request.headers.set('authorization', basicAuth);
    request.write(data);
    var response = await request.close();

    // Check the response status code to see if the request was successful
    if (response.statusCode == 201) {
      var responseBody = await response.transform(utf8.decoder).join();
      print(responseBody);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: postData,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
