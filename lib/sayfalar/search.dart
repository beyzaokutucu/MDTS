import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arama Sayfası'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Arama butonu
            ElevatedButton(
              onPressed: () {
                // Burada arama butonuna tıklandığında yapılacak işlemleri ekleyebilirsiniz.
                // Örneğin, arama sonuçlarını getirme, filtreleme vb.
              },
              child: Text('Ara'),
            ),
            SizedBox(height: 16.0),

            // Arama metin alanı
            TextField(
              decoration: InputDecoration(
                labelText: 'Arama yapın...',
                border: OutlineInputBorder(),
              ),
              // Burada TextField kullanıcının girdiği metni tutacaktır.
              // Gerekirse bu metni kullanarak arama işlemleri yapabilirsiniz.
            ),
          ],
        ),
      ),
    );
  }
}
