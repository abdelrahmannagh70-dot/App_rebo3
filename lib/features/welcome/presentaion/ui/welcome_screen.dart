import 'package:app3/core/widget/App_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const Color goldColor = Color(0xFFC5A451);
  static const Color backgroundColor = Color(0xFFF7F8F9);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [

            IconButton(
              onPressed: () {
                   if (context.locale.languageCode == 'ar') {
                        context.setLocale(const Locale('en'));
                   } else {
                       context.setLocale(const Locale('ar'));
                   }
                   },
                    icon: const Icon(Icons.language),
                    ),



      Positioned.fill(
              child: Image.asset(
                'assets/images/welcome_background.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const ColoredBox(
                    color: backgroundColor,
                  );
                },
              ),
            ),


            Positioned.fill(
              child: Container(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),


            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.055,
                  vertical: screenHeight * 0.025,
                ),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.08),


                    Image.asset(
                      'assets/images/logo 2.png',
                      width: screenWidth * 0.62,
                      height: screenHeight * 0.10,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 14),

                    const Text(
                      'Order Your Book Now!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'DM',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF252525),
                      ),
                    ),

                    const Spacer(),



                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/login',
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: goldColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontFamily: 'DM',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/signup',
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF333333),
                          side: const BorderSide(
                            color: Color(0xFF333333),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            fontFamily: 'DM',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.045),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}