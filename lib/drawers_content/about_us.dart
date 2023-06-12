import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:payong/routes/routes.dart';

class AboutUs extends StatefulWidget {
  AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
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
                'ABOUT US', style: TextStyle(color: Colors.black, fontSize: 26),textAlign: TextAlign.center,),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: const Text(
              'PAGASA, one of the attached agencies of the Department of Science and Technology (DOST) under its Scientific and Technical Services Institutes, is mandated to “provide protection against natural calamities and utilize scientific knowledge as an effective instrument to insure the safety, well being and economic security of all the people, and for the promotion of national progress.” (Section 2, Statement of Policy, Presidential Decree No. 78; December 1972 as amended by Presidential Decree No. 1149; August 1977)', style: TextStyle(color: Colors.black),textAlign: TextAlign.center,),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.asset(
                          'assets/mission.png',
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          fit: BoxFit.fitWidth,
                          // opacity: const AlwaysStoppedAnimation(.5),
                        ),
                      ),
                      SizedBox(height: 8,),
                      Text('Mission',style: TextStyle(color: Colors.black,fontSize: 20),),
                      SizedBox(height: 8,),
                      Text('Protecting lives and properties through timely, accurate and reliable weather-related information and services.', style: TextStyle(color: Colors.black),textAlign: TextAlign.center,)
                    ],
                  )),
                  SizedBox(width: 8,),
                  Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.asset(
                          'assets/vision.png',
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          fit: BoxFit.fitWidth,
                          // opacity: const AlwaysStoppedAnimation(.5),
                        ),
                      ),
                       SizedBox(height: 8,),
                      Text('Vision',style: TextStyle(color: Colors.black,fontSize: 20),),
                      SizedBox(height: 8,),
                      Text('Center of excellence for weather related information and services', style: TextStyle(color: Colors.black),textAlign: TextAlign.center,)
                    ],
                  )),
                  SizedBox(width: 8,),
                  Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.asset(
                          'assets/values.png',
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          fit: BoxFit.fitWidth,
                          // opacity: const AlwaysStoppedAnimation(.5),
                        ),
                      ),
                       SizedBox(height: 8,),
                      Text('Values',style: TextStyle(color: Colors.black,fontSize: 20),),
                      SizedBox(height: 8,),
                      Text('Integrity, Commitment and Patriotism', style: TextStyle(color: Colors.black),textAlign: TextAlign.center,)
                    ],
                  )),
            ],
          ),
        )
      ]),
    );
  }
}
