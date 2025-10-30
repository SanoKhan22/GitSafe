import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/error_view.dart';
import '../../domain/entities/match_entity.dart';
import '../../domain/entities/team_entity.dart';
import '../providers/cricket_provider.dart';

class CreateMatchScreen extends ConsumerStatefulWidget {
  const CreateMatchScreen({super.key});

  @override
  ConsumerState<CreateMatchScreen> createState() => _CreateMatchScreenState();
}

class _CreateMatchScreenState extends ConsumerState<CreateMatchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _venueController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now().add(const Duration(hours: 1));
  TimeOfDay _selectedTime = TimeOfDay.now();
  int _selectedOvers = 20;
  int _selectedPlayersPerTeam = 11;
  MatchType _selectedMatchType = MatchType.local;
  
  TeamEntity? _selectedTeam1;
  TeamEntity? _selectedTeam2;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _venueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teamsAsync = ref.watch(teamsProvider);
    final matchCreationAsync = ref.watch(matchCreationProvider);

    // Listen to match creation state
    ref.listen<AsyncValue<MatchEntity?>>(matchCreationProvider, (previous, next) {
      next.whenOrNull(
        data: (match) {
          if (match != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Match created successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
        },
        error: (error, stack) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $error'),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'Create Match',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: teamsAsync.when(
        data: (teams) => _buildForm(context, teams, matchCreationAsync),
        loading: () => const Center(child: AppLoader()),
        error: (error, stack) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.refresh(teamsProvider),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, List<TeamEntity> teams, AsyncValue<MatchEntity?> matchCreationAsync) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildBasicInfoCard(),
            const SizedBox(height: 16),
            _buildTeamsCard(teams),
            const SizedBox(height: 16),
            _buildMatchSettingsCard(),
            const SizedBox(height: 16),
            _buildDateTimeCard(),
            const SizedBox(height: 24),
            matchCreationAsync.when(
              data: (_) => AppButton(
                text: 'Create Match',
                onPressed: _canCreateMatch() ? _createMatch : null,
              ),
              loading: () => const AppButton(
                text: 'Creating...',
                onPressed: null,
                child: AppLoader(size: 20),
              ),
              error: (_, __) => AppButton(
                text: 'Create Match',
                onPressed: _canCreateMatch() ? _createMatch : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Match Information',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Match Title',
              hintText: 'e.g., Sunday League Match',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a match title';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description (Optional)',
              hintText: 'Brief description of the match',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _venueController,
            decoration: const InputDecoration(
              labelText: 'Venue',
              hintText: 'e.g., Central Park Ground',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a venue';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTeamsCard(List<TeamEntity> teams) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Teams',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<TeamEntity>(
            value: _selectedTeam1,
            decoration: const InputDecoration(
              labelText: 'Team 1',
              border: OutlineInputBorder(),
            ),
            items: teams.map((team) {
              return DropdownMenuItem(
                value: team,
                child: Text(team.name),
              );
            }).toList(),
            onChanged: (team) {
              setState(() {
                _selectedTeam1 = team;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select Team 1';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<TeamEntity>(
            value: _selectedTeam2,
            decoration: const InputDecoration(
              labelText: 'Team 2',
              border: OutlineInputBorder(),
            ),
            items: teams.where((team) => team.id != _selectedTeam1?.id).map((team) {
              return DropdownMenuItem(
                value: team,
                child: Text(team.name),
              );
            }).toList(),
            onChanged: (team) {
              setState(() {
                _selectedTeam2 = team;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select Team 2';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMatchSettingsCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Match Settings',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<MatchType>(
            value: _selectedMatchType,
            decoration: const InputDecoration(
              labelText: 'Match Type',
              border: OutlineInputBorder(),
            ),
            items: MatchType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type.toString().split('.').last.toUpperCase()),
              );
            }).toList(),
            onChanged: (type) {
              setState(() {
                _selectedMatchType = type!;
              });
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: _selectedOvers,
                  decoration: const InputDecoration(
                    labelText: 'Overs',
                    border: OutlineInputBorder(),
                  ),
                  items: [5, 10, 15, 20, 25, 30, 50].map((overs) {
                    return DropdownMenuItem(
                      value: overs,
                      child: Text('$overs overs'),
                    );
                  }).toList(),
                  onChanged: (overs) {
                    setState(() {
                      _selectedOvers = overs!;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: _selectedPlayersPerTeam,
                  decoration: const InputDecoration(
                    labelText: 'Players per Team',
                    border: OutlineInputBorder(),
                  ),
                  items: [6, 7, 8, 9, 10, 11].map((players) {
                    return DropdownMenuItem(
                      value: players,
                      child: Text('$players players'),
                    );
                  }).toList(),
                  onChanged: (players) {
                    setState(() {
                      _selectedPlayersPerTeam = players!;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date & Time',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: _selectDate,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: _selectTime,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Time',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _selectedTime.format(context),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  bool _canCreateMatch() {
    return _selectedTeam1 != null &&
           _selectedTeam2 != null &&
           _titleController.text.trim().isNotEmpty &&
           _venueController.text.trim().isNotEmpty;
  }

  void _createMatch() {
    if (_formKey.currentState!.validate() && _canCreateMatch()) {
      final startDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      ref.read(matchCreationProvider.notifier).createMatch(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        team1: _selectedTeam1!,
        team2: _selectedTeam2!,
        venue: _venueController.text.trim(),
        startTime: startDateTime,
        overs: _selectedOvers,
        playersPerTeam: _selectedPlayersPerTeam,
        matchType: _selectedMatchType,
      );
    }
  }
}