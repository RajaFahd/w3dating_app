import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  // Profile creation data
  String? firstName;
  DateTime? birthDate;
  String? gender;
  String? sexualOrientation;
  List<String> interestedIn = [];
  String? lookingFor;
  List<String> selectedInterests = [];
  double? latitude;
  double? longitude;
  String? city;
  String? bio;
  String? occupation;

  // Set individual fields
  void setFirstName(String name) {
    firstName = name;
    notifyListeners();
  }

  void setBirthDate(DateTime date) {
    birthDate = date;
    notifyListeners();
  }

  void setGender(String genderValue) {
    gender = genderValue;
    notifyListeners();
  }

  void setSexualOrientation(String orientation) {
    sexualOrientation = orientation;
    notifyListeners();
  }

  void setInterestedIn(List<String> interests) {
    interestedIn = interests;
    notifyListeners();
  }

  void setLookingFor(String looking) {
    lookingFor = looking;
    notifyListeners();
  }

  void setInterests(List<String> interests) {
    selectedInterests = interests;
    notifyListeners();
  }

  void setLocation(double lat, double lon, String cityName) {
    latitude = lat;
    longitude = lon;
    city = cityName;
    notifyListeners();
  }

  void setBio(String bioText) {
    bio = bioText;
    notifyListeners();
  }

  void setOccupation(String job) {
    occupation = job;
    notifyListeners();
  }

  // Check if profile data is complete
  bool isProfileComplete() {
    return firstName != null &&
        birthDate != null &&
        gender != null &&
        sexualOrientation != null &&
        interestedIn.isNotEmpty &&
        lookingFor != null;
  }

  // Get profile data as Map for API
  Map<String, dynamic> getProfileData() {
    return {
      'first_name': firstName,
      'birth_date': birthDate?.toIso8601String().split('T')[0],
      'gender': gender,
      'sexual_orientation': sexualOrientation,
      'interested_in': interestedIn,
      'looking_for': lookingFor,
      'latitude': latitude,
      'longitude': longitude,
      'city': city,
      'bio': bio ?? '',
      'occupation': occupation ?? '',
    };
  }

  // Clear all data
  void clear() {
    firstName = null;
    birthDate = null;
    gender = null;
    sexualOrientation = null;
    interestedIn = [];
    lookingFor = null;
    selectedInterests = [];
    latitude = null;
    longitude = null;
    city = null;
    bio = null;
    occupation = null;
    notifyListeners();
  }

  // Save to local storage (optional)
  Future<void> saveToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    if (firstName != null) await prefs.setString('firstName', firstName!);
    if (gender != null) await prefs.setString('gender', gender!);
    // Add more as needed
  }

  // Load from local storage (optional)
  Future<void> loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    firstName = prefs.getString('firstName');
    gender = prefs.getString('gender');
    // Add more as needed
    notifyListeners();
  }
}
