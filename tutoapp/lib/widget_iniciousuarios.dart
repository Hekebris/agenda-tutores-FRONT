import 'package:flutter/material.dart';

class LoginTEST extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 390,
          height: 844,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              Positioned(
                left: -138,
                top: -22,
                child: Container(
                  width: 1168,
                  height: 866,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          NetworkImage("https://via.placeholder.com/1168x866"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 39,
                top: 66,
                child: Container(
                  width: 314,
                  height: 760,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 51,
                        top: 736,
                        child: SizedBox(
                          width: 210,
                          height: 24,
                          child: Text(
                            'Términos y condiciones',
                            style: TextStyle(
                              color: Color(0xFF7E3535),
                              fontSize: 20,
                              fontFamily: 'Inconsolata',
                              fontWeight: FontWeight.w500,
                              height: 0,
                              letterSpacing: -0.50,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 668,
                        child: Container(
                          width: 312,
                          height: 52,
                          child: Stack(children: []),
                        ),
                      ),
                      Positioned(
                        left: 1,
                        top: 335,
                        child: Container(
                          width: 313,
                          height: 96,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 73,
                                child: SizedBox(
                                  width: 159,
                                  height: 23,
                                  child: Text(
                                    'Olvidaste tu contrasena?',
                                    style: TextStyle(
                                      color: Color(0xFF7E3535),
                                      fontSize: 14,
                                      fontFamily: 'Inconsolata',
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                      letterSpacing: -1.12,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 194,
                                top: 73,
                                child: SizedBox(
                                  width: 119,
                                  height: 23,
                                  child: Text(
                                    'Tu! Registrate ahora',
                                    style: TextStyle(
                                      color: Color(0xFF7E3535),
                                      fontSize: 14,
                                      fontFamily: 'Inconsolata',
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                      letterSpacing: -1.12,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 313,
                                  height: 48,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 0,
                                        child: Container(
                                          width: 313,
                                          height: 48,
                                          decoration: ShapeDecoration(
                                            color: Color(0xFFE65A5A),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 110,
                                        top: 7,
                                        child: SizedBox(
                                          width: 92,
                                          height: 23,
                                          child: Text(
                                            'Log in',
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontSize: 30,
                                              fontFamily: 'Inconsolata',
                                              fontWeight: FontWeight.w700,
                                              height: 0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 19,
                        top: 244,
                        child: Container(
                          width: 275,
                          height: 46,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 275,
                                  height: 40,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 0,
                                        child: Container(
                                          width: 275,
                                          height: 40,
                                          decoration: ShapeDecoration(
                                            color: Color(0x661E1E1E),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 50,
                                        top: 4,
                                        child: Transform(
                                          transform: Matrix4.identity()
                                            ..translate(0.0, 0.0)
                                            ..rotateZ(1.57),
                                          child: Container(
                                            width: 33,
                                            decoration: ShapeDecoration(
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  width: 3,
                                                  strokeAlign: BorderSide
                                                      .strokeAlignCenter,
                                                  color: Color(0xFFF5C3C3),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 16,
                                        top: 18,
                                        child: Container(
                                          width: 23,
                                          height: 15,
                                          decoration: ShapeDecoration(
                                            color: Color(0xFFF5C3C3),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4)),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 15,
                                        top: 5,
                                        child: Container(
                                          width: 25,
                                          height: 30,
                                          child: Stack(children: []),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 59,
                                top: 6,
                                child: SizedBox(
                                  width: 124,
                                  height: 40,
                                  child: Text(
                                    'Contrasena',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontFamily: 'Inria Sans',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 19,
                        top: 175,
                        child: Container(
                          width: 275,
                          height: 48,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 275,
                                  height: 40,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 0,
                                        child: Container(
                                          width: 275,
                                          height: 40,
                                          decoration: ShapeDecoration(
                                            color: Color(0x661E1E1E),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 50,
                                        top: 4,
                                        child: Transform(
                                          transform: Matrix4.identity()
                                            ..translate(0.0, 0.0)
                                            ..rotateZ(1.57),
                                          child: Container(
                                            width: 33,
                                            decoration: ShapeDecoration(
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  width: 3,
                                                  strokeAlign: BorderSide
                                                      .strokeAlignCenter,
                                                  color: Color(0xFFF5C3C3),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 16,
                                        top: 6,
                                        child: Container(
                                          width: 23,
                                          height: 28,
                                          child: Stack(children: []),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 59,
                                top: 8,
                                child: SizedBox(
                                  width: 110,
                                  height: 40,
                                  child: Text(
                                    'Código ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontFamily: 'Inria Sans',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 70,
                        top: 0,
                        child: Container(
                          width: 172,
                          height: 82,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Stack(children: []),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
