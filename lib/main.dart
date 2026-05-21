import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase esasy paketi

void main() async {
  // 1. Flutter-iň bütin içki gurnawlarynyň taýyn bolmagyny üpjün edýär
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Android/app içindäki json açary arkaly Firebase-i internete baglaýar
  await Firebase.initializeApp();
  
  // 3. Programmany doly güýjünde işe girizýär
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Altyn Restoran',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      // Şu ýerde siziň esasy açylýan baş sahypaňyz durmaly
      home: const MenyuSahypasy(), 
    );
  }
}

// Barlag we durnuklylyk üçin öňki duran esasy sahypaňyz (MenyuSahypasy)
class MenyuSahypasy extends StatefulWidget {
  const MenyuSahypasy({super.key});

  @override
  State<MenyuSahypasy> createState() => _MenyuSahypasyState();
}

class _MenyuSahypasyState extends State<MenyuSahypasy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Altyn Restoran Menýu'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Firebase Üstünlikli Baglandy!\nIndi onlaýn maglumatlary çekip bolar.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}