import 'package:first_pro/api/api.dart';
import 'package:first_pro/utils/error_handler.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class EditWorkoutPlanPage extends StatefulWidget {
  final String userEmail;
  final Map<String, dynamic> initialWorkoutSplit;

  const EditWorkoutPlanPage({
    super.key,
    required this.userEmail,
    required this.initialWorkoutSplit,
  });

  @override
  State<EditWorkoutPlanPage> createState() => _EditWorkoutPlanPageState();
}

class _EditWorkoutPlanPageState extends State<EditWorkoutPlanPage> {
  late Map<String, String> _currentSplit;
  bool _isLoading = false;
  final List<String> _muscleGroups = ['Chest', 'Back', 'Legs', 'Shoulders', 'Arms', 'Rest'];
  final List<String> _daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  @override
  void initState() {
    super.initState();
    // Convert the dynamic map to a <String, String> map for type safety
    _currentSplit = Map<String, String>.from(widget.initialWorkoutSplit);
  }

  Future<void> _saveWorkoutSplit() async {
    setState(() => _isLoading = true);
    try {
      await updateWorkoutSplit(email: widget.userEmail, newSplit: _currentSplit);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Workout plan saved successfully!'),
            backgroundColor: Color(0xFF00CBA9),
          ),
        );
        Navigator.of(context).pop(); // Go back to the user page
      }
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141A28),
      body: Stack(
        children: [
          Container( // Animated background
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF141A28), Color(0xFF004D40)],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _daysOfWeek.length,
                    itemBuilder: (context, index) {
                      final day = _daysOfWeek[index];
                      return _buildDayEditor(day);
                    },
                  ),
                ),
                _buildSaveButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: [
          BackButton(color: Colors.white),
          const Text(
            "Customize Your Week",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayEditor(String day) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  day,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Theme(
                  data: Theme.of(context).copyWith(canvasColor: const Color(0xFF2A344D)),
                  child: DropdownButton<String>(
                    value: _currentSplit[day],
                    icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF00CBA9)),
                    underline: const SizedBox(),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    onChanged: (String? newValue) {
                      setState(() {
                        _currentSplit[day] = newValue!;
                      });
                    },
                    items: _muscleGroups.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveWorkoutSplit,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00CBA9),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: _isLoading
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
            : const Text("Save Plan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

