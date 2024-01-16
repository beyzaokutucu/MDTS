import 'package:dts/sayfalar/harita/map_page.dart';
import 'package:dts/sayfalar/oturum/profile_screen.dart';
import 'package:flutter/material.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({Key? key}) : super(key: key);

  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Arka plan gradient
          Container(
            width: double.infinity,
            height: 155,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.98, -0.19),
                end: Alignment(-0.98, 0.19),
                colors: [Color(0x6B7BC4B2), Color(0xFF7BC4B2)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),

          // Kullanıcı profil fotoğrafı
          Positioned(
            top: 20,
            right: 15,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/images/profilicon.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),

          // Kullanıcı adı
          Positioned(
            top: 30,
            right: 80,
            child: Container(
              child: Text(
                'Merhaba, Kullanıcı İsmi',
                style: TextStyle(
                  fontSize: 20,
                  color: const Color(0xFF222),
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ),

          // Ana içerik
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 165, right: 110),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 179,
                    height: 179,
                    decoration: BoxDecoration(
                      color: const Color(0xBCFF3737),
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image:
                              AssetImage('assets/images/anasayfaortafoto.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Başlık
              Text(
                'En Yakın Doğumhaneyi Göster',
                style: TextStyle(
                  fontSize: 24,
                  color: const Color(0xFF677294),
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
              ),

              // Açıklama
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Hamile misiniz? En yakın doğumhaneyi bulmak için aşağıdaki butona tıklayın.',
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color(0xFF677294),
                    fontFamily: 'Rubik',
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 20),

              // Doğumhaneyi Bul butonu
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapPage()),
                  ).then((value) {
                    // Geri döndüğümüzde altındaki bottomNavigationBar'ın seçili durumunu korumak için
                    setState(() {
                      _currentIndex = 0;
                    });
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF7BC4B2),
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  minimumSize: Size(270, 54),
                ),
                child: Text(
                  'Doğumhaneyi Bul',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          // Bottom Navigation Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });

                // Her bir bottom için sayfa geçişi burada tanımlanır
                switch (_currentIndex) {
                  case 0:
                    // Ana Sayfa
                    // Burada geçiş yapılacak sayfayı belirleyin
                    break;
                  case 1:
                    // Konum
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapPage()),
                    ).then((value) {
                      // Geri döndüğümüzde altındaki bottomNavigationBar'ın seçili durumunu korumak için
                      setState(() {
                        _currentIndex = 0;
                      });
                    });
                    break;
                  case 2:
                    // Kullanıcı
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilEkrani()),
                    ).then((value) {
                      // Geri döndüğümüzde altındaki bottomNavigationBar'ın seçili durumunu korumak için
                      setState(() {
                        _currentIndex = 0;
                      });
                    });
                    break;
                  default:
                    break;
                }
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home,
                      color: _currentIndex == 0 ? Color(0xBCFF3737) : null),
                  label: 'Ana Sayfa',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.location_on,
                      color: _currentIndex == 1 ? Color(0xBCFF3737) : null),
                  label: 'Konum',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person,
                      color: _currentIndex == 2 ? Color(0xBCFF3737) : null),
                  label: 'Kullanıcı',
                ),
              ],
              // Label için tema belirleme
              selectedItemColor: Color(0xBCFF3737),
              unselectedItemColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
