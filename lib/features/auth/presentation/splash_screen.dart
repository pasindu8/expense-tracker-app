import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../main.dart'; 

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isExpanded = false;
  bool _showText = false;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() async {
    
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) {
      setState(() {
        _isExpanded = true;
      });
    }
    
   
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _showText = true;
      });
    }

   
    await Future.delayed(const Duration(milliseconds: 4000));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const AuthGate(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 1000), 
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDFAF6), 
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppTheme.primaryTeal,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  const Positioned(
                    top: 14,
                    left: 14,
                    child: Icon(Icons.add_circle, color: Colors.white70, size: 24),
                  ),
                  Positioned(
                    bottom: 18,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(width: 14, height: 22, decoration: BoxDecoration(color: Colors.white60, borderRadius: BorderRadius.circular(4))),
                        const SizedBox(width: 8),
                        Container(width: 14, height: 38, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4))),
                        const SizedBox(width: 8),
                        Container(width: 14, height: 50, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            
            AnimatedSize(
              duration: const Duration(milliseconds: 1200),
              curve: Curves.fastOutSlowIn,
              child: Container(
                width: _isExpanded ? 240 : 0, 
                padding: const EdgeInsets.only(left: 16),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 1200),
                  opacity: _showText ? 1.0 : 0.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(text: 'Expense ', style: TextStyle(color: Colors.black87, fontSize: 32, fontWeight: FontWeight.bold)),
                              TextSpan(text: 'Tracker', style: TextStyle(color: AppTheme.primaryTeal, fontSize: 32, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Capture fast. Understand clearly.',
                        style: TextStyle(color: Colors.black54, fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}