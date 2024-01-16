import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "JohnDoe"; // Kullanıcı adı örneği
  String email = "john.doe@example.com"; // E-posta örneği

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil Sayfası"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Kullanıcı Adı: $username",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.0),
            Text(
              "E-posta: $email",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                // Şifre Değiştirme Ekranı Açma
                _showChangePasswordDialog(context);
              },
              child: Text("Şifre Değiştir"),
            ),
            ElevatedButton(
              onPressed: () {
                // Ayarlar Ekranı Açma
                _showSettingsDialog(context);
              },
              child: Text("Ayarlar"),
            ),
          ],
        ),
      ),
    );
  }

  // Şifre Değiştirme Ekranı
  Future<void> _showChangePasswordDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Şifre Değiştir"),
          content: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Mevcut Şifre"),
                obscureText: true,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Yeni Şifre"),
                obscureText: true,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Yeni Şifre Tekrar"),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("İptal"),
            ),
            ElevatedButton(
              onPressed: () {
                // Şifre değiştirme işlemleri burada gerçekleştirilebilir.
                // Örneğin: API isteği, veritabanı güncellemesi, vb.
                Navigator.of(context).pop();
              },
              child: Text("Değiştir"),
            ),
          ],
        );
      },
    );
  }

  // Ayarlar Ekranı
  Future<void> _showSettingsDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Ayarlar"),
          content: Column(
            children: [
              Text("Bu alanda uygulama ayarları yer alabilir."),
              // Diğer ayarlar buraya eklenebilir.
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Kapat"),
            ),
          ],
        );
      },
    );
  }
}
