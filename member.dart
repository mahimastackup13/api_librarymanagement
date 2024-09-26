class Member {
  String _id; 
  String name;
  String memberId;
  List<String> borrowedBooks;

  Member({
    required this.name,
    required this.memberId,
    required this.borrowedBooks,
    String? id,
  }) : _id = id ?? ''; 

  
  String get id => _id;


  set id(String value) {
    _id = value;
  }

  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'memberId': memberId,
      'borrowedBooks': borrowedBooks,
    };
  }

  
  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['_id'], 
      name: json['name'],
      memberId: json['memberId'],
      borrowedBooks: List<String>.from(json['borrowedBooks']),
    );
  }

  @override
  String toString() {
    return 'Member(name: $name, memberId: $memberId, borrowedBooks: $borrowedBooks, id: $_id)';
  }
}
