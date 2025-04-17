import 'package:flutter/material.dart';
import 'package:phase_1_app/utils/config.dart';

class UBDPage extends StatefulWidget {
  const UBDPage({super.key});

  @override
  State<UBDPage> createState() => _UBDPageState();
}

class _UBDPageState extends State<UBDPage> {
  final TextEditingController tddController = TextEditingController();
  final TextEditingController wtController = TextEditingController();
  final TextEditingController tbgController = TextEditingController();

  double latestUBD = 0.0;
  double LIT = 0;
  DateTime? lastUBDUpdate;

  String? selectedActivity;
  String? selectedMeal;

  bool isValidTDD = false;
  bool isValidWeight = false;
  bool isValidTBG = false;

  final Map<String, int> activityValues = {
    'Sleeping': 6, 'Slow Walking': 8, 'Light Yoga': 10,
    'Casual Cycling': 12, 'Jogging': 14, 'Running': 16,
    'Training': 18, 'Weightlifting': 20, 'Swimming': 22,
    'Hiking': 24, 'Biking': 16, 'Dancing': 14, 'Boxing': 26,
    'HIIT': 30, 'Pilates': 12, 'Zumba': 14, 'Rock Climbing': 28,
    'Martial Arts': 22, 'Crossfit': 25, 'Rowing': 20, 'Skating': 18,
  };

  final Map<String, int> mealValues = {
    'Rice with Dal': 55, 'Rice with Chicken Curry': 70,
    'Rice with Paneer Butter Masala': 80, 'Rice with Vegetable Curry': 65,
    'Pasta with Pesto': 50, 'Pasta with Marinara Sauce': 45,
    'Fruit Salad with Yogurt': 30, 'Chapati with Dal': 50,
    'Chapati with Chicken Curry': 60, 'Chapati with Paneer Curry': 65,
    'Naan with Butter Chicken': 75, 'Biryani with Raita': 85,
    'Biryani with Chicken': 90, 'Butter Chicken with Naan': 85,
  };

  void _validateInputs() {
    setState(() {
      double? tdd = double.tryParse(tddController.text);
      double? weight = double.tryParse(wtController.text);
      double? tbg = double.tryParse(tbgController.text);

      isValidTDD = tdd != null && tdd >= 40 && tdd <= 500;
      isValidWeight = weight != null && weight >= 2.5 && weight <= 400;
      isValidTBG = tbg != null && tbg >= 20 && tbg <= 50;
    });
  }

  Widget _buildInputField(TextEditingController controller, String label, double min, double max) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter $label',
            border: const OutlineInputBorder(),
            errorText: (controller.text.isNotEmpty &&
                    (double.tryParse(controller.text) == null ||
                        double.parse(controller.text) < min ||
                        double.parse(controller.text) > max))
                ? 'Value must be between $min and $max'
                : null,
          ),
          onChanged: (value) => _validateInputs(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDropdownField(Map<String, int> values, String? selectedValue, String label, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: InputDecoration(labelText: label),
      items: values.keys.map((String key) => DropdownMenuItem(value: key, child: Text(key))).toList(),
      onChanged: (val) {
        setState(() {
          onChanged(val);
        });
      },
    );
  }

  void _calculateAndShowUBD() async {
    final int CBG = 120;

    if (LIT == 0) {
      await _showLITPopup();
      return;
    }
    if (latestUBD == 0.0) {
      await _showLatestUBDPopup();
      return;
    }

    final double tdd = double.tryParse(tddController.text) ?? 0;
    final double wt = double.tryParse(wtController.text) ?? 0;
    final double valueOfMeal = mealValues[selectedMeal]!.toDouble();
    final double AM = (activityValues[selectedActivity] ?? 0) / 10;
    final double icAverage = ((500 / tdd) + (850 / wt)) / 2;
    final double fd = valueOfMeal / icAverage;
    final double SF = 1700 / tdd;
    final double TBG = double.tryParse(tbgController.text) ?? 0;
    final double CD = (CBG - TBG) / SF;
    final double iob = latestUBD * (1 - LIT / 5) * 0.2;
    final double ubd = (fd + CD - iob) * AM;

    latestUBD = ubd;
    lastUBDUpdate = DateTime.now();

    _showUBDConfirmationDialog(ubd.round());
  }

  void _showUBDConfirmationDialog(int ubd) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('UBD Confirmation'),
          content: Text('Your UBD is $ubd Units. Confirm dosage?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Reconsider'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Confirm', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showLITPopup() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter LIT Value'),
          content: TextField(
            onChanged: (value) {
              LIT = double.tryParse(value) ?? 0.0;
            },
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: "Enter LIT value"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                _calculateAndShowUBD();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _showLatestUBDPopup() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Enter Latest UBD Value'),
        content: TextField(
          onChanged: (value) {
            latestUBD = double.tryParse(value) ?? 0.0;
          },
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(hintText: "Enter latest UBD value"),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Confirm'),
            onPressed: () {
              Navigator.of(context).pop();
              _calculateAndShowUBD();
            },
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insulin UBD Calculation'),
        backgroundColor: Config.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildInputField(tddController, 'TDD', 40, 500),
            _buildInputField(wtController, 'Weight (kg)', 2.5, 400),
            const SizedBox(height: 7),
            const Text('Activity',style: TextStyle(fontWeight: FontWeight.bold),
            ), 
            _buildDropdownField(activityValues, selectedActivity, 'Activity', (val) {
              selectedActivity = val;
            }),
            const SizedBox(height: 15),
            const Text('Meal',style: TextStyle(fontWeight: FontWeight.bold),
              ),
            _buildDropdownField(mealValues, selectedMeal, 'Meal', (val) {
              selectedMeal = val;
            }),
            _buildInputField(tbgController, 'TBG', 20, 50),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateAndShowUBD,
              child: const Text('Proceed'),
            ),
          ],
        ),
      ),
    );
  }
}
