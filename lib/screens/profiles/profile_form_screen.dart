import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/enums.dart';
import '../../models/profile_model.dart';
import '../../providers/profile_provider.dart';
import '../../utils/validators.dart';

class ProfileFormScreen extends StatefulWidget {
  const ProfileFormScreen({this.existingProfile, super.key});

  final ProfileModel? existingProfile;

  @override
  State<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController =
      TextEditingController(text: widget.existingProfile?.name ?? '');
  late final TextEditingController _ageController = TextEditingController(
    text: widget.existingProfile?.age.toString() ?? '',
  );
  late final TextEditingController _heightController = TextEditingController(
    text: widget.existingProfile?.heightCm.toString() ?? '',
  );
  late final TextEditingController _weightController = TextEditingController(
    text: widget.existingProfile?.weightKg.toString() ?? '',
  );
  late final TextEditingController _notesController =
      TextEditingController(text: widget.existingProfile?.notes ?? '');

  late BiologicalSex _sex = widget.existingProfile?.sex ?? BiologicalSex.male;
  late ActivityLevel _activityLevel =
      widget.existingProfile?.activityLevel ?? ActivityLevel.moderate;
  late FitnessGoal _goal =
      widget.existingProfile?.goal ?? FitnessGoal.maintainWeight;
  late DietPreference? _diet = widget.existingProfile?.dietPreference;

  bool get _isEditing => widget.existingProfile != null;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final ProfileProvider provider = context.read<ProfileProvider>();
    final double height = double.parse(_heightController.text);
    final double weight = double.parse(_weightController.text);
    final int age = int.parse(_ageController.text);

    if (_isEditing) {
      final ProfileModel updated = widget.existingProfile!.copyWith(
        name: _nameController.text.trim(),
        age: age,
        sex: _sex,
        heightCm: height,
        weightKg: weight,
        activityLevel: _activityLevel,
        goal: _goal,
        notes: _notesController.text.trim(),
        dietPreference: _diet,
      );
      await provider.updateProfile(updated);
    } else {
      await provider.createProfile(
        name: _nameController.text.trim(),
        age: age,
        sex: _sex,
        heightCm: height,
        weightKg: weight,
        activityLevel: _activityLevel,
        goal: _goal,
        notes: _notesController.text.trim(),
        dietPreference: _diet,
      );
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Profile' : 'New Profile'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (String? v) =>
                  Validators.requiredText(v, field: 'Name'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
              validator: Validators.ageRange,
            ),
            const SizedBox(height: 16),
            SegmentedButton<BiologicalSex>(
              segments: const <ButtonSegment<BiologicalSex>>[
                ButtonSegment<BiologicalSex>(
                  value: BiologicalSex.male,
                  label: Text('Male'),
                ),
                ButtonSegment<BiologicalSex>(
                  value: BiologicalSex.female,
                  label: Text('Female'),
                ),
              ],
              selected: <BiologicalSex>{_sex},
              onSelectionChanged: (Set<BiologicalSex> selection) =>
                  setState(() => _sex = selection.first),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _heightController,
              decoration: const InputDecoration(labelText: 'Height (cm)'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (String? v) =>
                  Validators.positiveNumber(v, field: 'Height'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _weightController,
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (String? v) =>
                  Validators.positiveNumber(v, field: 'Weight'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ActivityLevel>(
              initialValue: _activityLevel,
              decoration: const InputDecoration(labelText: 'Activity Level'),
              items: ActivityLevel.values
                  .map(
                    (ActivityLevel level) => DropdownMenuItem<ActivityLevel>(
                      value: level,
                      child: Text(level.label),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (ActivityLevel? value) {
                if (value != null) setState(() => _activityLevel = value);
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<FitnessGoal>(
              initialValue: _goal,
              decoration: const InputDecoration(labelText: 'Goal'),
              items: FitnessGoal.values
                  .map(
                    (FitnessGoal goal) => DropdownMenuItem<FitnessGoal>(
                      value: goal,
                      child: Text(goal.label),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (FitnessGoal? value) {
                if (value != null) setState(() => _goal = value);
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<DietPreference?>(
              initialValue: _diet,
              decoration: const InputDecoration(labelText: 'Diet preference (optional)'),
              items: <DropdownMenuItem<DietPreference?>>[
                const DropdownMenuItem<DietPreference?>(
                  child: Text('Not specified'),
                ),
                ...DietPreference.values.map(
                  (DietPreference d) => DropdownMenuItem<DietPreference?>(
                    value: d,
                    child: Text(d.label),
                  ),
                ),
              ],
              onChanged: (DietPreference? value) => setState(() => _diet = value),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes (optional)'),
              maxLines: 3,
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: _submit,
              child: Text(_isEditing ? 'Save Changes' : 'Create Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
