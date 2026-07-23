import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/models/user_profile.dart';
import '../../providers/profile_provider.dart';
import '../../providers/weight_provider.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  Gender _gender = Gender.male;
  ActivityLevel _activity = ActivityLevel.moderatelyActive;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final profile = UserProfile(
      name: _nameController.text.trim(),
      age: int.parse(_ageController.text),
      gender: _gender,
      heightCm: double.parse(_heightController.text),
      weightKg: double.parse(_weightController.text),
      activityLevel: _activity,
    );
    ref.read(profileProvider.notifier).save(profile);
    ref.read(weightHistoryProvider.notifier).addRecord(profile.weightKg, note: 'Initial weight');
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tell us about you')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Age'),
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  if (n == null || n < 5 || n > 120) return 'Enter a valid age';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Gender', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              SegmentedButton<Gender>(
                segments: const [
                  ButtonSegment(value: Gender.male, label: Text('Male')),
                  ButtonSegment(value: Gender.female, label: Text('Female')),
                  ButtonSegment(value: Gender.other, label: Text('Other')),
                ],
                selected: {_gender},
                onSelectionChanged: (s) => setState(() => _gender = s.first),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _heightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Height (cm)'),
                validator: (v) {
                  final n = double.tryParse(v ?? '');
                  if (n == null || n < 50 || n > 260) return 'Enter a valid height';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
                validator: (v) {
                  final n = double.tryParse(v ?? '');
                  if (n == null || n < 20 || n > 400) return 'Enter a valid weight';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Activity Level', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              ...ActivityLevel.values.map(
                (level) => RadioListTile<ActivityLevel>(
                  contentPadding: EdgeInsets.zero,
                  value: level,
                  groupValue: _activity,
                  onChanged: (v) => setState(() => _activity = v!),
                  title: Text(level.label),
                  subtitle: Text(level.description),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Save & Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
