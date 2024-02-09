import 'package:flutter/material.dart';
import 'package:pmsn2024/screens/splash_screen.dart';

void main() => runApp( MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

/*class MyApp extends StatefulWidget {
   MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int contador = 0;

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Práctica 1', 
            style: TextStyle(
              fontSize: 30, 
              fontWeight: FontWeight.bold),
            ),
        ),
        drawer: Drawer(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: (){
            contador++;
            print(contador);
            setState(() {});
          },
          child: Icon(Icons.ads_click),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.network('https://celaya.tecnm.mx/wp-content/uploads/2021/02/cropped-FAV.png', 
              height: 250,),
            ),
            Text('Valor del Contador $contador')
          ],
        )
      ),
    );
  }
}*/