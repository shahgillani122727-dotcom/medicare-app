import 'package:flutter/material.dart';

void main() {
  runApp(const MediCareApp());
}

class MediCareApp extends StatelessWidget {
  const MediCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediCare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF185FA5)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  bool _highContrast = false;

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
  }

  List<Widget> get screens => [
    HomeScreen(highContrast: _highContrast),
    MedicationsScreen(highContrast: _highContrast),
    AppointmentsScreen(highContrast: _highContrast),
    VitalsScreen(highContrast: _highContrast),
    ProfileScreen(
      highContrast: _highContrast,
      onContrastToggle: (val) => setState(() => _highContrast = val),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bg = _highContrast ? Colors.black : Colors.white;
    final primary = _highContrast ? const Color(0xFFFFE566) : const Color(0xFF185FA5);
    final textCol = _highContrast ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: _highContrast ? Colors.black : const Color(0xFFF0F4F8),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: bg,
        selectedItemColor: primary,
        unselectedItemColor: _highContrast ? Colors.grey[600] : Colors.grey[400],
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 10),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.medication_rounded), label: 'Meds'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_rounded), label: 'Appts'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_rounded), label: 'Vitals'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}

// ─── HOME SCREEN ────────────────────────────────────────────────
class HomeScreen extends StatelessWidget {
  final bool highContrast;
  const HomeScreen({super.key, required this.highContrast});

  @override
  Widget build(BuildContext context) {
    final bg = highContrast ? Colors.black : const Color(0xFFF0F4F8);
    final cardBg = highContrast ? const Color(0xFF1A1A1A) : Colors.white;
    final textPrimary = highContrast ? Colors.white : const Color(0xFF111111);
    final textSec = highContrast ? Colors.grey[400]! : const Color(0xFF6B7280);
    final primary = highContrast ? const Color(0xFFFFE566) : const Color(0xFF185FA5);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: highContrast ? Colors.black : Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Good morning ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textPrimary)),
            Text('Monday, 30 March 2026',
                style: TextStyle(fontSize: 12, color: textSec)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: const Color(0xFFDBEAFE),
              child: Text('SG',
                  style: const TextStyle(color: Color(0xFF1E40AF), fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Hero Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: highContrast ? const Color(0xFFFFE566) : const Color(0xFF185FA5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello, Shahmeer!',
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w700,
                        color: highContrast ? Colors.black : Colors.white)),
                const SizedBox(height: 4),
                Text('2 medications due · 1 appointment tomorrow',
                    style: TextStyle(
                        fontSize: 13,
                        color: highContrast ? Colors.black87 : Colors.white70)),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('🎙 Voice command activated!')),
                    );
                  },
                  icon: const Icon(Icons.mic_rounded),
                  label: const Text('Tap to speak a command'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: highContrast ? Colors.black : Colors.white.withOpacity(0.2),
                    foregroundColor: highContrast ? const Color(0xFFFFE566) : Colors.white,
                    minimumSize: const Size(double.infinity, 46),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Vitals Grid
          _SectionTitle(title: "TODAY'S VITALS", highContrast: highContrast),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.6,
            children: [
              _VitalBox(label: 'Heart rate · bpm', value: '72', hc: highContrast),
              _VitalBox(label: 'Blood pressure', value: '120/80', hc: highContrast),
              _VitalBox(label: 'Temperature · F', value: '98.4°', hc: highContrast),
              _VitalBox(label: 'SpO2', value: '99%', hc: highContrast),
            ],
          ),
          const SizedBox(height: 16),

          // Next Appointment
          _SectionTitle(title: 'NEXT APPOINTMENT', highContrast: highContrast),
          const SizedBox(height: 8),
          _AppointmentCard(
            day: '31', month: 'MAR',
            doctor: 'Dr. Ahmed Khan',
            specialty: 'Cardiology · City Hospital',
            time: '10:30 AM · Room 4B',
            status: 'Confirmed', statusColor: Colors.green,
            highContrast: highContrast,
          ),
          const SizedBox(height: 16),

          // Medications
          _SectionTitle(title: 'MEDICATIONS DUE', highContrast: highContrast),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: highContrast ? const Color(0xFFFFE566) : const Color(0xFFE5E7EB), width: highContrast ? 2 : 1),
            ),
            child: Column(
              children: [
                _MedTile(name: 'Metformin 500mg', sub: 'Twice daily · With meals',
                    status: 'Taken ✓', statusColor: Colors.green, hc: highContrast),
                Divider(height: 1, color: highContrast ? Colors.grey[800] : const Color(0xFFF3F4F6)),
                _MedTile(name: 'Lisinopril 10mg', sub: 'Once daily · Morning',
                    status: 'Due now!', statusColor: Colors.red, hc: highContrast),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

// ─── MEDICATIONS SCREEN ─────────────────────────────────────────
class MedicationsScreen extends StatefulWidget {
  final bool highContrast;
  const MedicationsScreen({super.key, required this.highContrast});

  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  bool metforminTaken = true;
  bool lisinoprilTaken = false;
  bool soundAlert = true;
  bool vibration = true;

  @override
  Widget build(BuildContext context) {
    final bg = widget.highContrast ? Colors.black : const Color(0xFFF0F4F8);
    final cardBg = widget.highContrast ? const Color(0xFF1A1A1A) : Colors.white;
    final textPrimary = widget.highContrast ? Colors.white : const Color(0xFF111111);
    final primary = widget.highContrast ? const Color(0xFFFFE566) : const Color(0xFF185FA5);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: widget.highContrast ? Colors.black : Colors.white,
        elevation: 0,
        title: Text('My Medications',
            style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 19)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('🎙 Reading medications aloud...')),
                );
              },
              icon: const Icon(Icons.volume_up_rounded, size: 16),
              label: const Text('Read aloud', style: TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDBEAFE),
                foregroundColor: const Color(0xFF1E40AF),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Metformin
          _MedDetailCard(
            name: 'Metformin 500mg',
            sub: 'Twice daily · With meals',
            icon: Icons.medication_rounded,
            iconBg: const Color(0xFFFEF9C3),
            iconColor: const Color(0xFF92400E),
            accentColor: Colors.green,
            taken: metforminTaken,
            nextDose: 'Next: 6:00 PM with dinner',
            hc: widget.highContrast,
            onTake: () => setState(() => metforminTaken = !metforminTaken),
          ),
          const SizedBox(height: 12),
          // Lisinopril
          _MedDetailCard(
            name: 'Lisinopril 10mg',
            sub: 'Once daily · Morning',
            icon: Icons.vaccines_rounded,
            iconBg: const Color(0xFFFEE2E2),
            iconColor: const Color(0xFFB91C1C),
            accentColor: Colors.red,
            taken: lisinoprilTaken,
            nextDose: 'Due now · Morning dose',
            hc: widget.highContrast,
            onTake: () => setState(() => lisinoprilTaken = !lisinoprilTaken),
          ),
          const SizedBox(height: 12),
          // Atorvastatin
          _MedDetailCard(
            name: 'Atorvastatin 20mg',
            sub: 'Once daily · Night',
            icon: Icons.local_hospital_rounded,
            iconBg: const Color(0xFFFEF9C3),
            iconColor: const Color(0xFF854D0E),
            accentColor: Colors.amber,
            taken: false,
            nextDose: 'Tonight at 10:00 PM',
            hc: widget.highContrast,
            onTake: () {},
          ),
          const SizedBox(height: 16),
          // Reminder Settings
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.highContrast ? const Color(0xFF1A1A1A) : const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(14),
              border: widget.highContrast ? Border.all(color: const Color(0xFFFFE566), width: 2) : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🔔 Reminder Settings',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700,
                        color: widget.highContrast ? const Color(0xFFFFE566) : const Color(0xFF1E40AF))),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Sound alert', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: widget.highContrast ? Colors.white : Colors.black)),
                      Text('Audible notification', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                    ]),
                    Switch(value: soundAlert, onChanged: (v) => setState(() => soundAlert = v),
                        activeColor: widget.highContrast ? const Color(0xFFFFE566) : const Color(0xFF185FA5)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Vibration', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: widget.highContrast ? Colors.white : Colors.black)),
                      Text('Haptic feedback', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                    ]),
                    Switch(value: vibration, onChanged: (v) => setState(() => vibration = v),
                        activeColor: widget.highContrast ? const Color(0xFFFFE566) : const Color(0xFF185FA5)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

// ─── APPOINTMENTS SCREEN ────────────────────────────────────────
class AppointmentsScreen extends StatefulWidget {
  final bool highContrast;
  const AppointmentsScreen({super.key, required this.highContrast});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  String selectedSpecialty = 'Cardiology';
  String selectedTime = '10:30';

  @override
  Widget build(BuildContext context) {
    final bg = widget.highContrast ? Colors.black : const Color(0xFFF0F4F8);
    final textPrimary = widget.highContrast ? Colors.white : const Color(0xFF111111);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: widget.highContrast ? Colors.black : Colors.white,
        elevation: 0,
        title: Text('Appointments',
            style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 19)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF185FA5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('+ Book new', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionTitle(title: 'UPCOMING', highContrast: widget.highContrast),
          const SizedBox(height: 8),
          _AppointmentCard(
            day: '31', month: 'MAR',
            doctor: 'Dr. Ahmed Khan',
            specialty: 'Cardiology · City Hospital',
            time: '10:30 AM · Room 4B',
            status: 'Confirmed', statusColor: Colors.green,
            highContrast: widget.highContrast,
          ),
          const SizedBox(height: 10),
          _AppointmentCard(
            day: '05', month: 'APR',
            doctor: 'Dr. Fatima Ali',
            specialty: 'Endocrinology · Telehealth',
            time: '2:00 PM · Online',
            status: 'Online', statusColor: Colors.amber,
            highContrast: widget.highContrast,
          ),
          const SizedBox(height: 16),
          _SectionTitle(title: 'BOOK AN APPOINTMENT', highContrast: widget.highContrast),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.highContrast ? const Color(0xFF1A1A1A) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: widget.highContrast ? Border.all(color: const Color(0xFFFFE566), width: 2) : Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select specialty', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey[500])),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: ['Cardiology', 'Endocrinology', 'General', 'Dermatology'].map((s) {
                    final sel = selectedSpecialty == s;
                    return GestureDetector(
                      onTap: () => setState(() => selectedSpecialty = s),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: sel ? const Color(0xFFDBEAFE) : (widget.highContrast ? const Color(0xFF2A2A2A) : const Color(0xFFF9FAFB)),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: sel ? const Color(0xFF185FA5) : const Color(0xFFE5E7EB), width: sel ? 2 : 1),
                        ),
                        child: Text(s, style: TextStyle(fontSize: 13, fontWeight: sel ? FontWeight.w700 : FontWeight.w500, color: sel ? const Color(0xFF1E40AF) : (widget.highContrast ? Colors.white : Colors.black87))),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                Text('Preferred date', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey[500])),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    borderRadius: BorderRadius.circular(11),
                    color: widget.highContrast ? const Color(0xFF2A2A2A) : Colors.white,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 18, color: Color(0xFF185FA5)),
                      const SizedBox(width: 10),
                      Text('31 March 2026', style: TextStyle(fontSize: 14, color: widget.highContrast ? Colors.white : Colors.black87, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Text('Available time slots', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey[500])),
                const SizedBox(height: 8),
                GridView.count(
                  crossAxisCount: 3, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 7, mainAxisSpacing: 7, childAspectRatio: 2.2,
                  children: [
                    _TimeSlot(time: '9:00', available: false, selected: false, onTap: () {}, hc: widget.highContrast),
                    _TimeSlot(time: '10:30', available: true, selected: selectedTime == '10:30', onTap: () => setState(() => selectedTime = '10:30'), hc: widget.highContrast),
                    _TimeSlot(time: '11:00', available: true, selected: selectedTime == '11:00', onTap: () => setState(() => selectedTime = '11:00'), hc: widget.highContrast),
                    _TimeSlot(time: '2:00', available: true, selected: selectedTime == '2:00', onTap: () => setState(() => selectedTime = '2:00'), hc: widget.highContrast),
                    _TimeSlot(time: '3:30', available: false, selected: false, onTap: () {}, hc: widget.highContrast),
                    _TimeSlot(time: '4:00', available: true, selected: selectedTime == '4:00', onTap: () => setState(() => selectedTime = '4:00'), hc: widget.highContrast),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('✅ Appointment booked: $selectedSpecialty at $selectedTime')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF185FA5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Confirm Booking', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

// ─── VITALS SCREEN ──────────────────────────────────────────────
class VitalsScreen extends StatefulWidget {
  final bool highContrast;
  const VitalsScreen({super.key, required this.highContrast});

  @override
  State<VitalsScreen> createState() => _VitalsScreenState();
}

class _VitalsScreenState extends State<VitalsScreen> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bg = widget.highContrast ? Colors.black : const Color(0xFFF0F4F8);
    final textPrimary = widget.highContrast ? Colors.white : const Color(0xFF111111);
    final cardBg = widget.highContrast ? const Color(0xFF1A1A1A) : Colors.white;

    final weekData = [
      {'day': 'Mon', 'val': 68},
      {'day': 'Tue', 'val': 74},
      {'day': 'Wed', 'val': 71},
      {'day': 'Thu', 'val': 80},
      {'day': 'Fri', 'val': 76},
      {'day': 'Sat', 'val': 70},
      {'day': 'Sun', 'val': 72},
    ];

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: widget.highContrast ? Colors.black : Colors.white,
        elevation: 0,
        title: Text('Health Vitals',
            style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 19)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('● Live', style: TextStyle(color: Color(0xFF1E40AF), fontSize: 12, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GridView.count(
            crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.4,
            children: [
              _BigVitalBox(label: 'Heart rate', value: '72', unit: 'bpm', status: 'Normal', statusOk: true, hc: widget.highContrast),
              _BigVitalBox(label: 'Blood pressure', value: '120/80', unit: 'mmHg', status: 'Normal', statusOk: true, hc: widget.highContrast),
              _BigVitalBox(label: 'Temperature', value: '98.4°', unit: 'F', status: 'Normal', statusOk: true, hc: widget.highContrast),
              _BigVitalBox(label: 'SpO2', value: '99', unit: '%', status: 'Normal', statusOk: true, hc: widget.highContrast),
            ],
          ),
          const SizedBox(height: 16),
          _SectionTitle(title: 'WEEKLY HEART RATE TREND', highContrast: widget.highContrast),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg, borderRadius: BorderRadius.circular(16),
              border: widget.highContrast ? Border.all(color: const Color(0xFFFFE566), width: 2) : Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              children: weekData.map((d) {
                final pct = (d['val'] as int) / 100;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      SizedBox(width: 32, child: Text(d['day'] as String, style: TextStyle(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.w600))),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: pct,
                            minHeight: 11,
                            backgroundColor: widget.highContrast ? const Color(0xFF333333) : const Color(0xFFF3F4F6),
                            valueColor: AlwaysStoppedAnimation<Color>(widget.highContrast ? const Color(0xFF60A5FA) : const Color(0xFF185FA5)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 28,
                        child: Text('${d['val']}', style: const TextStyle(fontSize: 11, color: Color(0xFF1E40AF), fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          _SectionTitle(title: 'LOG NEW READING', highContrast: widget.highContrast),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg, borderRadius: BorderRadius.circular(16),
              border: widget.highContrast ? Border.all(color: const Color(0xFFFFE566), width: 2) : Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  style: TextStyle(color: textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Enter value (e.g. 72)',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(11), borderSide: const BorderSide(color: Color(0xFF185FA5), width: 2)),
                    filled: true,
                    fillColor: widget.highContrast ? const Color(0xFF2A2A2A) : Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('✅ Reading saved: ${_controller.text}')),
                      );
                      _controller.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF185FA5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Save reading', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

// ─── PROFILE SCREEN ─────────────────────────────────────────────
class ProfileScreen extends StatefulWidget {
  final bool highContrast;
  final ValueChanged<bool> onContrastToggle;
  const ProfileScreen({super.key, required this.highContrast, required this.onContrastToggle});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool voiceCommands = true;
  bool screenReader = false;
  bool hapticAlerts = true;
  int fontSize = 2; // 0=S 1=M 2=L 3=XL

  @override
  Widget build(BuildContext context) {
    final bg = widget.highContrast ? Colors.black : const Color(0xFFF0F4F8);
    final cardBg = widget.highContrast ? const Color(0xFF1A1A1A) : Colors.white;
    final textPrimary = widget.highContrast ? Colors.white : const Color(0xFF111111);
    final borderColor = widget.highContrast ? const Color(0xFFFFE566) : const Color(0xFFE5E7EB);
    final primary = widget.highContrast ? const Color(0xFFFFE566) : const Color(0xFF185FA5);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: widget.highContrast ? Colors.black : Colors.white,
        elevation: 0,
        title: Text('My Profile', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 19)),
        actions: [
          TextButton(onPressed: () {}, child: Text('Edit', style: TextStyle(color: primary, fontWeight: FontWeight.w700))),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Avatar
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color(0xFFDBEAFE),
                  child: const Text('SG', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Color(0xFF1E40AF))),
                ),
                const SizedBox(height: 10),
                Text('Shahmeer Gillani', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: textPrimary)),
                const SizedBox(height: 4),
                Text('Patient ID: #MED-2024-0831', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: [
                    _Badge(label: 'Blood: O+', color: const Color(0xFFDBEAFE), textColor: const Color(0xFF1D4ED8)),
                    _Badge(label: 'Age: 24', color: const Color(0xFFDCFCE7), textColor: const Color(0xFF15803D)),
                    _Badge(label: 'Diabetic', color: const Color(0xFFFEF9C3), textColor: const Color(0xFF92400E)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Accessibility Settings
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg, borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: widget.highContrast ? 2 : 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Accessibility Settings', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary)),
                const SizedBox(height: 12),
                _SettingRow(label: 'Voice commands', sub: 'Hands-free control', value: voiceCommands, onChanged: (v) => setState(() => voiceCommands = v), hc: widget.highContrast),
                _SettingRow(label: 'Screen reader', sub: 'VoiceOver / TalkBack', value: screenReader, onChanged: (v) => setState(() => screenReader = v), hc: widget.highContrast),
                _SettingRow(label: 'High contrast mode', sub: 'Better visibility', value: widget.highContrast, onChanged: widget.onContrastToggle, hc: widget.highContrast),
                _SettingRow(label: 'Haptic alerts', sub: 'Vibration reminders', value: hapticAlerts, onChanged: (v) => setState(() => hapticAlerts = v), hc: widget.highContrast),
                const SizedBox(height: 8),
                Text('Text size', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary)),
                const SizedBox(height: 8),
                Row(
                  children: ['S', 'M', 'L', 'XL'].asMap().entries.map((e) {
                    final sel = fontSize == e.key;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => fontSize = e.key),
                        child: Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: BoxDecoration(
                            color: sel ? const Color(0xFF185FA5) : (widget.highContrast ? const Color(0xFF2A2A2A) : const Color(0xFFF9FAFB)),
                            borderRadius: BorderRadius.circular(9),
                            border: Border.all(color: sel ? const Color(0xFF185FA5) : const Color(0xFFE5E7EB)),
                          ),
                          child: Center(child: Text(e.value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: sel ? Colors.white : (widget.highContrast ? Colors.white : Colors.grey[600])))),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Emergency Contacts
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg, borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: widget.highContrast ? 2 : 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Emergency Contacts', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary)),
                const SizedBox(height: 12),
                _ContactRow(name: 'Ali Gillani (Brother)', phone: '+92 300 1234567', hc: widget.highContrast),
                const Divider(),
                _ContactRow(name: 'Dr. Ahmed Khan', phone: '+92 21 9876543', hc: widget.highContrast),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

// ─── REUSABLE WIDGETS ───────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String title;
  final bool highContrast;
  const _SectionTitle({required this.title, required this.highContrast});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
        color: highContrast ? Colors.grey[400] : const Color(0xFF9CA3AF), letterSpacing: 0.06));
  }
}

class _VitalBox extends StatelessWidget {
  final String label, value;
  final bool hc;
  const _VitalBox({required this.label, required this.value, required this.hc});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: hc ? const Color(0xFF1A1A1A) : const Color(0xFFEFF6FF),
        border: Border.all(color: hc ? const Color(0xFF60A5FA) : const Color(0xFFBFDBFE)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: hc ? const Color(0xFF60A5FA) : const Color(0xFF1E40AF))),
          const SizedBox(height: 3),
          Text(label, style: TextStyle(fontSize: 10, color: hc ? const Color(0xFF93C5FD) : const Color(0xFF3B82F6), fontWeight: FontWeight.w500), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _BigVitalBox extends StatelessWidget {
  final String label, value, unit, status;
  final bool statusOk, hc;
  const _BigVitalBox({required this.label, required this.value, required this.unit, required this.status, required this.statusOk, required this.hc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: hc ? const Color(0xFF1A1A1A) : const Color(0xFFF9FAFB),
        border: Border.all(color: hc ? const Color(0xFF60A5FA) : const Color(0xFFF3F4F6)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: hc ? Colors.white : Colors.black)),
          Text(unit, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
          const SizedBox(height: 5),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: statusOk ? Colors.green[700] : Colors.red[700])),
        ],
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final String day, month, doctor, specialty, time, status;
  final Color statusColor;
  final bool highContrast;
  const _AppointmentCard({required this.day, required this.month, required this.doctor, required this.specialty, required this.time, required this.status, required this.statusColor, required this.highContrast});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: highContrast ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: highContrast ? const Color(0xFFFFE566) : const Color(0xFFE5E7EB), width: highContrast ? 2 : 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
            decoration: BoxDecoration(
              color: highContrast ? const Color(0xFF2A2A2A) : const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(day, style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700, color: highContrast ? const Color(0xFFFFE566) : const Color(0xFF1E40AF))),
                Text(month, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: highContrast ? const Color(0xFFFFE566) : const Color(0xFF3B82F6))),
              ],
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doctor, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: highContrast ? Colors.white : Colors.black)),
                const SizedBox(height: 2),
                Text(specialty, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                const SizedBox(height: 6),
                Text(time, style: const TextStyle(fontSize: 12, color: Color(0xFF185FA5), fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: statusColor[700])),
          ),
        ],
      ),
    );
  }
}

class _MedTile extends StatelessWidget {
  final String name, sub, status;
  final Color statusColor;
  final bool hc;
  const _MedTile({required this.name, required this.sub, required this.status, required this.statusColor, required this.hc});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.medication_rounded, color: statusColor[600]),
      title: Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: hc ? Colors.white : Colors.black)),
      subtitle: Text(sub, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: statusColor.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
        child: Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: statusColor[700])),
      ),
    );
  }
}

class _MedDetailCard extends StatelessWidget {
  final String name, sub, nextDose;
  final IconData icon;
  final Color iconBg, iconColor, accentColor;
  final bool taken, hc;
  final VoidCallback onTake;
  const _MedDetailCard({required this.name, required this.sub, required this.icon, required this.iconBg, required this.iconColor, required this.accentColor, required this.taken, required this.nextDose, required this.hc, required this.onTake});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: hc ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: const BorderRadius.only(topRight: Radius.circular(16), bottomRight: Radius.circular(16)),
        border: Border(
          left: BorderSide(color: accentColor, width: 4),
          top: BorderSide(color: hc ? const Color(0xFF333333) : const Color(0xFFE5E7EB)),
          right: BorderSide(color: hc ? const Color(0xFF333333) : const Color(0xFFE5E7EB)),
          bottom: BorderSide(color: hc ? const Color(0xFF333333) : const Color(0xFFE5E7EB)),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: hc ? Colors.white : Colors.black)),
                  Text(sub, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                ]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: taken ? Colors.green.withOpacity(0.12) : Colors.red.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
                child: Text(taken ? 'Taken ✓' : 'Due now!', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: taken ? Colors.green[700] : Colors.red[700])),
              ),
            ],
          ),
          if (!taken) ...[
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: ElevatedButton(
                onPressed: onTake,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF185FA5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                child: const Text('Mark as taken', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              )),
              const SizedBox(width: 8),
              Expanded(child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                child: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w700)),
              )),
            ]),
          ],
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(color: hc ? const Color(0xFF2A2A2A) : const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              Icon(Icons.access_time_rounded, size: 14, color: Colors.grey[500]),
              const SizedBox(width: 6),
              Text(nextDose, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
            ]),
          ),
        ],
      ),
    );
  }
}

class _TimeSlot extends StatelessWidget {
  final String time;
  final bool available, selected, hc;
  final VoidCallback onTap;
  const _TimeSlot({required this.time, required this.available, required this.selected, required this.hc, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: available ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF185FA5) : (available ? (hc ? const Color(0xFF2A2A2A) : Colors.white) : const Color(0xFFF9FAFB)),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? const Color(0xFF185FA5) : const Color(0xFFE5E7EB), width: selected ? 2 : 1),
        ),
        child: Center(
          child: Text(time, style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700,
              color: selected ? Colors.white : (available ? (hc ? Colors.white : Colors.black87) : Colors.grey[400]))),
        ),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final String label, sub;
  final bool value, hc;
  final ValueChanged<bool> onChanged;
  const _SettingRow({required this.label, required this.sub, required this.value, required this.onChanged, required this.hc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: hc ? Colors.white : Colors.black)),
            Text(sub, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
          ]),
          Switch(value: value, onChanged: onChanged, activeColor: hc ? const Color(0xFFFFE566) : const Color(0xFF185FA5)),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final String name, phone;
  final bool hc;
  const _ContactRow({required this.name, required this.phone, required this.hc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const CircleAvatar(radius: 18, backgroundColor: Color(0xFFDBEAFE), child: Icon(Icons.person, color: Color(0xFF1E40AF), size: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: hc ? Colors.white : Colors.black)),
              Text(phone, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
            ]),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDBEAFE), elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            child: const Text('Call', style: TextStyle(color: Color(0xFF1E40AF), fontSize: 12, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color, textColor;
  const _Badge({required this.label, required this.color, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textColor)),
    );
  }
}
