import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'class_info_screen.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  final List<String> sensorImages = [
    'assets/main_home_images/sound_sensor.png',
    'assets/main_home_images/flame_sensor.png',
    'assets/main_home_images/ultrasonic_sensor.png',
    'assets/main_home_images/touch_sensor.png',
    'assets/main_home_images/fingerprint_sensor.png',
    'assets/main_home_images/gas_sensor.png',
    'assets/main_home_images/humidity_temperature_sensor.png',
    'assets/main_home_images/rfid_sensor.png',
    'assets/main_home_images/soil_moisture_sensor.png',
    'assets/main_home_images/waterlevel_sensor.png',
  ];

  final List<String> sensorNames = [
    'Sound Sensor',
    'Flame Sensor',
    'Ultrasonic Sensor',
    'Touch Sensor',
    'Fingerprint Sensor',
    'Gas Sensor',
    'Humidity & Temperature Sensor',
    'RFID Sensor',
    'Soil Moisture Sensor',
    'Water Level Sensor',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top section with background image
            Stack(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/main_home_images/background_image.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.6),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 20,
                  right: 20,
                  child: const Text(
                    'Discover your next Project with Arduino Sensors',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 3,
                          color: Colors.black45,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Middle section - Discover Arduino Sensors card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Discover Arduino Sensors',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'See how simple parts can gather real-world data for your projects.',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 15),
                      // Sensor buttons row
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: sensorNames.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: _buildSensorButton(sensorNames[index]),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Bottom section - Arduino Sensors title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Arduino Sensors',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Image slider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CarouselSlider.builder(
                itemCount: sensorImages.length,
                itemBuilder: (context, index, realIndex) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SensorDetailScreen(
                            sensorName: sensorNames[index],
                            sensorImage: sensorImages[index],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.3),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          sensorImages[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        ),
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  height: 200,
                  enlargeCenterPage: true,
                  autoPlay: false,
                  enableInfiniteScroll: true,
                  viewportFraction: 0.8,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // View More Arduino Sensor section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  // Navigate to class_info_screen when tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ClassInfoScreen()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      children: [
                        // Background image
                        Image.asset(
                          'assets/main_home_images/down_image.png',
                          width: double.infinity,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                        // Gradient overlay for better text visibility
                        Container(
                          width: double.infinity,
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.6),
                              ],
                            ),
                          ),
                        ),
                        // Text overlay
                        Positioned(
                          bottom: 20,
                          left: 20,
                          right: 20,
                          child: const Text(
                            'View More Arduino Sensor',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 3,
                                  color: Colors.black45,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorButton(String text) {
    return GestureDetector(
      onTap: () {
        // Navigate to class_info_screen with the specific sensor
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ClassInfoScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// Sensor detail screen (second screen based on second image)
class SensorDetailScreen extends StatelessWidget {
  final String sensorName;
  final String sensorImage;

  const SensorDetailScreen({
    super.key,
    required this.sensorName,
    required this.sensorImage,
  });

  @override
  Widget build(BuildContext context) {
    // Color palette from home_screen
    const Color darkBlue = Color(0xFF0A2540);
    const Color tealBlue = Color(0xFF0FB9B1);
    const Color lightWhite = Color(0xFFF5F8FA);
    const Color greyText = Color(0xFF6B7280);

    final LinearGradient buttonGradient = const LinearGradient(
      colors: [darkBlue, tealBlue],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          sensorName,
          style: const TextStyle(
            color: darkBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: darkBlue),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero image section with gradient overlay
            Container(
              width: double.infinity,
              height: 280,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [lightWhite, Colors.white],
                ),
              ),
              child: Stack(
                children: [
                  // Background decoration
                  Positioned(
                    top: 20,
                    right: -50,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: tealBlue.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -30,
                    left: -50,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: darkBlue.withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                  // Sensor image
                  Center(
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          sensorImage,
                          fit: BoxFit.contain,
                          height: 200,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Content section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with gradient underline
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sensorName,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: darkBlue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 4,
                          width: 60,
                          decoration: BoxDecoration(
                            gradient: buttonGradient,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Description
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: lightWhite,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: tealBlue.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Overview',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: darkBlue,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'This sensor provides accurate measurements and reliable performance for your Arduino projects. Perfect for beginners and advanced users alike.',
                            style: TextStyle(
                              fontSize: 16,
                              color: greyText,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Features section
                    const Text(
                      'Key Features',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: darkBlue,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildFeatureItem(
                      icon: Icons.check_circle,
                      title: 'High Accuracy',
                      description: 'Precise measurements for reliable results',
                      darkBlue: darkBlue,
                      tealBlue: tealBlue,
                      greyText: greyText,
                    ),

                    _buildFeatureItem(
                      icon: Icons.bolt,
                      title: 'Low Power',
                      description:
                          'Energy efficient for battery-powered projects',
                      darkBlue: darkBlue,
                      tealBlue: tealBlue,
                      greyText: greyText,
                    ),

                    _buildFeatureItem(
                      icon: Icons.settings,
                      title: 'Easy Integration',
                      description: 'Simple connection with Arduino boards',
                      darkBlue: darkBlue,
                      tealBlue: tealBlue,
                      greyText: greyText,
                    ),

                    const SizedBox(height: 40),

                    // CTA Button
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: buttonGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: darkBlue.withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ClassInfoScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lightbulb,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'View Project Ideas',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
    required Color darkBlue,
    required Color tealBlue,
    required Color greyText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: tealBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: tealBlue, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: darkBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: greyText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
