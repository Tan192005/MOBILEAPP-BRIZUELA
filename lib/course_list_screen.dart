import 'package:flutter/material.dart';

import 'api_controller.dart';
import 'course_model.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  static const Color _ink = Color(0xFF20231F);
  static const Color _muted = Color(0xFF74796F);
  static const Color _accent = Color(0xFFB8F659);
  static const Color _canvas = Color(0xFFF7F8F3);

  static const String _wheyProteinImage =
      'https://cdn.dummyjson.com/product-images/groceries/protein-powder/thumbnail.webp';
  static const List<Course> _supplementProducts = [
    Course(
      id: -1,
      name: 'Creatine Monohydrate',
      content:
          'Sample supplement listing. Micronized creatine powder for your training routine. Price shown is illustrative.',
      cost: 24.99,
      category: 'sports-nutrition',
      image: '',
    ),
    Course(
      id: -2,
      name: 'Whey Protein Powder',
      content:
          'Sample supplement listing. Protein powder for a post-workout shake. Price shown is illustrative.',
      cost: 34.99,
      category: 'sports-nutrition',
      image: _wheyProteinImage,
    ),
  ];

  final TextEditingController _searchController = TextEditingController();
  final ApiController _apiController = ApiController();
  late Future<List<Course>> _coursesFuture;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _coursesFuture = fetchCourses();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _apiController.dispose();
    super.dispose();
  }

  Future<List<Course>> fetchCourses() async {
    final products = await _apiController.fetchProducts();
    return [
      ...products.map(
        (product) => Course(
          id: product.id,
          name: product.title,
          content: product.description,
          cost: product.price,
          category: product.category,
          image: product.thumbnail,
        ),
      ),
      ..._supplementProducts,
    ];
  }

  Future<void> _refreshCourses() async {
    final future = fetchCourses();
    setState(() => _coursesFuture = future);
    await future;
  }

  List<Course> _filterCourses(List<Course> courses) {
    final query = _searchController.text.trim().toLowerCase();
    return courses.where((course) {
      final matchesCategory =
          _selectedCategory == 'All' ||
          (_selectedCategory == 'Nutrition'
              ? course.category == 'sports-nutrition'
              : course.category != 'sports-nutrition');
      final matchesQuery =
          query.isEmpty ||
          course.name.toLowerCase().contains(query) ||
          course.content.toLowerCase().contains(query) ||
          course.category.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _canvas,
      appBar: AppBar(
        backgroundColor: _canvas,
        foregroundColor: _ink,
        elevation: 0,
        title: const Text(
          'FITORA',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh products',
            onPressed: _refreshCourses,
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: FutureBuilder<List<Course>>(
        future: _coursesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cloud_off_outlined,
                      size: 52,
                      color: _muted,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Couldn’t load the catalog',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: _ink,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Check your connection and try again.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: _muted),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: _refreshCourses,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final courses = _filterCourses(snapshot.data!);
          return RefreshIndicator(
            onRefresh: _refreshCourses,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildHero(courses.length),
                      const SizedBox(height: 22),
                      TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: 'Search equipment or supplements',
                          hintStyle: const TextStyle(color: _muted),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: _muted,
                          ),
                          suffixIcon: _searchController.text.isEmpty
                              ? null
                              : IconButton(
                                  tooltip: 'Clear search',
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.close_rounded),
                                ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      _buildCategoryFilters(),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Shop products',
                              style: TextStyle(
                                color: _ink,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Text(
                            '${courses.length} items',
                            style: const TextStyle(color: _muted),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Supplement listings and prices are examples.',
                        style: TextStyle(color: _muted, fontSize: 12),
                      ),
                      if (courses.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 48),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.search_off_rounded,
                                  size: 44,
                                  color: _muted,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'No products found',
                                  style: TextStyle(
                                    color: _ink,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Try another search or category.',
                                  style: TextStyle(color: _muted),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ]),
                  ),
                ),
                if (courses.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    sliver: SliverLayoutBuilder(
                      builder: (context, constraints) {
                        final columns = constraints.crossAxisExtent >= 620
                            ? 3
                            : 2;
                        return SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) =>
                                _buildProductCard(courses[index]),
                            childCount: courses.length,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                mainAxisSpacing: 14,
                                crossAxisSpacing: 14,
                                childAspectRatio: columns == 2 ? 0.66 : 0.78,
                              ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHero(int productCount) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF272B25), Color(0xFF41483B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _accent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'FITORA PICKS',
                    style: TextStyle(
                      color: _ink,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Fuel your\nnext workout.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$productCount picks for your fitness journey',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.fitness_center_rounded,
              color: _accent,
              size: 38,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    const categories = ['All', 'Equipment', 'Nutrition'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          final selected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(category),
              selected: selected,
              onSelected: (_) => setState(() => _selectedCategory = category),
              selectedColor: _accent,
              backgroundColor: Colors.white,
              side: BorderSide.none,
              labelStyle: TextStyle(
                color: _ink,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProductCard(Course course) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showProductDetails(course),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _buildProductImage(course),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.94),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        course.category == 'sports-nutrition'
                            ? 'NUTRITION'
                            : 'SPORTS GEAR',
                        style: const TextStyle(
                          color: _ink,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 14,
                        height: 1.15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '\$${course.cost.toStringAsFixed(2)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _ink,
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 17,
                          color: _muted,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(Course course) {
    if (course.image.isEmpty) {
      return _buildCreatineArtwork();
    }

    return Image.network(
      course.image,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => _buildImageFallback(course),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: const Color(0xFFF0F2EB),
          alignment: Alignment.center,
          child: const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: _ink,
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageFallback(Course course) {
    return Container(
      color: const Color(0xFFEFF2E9),
      alignment: Alignment.center,
      child: Icon(
        course.category == 'sports-nutrition'
            ? Icons.science_outlined
            : Icons.sports_gymnastics_rounded,
        size: 56,
        color: _ink,
      ),
    );
  }

  Widget _buildCreatineArtwork() {
    return Container(
      color: const Color(0xFFE8F0DE),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 66,
            height: 82,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFD4DCCB)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x18000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFF35452E),
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bolt_rounded, color: _accent, size: 25),
                  SizedBox(height: 2),
                  Text(
                    'CREATINE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 7,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.3,
                    ),
                  ),
                  Text(
                    'MONOHYDRATE',
                    style: TextStyle(color: Colors.white70, fontSize: 4),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'ILLUSTRATION',
            style: TextStyle(
              color: _muted,
              fontSize: 8,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  void _showProductDetails(Course course) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: _canvas,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: SizedBox(
                  width: double.infinity,
                  height: 210,
                  child: _buildProductImage(course),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                course.category == 'sports-nutrition'
                    ? 'SPORTS NUTRITION'
                    : 'SPORTS & FITNESS',
                style: const TextStyle(
                  color: _muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                course.name,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                course.content,
                style: const TextStyle(color: _muted, height: 1.4),
              ),
              if (course.category == 'sports-nutrition') ...[
                const SizedBox(height: 10),
                const Text(
                  'Example listing only. Check product labels and consult a qualified health professional before using supplements.',
                  style: TextStyle(color: _muted, fontSize: 12, height: 1.35),
                ),
              ],
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '\$${course.cost.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: _accent,
                      foregroundColor: _ink,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Done'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
