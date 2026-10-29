import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'api_controller.dart';
import 'course_list_screen.dart';

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

  int _selectedIndex = 0;
  String _selectedCategory = 'All';
  final _searchController = TextEditingController();
  final _apiController = ApiController();
  List<FitoraService> _services = [];
  List<ApiProduct> _apiProducts = [];
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
    _apiController.dispose();
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

      if (mounted) {
        setState(() => _services = localServices);
      }

      final apiProducts = await _apiController.fetchProducts();

      if (!mounted) return;
      setState(() {
        _services = localServices;
        _apiProducts = apiProducts;
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
    setState(() => _selectedIndex = index);
  }

  void _openProductCatalog() {
    Navigator.of(context).pop();
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const CourseListScreen()));
  }

  void _bookService(String name) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$name added to your plan.')));
  }

  @override
  Widget build(BuildContext context) {
    final title = ['Dashboard', 'Services', 'Progress'][_selectedIndex];
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: const Color(0xFFF7F4F0),
        colorScheme: ColorScheme.fromSeed(seedColor: orange),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F4F0),
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
          actions: [
            IconButton(
              onPressed: _loadCatalog,
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Refresh services',
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
        body: _selectedIndex == 0 ? _buildDashboard() : _buildSection(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _bookService('Quick workout'),
          backgroundColor: ink,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text('Start workout'),
        ),
      ),
    );
  }

  Widget _buildDashboard() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      children: [
        const Text(
          'Good morning, athlete',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: ink,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Small steps. Stronger every day.',
          style: TextStyle(color: muted, fontSize: 15),
        ),
        const SizedBox(height: 22),
        _buildHeroCard(),
        const SizedBox(height: 20),
        const Text(
          'Your snapshot',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: ink,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _statCard('26', 'active minutes', Icons.timer_outlined),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _statCard(
                '4',
                'sessions this week',
                Icons.local_fire_department_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildServicePreview(),
      ],
    );
  }

  Widget _buildHeroCard() {
    return Container(
      height: 190,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: ink,
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: AssetImage('assets/images/image-1790068242124.png'),
          fit: BoxFit.cover,
          opacity: 0.28,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'TODAY\'S FOCUS',
            style: TextStyle(
              color: orange,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Strength & mobility',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '20 min  •  Beginner friendly',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: orange),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: ink,
            ),
          ),
          Text(label, style: const TextStyle(color: muted, fontSize: 12)),
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
    if (_services.isEmpty) return const SizedBox.shrink();
    final service = _services.first;
    return _serviceCard(service);
  }

  Widget _buildSection() {
    if (_selectedIndex == 2) {
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
          _statCard('4', 'sessions completed this week', Icons.insights),
        ],
      );
    }
    final categories = [
      'All',
      ..._services.map((service) => service.category).toSet(),
    ];
    final filteredServices = _selectedCategory == 'All'
        ? _services
        : _services
              .where((service) => service.category == _selectedCategory)
              .toList();
    final query = _searchController.text.trim().toLowerCase();
    final searchedServices = filteredServices.where((service) {
      return query.isEmpty ||
          service.name.toLowerCase().contains(query) ||
          service.category.toLowerCase().contains(query) ||
          service.description.toLowerCase().contains(query);
    }).toList();
    final searchedProducts = _apiProducts.where((product) {
      return query.isEmpty ||
          product.title.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query);
    }).toList();
    return RefreshIndicator(
      onRefresh: _loadCatalog,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
        children: [
          const Text(
            'Train with purpose.',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: ink,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Browse Fitora services and products loaded from the live catalog API.',
            style: TextStyle(color: muted),
          ),
          const SizedBox(height: 16),
          if (_errorMessage != null) _errorBanner(),
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search products and services',
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories
                  .map(
                    (category) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: _selectedCategory == category,
                        selectedColor: orange,
                        onSelected: (_) =>
                            setState(() => _selectedCategory = category),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Fitora services',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: ink,
            ),
          ),
          const SizedBox(height: 10),
          ...searchedServices.map(_serviceCard),
          if (searchedServices.isEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text('No services match your search.'),
            ),
          const SizedBox(height: 16),
          const Text(
            'Products from the API',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: ink,
            ),
          ),
          const SizedBox(height: 10),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          if (!_isLoading && searchedProducts.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                query.isEmpty
                    ? 'No products are available.'
                    : 'No products match "$query".',
              ),
            ),
          ListView.builder(
            itemCount: searchedProducts.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => _apiCard(searchedProducts[index]),
          ),
        ],
      ),
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
                onPressed: () => _bookService(service.name),
                child: const Text('Add to plan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _apiCard(ApiProduct product) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Image.network(
          product.thumbnail,
          width: 54,
          height: 54,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) =>
              const Icon(Icons.image_not_supported_outlined),
        ),
        title: Text(
          product.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              product.category,
              style: const TextStyle(fontSize: 12, color: muted),
            ),
          ],
        ),
        trailing: Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.w800),
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
            _drawerItem(0, Icons.dashboard_outlined, 'Dashboard'),
            _drawerItem(1, Icons.fitness_center_outlined, 'Workouts'),
            _drawerItem(2, Icons.insights_outlined, 'Progress'),
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
