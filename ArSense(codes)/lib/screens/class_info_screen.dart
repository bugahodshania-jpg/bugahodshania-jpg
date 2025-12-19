import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/classification_provider.dart';

/// 🎨 COLOR PALETTE
const Color darkBlue = Color(0xFF0A2540);
const Color tealBlue = Color(0xFF0FB9B1);
const LinearGradient buttonGradient = LinearGradient(
  colors: [darkBlue, tealBlue],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

/// 🔹 CLASS DESCRIPTIONS
const Map<String, String> classDescriptions = {
  'fingerprint sensor':
      'A fingerprint sensor is a biometric input device that captures and analyzes the unique ridge and valley patterns present on a human fingerprint. It works using optical, capacitive, or ultrasonic technology to create a digital fingerprint template. Optical sensors use light to capture an image, capacitive sensors detect electrical differences between ridges and valleys, and ultrasonic sensors use sound waves for high accuracy. Fingerprint sensors are widely used in security and authentication systems such as door locks, attendance systems, smartphones, laptops, and identity verification applications. They provide a high level of security because fingerprints are unique to each individual.',

  'ultrasonic sensor':
      'An ultrasonic sensor is a distance-measuring device that emits high-frequency sound waves (ultrasound) and calculates distance based on the time it takes for the echo to return after hitting an object. Using the time-of-flight principle, the sensor determines how far an object is from it with good accuracy. Ultrasonic sensors are commonly used in robotics for obstacle detection, parking assistance systems in vehicles, water level monitoring, and automated systems. They are reliable for non-contact distance measurement and work well in various lighting conditions.',

  'water level sensor':
      'A water level sensor is designed to detect and monitor the level of liquids in tanks, containers, or natural water bodies. It can operate using float-based, resistive, capacitive, or ultrasonic techniques depending on the design. These sensors provide analog or digital signals that indicate low, medium, or high water levels. Water level sensors are widely used in automatic water pumps, irrigation systems, flood detection systems, industrial liquid storage, and household water management to prevent overflow or dry running.',

  'sound sensor':
      'A sound sensor is an electronic module that detects sound waves and converts them into electrical signals that can be processed by a microcontroller. It typically includes a microphone, amplifier, and comparator to measure sound intensity or detect specific sound thresholds. Sound sensors are commonly used in voice-activated systems, noise detection, clap-controlled switches, security alarms, and interactive Arduino projects. While basic sound sensors measure volume, advanced systems can analyze sound patterns for voice recognition.',

  'humidity temperature sensor':
      'A humidity and temperature sensor measures the ambient temperature and the relative humidity of the surrounding environment. It uses integrated sensing elements to provide accurate digital or analog readings. These sensors are commonly found in weather stations, HVAC systems, smart home automation, agricultural monitoring, greenhouses, and environmental data logging. Monitoring humidity and temperature helps maintain comfort, protect equipment, and optimize plant growth and storage conditions.',

  'soil moisture sensor':
      'A soil moisture sensor measures the water content present in soil by detecting changes in electrical resistance or capacitance. Resistive sensors measure conductivity between probes, while capacitive sensors detect changes in dielectric properties of the soil. These sensors are widely used in agriculture, gardening, and smart irrigation systems to ensure plants receive the right amount of water. They help conserve water, improve crop yield, and prevent overwatering or underwatering.',

  'flame sensor':
      'A flame sensor is designed to detect the presence of fire or flames by sensing infrared (IR) light emitted by burning objects. It can identify flames from a certain distance depending on sensitivity and environmental conditions. Flame sensors are commonly used in fire alarm systems, fire-fighting robots, industrial safety equipment, and emergency shutdown systems. Early flame detection helps reduce fire hazards and improves safety in homes and industrial environments.',

  'touch sensor':
      'A touch sensor detects physical contact or proximity using capacitive or resistive sensing technology. Capacitive touch sensors respond to changes in electrical charge caused by the human body, while resistive sensors detect pressure applied to the surface. Touch sensors are commonly used in touchscreens, control panels, lamps, elevators, and interactive electronic devices. They offer a simple, durable, and user-friendly way to provide input without mechanical buttons.',

  'smoke gas sensor':
      'A smoke and gas sensor detects the presence of smoke, toxic gases, or combustible gases using chemical sensing elements. These sensors change their electrical properties when exposed to gases such as LPG, methane, carbon monoxide, or smoke particles. Smoke and gas sensors are essential for fire detection systems, air quality monitoring, industrial safety, and home gas leak detection. They play a critical role in preventing accidents and protecting human life.',

  'RFID sensor':
      'An RFID (Radio Frequency Identification) sensor, also known as an RFID reader, uses electromagnetic fields to detect and read data stored on RFID tags or cards. Each tag contains a unique identifier that can be read without physical contact. RFID sensors are widely used in access control systems, attendance tracking, inventory management, cashless payments, toll collection, and asset tracking. They offer fast, secure, and efficient identification and automation capabilities.',
};

/// 🔹 SENSOR IMAGES
const Map<String, String> classImages = {
  'fingerprint sensor': 'assets/sensors/fingerprint.png',
  'ultrasonic sensor': 'assets/sensors/ultrasonic.png',
  'water level sensor': 'assets/sensors/water_level.png',
  'sound sensor': 'assets/sensors/sound.png',
  'humidity temperature sensor': 'assets/sensors/humidity_temp.png',
  'soil moisture sensor': 'assets/sensors/soil_moisture.png',
  'flame sensor': 'assets/sensors/flame.png',
  'touch sensor': 'assets/sensors/touch.png',
  'smoke gas sensor': 'assets/sensors/smoke_gas.png',
  'RFID sensor': 'assets/sensors/rfid.png',
};

/// 🔹 SENSOR CATEGORY
const Map<String, String> sensorCategories = {
  'fingerprint sensor': 'Biometric Sensor',
  'ultrasonic sensor': 'Distance Sensor',
  'water level sensor': 'Environmental Sensor',
  'sound sensor': 'Environmental Sensor',
  'humidity temperature sensor': 'Environmental Sensor',
  'soil moisture sensor': 'Environmental Sensor',
  'flame sensor': 'Safety Sensor',
  'touch sensor': 'Input Sensor',
  'smoke gas sensor': 'Safety Sensor',
  'RFID sensor': 'Identification Sensor',
};

/// 🔹 SENSOR PROJECT IDEAS (EXPANDED)
const Map<String, List<String>> sensorProjectIdeas = {
  'fingerprint sensor': [
    'Smart door lock',
    'Attendance tracking system',
    'Biometric security access',
    'Personalized device unlocking',
    'Time clock system for employees',
    'Secure locker system',
    'Mobile banking authentication',
    'Gym access system',
    'Hotel room door lock',
    'Secure voting system',
    'Biometric ATM authentication',
  ],
  'ultrasonic sensor': [
    'Obstacle avoiding robot',
    'Parking assistance',
    'Liquid level detection',
    'Blind spot detection system',
    'Smart pet feeder distance detection',
    'Proximity-based automatic door',
    'Smart trash can lid automation',
    'Object counting system',
    'Distance-based alarm system',
    'Automatic faucet control',
    'Robotic arm positioning',
  ],
  'water level sensor': [
    'Automatic pump control',
    'Flood detection system',
    'Smart irrigation',
    'Rainwater harvesting system monitoring',
    'Water tank level notification system',
    'Aquarium water level monitoring',
    'Swimming pool water level monitor',
    'Hydroponic system control',
    'Industrial water tank monitoring',
    'Dam overflow alert system',
    'Sump pump automation',
  ],
  'sound sensor': [
    'Noise monitoring',
    'Sound-activated alarm',
    'Voice recognition projects',
    'Clap-controlled home automation',
    'Baby cry detector',
    'Ambient noise-based light control',
    'Musical instrument tuner',
    'Sound level logger',
    'Security alarm activation',
    'Voice-controlled robot',
    'Smart conference room alert system',
  ],
  'humidity temperature sensor': [
    'Greenhouse monitoring',
    'Weather station',
    'HVAC automation',
    'Smart home climate control',
    'Cold storage temperature monitor',
    'Comfort level monitoring system',
    'Refrigerator monitoring system',
    'Server room environment monitor',
    'Smart wardrobe environment control',
    'Museum artifact preservation monitor',
    'Cigar humidor monitoring system',
  ],
  'soil moisture sensor': [
    'Smart irrigation',
    'Automated watering',
    'Soil health monitoring',
    'Plant care notification system',
    'Agricultural field monitoring',
    'Garden moisture alert system',
    'Indoor plant watering system',
    'Smart flower pot',
    'Hydroponics system moisture control',
    'Orchard irrigation optimization',
    'Landscape maintenance automation',
  ],
  'flame sensor': [
    'Fire alarm system',
    'Flame-sensing robot',
    'Industrial safety monitor',
    'Kitchen fire detection system',
    'Camping safety flame monitor',
    'Laboratory flame hazard alert',
    'Gas stove flame monitor',
    'BBQ grill safety monitor',
    'Oil refinery flame alert',
    'Candle flame detector',
    'Emergency flame suppression trigger',
  ],
  'touch sensor': [
    'Touch-activated lamp',
    'Interactive panels',
    'Smart home controls',
    'Touch-based game controller',
    'Museum interactive exhibits',
    'Gesture or tap-based vending machine',
    'Touch piano or instrument',
    'Elevator touch button panel',
    'Touch-sensitive robot interface',
    'Interactive learning board',
    'Digital art canvas',
  ],
  'smoke gas sensor': [
    'Air quality monitor',
    'Fire alarm',
    'Gas leak detection',
    'Indoor pollution monitoring',
    'Smart kitchen safety system',
    'Industrial emission monitoring',
    'Vehicle emission detection',
    'Carbon monoxide detector',
    'Smart HVAC air quality control',
    'Laboratory chemical leak alert',
    'Smart home ventilation trigger',
  ],
  'RFID sensor': [
    'Attendance tracking',
    'Inventory management',
    'Access control system',
    'Library book tracking',
    'Pet identification system',
    'Cashless cafeteria system',
    'Warehouse tracking system',
    'Event ticketing system',
    'Supply chain monitoring',
    'Parking lot vehicle tracking',
    'Equipment checkout system',
  ],
};

/// 🔹 MAIN SCREEN
class ClassInfoScreen extends StatelessWidget {
  const ClassInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text(
          'Class Information',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0A2540),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: darkBlue,
      ),
      body: Consumer<ClassificationProvider>(
        builder: (context, provider, child) {
          if (provider.classLabels.isEmpty) {
            return const _EmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.classLabels.length,
            itemBuilder: (context, index) {
              final className = provider.classLabels[index];

              final prediction = provider.allPredictions
                  .where((p) => p.className == className)
                  .toList();
              final confidence = prediction.isNotEmpty
                  ? prediction.first.confidence
                  : 0.0;

              return _ClassInfoCard(
                className: className,
                description:
                    classDescriptions[className] ?? 'No description available.',
                confidence: confidence,
              );
            },
          );
        },
      ),
    );
  }
}

/// 🔹 EMPTY STATE
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No class data available',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Start classifying images to see class information',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

/// 🔹 CLASS CARD (COLLAPSIBLE)
class _ClassInfoCard extends StatefulWidget {
  final String className;
  final String description;
  final double confidence;

  const _ClassInfoCard({
    required this.className,
    required this.description,
    required this.confidence,
  });

  @override
  State<_ClassInfoCard> createState() => _ClassInfoCardState();
}

class _ClassInfoCardState extends State<_ClassInfoCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          /// HEADER IMAGE
          Container(
            height: 160,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Image.asset(
                classImages[widget.className] ?? '',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.sensors, size: 72, color: darkBlue),
                ),
              ),
            ),
          ),

          /// COLLAPSIBLE BODY
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// CLASS NAME + ICON
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.className,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: darkBlue,
                        ),
                      ),
                      Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: darkBlue,
                        size: 28,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  /// EXPANDED CONTENT
                  AnimatedCrossFade(
                    firstChild: const SizedBox.shrink(),
                    secondChild: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Category',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: darkBlue,
                              ),
                            ),
                            Text(
                              sensorCategories[widget.className] ??
                                  'Unknown Category',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: tealBlue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        /// VIEW EXAMPLES BUTTON
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SensorProjectIdeasScreen(
                                  className: widget.className,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: buttonGradient,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Center(
                              child: Text(
                                'Project Ideas',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    crossFadeState: _isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 🔹 SENSOR PROJECT IDEAS SCREEN (DYNAMIC ICONS, STYLED LIKE CLASS CARDS)
class SensorProjectIdeasScreen extends StatelessWidget {
  final String className;

  const SensorProjectIdeasScreen({super.key, required this.className});

  /// Map sensor types to icons
  IconData _getSensorIcon(String sensor) {
    switch (sensor.toLowerCase()) {
      case 'fingerprint sensor':
        return Icons.fingerprint;
      case 'ultrasonic sensor':
        return Icons.sensors; // can be customized further
      case 'water level sensor':
        return Icons.water_drop;
      case 'sound sensor':
        return Icons.volume_up;
      case 'humidity temperature sensor':
        return Icons.thermostat;
      case 'soil moisture sensor':
        return Icons.grass;
      case 'flame sensor':
        return Icons.local_fire_department;
      case 'touch sensor':
        return Icons.touch_app;
      case 'smoke gas sensor':
        return Icons.air;
      case 'rfid sensor':
        return Icons.nfc;
      default:
        return Icons.lightbulb_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ideas = sensorProjectIdeas[className] ?? [];
    final icon = _getSensorIcon(className);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$className Project Ideas',
          style: const TextStyle(
            color: darkBlue, // keeps the text color dark
            fontSize: 16, // smaller font size
            fontWeight: FontWeight.bold, // optional
          ),
        ),
        backgroundColor: Colors.white, // white AppBar
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: darkBlue), // back button color
      ),

      backgroundColor: const Color(0xFFF6F8FB),
      body: ideas.isEmpty
          ? const Center(
              child: Text(
                'No project ideas available',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: ideas.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// HEADER WITH DYNAMIC ICON
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(15),
                          ),
                          gradient: LinearGradient(
                            colors: [
                              tealBlue.withValues(alpha: 0.7),
                              darkBlue.withValues(alpha: 0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Icon(icon, size: 36, color: Colors.white),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Project Idea ${index + 1}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      /// BODY
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          ideas[index],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
