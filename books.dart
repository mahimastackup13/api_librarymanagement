// // import 'dart:convert'


class Book {
  String _id; 
  String title;
  String author;
  int year;
  String genre;
  String isbn;

  Book({
    required this.title,
    required this.author,
    required this.year,
    required this.genre,
    required this.isbn,
    String? id, 
  }) : _id = id ?? ''; 
   String get id => _id;
   set id(String value) {
    _id = value;
  }

 
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'year': year,
      'genre': genre,
      'isbn': isbn,
    };
  }

 
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id'], 
      title: json['title'],
      author: json['author'],
      year: json['year'],
      genre: json['genre'],
      isbn: json['isbn'],
    );
  }

  @override
  String toString() {
    return 'Book(title: $title, author: $author, year: $year, genre: $genre, isbn: $isbn, id: $_id)';
  }
}





