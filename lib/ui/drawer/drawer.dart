import 'package:flutter/material.dart';
import 'package:payong/drawers_content/about_us.dart';
import 'package:payong/drawers_content/contact_us.dart';
import 'package:payong/utils/themes.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerPage extends StatelessWidget {
  final VoidCallback onTap;
  const DrawerPage({required Key key, required this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Scaffold(
        // backgroundColor: kColorPrimary,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                // ignore: prefer_const_literals_to_create_immutables
                colors: [
                  Color(0xFF005EEB),
                  Color(0xFF489E59),
                  Color(0xFFF2E90B),
                  Color(0xFF762917),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                tileMode: TileMode.clamp),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 35,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 30,
                  ),
                  _drawerItem(text: 'Home', onTap: () {}),
                  _drawerItem(
                      text: 'About Us',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AboutUs()),
                        );
                      }),
                  _drawerItem(text: 'Contact Us', onTap: () {
                     Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ContactUs()),
                        );
                  }),
                  _drawerItem(text: 'Visit Website', onTap: () async{
                    await openlaunchUrl('https://bagong.pagasa.dost.gov.ph/');
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    
  }

Future<void> openlaunchUrl(String urlLink) async {
    if (!await launchUrl(Uri.parse(urlLink))) {
      throw Exception('Could not launch $urlLink');
    }
  }
  

  InkWell _drawerItem({
    required String text,
    required Function onTap,
  }) {
    return InkWell(
      onTap: () {
        onTap();
        //this.onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 58,
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 10,
            ),
            Text(
              text.trim(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
