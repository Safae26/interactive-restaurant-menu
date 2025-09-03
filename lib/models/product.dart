import 'package:intl/intl.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  bool isFavorite;
  int likes;
  int dislikes;
  List<Comment> comments;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    this.isFavorite = false,
    this.likes = 0,
    this.dislikes = 0,
    this.comments = const [],
  }) : assert(price >= 0, 'Price cannot be negative');

  Product addCommentWithCopy(Comment comment) {
    final newComments = List<Comment>.from(comments)..add(comment);
    return copyWith(comments: newComments);
  }

  void toggleFavorite() {
    isFavorite = !isFavorite;
  }

  void incrementLikes() {
    likes++;
    if (dislikes > 0) dislikes--; // Un like annule un dislike
  }

  void incrementDislikes() {
    dislikes++;
    if (likes > 0) likes--; // Un dislike annule un like
  }

  void addComment(Comment comment) {
    comments.add(comment);
    comments.sort((a, b) => b.date.compareTo(a.date));
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    String? imageUrl,
    bool? isFavorite,
    int? likes,
    int? dislikes,
    List<Comment>? comments,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      likes: likes ?? this.likes,
      dislikes: dislikes ?? this.dislikes,
      comments: comments ?? this.comments,
    );
  }

  factory Product.fromMap(Map<String, dynamic> data) {
    return Product(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      category: data['category'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      isFavorite: data['isFavorite'] ?? false,
      likes: data['likes'] ?? 0,
      dislikes: data['dislikes'] ?? 0,
      comments:
          (data['comments'] as List<dynamic>?)
              ?.map((c) => Comment.fromMap(c as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
      'likes': likes,
      'dislikes': dislikes,
      'comments': comments.map((c) => c.toMap()).toList(),
    };
  }
}

class Comment {
  final String user;
  final String text;
  final DateTime date;

  Comment({required this.user, required this.text, DateTime? date})
    : date = date ?? DateTime.now();

  String get formattedDate {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  factory Comment.fromMap(Map<String, dynamic> data) {
    return Comment(
      user: data['user'] ?? '',
      text: data['text'] ?? '',
      date: data['date'] != null ? DateTime.parse(data['date']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {'user': user, 'text': text, 'date': date.toIso8601String()};
  }

  @override
  String toString() => '$user: $text ($formattedDate)';
}
