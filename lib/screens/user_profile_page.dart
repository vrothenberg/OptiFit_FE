import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class UserProfile {
  final String name;
  final String email;
  final String? profilePictureUrl;
  final DateTime? birthDate;
  final String? gender;
  final double? height; // in cm
  final double? weight; // in kg
  final String? chronotype;
  final TimeOfDay? sleepTime;
  final TimeOfDay? wakeTime;
  final String? location;
  final String fitnessGoals;
  final String dietaryPreferences;

  UserProfile({
    required this.name,
    required this.email,
    this.profilePictureUrl,
    this.birthDate,
    this.gender,
    this.height,
    this.weight,
    this.chronotype,
    this.sleepTime,
    this.wakeTime,
    this.location,
    required this.fitnessGoals,
    required this.dietaryPreferences,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'],
      email: json['email'],
      profilePictureUrl: json['profilePictureUrl'],
      birthDate: json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null,
      gender: json['gender'],
      height: json['height'] != null ? json['height'].toDouble() : null,
      weight: json['weight'] != null ? json['weight'].toDouble() : null,
      chronotype: json['chronotype'],
      sleepTime: json['sleepTime'] != null ? _parseTimeOfDay(json['sleepTime']) : null,
      wakeTime: json['wakeTime'] != null ? _parseTimeOfDay(json['wakeTime']) : null,
      location: json['location'],
      fitnessGoals: json['fitnessGoals'],
      dietaryPreferences: json['dietaryPreferences'],
    );
  }
}

TimeOfDay? _parseTimeOfDay(String? timeString) {
  if (timeString == null) return null;
  final parts = timeString.split(':');
  if (parts.length == 2) {
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
  return null;
}

UserProfile getDummyUserProfile() {
  String jsonString = '''
  {
    "name": "John Doe",
    "email": "john.doe@example.com",
    "profilePictureUrl": "https://example.com/profile.jpg",
    "birthDate": "1990-05-15",
    "gender": "Male",
    "height": 180.0,
    "weight": 80.0,
    "chronotype": "Intermediate",
    "sleepTime": "23:00",
    "wakeTime": "07:00",
    "location": "San Francisco",
    "fitnessGoals": "Maintain Health",
    "dietaryPreferences": "Omnivore"
  }
  ''';
  Map<String, dynamic> jsonMap = jsonDecode(jsonString);
  return UserProfile.fromJson(jsonMap);
}

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController profilePictureUrlController;
  late TextEditingController birthDateController;
  late TextEditingController genderController;
  late TextEditingController heightController;
  late TextEditingController weightController;
  late TextEditingController chronotypeController;
  late TextEditingController sleepTimeController;
  late TextEditingController wakeTimeController;
  late TextEditingController locationController;
  late TextEditingController fitnessGoalsController;
  late TextEditingController dietaryPreferencesController;
  bool _isEditing = false;

  final List<String> _genderOptions = ['Male', 'Female', 'Other'];
  final List<String> _chronotypeOptions = ['Intermediate', 'Early Bird', 'Night Owl'];
  final List<String> _fitnessGoalOptions = [
    'Maintain Health',
    'Lose Weight',
    'Gain Muscle',
    'Improve Endurance',
    'Increase Flexibility'
  ];
  final List<String> _dietaryOptions = [
    'Omnivore',
    'Vegetarian',
    'Pescatarian',
    'Vegan',
    'Paleo'
  ];

  List<double> get _heightOptions => List.generate(151, (i) => 100.0 + i);
  List<double> get _weightOptions => List.generate(341, (i) => 30.0 + (i * 0.5));

  @override
  void initState() {
    super.initState();
    final userProfile = getDummyUserProfile();

    // Initialize controllers
    nameController = TextEditingController(text: userProfile.name);
    emailController = TextEditingController(text: userProfile.email);
    profilePictureUrlController = TextEditingController(text: userProfile.profilePictureUrl ?? '');
    birthDateController = TextEditingController(text: userProfile.birthDate?.toIso8601String().split('T')[0] ?? '');
    genderController = TextEditingController(text: userProfile.gender ?? '');
    heightController = TextEditingController(text: userProfile.height?.toString() ?? '');
    weightController = TextEditingController(text: userProfile.weight?.toString() ?? '');
    chronotypeController = TextEditingController(text: userProfile.chronotype ?? '');
    sleepTimeController = TextEditingController(
      text: userProfile.sleepTime != null ? '' : '');
    wakeTimeController = TextEditingController(
      text: userProfile.wakeTime != null ? '' : '');
    locationController = TextEditingController(text: userProfile.location ?? '');
    fitnessGoalsController = TextEditingController(text: userProfile.fitnessGoals);
    dietaryPreferencesController = TextEditingController(text: userProfile.dietaryPreferences);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userProfile = getDummyUserProfile();
    
    // Only update if sleepTime and wakeTime are available.
    if (userProfile.sleepTime != null) {
      sleepTimeController.text = userProfile.sleepTime!.format(context);
    }
    if (userProfile.wakeTime != null) {
      wakeTimeController.text = userProfile.wakeTime!.format(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('User Profile'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text(_isEditing ? 'Save' : 'Edit'),
          onPressed: _isEditing ? _saveProfile : _toggleEditMode,
        ),
      ),
      child: SingleChildScrollView(
        child: SafeArea(
          child: CupertinoFormSection.insetGrouped(
            header: const Text('Personal Information'),
            children: <Widget>[
              _buildProfilePictureSection(),
              _buildTextFieldRow('Name', nameController),
              _buildTextFieldRow('Email', emailController, keyboardType: TextInputType.emailAddress),
              _buildDatePickerField(),
              _buildPickerField('Gender', genderController, _genderOptions),
              _buildNumberPickerField('Height (cm)', heightController, _heightOptions, 'cm'),
              _buildNumberPickerField('Weight (kg)', weightController, _weightOptions, 'kg', decimalPlaces: 1),
              _buildPickerField('Chronotype', chronotypeController, _chronotypeOptions),
              _buildTimePickerField('Sleep Time', sleepTimeController),
              _buildTimePickerField('Wake Time', wakeTimeController),
              _buildLocationField(),
              _buildPickerField('Fitness Goals', fitnessGoalsController, _fitnessGoalOptions),
              _buildPickerField('Dietary Preferences', dietaryPreferencesController, _dietaryOptions),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    return GestureDetector(
      onTap: _isEditing ? () => _handleProfilePictureUpdate() : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: profilePictureUrlController.text.isNotEmpty
                    ? NetworkImage(profilePictureUrlController.text)
                    : null,
                child: profilePictureUrlController.text.isEmpty
                    ? const Icon(CupertinoIcons.person_circle_fill, size: 120, color: CupertinoColors.systemGrey)
                    : null,
              ),
              if (_isEditing)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(CupertinoIcons.camera_fill, size: 20, color: CupertinoColors.white),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldRow(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return CupertinoFormRow(
      prefix: SizedBox(width: 120, child: Text(label)),
      child: CupertinoTextField(
        controller: controller,
        keyboardType: keyboardType,
        textAlign: TextAlign.right,
        readOnly: !_isEditing,
        placeholder: 'Enter $label',
      ),
    );
  }

  Widget _buildDatePickerField() {
    return CupertinoFormRow(
      prefix: SizedBox(width: 120, child: const Text('Birth Date')),
      child: CupertinoTextField(
        controller: birthDateController,
        readOnly: true,
        placeholder: 'Select birth date',
        onTap: _isEditing ? () => _showDatePicker(context) : null,
        suffix: _isEditing ? const Icon(CupertinoIcons.calendar, size: 20) : null,
      ),
    );
  }

  Widget _buildPickerField(String label, TextEditingController controller, List<String> options) {
    return CupertinoFormRow(
      prefix: SizedBox(width: 120, child: Text(label)),
      child: CupertinoTextField(
        controller: controller,
        readOnly: true,
        placeholder: 'Select $label',
        onTap: _isEditing ? () => _showOptionsPicker(context, controller, options) : null,
        suffix: _isEditing ? const Icon(CupertinoIcons.chevron_down, size: 16) : null,
      ),
    );
  }

  Widget _buildNumberPickerField(String label, TextEditingController controller, List<double> options, String unit,
      {int decimalPlaces = 0}) {
    return CupertinoFormRow(
      prefix: SizedBox(width: 120, child: Text(label)),
      child: CupertinoTextField(
        controller: controller,
        readOnly: true,
        placeholder: 'Select $label',
        onTap: _isEditing ? () => _showNumberPicker(context, controller, options, unit, decimalPlaces) : null,
        suffix: _isEditing ? const Icon(CupertinoIcons.chevron_down, size: 16) : null,
      ),
    );
  }

  Widget _buildTimePickerField(String label, TextEditingController controller) {
    return CupertinoFormRow(
      prefix: SizedBox(width: 120, child: Text(label)),
      child: CupertinoTextField(
        controller: controller,
        readOnly: true,
        placeholder: 'Select $label',
        onTap: _isEditing ? () => _showTimePicker(context, controller) : null,
        suffix: _isEditing ? const Icon(CupertinoIcons.time, size: 20) : null,
      ),
    );
  }

  Widget _buildLocationField() {
    return CupertinoFormRow(
      prefix: SizedBox(width: 120, child: const Text('Location')),
      child: CupertinoTextField(
        controller: locationController,
        placeholder: 'Enter location',
        readOnly: !_isEditing,
        suffix: _isEditing
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.location_fill, size: 20),
                onPressed: () => _handleLocationSelection(),
              )
            : null,
      ),
    );
  }

  void _showDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 216,
        color: CupertinoColors.white,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: birthDateController.text.isNotEmpty ? DateTime.parse(birthDateController.text) : DateTime.now(),
          onDateTimeChanged: (DateTime newDate) {
            birthDateController.text = newDate.toIso8601String().split('T')[0];
          },
        ),
      ),
    );
  }

  void _showTimePicker(BuildContext context, TextEditingController controller) {
    final initialTime = TimeOfDayExtension.fromString(controller.text) ?? TimeOfDay.now();

    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 216,
        color: CupertinoColors.white,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.time,
          use24hFormat: false,
          initialDateTime: DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            initialTime.hour,
            initialTime.minute,
          ),
          onDateTimeChanged: (DateTime newTime) {
            controller.text = TimeOfDay.fromDateTime(newTime).format(context);
          },
        ),
      ),
    );
  }

  void _showOptionsPicker(BuildContext context, TextEditingController controller, List<String> options) {
    final initialIndex = options.indexOf(controller.text).clamp(0, options.length - 1);

    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 216,
        color: CupertinoColors.white,
        child: CupertinoPicker(
          scrollController: FixedExtentScrollController(initialItem: initialIndex),
          itemExtent: 32,
          onSelectedItemChanged: (index) => controller.text = options[index],
          children: options.map((opt) => Text(opt)).toList(),
        ),
      ),
    );
  }

  void _showNumberPicker(
    BuildContext context,
    TextEditingController controller,
    List<double> options,
    String unit,
    int decimalPlaces,
  ) {
    final currentValue = double.tryParse(controller.text) ?? options.first;
    final initialIndex = options.indexOf(currentValue).clamp(0, options.length - 1);

    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 216,
        color: CupertinoColors.white,
        child: CupertinoPicker(
          scrollController: FixedExtentScrollController(initialItem: initialIndex),
          itemExtent: 32,
          onSelectedItemChanged: (index) => controller.text =
              options[index].toStringAsFixed(decimalPlaces),
          children: options.map((num) =>
              Text('${num.toStringAsFixed(decimalPlaces)} $unit')
          ).toList(),
        ),
      ),
    );
  }

  void _handleProfilePictureUpdate() {
    // Implement image picker logic
  }

  void _handleLocationSelection() {
    // Implement location picker logic
  }

  void _toggleEditMode() {
    setState(() => _isEditing = !_isEditing);
  }

  void _saveProfile() {
    // Implement save logic
    _toggleEditMode();
  }

  @override
  void dispose() {
    // Dispose all controllers
    nameController.dispose();
    emailController.dispose();
    profilePictureUrlController.dispose();
    birthDateController.dispose();
    genderController.dispose();
    heightController.dispose();
    weightController.dispose();
    chronotypeController.dispose();
    sleepTimeController.dispose();
    wakeTimeController.dispose();
    locationController.dispose();
    fitnessGoalsController.dispose();
    dietaryPreferencesController.dispose();
    super.dispose();
  }
}

extension TimeOfDayExtension on TimeOfDay {
  static TimeOfDay? fromString(String timeString) {
    final parts = timeString.split(RegExp(r'[:\s]'));
    if (parts.length >= 2) {
      try {
        int hour = int.parse(parts[0]);
        int minute = int.parse(parts[1]);
        if (parts.length > 2 && parts[2].toLowerCase() == 'pm' && hour < 12) {
          hour += 12;
        }
        return TimeOfDay(hour: hour, minute: minute);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}