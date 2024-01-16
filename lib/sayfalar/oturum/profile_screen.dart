import 'package:flutter/material.dart';
import 'package:dts/sayfalar/harita/map_page.dart';

class ProfilEkrani extends StatefulWidget {
  const ProfilEkrani({Key? key}) : super(key: key);

  @override
  _ProfilEkraniState createState() => _ProfilEkraniState();
}

class _ProfilEkraniState extends State<ProfilEkrani> {
  int _currentIndex = 2; // Set the index for the profile page

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Handle settings button press
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Kullanıcı profil fotoğrafı
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/profilicon.png'),
            ),

            SizedBox(height: 20),

            // Your existing profile information widgets

            SizedBox(height: 20),

            // Your existing password change button or form

            // Bottom Navigation Bar
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: BottomNavigationBar(
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });

                    // Handle bottom navigation bar item taps
                    switch (_currentIndex) {
                      case 0:
                        // Ana Sayfa
                        Navigator.pop(context);
                        break;
                      case 1:
                        // Konum
                        // Navigate to the map page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MapPage()),
                        );
                        break;
                      case 2:
                        // Kullanıcı
                        // Stay on the profile page
                        break;
                    }
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Ana Sayfa',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.location_on),
                      label: 'Konum',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: 'Kullanıcı',
                    ),
                  ],
                  selectedItemColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
