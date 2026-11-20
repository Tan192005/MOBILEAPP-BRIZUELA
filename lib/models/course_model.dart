class Course {
  const Course({
    required this.id,
    required this.name,
    required this.content,
    required this.cost,
    required this.category,
    required this.image,
    this.active = true,
    this.duration = '',
    this.language = '',
    this.url = '',
  });

  final int id;
  final String name;
  final String content;
  final double cost;
  final String category;
  final String image;
  final bool active;
  final String duration;
  final String language;
  final String url;

  factory Course.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['title'];
    final description = json['description'];
    final price = json['price'];
    final category = json['category'];
    final image = json['thumbnail'];

    if (id is! int ||
        name is! String ||
        description is! String ||
        price is! num ||
        category is! String ||
        image is! String) {
      throw const FormatException('Product data has an unexpected format.');
    }

    return Course(
      id: id,
      name: name,
      content: description,
      cost: price.toDouble(),
      category: category,
      image: image,
    );
  }
}
