import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ImagePicker _picker = ImagePicker();
  final List<File?> _images = List.filled(6, null);
  
  // State for editable fields
  List<String> _selectedInterests = ['Photography', 'Tea', 'Travel'];
  String _selectedRelationshipGoal = 'Long-term partner';
  String _selectedLanguage = 'English';
  String _selectedSexualOrientation = 'Straight';

  Future<void> _pickImage(int index) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        setState(() {
          _images[index] = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showInterestsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _InterestsModal(
        selectedInterests: _selectedInterests,
        onSave: (interests) {
          setState(() {
            _selectedInterests = interests;
          });
        },
      ),
    );
  }

  void _showRelationshipGoalsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _RelationshipGoalsModal(
        selectedGoal: _selectedRelationshipGoal,
        onSelect: (goal) {
          setState(() {
            _selectedRelationshipGoal = goal;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showLanguageModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _LanguageModal(
        selectedLanguage: _selectedLanguage,
        onSelect: (language) {
          setState(() {
            _selectedLanguage = language;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showSexualOrientationModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _SexualOrientationModal(
        selectedOrientation: _selectedSexualOrientation,
        onSelect: (orientation) {
          setState(() {
            _selectedSexualOrientation = orientation;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildImageBox(int index, {bool isLarge = false}) {
    final isSmall = MediaQuery.of(context).size.width < 400;
    final double largeSize = isSmall ? 220 : 240;
    final double smallSize = isSmall ? 100 : 110;
    final double size = isLarge ? largeSize : smallSize;
    
    return GestureDetector(
      onTap: () => _pickImage(index),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.2), style: BorderStyle.solid, width: 2),
        ),
        child: _images[index] != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  _images[index]!,
                  fit: BoxFit.cover,
                ),
              )
            : Center(
                child: Icon(Icons.add, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), size: 40),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 400;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: scheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: scheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Edit Profile', style: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.bold)),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Photo grid layout
            SizedBox(
              height: isSmall ? 260 : 250,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Large photo box (left)
                  _buildImageBox(0, isLarge: true),
                  
                  SizedBox(width: isSmall ? 8 : 12),
                  
                  // Small photo boxes (right column)
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: _buildImageBox(1)),
                          ],
                        ),
                        SizedBox(height: isSmall ? 8 : 12),
                        Row(
                          children: [
                            Expanded(child: _buildImageBox(2)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),


            // Bottom 3 small boxes
            Row(
              children: [
                Expanded(child: _buildImageBox(3)),
                SizedBox(width: isSmall ? 8 : 12),
                Expanded(child: _buildImageBox(4)),
                SizedBox(width: isSmall ? 8 : 12),
                Expanded(child: _buildImageBox(5)),
              ],
            ),

            const SizedBox(height: 20),

            _SettingTile(
              title: 'Interests',
              value: _selectedInterests.join(', '),
              onTap: () => _showInterestsModal(),
            ),

            _SettingTile(
              title: 'Relationship goals',
              value: _selectedRelationshipGoal,
              showArrow: true,
              onTap: () => _showRelationshipGoalsModal(),
            ),

            _SettingTile(
              title: 'language I know',
              value: _selectedLanguage,
              showArrow: true,
              onTap: () => _showLanguageModal(),
            ),

            _SettingTile(
              title: 'Sexual Orientation',
              value: _selectedSexualOrientation,
              showArrow: true,
              onTap: () => _showSexualOrientationModal(),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final String title;
  final String value;
  final bool showArrow;
  final VoidCallback? onTap;

  const _SettingTile({
    required this.title,
    required this.value,
    this.showArrow = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: scheme.onSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(value,
                      style: TextStyle(color: scheme.onSurface.withOpacity(0.65))),
                ],
              ),
            ),
            if (showArrow)
              Icon(Icons.chevron_right, color: scheme.onSurface.withOpacity(0.6)),
          ],
        ),
      ),
    );
  }
}

// Interests Modal
class _InterestsModal extends StatefulWidget {
  final List<String> selectedInterests;
  final Function(List<String>) onSave;

  const _InterestsModal({
    required this.selectedInterests,
    required this.onSave,
  });

  @override
  State<_InterestsModal> createState() => _InterestsModalState();
}

class _InterestsModalState extends State<_InterestsModal> {
  final TextEditingController _searchController = TextEditingController();
  late List<String> _selected;
  
  final List<String> _allInterests = [
    'Photography', 'Tea', 'Travel', 'Music', 'Sports', 'Cooking',
    'Reading', 'Gaming', 'Art', 'Dancing', 'Yoga', 'Movies',
    'Hiking', 'Swimming', 'Cycling', 'Running', 'Fitness', 'Fashion',
    'Technology', 'Writing', 'Pets', 'Wine', 'Coffee', 'Gardening',
  ];

  List<String> get _filteredInterests {
    if (_searchController.text.isEmpty) return _allInterests;
    return _allInterests
        .where((i) => i.toLowerCase().contains(_searchController.text.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.selectedInterests);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: scheme.onSurface.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text('Select Interests', style: TextStyle(color: scheme.onSurface, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: scheme.onSurface),
              decoration: InputDecoration(
                hintText: 'Search interests...',
                hintStyle: TextStyle(color: scheme.onSurface.withOpacity(0.4)),
                prefixIcon: Icon(Icons.search, color: scheme.onSurface.withOpacity(0.6)),
                filled: true,
                fillColor: scheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(height: 16),
          if (_selected.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _selected.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: Chip(
                      label: Text(_selected[index]),
                      labelStyle: const TextStyle(color: Colors.white),
                      backgroundColor: scheme.primary,
                      deleteIcon: const Icon(Icons.close, size: 18, color: Colors.white),
                      onDeleted: () {
                        setState(() {
                          _selected.remove(_selected[index]);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredInterests.length,
              itemBuilder: (context, index) {
                final interest = _filteredInterests[index];
                final isSelected = _selected.contains(interest);
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selected.remove(interest);
                      } else {
                        _selected.add(interest);
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected ? scheme.primary : scheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isSelected ? scheme.primary : Theme.of(context).dividerColor.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Text(
                          interest,
                          style: TextStyle(color: isSelected ? Colors.white : scheme.onSurface, fontSize: 15),
                        ),
                        const Spacer(),
                        if (isSelected)
                          const Icon(Icons.check, color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  widget.onSave(_selected);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Relationship Goals Modal
class _RelationshipGoalsModal extends StatelessWidget {
  final String selectedGoal;
  final Function(String) onSelect;

  const _RelationshipGoalsModal({
    required this.selectedGoal,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final goals = [
      'Long-term partner',
      'Long-term, open to short',
      'Short-term, open to long',
      'Short-term fun',
      'New friends',
      'Still figuring it out',
    ];

    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      color: scheme.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: scheme.onSurface.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text('Relationship Goals', style: TextStyle(color: scheme.onSurface, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ...goals.map((goal) => _buildOption(context, goal)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, String goal) {
    final isSelected = goal == selectedGoal;
    return GestureDetector(
      onTap: () => onSelect(goal),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).dividerColor.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                goal,
                style: TextStyle(color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface, fontSize: 15),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.white, size: 22),
          ],
        ),
      ),
    );
  }
}

// Language Modal
class _LanguageModal extends StatelessWidget {
  final String selectedLanguage;
  final Function(String) onSelect;

  const _LanguageModal({
    required this.selectedLanguage,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final languages = [
      {'name': 'English', 'flag': '🇬🇧'},
      {'name': 'Indonesia', 'flag': '🇮🇩'},
      {'name': 'Spanish', 'flag': '🇪🇸'},
      {'name': 'French', 'flag': '🇫🇷'},
      {'name': 'German', 'flag': '🇩🇪'},
      {'name': 'Chinese', 'flag': '🇨🇳'},
      {'name': 'Japanese', 'flag': '🇯🇵'},
      {'name': 'Korean', 'flag': '🇰🇷'},
      {'name': 'Arabic', 'flag': '🇸🇦'},
      {'name': 'Russian', 'flag': '🇷🇺'},
      {'name': 'Portuguese', 'flag': '🇵🇹'},
      {'name': 'Italian', 'flag': '🇮🇹'},
    ];

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text('Language I Know', style: TextStyle(color: scheme.onSurface, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: languages.length,
              itemBuilder: (context, index) {
                final lang = languages[index];
                final isSelected = lang['name'] == selectedLanguage;
                
                return GestureDetector(
                  onTap: () => onSelect(lang['name']!),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected ? scheme.primary : scheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isSelected ? scheme.primary : Theme.of(context).dividerColor.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Text(
                          lang['flag']!,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          lang['name']!,
                          style: TextStyle(color: isSelected ? Colors.white : scheme.onSurface, fontSize: 15),
                        ),
                        const Spacer(),
                        if (isSelected)
                          const Icon(Icons.check_circle, color: Colors.white, size: 22),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Sexual Orientation Modal
class _SexualOrientationModal extends StatelessWidget {
  final String selectedOrientation;
  final Function(String) onSelect;

  const _SexualOrientationModal({
    required this.selectedOrientation,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final orientations = [
      'Straight',
      'Gay',
      'Lesbian',
      'Bisexual',
      'Asexual',
      'Demisexual',
      'Pansexual',
      'Queer',
      'Questioning',
    ];

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: scheme.onSurface.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text('Sexual Orientation', style: TextStyle(color: scheme.onSurface, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ...orientations.map((orientation) => _buildOption(context, orientation)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, String orientation) {
    final isSelected = orientation == selectedOrientation;
    return GestureDetector(
      onTap: () => onSelect(orientation),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).dividerColor.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                orientation,
                style: TextStyle(color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface, fontSize: 15),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.white, size: 22),
          ],
        ),
      ),
    );
  }
}
