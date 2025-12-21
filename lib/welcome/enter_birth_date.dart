import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';

class EnterBirthDate extends StatefulWidget {
  const EnterBirthDate({Key? key}) : super(key: key);

  @override
  State<EnterBirthDate> createState() => _EnterBirthDateState();
}

class _EnterBirthDateState extends State<EnterBirthDate> {
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    // Title
                    const Text(
                      'Enter your Birth Date?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Date input
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF383840),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.white54,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _dateController,
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(8), // mmddyyyy
                                _DateTextInputFormatter(),
                              ],
                              decoration: const InputDecoration(
                                hintText: 'mm/dd/yyyy',
                                hintStyle: TextStyle(color: Colors.white54),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Next button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF3F80),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    final dateText = _dateController.text.trim();
                    if (dateText.isNotEmpty && dateText.length == 10) {
                      try {
                        final parts = dateText.split('/');
                        final date = DateTime(int.parse(parts[2]), int.parse(parts[0]), int.parse(parts[1]));
                        Provider.of<ProfileProvider>(context, listen: false).setBirthDate(date);
                        Navigator.pushNamed(context, '/your_gender');
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Invalid date format')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter your birth date')),
                      );
                    }
                  },
                  child: const Text(
                    'Next',
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
      ),
    );
  }
}

class _DateTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Keep only digits and cap to 8 (mmddyyyy)
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final capped = digitsOnly.length > 8 ? digitsOnly.substring(0, 8) : digitsOnly;

    String formatted;
    if (capped.length <= 2) {
      formatted = capped; // m, mm
    } else if (capped.length <= 4) {
      formatted = '${capped.substring(0, 2)}/${capped.substring(2)}'; // mm/dd
    } else {
      // mm/dd/yyyy (partial allowed)
      final mm = capped.substring(0, 2);
      final dd = capped.substring(2, 4);
      final yyyy = capped.substring(4);
      formatted = '$mm/$dd/$yyyy';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

