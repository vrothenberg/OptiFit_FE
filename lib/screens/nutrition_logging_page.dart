import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class FoodLogEntry {
  String foodName;
  double quantity;
  double calories;
  double protein;
  double carbs;
  double fat;
  XFile? image;
  bool isConfirmed;

  FoodLogEntry({
    required this.foodName,
    required this.quantity,
    this.calories = 0,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
    this.image,
    this.isConfirmed = false,
  });
}

class NutritionLoggingPage extends StatefulWidget {
  const NutritionLoggingPage({Key? key}) : super(key: key);

  @override
  _NutritionLoggingPageState createState() => _NutritionLoggingPageState();
}

class _NutritionLoggingPageState extends State<NutritionLoggingPage> {
  final List<FoodLogEntry> _pendingLogs = [];
  final TextEditingController _searchController = TextEditingController();
  XFile? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Log Meal'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('Save'),
          onPressed: _saveLogs,
        ),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            CupertinoSliverRefreshControl(onRefresh: () async {}),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildSearchField(),
                      const SizedBox(height: 24),
                      _buildImageUploadSection(),
                      const SizedBox(height: 24),
                      ..._buildPendingLogs(),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return CupertinoSearchTextField(
      placeholder: 'Search food',
      onSubmitted: (value) {
        if (value.isNotEmpty) {
          _addNewLogEntry(FoodLogEntry(
            foodName: value,
            quantity: 100,
          ));
        }
      },
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      children: [
        if (_selectedImage != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(_selectedImage!.path),
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
        Row(
          children: [
            Expanded(
              child: CupertinoButton(
                color: CupertinoColors.systemGrey5,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    const Icon(CupertinoIcons.camera, size: 28),
                    const SizedBox(height: 8),
                    Text(
                      'Take Photo',
                      style: CupertinoTheme.of(context).textTheme.actionTextStyle,
                    ),
                  ],
                ),
                onPressed: () => _handleImageSelection(ImageSource.camera),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CupertinoButton(
                color: CupertinoColors.systemGrey5,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    const Icon(CupertinoIcons.photo, size: 28),
                    const SizedBox(height: 8),
                    Text(
                      'Choose Photo',
                      style: CupertinoTheme.of(context).textTheme.actionTextStyle,
                    ),
                  ],
                ),
                onPressed: () => _handleImageSelection(ImageSource.gallery),
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildPendingLogs() {
    return _pendingLogs.map((log) => _buildLogEntry(log)).toList();
  }

  Widget _buildLogEntry(FoodLogEntry log) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: CupertinoColors.systemGrey4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (log.image != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(log.image!.path),
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              // Use default background (remove explicit backgroundColor for native look)
              CupertinoFormSection.insetGrouped(
                children: [
                  CupertinoTextFormFieldRow(
                    placeholder: 'Food Name',
                    initialValue: log.foodName,
                    onChanged: (value) => log.foodName = value,
                  ),
                  CupertinoTextFormFieldRow(
                    placeholder: 'Quantity (g)',
                    initialValue: log.quantity.toString(),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => log.quantity = double.tryParse(value) ?? 0,
                  ),
                ],
              ),
              if (log.calories > 0) ...[
                const SizedBox(height: 12),
                _buildNutritionInfo(log),
              ],
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Icon(
                        CupertinoIcons.delete,
                        color: CupertinoColors.destructiveRed,
                      ),
                      onPressed: () => _removeLogEntry(log),
                    ),
                    Row(
                      children: [
                        Text(
                          'Confirmed',
                          style: CupertinoTheme.of(context).textTheme.textStyle,
                        ),
                        const SizedBox(width: 8),
                        CupertinoSwitch(
                          value: log.isConfirmed,
                          onChanged: (value) =>
                              setState(() => log.isConfirmed = value),
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
    );
  }

  Widget _buildNutritionInfo(FoodLogEntry log) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNutritionItem('Calories', '${log.calories.toStringAsFixed(0)} kcal'),
          _buildNutritionItem('Protein', '${log.protein.toStringAsFixed(1)}g'),
          _buildNutritionItem('Carbs', '${log.carbs.toStringAsFixed(1)}g'),
          _buildNutritionItem('Fat', '${log.fat.toStringAsFixed(1)}g'),
        ],
      ),
    );
  }

  Widget _buildNutritionItem(String label, String value) {
    return Column(
      children: [
        // Replace Material's caption style with a custom Cupertino text style
        Text(
          label,
          style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                fontSize: 12,
                color: CupertinoColors.systemGrey,
              ),
        ),
        Text(
          value,
          style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  Future<void> _handleImageSelection(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() => _selectedImage = image);
      final detectedFoods = await _mockProcessImage(image);
      for (var food in detectedFoods) {
        _addNewLogEntry(food);
      }
    }
  }

  void _addNewLogEntry(FoodLogEntry log) {
    setState(() => _pendingLogs.add(log));
  }

  void _removeLogEntry(FoodLogEntry log) {
    setState(() => _pendingLogs.remove(log));
  }

  Future<void> _fetchNutrients(FoodLogEntry log) async {
    final nutrients = await _mockFetchNutrients(log.foodName, log.quantity);
    setState(() {
      log.calories = nutrients['calories'] ?? 0;
      log.protein = nutrients['protein'] ?? 0;
      log.carbs = nutrients['carbs'] ?? 0;
      log.fat = nutrients['fat'] ?? 0;
    });
  }

  void _saveLogs() {
    final confirmedLogs = _pendingLogs.where((log) => log.isConfirmed).toList();
    Navigator.pop(context);
  }

  // Mock API functions
  Future<List<FoodLogEntry>> _mockProcessImage(XFile image) async {
    await Future.delayed(const Duration(seconds: 2));
    return [
      FoodLogEntry(foodName: 'Apple', quantity: 150, image: image),
      FoodLogEntry(foodName: 'Peanut Butter', quantity: 30, image: image),
    ];
  }

  Future<Map<String, double>> _mockFetchNutrients(String food, double quantity) async {
    await Future.delayed(const Duration(seconds: 1));
    final mockData = {
      'Apple': {'calories': 52, 'protein': 0.3, 'carbs': 14, 'fat': 0.2},
      'Peanut Butter': {'calories': 588, 'protein': 25, 'carbs': 20, 'fat': 50},
    };

    return mockData[food]?.map((key, value) => MapEntry(
          key,
          (value * quantity / 100).toDouble(),
        )) ??
        {};
  }
}
