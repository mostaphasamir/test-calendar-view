import 'package:flutter/material.dart';



void main() {
  runApp(MaterialApp(
    home: WaveBottomNavBar()
  ));
}
class WaveBottomNavBar extends StatefulWidget {
  const WaveBottomNavBar({super.key});

  @override
  _WaveBottomNavBarState createState() => _WaveBottomNavBarState();
}

class _WaveBottomNavBarState extends State<WaveBottomNavBar>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 0).animate(_controller);
  }

  void _onItemTapped(int index) {
    setState(() {
      final previousPosition = _selectedIndex * (1 / 4);
      final newPosition = index * (1 / 4);

      _animation = Tween<double>(begin: previousPosition, end: newPosition)
          .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

      _controller.reset();
      _controller.forward();

      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Text(
          "Selected Tab: ${_getTabLabel(_selectedIndex)}",
          style: TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar: Stack(
        children: [
          CustomPaint(
            size: const Size(double.infinity, 80),
            painter: WavePainter(_animation),
          ),
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  icon: Icons.settings,
                  label: "Service",
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.dashboard,
                  label: "Dashboard",
                  index: 1,
                ),
                _buildNavItem(
                  icon: Icons.notifications,
                  label: "Notification",
                  index: 2,
                ),
                _buildNavItem(
                  icon: Icons.person,
                  label: "Profile",
                  index: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: isSelected ? Colors.purple : Colors.transparent,
            radius: 24,
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black54,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.purple : Colors.black54,
              fontWeight: !isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  String _getTabLabel(int index) {
    switch (index) {
      case 0:
        return "Service";
      case 1:
        return "Dashboard";
      case 2:
        return "Notification";
      case 3:
        return "Profile";
      default:
        return "";
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class WavePainter extends CustomPainter {
  final Animation<double> animation;

  WavePainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final waveWidth = size.width / 4;
    final waveCenter = animation.value * size.width + waveWidth / 2;

    // Adjusting the rectangle to have a rounded border radius
    final rectPath = Path()
      ..addRRect(RRect.fromRectAndCorners(
        Rect.fromLTRB(0, -40, size.width, size.height),
      ));

    final wavePath = Path();
    wavePath.moveTo(0, 0);
    wavePath.lineTo(waveCenter - waveWidth / 2, 0);

    wavePath.quadraticBezierTo(
      waveCenter,
      -40,
      waveCenter + waveWidth / 2,
      0,

    );

    wavePath.lineTo(size.width, 0); // Move to the right edge
    wavePath.lineTo(size.width, size.height); // Bottom right corner
    wavePath.lineTo(0, size.height); // Bottom left corner

    wavePath.close(); // Close the path

    // Combine the rectangle and wave paths
    final combinedPath = Path.combine(PathOperation.intersect, rectPath, wavePath);

    // Draw the combined path
    canvas.drawPath(combinedPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}


