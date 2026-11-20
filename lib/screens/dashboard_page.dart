import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/workout_api.dart';
import 'course_list_screen.dart';
import '../models/workout.dart';
import 'workout_session_screen.dart';

class FitoraService {
  final String id;
  final String name;
  final String category;
  final String description;
  final int durationMinutes;
  final double price;
  final String level;
  final IconData icon;
  final bool featured;

  const FitoraService({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.durationMinutes,
    required this.price,
    required this.level,
    required this.icon,
    required this.featured,
  });

  factory FitoraService.fromJson(Map<String, dynamic> json) {
    return FitoraService(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      durationMinutes: json['durationMinutes'] as int,
      price: (json['price'] as num).toDouble(),
      level: json['level'] as String,
      icon: _iconFor(json['icon'] as String),
      featured: json['featured'] as bool,
    );
  }

  static IconData _iconFor(String value) {
    switch (value) {
      case 'self_improvement':
        return Icons.self_improvement;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'directions_walk':
        return Icons.directions_walk;
      case 'accessibility_new':
        return Icons.accessibility_new;
      case 'directions_run':
        return Icons.directions_run;
      case 'bolt':
        return Icons.bolt;
      default:
        return Icons.fitness_center;
    }
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static const orange = Color(0xFFFFB26B);
  static const ink = Color(0xFF191919);
  static const muted = Color(0xFF766E68);
  static const forest = Color(0xFF183D35);
  static const canvas = Color(0xFFF6F4EF);
  static const _dashboardIndex = 0;
  static const _workoutsIndex = 1;
  static const _servicesIndex = 2;
  static const _progressIndex = 3;

  int _selectedIndex = _dashboardIndex;
  String _selectedCategory = 'All';
  final _searchController = TextEditingController();
  List<FitoraService> _services = [];
  List<Workout> _workouts = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCatalog();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCatalog() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final localJson = await rootBundle.loadString(
        'assets/data/fitora_services.json',
      );
      final localData = jsonDecode(localJson) as Map<String, dynamic>;
      final localServices = (localData['services'] as List<dynamic>)
          .map((item) => FitoraService.fromJson(item as Map<String, dynamic>))
          .toList();
      final workouts = await WorkoutApi.loadWorkouts();

      if (!mounted) return;
      setState(() {
        _services = localServices;
        _workouts = workouts;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Could not load the catalog. $error';
      });
    }
  }

  void _selectDestination(int index) {
    Navigator.of(context).pop();
    setState(() {
      _selectedIndex = index;
      _selectedCategory = 'All';
      _searchController.clear();
    });
  }

  void _openProductCatalog() {
    Navigator.of(context).pop();
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const CourseListScreen()));
  }

  Future<void> _startWorkout({
    String? id,
    String? name,
    int? durationMinutes,
    String? level,
    Workout? workout,
  }) async {
    final completed = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => WorkoutSessionScreen(
          workoutId: workout?.id ?? id ?? 'quick',
          title: workout?.title ?? name ?? 'Quick Full-Body Workout',
          durationMinutes: workout?.durationMinutes ?? durationMinutes ?? 20,
          level: workout?.difficulty ?? level ?? 'Beginner friendly',
          workout: workout,
        ),
      ),
    );
    if (!mounted || completed != true) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Workout completed. Great work!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = [
      'Dashboard',
      'Workouts',
      'Services',
      'Progress',
    ][_selectedIndex];
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: canvas,
        colorScheme: ColorScheme.fromSeed(
          seedColor: forest,
          primary: forest,
          secondary: orange,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: canvas,
          foregroundColor: ink,
          elevation: 0,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'fitora ${title.toLowerCase()}',
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          titleSpacing: 20,
          actions: [
            IconButton(
              onPressed: _loadCatalog,
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Refresh catalog',
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: CircleAvatar(
                backgroundColor: ink,
                child: Icon(Icons.person_outline, color: Colors.white),
              ),
            ),
          ],
        ),
        drawer: _buildDrawer(),
        body: switch (_selectedIndex) {
          _dashboardIndex => _buildDashboard(),
          _workoutsIndex => _buildWorkoutsSection(),
          _servicesIndex => _buildServicesSection(),
          _ => _buildProgressSection(),
        },
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFE7F0E9),
          elevation: 8,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
              _selectedCategory = 'All';
              _searchController.clear();
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.fitness_center_outlined),
              selectedIcon: Icon(Icons.fitness_center_rounded),
              label: 'Workouts',
            ),
            NavigationDestination(
              icon: Icon(Icons.spa_outlined),
              selectedIcon: Icon(Icons.spa_rounded),
              label: 'Services',
            ),
            NavigationDestination(
              icon: Icon(Icons.insights_outlined),
              selectedIcon: Icon(Icons.insights_rounded),
              label: 'Progress',
            ),
          ],
        ),
        floatingActionButton: _selectedIndex == _dashboardIndex
            ? FloatingActionButton.extended(
                onPressed: _startWorkout,
                backgroundColor: orange,
                foregroundColor: ink,
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text(
                  'Start workout',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildDashboard() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/home_gym_background.png',
          key: const ValueKey('home-background-image'),
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
        const ColoredBox(color: Color(0xBFF6F4EF)),
        ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 112),
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 10,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _greeting,
                      style: const TextStyle(
                        color: forest,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Ready to move?',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: forest,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0E2),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: const Color(0xFFF6D6B8)),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.local_fire_department_rounded,
                        color: Color(0xFFE78342),
                        size: 20,
                      ),
                      SizedBox(width: 5),
                      Text(
                        '4 day streak',
                        style: TextStyle(
                          color: ink,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            const Text(
              'Small steps. Stronger every day.',
              style: TextStyle(color: muted, fontSize: 14),
            ),
            const SizedBox(height: 20),
            _buildHeroCard(),
            if (_errorMessage != null) ...[
              const SizedBox(height: 14),
              _errorBanner(),
            ],
            const SizedBox(height: 26),
            _sectionHeading(
              'Your progress',
              action: 'View all',
              onAction: () => setState(() => _selectedIndex = _progressIndex),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    '26',
                    'active minutes',
                    Icons.timer_outlined,
                    detail: 'of 40 min goal',
                    progress: 0.65,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(
                    '4',
                    'sessions this week',
                    Icons.fitness_center_rounded,
                    detail: 'of 5 session goal',
                    progress: 0.8,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            _sectionHeading(
              'Made for your goals',
              subtitle: 'Programs to keep your momentum going.',
              action: 'See all',
              onAction: () => setState(() => _selectedIndex = _workoutsIndex),
            ),
            const SizedBox(height: 12),
            _buildWorkoutPreview(),
            const SizedBox(height: 24),
            _sectionHeading(
              'Featured services',
              action: 'See all',
              onAction: () => setState(() => _selectedIndex = _servicesIndex),
            ),
            const SizedBox(height: 10),
            _buildServicePreview(),
          ],
        ),
      ],
    );
  }

  Widget _sectionHeading(
    String title, {
    String? subtitle,
    String? action,
    VoidCallback? onAction,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: forest,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.3,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(color: muted, fontSize: 12),
                ),
              ],
            ],
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: forest,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
            child: Text(
              action,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
      ],
    );
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning, athlete';
    if (hour < 17) return 'Good afternoon, athlete';
    return 'Good evening, athlete';
  }

  Widget _buildHeroCard() {
    return Container(
      height: 248,
      decoration: BoxDecoration(
        color: forest,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26183D35),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/image-1790068242124.png',
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const ColoredBox(color: forest),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x22183D35), Color(0xF2183D35)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: orange,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'TODAY\'S FOCUS',
                    style: TextStyle(
                      color: ink,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Strength & mobility',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 5),
                const Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      color: Colors.white70,
                      size: 15,
                    ),
                    SizedBox(width: 5),
                    Text(
                      '20 min  ·  Beginner friendly',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.icon(
                    onPressed: () =>
                        setState(() => _selectedIndex = _workoutsIndex),
                    style: FilledButton.styleFrom(
                      backgroundColor: orange,
                      foregroundColor: forest,
                      minimumSize: const Size(0, 46),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow_rounded, size: 20),
                    label: const Text(
                      'Explore workout',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutPreview() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_workouts.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 194,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _workouts.length > 3 ? 3 : _workouts.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final workout = _workouts[index];
          return SizedBox(
            width: 238,
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                key: ValueKey('home-workout-${workout.id}'),
                onTap: () => _startWorkout(workout: workout),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            workout.image,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                const ColoredBox(color: forest),
                          ),
                          const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0x00000000), Color(0xA6000000)],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 12,
                            bottom: 10,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.schedule_rounded,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '${workout.durationMinutes} min',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(13, 10, 13, 11),
                      child: Text(
                        workout.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: forest,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _statCard(
    String value,
    String label,
    IconData icon, {
    required String detail,
    required double progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFECEAE4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C183D35),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2EC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: forest, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 25,
              height: 1,
              fontWeight: FontWeight.w900,
              color: forest,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            maxLines: 2,
            style: const TextStyle(
              color: forest,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(detail, style: const TextStyle(color: muted, fontSize: 10)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: const Color(0xFFF0EAE5),
              color: forest,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicePreview() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (_services.isEmpty) {
      if (_errorMessage != null) return _errorBanner();
      return const SizedBox.shrink();
    }
    final service = _services.first;
    return _serviceCard(service);
  }

  Widget _buildWorkoutsSection() {
    final categories = [
      'All',
      ..._workouts.map((workout) => workout.category).toSet(),
    ];
    final query = _searchController.text.trim().toLowerCase();
    final searchedWorkouts = _workouts.where((workout) {
      final matchesCategory =
          _selectedCategory == 'All' || workout.category == _selectedCategory;
      return matchesCategory &&
          (query.isEmpty ||
              workout.title.toLowerCase().contains(query) ||
              workout.category.toLowerCase().contains(query) ||
              workout.difficulty.toLowerCase().contains(query) ||
              workout.exercises.any(
                (exercise) =>
                    exercise.name.toLowerCase().contains(query) ||
                    exercise.targetMuscle.toLowerCase().contains(query),
              ));
    }).toList();

    return RefreshIndicator(
      onRefresh: _loadCatalog,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(18, 19, 18, 20),
            decoration: BoxDecoration(
              color: forest,
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF214D43), forest],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'MOVE WITH PURPOSE',
                    style: TextStyle(
                      color: Color(0xFFD8E8DC),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Workout programs',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Choose your focus. Select 3 exercises to begin.',
                  style: TextStyle(color: Color(0xFFD5E1DA), fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            textInputAction: TextInputAction.search,
            decoration: _searchDecoration('Search workouts'),
          ),
          const SizedBox(height: 14),
          _categoryFilters(categories),
          const SizedBox(height: 18),
          if (_errorMessage != null) _errorBanner(),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          if (!_isLoading && searchedWorkouts.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                query.isEmpty
                    ? 'No workouts match this category.'
                    : 'No workouts match "$query".',
              ),
            ),
          ...searchedWorkouts.map(_workoutCard),
        ],
      ),
    );
  }

  Widget _buildServicesSection() {
    final categories = [
      'All',
      ..._services.map((service) => service.category).toSet(),
    ];
    final query = _searchController.text.trim().toLowerCase();
    final searchedServices = _services.where((service) {
      final matchesCategory =
          _selectedCategory == 'All' || service.category == _selectedCategory;
      return matchesCategory &&
          (query.isEmpty ||
              service.name.toLowerCase().contains(query) ||
              service.category.toLowerCase().contains(query) ||
              service.description.toLowerCase().contains(query));
    }).toList();

    return RefreshIndicator(
      onRefresh: _loadCatalog,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          const Text(
            'Fitora services',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: ink,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Explore coaching and training services from Fitora.',
            style: TextStyle(color: muted),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            textInputAction: TextInputAction.search,
            decoration: _searchDecoration('Search services'),
          ),
          const SizedBox(height: 14),
          _categoryFilters(categories),
          const SizedBox(height: 18),
          if (_errorMessage != null) _errorBanner(),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          if (!_isLoading && searchedServices.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                query.isEmpty
                    ? 'No services match this category.'
                    : 'No services match "$query".',
              ),
            ),
          ...searchedServices.map(_serviceCard),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Keep your momentum.',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
            color: ink,
          ),
        ),
        const SizedBox(height: 18),
        _statCard(
          '4',
          'sessions completed this week',
          Icons.insights,
          detail: 'of 5 session goal',
          progress: 0.8,
        ),
      ],
    );
  }

  InputDecoration _searchDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: const Icon(Icons.search_rounded),
      suffixIcon: _searchController.text.isEmpty
          ? null
          : IconButton(
              tooltip: 'Clear search',
              onPressed: () {
                _searchController.clear();
                setState(() {});
              },
              icon: const Icon(Icons.clear_rounded),
            ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(color: Color(0xFFE7E6E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(17),
        borderSide: const BorderSide(color: forest, width: 1.5),
      ),
    );
  }

  Widget _categoryFilters(List<String> categories) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories
            .map(
              (category) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(category),
                  selected: _selectedCategory == category,
                  selectedColor: forest,
                  labelStyle: TextStyle(
                    color: _selectedCategory == category ? Colors.white : muted,
                    fontWeight: FontWeight.w700,
                  ),
                  shape: const StadiumBorder(),
                  onSelected: (_) =>
                      setState(() => _selectedCategory = category),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _workoutCard(Workout workout) {
    return Card(
      key: ValueKey('workout-card-${workout.id}'),
      elevation: 2,
      shadowColor: const Color(0x17183D35),
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: Color(0xFFECEAE4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                workout.image,
                width: double.infinity,
                height: 188,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  height: 188,
                  width: double.infinity,
                  color: const Color(0xFF273432),
                  child: const Icon(
                    Icons.fitness_center_rounded,
                    color: Colors.white,
                    size: 44,
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x10000000), Color(0x5C000000)],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 13,
                top: 13,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: forest.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 7,
                    ),
                    child: Text(
                      workout.category.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout.title,
                  style: const TextStyle(
                    color: ink,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _workoutDetail(
                      Icons.schedule_rounded,
                      '${workout.durationMinutes} min',
                    ),
                    _workoutDetail(
                      Icons.signal_cellular_alt_rounded,
                      workout.difficulty,
                    ),
                    _workoutDetail(
                      Icons.fitness_center_rounded,
                      '${workout.exercises.length} exercises',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => _startWorkout(workout: workout),
                    style: FilledButton.styleFrom(
                      backgroundColor: forest,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Start workout'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _workoutDetail(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: muted),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: muted, fontSize: 12)),
      ],
    );
  }

  Widget _serviceCard(FitoraService service) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                height: 132,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/image-1790068242124.png',
                      fit: BoxFit.cover,
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.05),
                            Colors.black.withValues(alpha: 0.62),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          service.category.toUpperCase(),
                          style: const TextStyle(
                            color: ink,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 14,
                      right: 14,
                      child: Row(
                        children: [
                          Icon(service.icon, color: Colors.white, size: 24),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              service.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          if (service.featured)
                            const Icon(Icons.star_rounded, color: orange),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFFFE1C5),
                  child: Icon(service.icon, color: ink),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    service.level,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: muted,
                    ),
                  ),
                ),
                Text(
                  '${service.durationMinutes} min',
                  style: const TextStyle(
                    color: ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              service.description,
              style: const TextStyle(color: muted, height: 1.35),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Text(
                  '${service.durationMinutes} min  •  ${service.level}',
                  style: const TextStyle(color: muted, fontSize: 12),
                ),
                const Spacer(),
                Text(
                  '\$${service.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: ink,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => _startWorkout(
                  id: service.id,
                  name: service.name,
                  durationMinutes: service.durationMinutes,
                  level: service.level,
                ),
                child: const Text('Start workout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorBanner() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: MaterialBanner(
        content: Text(_errorMessage!),
        actions: [
          TextButton(onPressed: _loadCatalog, child: const Text('Retry')),
        ],
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const ListTile(
              contentPadding: EdgeInsets.fromLTRB(24, 18, 16, 18),
              leading: CircleAvatar(
                backgroundColor: ink,
                child: Icon(Icons.fitness_center, color: Colors.white),
              ),
              title: Text(
                'FITORA',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.4,
                ),
              ),
              subtitle: Text('TRAIN WITH PURPOSE'),
            ),
            const Divider(),
            _drawerItem(_dashboardIndex, Icons.dashboard_outlined, 'Dashboard'),
            _drawerItem(
              _workoutsIndex,
              Icons.fitness_center_outlined,
              'Workouts',
            ),
            _drawerItem(_servicesIndex, Icons.spa_outlined, 'Services'),
            _drawerItem(_progressIndex, Icons.insights_outlined, 'Progress'),
            ListTile(
              leading: const Icon(Icons.inventory_2_outlined),
              title: const Text('API Product Catalog'),
              onTap: _openProductCatalog,
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(int index, IconData icon, String label) {
    return ListTile(
      selected: _selectedIndex == index,
      selectedTileColor: const Color(0xFFFFE1C5),
      leading: Icon(icon),
      title: Text(label),
      onTap: () => _selectDestination(index),
    );
  }
}
