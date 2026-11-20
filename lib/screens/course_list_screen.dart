import 'package:flutter/material.dart';

import '../models/course_model.dart';
import '../services/api_controller.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  static const String _wheyProteinImage =
      'https://cdn.dummyjson.com/product-images/groceries/protein-powder/thumbnail.webp';
  static const Map<String, Color> _supplementPackageColors = {
    'Transparent Labs': Color(0xFF34433D),
    'Optimum Nutrition': Color(0xFFB52F34),
    'Legion Athletics': Color(0xFFD66C42),
    'Dymatize': Color(0xFF344B70),
    'Momentous': Color(0xFF496C57),
    'Orgain': Color(0xFF648A43),
    'Ascent Protein': Color(0xFF4F7894),
    'Naked Nutrition': Color(0xFFC29A4C),
    'Thorne': Color(0xFF777777),
    'KOS': Color(0xFF69774C),
  };
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
    Course(
      id: -3,
      name: 'Transparent Labs Whey Protein Isolate',
      content: 'Grass-fed whey protein isolate powder. Example listing.',
      cost: 59.99,
      category: 'sports-nutrition',
      image: 'assets/images/protein_products/transparent_labs.png',
    ),
    Course(
      id: -4,
      name: 'Optimum Nutrition Gold Standard 100% Whey',
      content: 'Whey protein powder. Example listing.',
      cost: 39.99,
      category: 'sports-nutrition',
      image: 'assets/images/protein_products/optimum_nutrition.png',
    ),
    Course(
      id: -5,
      name: 'Legion Athletics Whey+ Protein Powder',
      content: 'Whey protein powder. Example listing.',
      cost: 49.99,
      category: 'sports-nutrition',
      image: 'assets/images/protein_products/legion_athletics.png',
    ),
    Course(
      id: -6,
      name: 'Dymatize ISO100 Protein Powder',
      content: 'Hydrolyzed whey protein powder. Example listing.',
      cost: 37.99,
      category: 'sports-nutrition',
      image: 'assets/images/protein_products/dymatize.png',
    ),
    Course(
      id: -7,
      name: 'Momentous Essential Whey Protein',
      content: 'Whey protein powder. Example listing.',
      cost: 59.95,
      category: 'sports-nutrition',
      image: 'assets/images/protein_products/momentous.png',
    ),
    Course(
      id: -8,
      name: 'Orgain Organic Plant Based Protein Powder',
      content: 'Plant-based protein powder. Example listing.',
      cost: 29.99,
      category: 'sports-nutrition',
      image: 'assets/images/protein_products/orgain.png',
    ),
    Course(
      id: -9,
      name: 'Ascent Protein Native Fuel Whey',
      content: 'Whey protein powder. Example listing.',
      cost: 39.99,
      category: 'sports-nutrition',
      image: 'assets/images/protein_products/ascent_protein.png',
    ),
    Course(
      id: -10,
      name: 'Naked Nutrition Naked Whey',
      content: 'Whey protein powder. Example listing.',
      cost: 37.99,
      category: 'sports-nutrition',
      image: 'assets/images/protein_products/naked_nutrition.png',
    ),
    Course(
      id: -11,
      name: 'Thorne Whey Protein Isolate',
      content: 'Whey protein isolate powder. Example listing.',
      cost: 55.00,
      category: 'sports-nutrition',
      image: '',
    ),
    Course(
      id: -12,
      name: 'KOS Organic Plant Protein',
      content: 'Plant-based protein powder. Example listing.',
      cost: 39.99,
      category: 'sports-nutrition',
      image: '',
    ),
  ];

  final TextEditingController _searchController = TextEditingController();
  final ApiController _apiController = ApiController();
  late Future<List<Course>> _coursesFuture;

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
    if (query.isEmpty) return courses;

    return courses.where((course) {
      return course.name.toLowerCase().contains(query) ||
          course.content.toLowerCase().contains(query) ||
          course.category.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Catalog'),
        actions: [
          IconButton(
            tooltip: 'Refresh products',
            onPressed: _refreshCourses,
            icon: const Icon(Icons.refresh),
          ),
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
                    const Icon(Icons.cloud_off_outlined, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      'Could not load products.\n${snapshot.error}',
                      textAlign: TextAlign.center,
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
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Search products',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Clear search',
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.clear),
                          ),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${courses.length} sports & fitness ${courses.length == 1 ? 'product' : 'products'}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Supplement listings and prices are examples.',
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ),
                if (courses.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text('No products match your search.'),
                    ),
                  ),
                ...courses.map(_buildProductCard),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(Course course) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: course.image.isEmpty
              ? _buildSupplementImage(course)
              : course.image.startsWith('assets/')
              ? Image.asset(
                  course.image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  course.image,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox(
                    width: 64,
                    height: 64,
                    child: Icon(Icons.image_not_supported_outlined),
                  ),
                ),
        ),
        title: Text(
          course.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${course.category == 'sports-nutrition' ? 'Sports Nutrition' : 'Sports & Fitness'}\n${course.content}',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        isThreeLine: true,
        trailing: Text(
          '\$${course.cost.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildSupplementImage(Course course) {
    final brand = _supplementPackageColors.keys.firstWhere(
      course.name.startsWith,
      orElse: () => 'FITORA',
    );
    final packageColor =
        _supplementPackageColors[brand] ?? const Color(0xFF536B50);

    return SizedBox(
      width: 64,
      height: 64,
      child: ColoredBox(
        color: const Color(0xFFE8F0E2),
        child: Center(
          child: Container(
            width: 36,
            height: 48,
            decoration: BoxDecoration(
              color: packageColor,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.black12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3,
                  offset: Offset(1, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 22,
                  height: 6,
                  decoration: BoxDecoration(
                    color: packageColor.withValues(alpha: 0.75),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(3),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Text(
                        brand.toUpperCase(),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 5,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Text(
                    'PROTEIN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 4,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
