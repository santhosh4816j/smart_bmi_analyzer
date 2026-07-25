import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/profile_model.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/glass_card.dart';
import 'profile_form_screen.dart';

class ProfileListScreen extends StatefulWidget {
  const ProfileListScreen({super.key});

  @override
  State<ProfileListScreen> createState() => _ProfileListScreenState();
}

class _ProfileListScreenState extends State<ProfileListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ProfileProvider provider = context.watch<ProfileProvider>();
    final List<ProfileModel> profiles = provider.search(_query);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profiles'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const ProfileFormScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (String value) => setState(() => _query = value),
              decoration: const InputDecoration(
                hintText: 'Search profiles',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: profiles.isEmpty
                ? Center(
                    child: Text(
                      'No profiles found',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    itemCount: profiles.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (BuildContext context, int index) {
                      final ProfileModel profile = profiles[index];
                      final bool isActive = profile.id == provider.activeProfileId;
                      return GlassCard(
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            radius: 24,
                            child: Text(
                              profile.name.isEmpty
                                  ? '?'
                                  : profile.name[0].toUpperCase(),
                            ),
                          ),
                          title: Text(
                            profile.name,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            '${profile.age} yrs · ${profile.sex.label} · ${profile.goal.label}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              if (isActive)
                                const Padding(
                                  padding: EdgeInsets.only(right: 4),
                                  child: Icon(Icons.check_circle, color: Colors.green),
                                ),
                              PopupMenuButton<String>(
                                onSelected: (String action) =>
                                    _handleAction(context, action, profile),
                                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'select',
                                    child: Text('Set active'),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'edit',
                                    child: Text('Edit'),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Text('Delete'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => ProfileFormScreen(existingProfile: profile),
                            ),
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

  Future<void> _handleAction(
    BuildContext context,
    String action,
    ProfileModel profile,
  ) async {
    final ProfileProvider provider = context.read<ProfileProvider>();
    switch (action) {
      case 'select':
        await provider.setActiveProfile(profile.id);
      case 'edit':
        if (!context.mounted) return;
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => ProfileFormScreen(existingProfile: profile),
          ),
        );
      case 'delete':
        final bool? confirmed = await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) => AlertDialog(
            title: const Text('Delete profile?'),
            content: Text('This removes ${profile.name} and their history.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
        if (confirmed ?? false) {
          await provider.deleteProfile(profile.id);
        }
    }
  }
}
