
// import 'dart:convert';


class Author {
  String _id; 
  String name;
  DateTime dob;
  List<String> booksWritten;

  Author({
    required this.name,
    required this.dob,
    required this.booksWritten,
    String? id, 
  }) : _id = id ?? ''; 
   String get id => _id;
   set id(String value) {
    _id = value;
  }

  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dob': dob.toIso8601String(),
      'booksWritten': booksWritten,
    };
  }

  
  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['_id'], 
      name: json['name'],
      dob: DateTime.parse(json['dob']),
      booksWritten: List<String>.from(json['booksWritten']),
    );
  }

  @override
  String toString() {
    return 'Author(name: $name, dob: ${dob.toIso8601String()}, booksWritten: $booksWritten, id: $_id)';
  }
}


