class Product {
  final int id;
  final String name;
  final String slug;
  final String tagline;
  final String description;
  final String price;
  final int priceCents;
  final String currency;
  final String image;
  final List<String> images;
  final Map<String, dynamic> specs;
  final String? categoryName;
  final String? brandName;
  final bool inStock;
  final bool isFeatured;

  const Product({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.price,
    required this.currency,
    required this.image,
    required this.specs,
    this.slug = '',
    this.priceCents = 0,
    this.images = const [],
    this.categoryName,
    this.brandName,
    this.inStock = true,
    this.isFeatured = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final category = json['category'];
    final brand = json['brand'];
    final rawImages = json['images'];

    return Product(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      tagline: json['tagline'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: json['price'] as String? ?? '',
      priceCents: (json['price_cents'] as num?)?.toInt() ?? 0,
      currency: json['currency'] as String? ?? 'USD',
      image: json['image'] as String? ?? '',
      images: rawImages is List
          ? rawImages
              .map((item) => (item as Map<String, dynamic>)['url'] as String? ?? '')
              .where((url) => url.isNotEmpty)
              .toList()
          : const [],
      specs: json['specs'] is Map
          ? (json['specs'] as Map).cast<String, dynamic>()
          : const {},
      categoryName: category is Map ? category['name'] as String? : null,
      brandName: brand is Map ? brand['name'] as String? : null,
      inStock: json['in_stock'] as bool? ?? true,
      isFeatured: json['is_featured'] as bool? ?? false,
    );
  }

  String get imageUrl {
    if (image.isNotEmpty) {
      return image;
    }

    return images.isNotEmpty ? images.first : '';
  }

  double get numericPrice {
    if (priceCents > 0) {
      return priceCents / 100;
    }

    final cleaned = price.replaceAll(RegExp(r'[$,]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }
}
