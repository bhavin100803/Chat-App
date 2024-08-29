import 'dart:async';

import 'package:chatapp/colors.dart';
import 'package:chatapp/models/onboarding_content.dart';
import 'package:chatapp/pages/myphone.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreens extends StatefulWidget {
  const OnboardingScreens({super.key});

  @override
  State<OnboardingScreens> createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends State<OnboardingScreens> {
  int currentIndex = 0;

  late Timer _timer;
  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (currentIndex <= contents.length) {
        currentIndex++;
      }
      _controller.animateToPage(
        currentIndex,
        duration: Duration(seconds: 1),
        curve: Curves.easeIn,
      );
      super.initState();
    });
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: width,
          height: height,
          child: Column(
            children: [
              // SizedBox(height: height * 0.03,),
              Container(
                height: height,
                child: PageView.builder(
                  itemCount: contents.length,
                  controller: _controller,
                  onPageChanged: (int index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.white,
                      height: height,
                      width: width,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 40.00,
                            ),
                            Text(
                              contents[index].title,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: width * 0.09,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Image.asset(contents[index].image),
                            Container(
                              padding: EdgeInsets.all(10),
                              height: 200,
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Text(
                                    contents[index].desc,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                  // SizedBox(height: 20,),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: _buildDots()),
                                  // SizedBox(height: 20,),
                                  Container(
                                    child: currentIndex == contents.length - 1
                                        ? Center(
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        color.thirdcolor),
                                                onPressed: () {
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              MyPhone()));
                                                },
                                                child: Text(
                                                  "Get Started",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )))
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            MyPhone(),
                                                      ),
                                                    );
                                                  });
                                                },
                                                child: Text(
                                                  "Skip",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.inter(
                                                    textStyle: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  _controller.nextPage(
                                                      duration: Duration(
                                                          milliseconds: 300),
                                                      curve:
                                                          Curves.easeOutSine);
                                                },
                                                child: Text(
                                                  ">",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        color.thirdcolor
                                                    // maximumSize:
                                                    //     Size.fromWidth(width * 0.115),
                                                    ),
                                                // text: ">",
                                                // getWidth: width * 0.115,
                                                // OnTap: () {
                                                //
                                                // },
                                              )
                                            ],
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // body: Container(
      //   height: double.infinity,
      //   width: double.infinity,
      //   child: Column(
      //     children: [
      //       // SizedBox(
      //       //   height: height * 0.03,
      //       // ),
      //       Expanded(
      //         child: PageView.builder(
      //           scrollDirection: Axis.horizontal,
      //           controller: _controller,
      //           itemCount: contents.length,
      //           onPageChanged: (int index) {
      //             setState(() {
      //               currentIndex = index;
      //             });
      //           },
      //           itemBuilder: (context, index) {
      //             return Stack(children: [
      //               Container(
      //                 child: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.center,
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [
      //                     Text(
      //                       contents[index].title,
      //                       textAlign: TextAlign.center,
      //                       style: GoogleFonts.poppins(
      //                         textStyle: TextStyle(
      //                             fontSize: width * 0.09,
      //                             fontWeight: FontWeight.w700,
      //                             color: Colors.black),
      //                       ),
      //                     ),
      //                     SizedBox(
      //                       height: height * 0.50,
      //                     ),
      //                     Padding(
      //                       padding: const EdgeInsets.symmetric(
      //                         horizontal: 20,
      //                       ),
      //                       // child:
      //                     )
      //                   ],
      //                 ),
      //               ),
      //               Padding(
      //                 padding: EdgeInsets.only(
      //                   top: height * 0.2,
      //                 ),
      //                 child: Container(
      //                   height: height * 0.90,
      //                   width: width,
      //                   child: Image.asset(
      //                     contents[index].image,
      //                     fit: BoxFit.fitWidth,
      //                   ),
      //                 ),
      //               ),
      //
      //               Padding(
      //                 padding: EdgeInsets.only(
      //                   top: height * 0.88,
      //                 ),
      //                 child: Row(
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: _buildDots(),
      //                 ),
      //               ),
      //               Container(
      //                 padding: EdgeInsets.only(
      //                   top: height * 0.88,
      //                 ),
      //                 child: Column(
      //                   children: [
      //                     Text(
      //                       contents[index].desc,
      //                       textAlign: TextAlign.center,
      //                       style: GoogleFonts.poppins(
      //                         textStyle: TextStyle(
      //                             fontSize: width * 0.028,
      //                             fontWeight: FontWeight.w500,
      //                             color: Colors.black),
      //                       ),
      //                     ),
      //                     Padding(
      //                       padding: EdgeInsets.only(
      //                           top: height * 0.90,
      //                           right: width * 0.08,
      //                           left: width * 0.08),
      //                       child: currentIndex == contents.length - 1
      //                           ? Center(
      //                           child: ElevatedButton(
      //                             onPressed: () {
      //                               Navigator.pushReplacement(
      //                                   context,
      //                                   MaterialPageRoute(
      //                                     builder: (_) => MyPhone(),
      //                                   ));
      //                             },
      //                             child: Text("GET STARTED"),
      //                             style: ElevatedButton.styleFrom(
      //                               maximumSize: Size.fromWidth(width * 0.43),
      //                             ),
      // text: ">",
      // getWidth: width * 0.115,
      // OnTap: () {
      //
      // },
      // )
      // GetButton(
      //     text: "GET STARTED",
      //     getWidth: width * 0.43,
      //     OnTap: () {
      //       Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(
      //           builder: (_) => MyPhone(),
      //         ),
      //       );
      //     }),
      // )
      //                           : Row(
      //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                         children: [
      //                           GestureDetector(
      //                             onTap: () {
      //                               setState(() {
      //                                 Navigator.pushReplacement(
      //                                   context,
      //                                   MaterialPageRoute(
      //                                     builder: (_) => MyPhone(),
      //                                   ),
      //                                 );
      //                               });
      //                             },
      //                             child: Text(
      //                               "Skip",
      //                               textAlign: TextAlign.center,
      //                               style: GoogleFonts.inter(
      //                                 textStyle: TextStyle(
      //                                     fontSize: 13,
      //                                     fontWeight: FontWeight.w500,
      //                                     color: Colors.grey),
      //                               ),
      //                             ),
      //                           ),
      //                           ElevatedButton(
      //                             onPressed: () {
      //                               _controller.nextPage(
      //                                   duration: Duration(milliseconds: 300),
      //                                   curve: Curves.easeOutSine);
      //                             },
      //                             child: Text(">"),
      //                             style: ElevatedButton.styleFrom(
      //                               // maximumSize:
      //                               //     Size.fromWidth(width * 0.115),
      //                             ),
      //                             // text: ">",
      //                             // getWidth: width * 0.115,
      //                             // OnTap: () {
      //                             //
      //                             // },
      //                           )
      //                         ],
      //                       ),
      //                     )
      //                   ],
      //                 ),
      //
      //               ),
      //
      //
      //               // Padding(
      //               //   padding: EdgeInsets.only(
      //               //     top: height * 0.79,
      //               //   ),
      //               //   child: Text(
      //               //     contents[index].desc,
      //               //     textAlign: TextAlign.center,
      //               //     style: GoogleFonts.poppins(
      //               //       textStyle: TextStyle(
      //               //           fontSize: width * 0.028,
      //               //           fontWeight: FontWeight.w500,
      //               //           color: Colors.black),
      //               //     ),
      //               //   ),
      //               // ),
      //
      //             ]);
      //           },
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  List<Widget> _buildDots() {
    return List.generate(
      contents.length,
      (index) => Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          width: currentIndex == index ? 17.0 : 8,
          height: 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21),
            color: currentIndex == index ? color.thirdcolor : Colors.grey,
          ),
        ),
      ),
    );
  }
}
