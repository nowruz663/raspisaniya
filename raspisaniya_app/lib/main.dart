import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase-i işe girizmek
  await Firebase.initializeApp();
  runApp(const TohiRaspisaniyaApp());
}

class TohiRaspisaniyaApp extends StatelessWidget {
  const TohiRaspisaniyaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TOHI Sanly Raspisaniýa',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primaryColor: const Color(0xFFD700),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD700),
          secondary: Color(0xFFB59410),
          surface: Color(0xFF1E293B),
        ),
        useMaterial3: true,
      ),
      home: const LoginSahypasy(),
    );
  }
}

// 1. SAHYPA: ONLAÝN LOGIN WE REGISTRASIÝA
class LoginSahypasy extends StatefulWidget {
  const LoginSahypasy({super.key});

  @override
  State<LoginSahypasy> createState() => _LoginSahypasyState();
}

class _LoginSahypasyState extends State<LoginSahypasy> {
  final _loginController = TextEditingController();
  final _parolController = TextEditingController();
  final _registrasiyaAtController = TextEditingController();
  bool _isLoginView = true;

  void _girişEt() async {
    String log = _loginController.text.trim();
    String pas = _parolController.text.trim();

    if (log == 'admin' && pas == 'admin') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminOtagySahypasy()));
      return;
    }

    // Firebase Firestore-dan ulanyjyny barlamak
    var snap = await FirebaseFirestore.instance
        .collection('ulanyjylar')
        .where('login', isEqualTo: log)
        .where('parol', isEqualTo: pas)
        .get();

    if (snap.docs.isNotEmpty) {
      String ulanyjyAdy = snap.docs.first.data()['ad'] ?? 'Talyp';
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TalypEsasySahypa(ulanyjyAdy: ulanyjyAdy)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login ýa-da parol ýalňyş!', style: TextStyle(color: Colors.red))),
      );
    }
  }

  void _registrasiyaEt() async {
    if (_registrasiyaAtController.text.isEmpty || _loginController.text.isEmpty || _parolController.text.isEmpty) return;

    // Firebase-e täze ulanyjy goşmak
    await FirebaseFirestore.instance.collection('ulanyjylar').add({
      'ad': _registrasiyaAtController.text.trim(),
      'login': _loginController.text.trim(),
      'parol': _parolController.text.trim(),
    });

    setState(() {
      _isLoginView = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registrasiýa şowly gutardy! Giriň.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFD700), width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(border: Border.all(color: const Color(0xFFD700), width: 2), borderRadius: BorderRadius.circular(8)),
                child: const Text('TOHI', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFD700), letterSpacing: 2)),
              ),
              const SizedBox(height: 24),
              if (!_isLoginView) ...[
                TextField(controller: _registrasiyaAtController, decoration: const InputDecoration(labelText: 'Doly Adyňyz')),
                const SizedBox(height: 12),
              ],
              TextField(controller: _loginController, decoration: const InputDecoration(labelText: 'Login')),
              const SizedBox(height: 12),
              TextField(controller: _parolController, obscureText: true, decoration: const InputDecoration(labelText: 'Parol')),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD700), foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 45)),
                onPressed: _isLoginView ? _girişEt : _registrasiyaEt,
                child: Text(_isLoginView ? 'Giriş Et' : 'Registrasiýa Bol'),
              ),
              TextButton(
                onPressed: () => setState(() => _isLoginView = !_isLoginView),
                child: Text(_isLoginView ? 'Täze profil açmak' : 'Öň profilim bar', style: const TextStyle(color: Color(0xFFD700))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 2. SAHYPA: TALÝPLAR ÜÇIN ESASY BÖLEK
class TalypEsasySahypa extends StatefulWidget {
  final String ulanyjyAdy;
  const TalypEsasySahypa({super.key, required this.ulanyjyAdy});

  @override
  State<TalypEsasySahypa> createState() => _TalypEsasySahypaState();
}

class _TalypEsasySahypaState extends State<TalypEsasySahypa> {
  String _currentMenu = 'kurslar';
  final _chatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salam, ${widget.ulanyjyAdy}', style: const TextStyle(color: Color(0xFFD700))),
        actions: [
          IconButton(icon: const Icon(Icons.logout, color: Colors.red), onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginSahypasy())))
        ],
      ),
      body: Row(
        children: [
          Container(
            width: 200,
            color: const Color(0xFF1E293B),
            child: Column(
              children: [
                const SizedBox(height: 20),
                ListTile(leading: const Icon(Icons.grid_view, color: Color(0xFFD700)), title: const Text('Kurs Gutulary'), onTap: () => setState(() => _currentMenu = 'kurslar')),
                ListTile(leading: const Icon(Icons.chat, color: Color(0xFFD700)), title: const Text('Admin bilen Çat'), onTap: () => setState(() => _currentMenu = 'chat')),
              ],
            ),
          ),
          Expanded(child: _currentMenu == 'kurslar' ? _buildKursGutyary() : _buildChatBölümi()),
        ],
      ),
    );
  }

  Widget _buildKursGutyary() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 300,
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFD700), width: 2)),
              child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.looks_one, size: 50, color: Color(0xFFD700)),
                Text('1-nji we 2-nji Kurslar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ]),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              height: 300,
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFD700), width: 2)),
              child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.looks_two, size: 50, color: Color(0xFFD700)),
                Text('3-nji we 4-nji Kurslar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBölümi() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('chat').orderBy('wagt', descending: false).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                var docs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var data = docs[index].data() as Map<String, dynamic>;
                    bool isAdmin = data['kimden'] == 'Admin';
                    return Align(
                      alignment: isAdmin ? Alignment.centerLeft : Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isAdmin ? Colors.grey[800] : const Color(0xFFB59410).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text("${data['kimden']}: ${data['tekst']}"),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(child: TextField(controller: _chatController, decoration: const InputDecoration(hintText: 'Admine ýazyň...'))),
              IconButton(
                icon: const Icon(Icons.send, color: Color(0xFFD700)),
                onPressed: () async {
                  if (_chatController.text.isEmpty) return;
                  await FirebaseFirestore.instance.collection('chat').add({
                    'kimden': widget.ulanyjyAdy,
                    'tekst': _chatController.text.trim(),
                    'wagt': FieldValue.serverTimestamp(),
                  });
                  _chatController.clear();
                },
              )
            ],
          )
        ],
      ),
    );
  }
}

// 3. SAHYPA: ADMIN PANELI
class AdminOtagySahypasy extends StatefulWidget {
  const AdminOtagySahypasy({super.key});

  @override
  State<AdminOtagySahypasy> createState() => _AdminOtagySahypasyState();
}

class _AdminOtagySahypasyState extends State<AdminOtagySahypasy> {
  String _adminMenyu = 'ulanyjylar';
  final _adminChatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADMIN CONTROL PANEL', style: TextStyle(color: Color(0xFFD700))),
        actions: [
          IconButton(icon: const Icon(Icons.logout, color: Colors.red), onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginSahypasy())))
        ],
      ),
      body: Row(
        children: [
          Container(
            width: 220,
            color: const Color(0xFF0F172A),
            child: Column(
              children: [
                ListTile(leading: const Icon(Icons.people), title: const Text('Talyplar'), onTap: () => setState(() => _adminMenyu = 'ulanyjylar')),
                ListTile(leading: const Icon(Icons.chat), title: const Text('Hatlar'), onTap: () => setState(() => _adminMenyu = 'hatlar')),
              ],
            ),
          ),
          Expanded(child: _buildAdminContent()),
        ],
      ),
    );
  }

  Widget _buildAdminContent() {
    if (_adminMenyu == 'ulanyjylar') {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('ulanyjylar').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          var docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var docId = docs[index].id;
              var data = docs[index].data() as Map<String, dynamic>;
              var loginEdit = TextEditingController(text: data['login']);
              var parolEdit = TextEditingController(text: data['parol']);

              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(child: Text(data['ad'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(child: TextField(controller: loginEdit, decoration: const InputDecoration(labelText: 'Login'))),
                      const SizedBox(width: 10),
                      Expanded(child: TextField(controller: parolEdit, decoration: const InputDecoration(labelText: 'Parol'))),
                      IconButton(
                        icon: const Icon(Icons.save, color: Color(0xFFD700)),
                        onPressed: () async {
                          // Firebase-de maglumaty täzelemek
                          await FirebaseFirestore.instance.collection('ulanyjylar').doc(docId).update({
                            'login': loginEdit.text,
                            'parol': parolEdit.text,
                          });
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Onlaýn täzelendi!')));
                        },
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('chat').orderBy('wagt', descending: false).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                      return ListTile(title: Text("${data['kimden']}: ${data['tekst']}"));
                    },
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(child: TextField(controller: _adminChatController, decoration: const InputDecoration(hintText: 'Jogap ýazyň...'))),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFFD700)),
                  onPressed: () async {
                    if (_adminChatController.text.isEmpty) return;
                    await FirebaseFirestore.instance.collection('chat').add({
                      'kimden': 'Admin',
                      'tekst': _adminChatController.text.trim(),
                      'wagt': FieldValue.serverTimestamp(),
                    });
                    _adminChatController.clear();
                  },
                )
              ],
            )
          ],
        ),
      );
    }
  }
}