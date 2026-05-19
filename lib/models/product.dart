class Product {
  final int? id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double rating;
  final int stock;

  Product({
    this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    this.rating = 0.0,
    this.stock = 10,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['thumbnail'] ?? json['image'] ?? '',
      rating: json['rating'] != null 
          ? (json['rating'] as num).toDouble() 
          : 4.5,
      stock: json['stock'] ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'thumbnail': image,
      'stock': stock,
    };
  }

  Product copyWith({
    int? id,
    String? title,
    double? price,
    String? description,
    String? category,
    String? image,
    double? rating,
    int? stock,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      stock: stock ?? this.stock,
    );
  }
}