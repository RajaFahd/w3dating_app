import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../template/bottom_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() => _isLoading = true);
    try {
      final response = await _apiService.getEvents();
      if (response['success'] == true && response['data'] != null) {
        setState(() {
          _events = List<Map<String, dynamic>>.from(response['data']);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to load events: ${e.toString()}');
    }
  }

  void _showCreateEventDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateEventDialog(
        onEventCreated: () {
          Navigator.pop(context);
          _loadEvents();
        },
      ),
    );
  }

  void _showEventDetail(Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) => EventDetailDialog(
        event: event,
        onJoinToggle: () => _toggleJoinEvent(
          event['id'],
          event['has_joined'] == true,
        ),
      ),
    );
  }

  void _showEditEventDialog(Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) => EditEventDialog(
        event: event,
        onEventUpdated: () {
          Navigator.pop(context);
          _loadEvents();
        },
      ),
    );
  }

  Future<void> _deleteEvent(int eventId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final response = await _apiService.deleteEvent(eventId);
        if (response['success'] == true) {
          _loadEvents();
          _showSuccess('Event deleted successfully');
        }
      } catch (e) {
        _showError('Failed to delete event: ${e.toString()}');
      }
    }
  }

  Future<void> _toggleJoinEvent(int eventId, bool hasJoined) async {
    try {
      final response = hasJoined
          ? await _apiService.leaveEvent(eventId)
          : await _apiService.joinEvent(eventId);

      if (response['success'] == true) {
        _loadEvents();
        _showSuccess(hasJoined ? 'Left event' : 'Joined event');
      }
    } catch (e) {
      _showError('Failed to ${hasJoined ? 'leave' : 'join'} event: ${e.toString()}');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Events',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FloatingActionButton(
                    mini: true,
                    backgroundColor: const Color(0xFFFF3F80),
                    onPressed: _showCreateEventDialog,
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            // Events list
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _events.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.event_note,
                                  size: 64,
                                  color: Colors.white.withOpacity(0.5)),
                              const SizedBox(height: 16),
                              Text(
                                'No events yet',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Create one to get started!',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadEvents,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            itemCount: _events.length,
                            itemBuilder: (context, index) {
                              final event = _events[index];
                              return GestureDetector(
                                onTap: () => _showEventDetail(event),
                                child: EventCard(
                                  event: event,
                                  onEdit: () => _showEditEventDialog(event),
                                  onDelete: () => _deleteEvent(event['id']),
                                  onJoinToggle: () => _toggleJoinEvent(
                                    event['id'],
                                    event['has_joined'] == true,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(currentIndex: 1),
    );
  }
}

class EventCard extends StatelessWidget {
  final Map<String, dynamic> event;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onJoinToggle;

  const EventCard({
    required this.event,
    required this.onEdit,
    required this.onDelete,
    required this.onJoinToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isOwner = event['is_owner'] == true;
    final image = event['image'] as String?;
    final eventDate = event['event_date'];

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      color: const Color(0xFF2A2B30),
      child: SizedBox(
        height: 200,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image or placeholder
              if (image != null && image.isNotEmpty && _isValidBase64(image))
                Image.memory(
                  base64Decode(image.trim()),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[800],
                      child: const Center(child: Icon(Icons.image, color: Colors.white30)),
                    );
                  },
                )
              else
                Container(
                  color: Colors.grey[800],
                  child: Center(
                  child: Icon(Icons.event, size: 64, color: Colors.white.withOpacity(0.3)),
                ),
              ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            // Content overlay
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          event['title'] ?? 'Untitled Event',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isOwner)
                        PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              onTap: onEdit,
                              child: const Row(
                                children: [
                                  Icon(Icons.edit, size: 18),
                                  SizedBox(width: 8),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              onTap: onDelete,
                              child: const Row(
                                children: [
                                  Icon(Icons.delete, size: 18, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Delete', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  // Bottom section with details
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 14, color: Colors.white.withOpacity(0.7)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event['location'] ?? 'TBD',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    size: 14, color: Colors.white.withOpacity(0.7)),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    _formatEventDate(eventDate),
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!isOwner)
                            GestureDetector(
                              onTap: onJoinToggle,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: event['has_joined'] == true
                                      ? Colors.green.withOpacity(0.7)
                                      : Colors.pink.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  event['has_joined'] == true ? 'Joined' : 'Join',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  bool _isValidBase64(String str) {
    try {
      if (str.isEmpty) return false;
      // Base64 strings should be divisible by 4 after trimming
      final trimmed = str.trim();
      if (trimmed.length % 4 != 0) return false;
      base64Decode(trimmed);
      return true;
    } catch (e) {
      return false;
    }
  }

  String _formatEventDate(dynamic dateTime) {
    if (dateTime == null) return 'TBD';
    try {
      final dt = DateTime.parse(dateTime.toString());
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Invalid date';
    }
  }
}

class CreateEventDialog extends StatefulWidget {
  final VoidCallback onEventCreated;

  const CreateEventDialog({super.key, required this.onEventCreated});

  @override
  State<CreateEventDialog> createState() => _CreateEventDialogState();
}

class _CreateEventDialogState extends State<CreateEventDialog> {
  final ApiService _apiService = ApiService();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  XFile? _selectedImage;
  bool _isLoading = false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  Future<void> _createEvent() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final eventDate = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      String? imageBase64;
      if (_selectedImage != null) {
        final bytes = await File(_selectedImage!.path).readAsBytes();
        imageBase64 = base64Encode(bytes);
      }

      final response = await _apiService.createEvent(
        title: _titleController.text,
        description: _descriptionController.text,
        location: _locationController.text,
        eventDate: eventDate.toString().substring(0, 16).replaceFirst('T', ' '),
        image: imageBase64,
      );

      setState(() => _isLoading = false);

      if (response['success'] == true) {
        widget.onEventCreated();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Failed to create event')),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF2A2B30),
      title: const Text('Create Event', style: TextStyle(color: Colors.white)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image preview
            GestureDetector(
              onTap: _selectImage,
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _selectedImage == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image,
                                size: 48,
                                color: Colors.white.withOpacity(0.5)),
                            const SizedBox(height: 8),
                            Text(
                              'Tap to select image',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(_selectedImage!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Event Title',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              style: const TextStyle(color: Colors.white),
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Description',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _locationController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Location',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _selectDate,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                      ),
                      child: Text(
                        _selectedDate == null
                            ? 'Select Date'
                            : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                        style: TextStyle(
                          color: _selectedDate == null
                              ? Colors.white.withOpacity(0.5)
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: _selectTime,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                      ),
                      child: Text(
                        _selectedTime == null
                            ? 'Select Time'
                            : '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: _selectedTime == null
                              ? Colors.white.withOpacity(0.5)
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF3F80),
          ),
          onPressed: _isLoading ? null : _createEvent,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('Create', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class EditEventDialog extends StatefulWidget {
  final Map<String, dynamic> event;
  final VoidCallback onEventUpdated;

  const EditEventDialog({
    super.key,
    required this.event,
    required this.onEventUpdated,
  });

  @override
  State<EditEventDialog> createState() => _EditEventDialogState();
}

class _EditEventDialogState extends State<EditEventDialog> {
  final ApiService _apiService = ApiService();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  XFile? _selectedImage;
  bool _isLoading = false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event['title']);
    _descriptionController =
        TextEditingController(text: widget.event['description']);
    _locationController =
        TextEditingController(text: widget.event['location']);

    try {
      final dt = DateTime.parse(widget.event['event_date'].toString());
      _selectedDate = dt;
      _selectedTime = TimeOfDay(hour: dt.hour, minute: dt.minute);
    } catch (e) {
      _selectedDate = null;
      _selectedTime = null;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  Future<void> _updateEvent() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final eventDate = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      String? imageBase64;
      if (_selectedImage != null) {
        final bytes = await File(_selectedImage!.path).readAsBytes();
        imageBase64 = base64Encode(bytes);
      }

      final response = await _apiService.updateEvent(
        eventId: widget.event['id'],
        title: _titleController.text,
        description: _descriptionController.text,
        location: _locationController.text,
        eventDate: eventDate.toString().substring(0, 16).replaceFirst('T', ' '),
        image: imageBase64,
      );

      setState(() => _isLoading = false);

      if (response['success'] == true) {
        widget.onEventUpdated();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Failed to update event')),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF2A2B30),
      title: const Text('Edit Event', style: TextStyle(color: Colors.white)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image preview
            GestureDetector(
              onTap: _selectImage,
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(_selectedImage!.path),
                          fit: BoxFit.cover,
                        ),
                      )
                    : widget.event['image'] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              base64Decode(widget.event['image'].toString().trim()),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.image,
                                          size: 48,
                                          color: Colors.white.withOpacity(0.5)),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Tap to change image',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image,
                                    size: 48,
                                    color: Colors.white.withOpacity(0.5)),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap to select image',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Event Title',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              style: const TextStyle(color: Colors.white),
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Description',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _locationController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Location',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _selectDate,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                      ),
                      child: Text(
                        _selectedDate == null
                            ? 'Select Date'
                            : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                        style: TextStyle(
                          color: _selectedDate == null
                              ? Colors.white.withOpacity(0.5)
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: _selectTime,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                      ),
                      child: Text(
                        _selectedTime == null
                            ? 'Select Time'
                            : '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: _selectedTime == null
                              ? Colors.white.withOpacity(0.5)
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF3F80),
          ),
          onPressed: _isLoading ? null : _updateEvent,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('Update', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class EventDetailDialog extends StatelessWidget {
  final Map<String, dynamic> event;
  final VoidCallback onJoinToggle;

  const EventDetailDialog({
    super.key,
    required this.event,
    required this.onJoinToggle,
  });

  @override
  Widget build(BuildContext context) {
    final creator = event['creator'] as Map<String, dynamic>?;
    final creatorProfile = creator?['profile'] as Map<String, dynamic>?;
    final creatorName = creatorProfile?['first_name'] ?? 'Unknown';
    final image = event['image'] as String?;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: const Color(0xFF2A2B30),
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image
                if (image != null && image.isNotEmpty && _isValidBase64(image))
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Image.memory(
                      base64Decode(image.trim()),
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 250,
                          color: Colors.grey[800],
                          child: const Center(
                            child: Icon(Icons.image,
                                size: 64, color: Colors.white30),
                          ),
                        );
                      },
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        event['title'] ?? 'Untitled Event',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Creator
                      Text(
                        'By $creatorName',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Location
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on,
                              size: 20, color: Colors.white.withOpacity(0.7)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Location',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  event['location'] ?? 'TBD',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Date & Time
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.calendar_today,
                              size: 20, color: Colors.white.withOpacity(0.7)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date & Time',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  _formatEventDate(event['event_date']),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Contact
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.phone,
                              size: 20, color: Colors.white.withOpacity(0.7)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Contact',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  event['contact'] ?? 'N/A',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Description
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            event['description'] ?? '',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Participants
                      Text(
                        'Participants: ${event['participants_count'] ?? 0}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Action buttons
                      Row(
                        children: [
                          if (event['is_owner'] != true)
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: event['has_joined'] == true
                                      ? Colors.green
                                      : const Color(0xFFFF3F80),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  onJoinToggle();
                                },
                                child: Text(
                                  event['has_joined'] == true ? 'Leave Event' : 'Join Event',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          if (event['is_owner'] != true)
                            const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[700],
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'Close',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatEventDate(dynamic dateTime) {
    if (dateTime == null) return 'TBD';
    try {
      final dt = DateTime.parse(dateTime.toString());
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Invalid date';
    }
  }

  bool _isValidBase64(String str) {
    try {
      if (str.isEmpty) return false;
      final trimmed = str.trim();
      if (trimmed.length % 4 != 0) return false;
      base64Decode(trimmed);
      return true;
    } catch (e) {
      return false;
    }
  }
}

