import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:payong/routes/routes.dart';
import 'package:url_launcher/url_launcher.dart' as url;

class ContactUs extends StatefulWidget {
  ContactUs({super.key});

  @override
  State<ContactUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 0, 0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(Routes.mobMain);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.white, spreadRadius: 3),
                ],
              ),
              height: 40,
              width: 40,
              child: Center(
                child: Icon(Icons.arrow_back_ios),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
                'CONTACT US', style: TextStyle(color: Colors.black, fontSize: 26),textAlign: TextAlign.center,),
          ],
        ),
         Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
           child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                  'Email:', style: TextStyle(color: Colors.black, fontSize: 20),textAlign: TextAlign.center,),
            ],
                 ),
         ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: GestureDetector(
            onTap: ()async{
                 await url.launchUrl(Uri(path: 'pagasadost.farmweather@gmail.com'));

            },
            child: const Text(
                'pagasadost.farmweather@gmail.com', style: TextStyle(color: Colors.blueAccent),textAlign: TextAlign.center,),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: GestureDetector(
            onTap: ()async{
                 await url.launchUrl(Uri(path: 'pagasa.climps@gmail.com '));

            },
            child: const Text(
                'pagasa.climps@gmail.com ', style: TextStyle(color: Colors.blueAccent),textAlign: TextAlign.center,),
          ),
        ),
       
      ]),
    );
  }
}
