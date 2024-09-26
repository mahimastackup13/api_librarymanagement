import 'dart:io'; 
import 'library_api.dart';
import 'books.dart';
import 'author.dart';
import 'member.dart';

class LibraryManager {
  List<Book> books = [];
  List<Author> authors = [];
  List<Member> members = [];

  final DataPersistence dataPersistence; 

  LibraryManager(this.dataPersistence);
  
  get year => null;

  // .................................................Book Methods......................................//
  Future<void> loadBooks() async {
    books = await dataPersistence.getBooks(); 
  }

  Future<void> addBook() async {
    try {
      final title = _getValidInput('Enter book title: ');
      final author = _getValidInput('Enter author: ');
      final genre = _getValidInput('Enter genre: ');
      final isbn = _getValidInput('Enter ISBN: ');

      final newBook = Book(
        title: title,
        author: author,
        year: year,
        genre: genre,
        isbn: isbn,
      );

      books.add(newBook);
      await dataPersistence.saveBook(newBook);
      print('Book added successfully.');
    } catch (e) {
      print('Error adding book: $e');
    }
  }

  void viewBooks() {
    if (books.isEmpty) {
      print('No books available.');
    } else {
      for (var book in books) {
        print(book);
      }
    }
  }

  
  Future<void> updateBook(String isbn) async {
  try {
    final book = books.firstWhere((b) => b.isbn == isbn,
        orElse: () => throw Exception('Book not found.'));
         stdout.write('Enter new title (leave empty to keep unchanged): ');
      final title = stdin.readLineSync();
      stdout.write('Enter new author (leave empty to keep unchanged): ');
      final author = stdin.readLineSync();
      stdout.write('Enter new publication year (leave empty to keep unchanged): ');
      final yearInput = stdin.readLineSync();
      stdout.write('Enter new genre (leave empty to keep unchanged): ');
      final genre = stdin.readLineSync();

      if (title != null && title.isNotEmpty) book.title = title;
      if (author != null && author.isNotEmpty) book.author = author;
      if (yearInput != null && yearInput.isNotEmpty) book.year = int.parse(yearInput);
      if (genre != null && genre.isNotEmpty) book.genre = genre;


    
    
    await dataPersistence.updateBook(book.id, book);
    print('Book updated.');
  } catch (e) {
    print('Error updating book: $e');
  }
}

Future<void> deleteBook(String isbn) async {
  try {
    final book = books.firstWhere((b) => b.isbn == isbn,
        orElse: () => throw Exception('Book not found.'));
    
    
    await dataPersistence.deleteBook(book.id);
    books.removeWhere((b) => b.isbn == isbn);
    print('Book deleted.');
  } catch (e) {
    print('Error deleting book: $e');
  }
}


  void searchBooks(String query) {
    final results = books.where((book) =>
        book.title.toLowerCase().contains(query.toLowerCase()) ||
        book.author.toLowerCase().contains(query.toLowerCase()) ||
        book.genre.toLowerCase().contains(query.toLowerCase()));

    if (results.isEmpty) {
      print('No books found.');
    } else {
      for (var book in results) {
        print(book);
      }
    }
  }

  //................................................................Author Methods........................................//

  Future<void> addAuthor() async {
  try {
    final name = _getValidInput('Enter author name: ');
    final dob = _getValidDateInput('Enter author date of birth (YYYY-MM-DD): ');
    stdout.write('Enter books written by author (comma-separated): ');
    final booksWritten = stdin.readLineSync()!.split(',').map((b) => b.trim()).toList();

    final newAuthor = Author(name: name, dob: dob, booksWritten: booksWritten);

    if (authors.any((a) => a.name == newAuthor.name && a.dob == newAuthor.dob)) {
      print('An author with the same name and DOB already exists.');
      return;
    }

    
    final savedAuthor = await dataPersistence.saveAuthor(newAuthor);
    newAuthor.id = savedAuthor.id;

    authors.add(newAuthor);
    print('Author added successfully.');
  } catch (e) {
    print('Error adding author: $e');
  }
}

Future<void> updateAuthor(String name) async {
  try {
    
    final author = authors.firstWhere((a) => a.name == name, orElse: () => throw Exception('Author not found.'));
    
    stdout.write('Enter new name (leave empty to keep unchanged): ');
    final newName = stdin.readLineSync();
    stdout.write('Enter new date of birth (leave empty to keep unchanged): ');
    final dobInput = stdin.readLineSync();
    stdout.write('Enter new books written (leave empty to keep unchanged): ');
    final booksInput = stdin.readLineSync();

    
    if (newName != null && newName.isNotEmpty) author.name = newName;
    if (dobInput != null && dobInput.isNotEmpty) author.dob = DateTime.parse(dobInput);
    if (booksInput != null && booksInput.isNotEmpty) {
      author.booksWritten = booksInput.split(',').map((b) => b.trim()).toList();
    }

    
    await dataPersistence.updateAuthor(author.id, author); 
    print('Author updated.');
  } catch (e) {
    print('Error updating author: $e');
  }
}

Future<void> deleteAuthor(String name) async {
  try {
    final author = authors.firstWhere((a) => a.name == name, orElse: () => throw Exception('Author not found.'));
    authors.removeWhere((a) => a.id == author.id);
    await dataPersistence.deleteAuthor(author.id);
    print('Author deleted.');
  } catch (e) {
    print('Error deleting author: $e');
  }
}


//..............................................................Member Method.............................................................//

  Future<void> addMember() async {
    try {
      final name = _getValidInput('Enter member name: ');
      final membershipId = _getValidInput('Enter membership ID: ');

      final newMember = Member(
        name: name,
        memberId: membershipId,
        borrowedBooks: [],
      );
      final savedMember = await dataPersistence.saveMember(newMember); 
      members.add(savedMember);
      print('Member added successfully.');
    } catch (e) {
      print('Error adding member: $e');
    }
  }

  Future<void> updateMember(String memberId) async {
    try {
      final member = members.firstWhere(
        (m) => m.memberId == memberId,
        orElse: () => throw Exception('Member not found.'),
      );

      stdout.write('Enter new name (leave empty to keep unchanged): ');
      final name = stdin.readLineSync();
      stdout.write('Enter new membership start date (leave empty to keep unchanged): ');
      final sinceInput = stdin.readLineSync();

      if (name != null && name.isNotEmpty) member.name = name;
      if (sinceInput != null && sinceInput.isNotEmpty) {
        
      }

      await dataPersistence.updateMember(member.id, member); 
      print('Member updated.');
    } catch (e) {
      print('Error updating member: $e');
    }
  }

  Future<void> deleteMember(String memberId) async {
    try {
      final member = members.firstWhere(
        (m) => m.memberId == memberId,
        orElse: () => throw Exception('Member not found.'),
      );

      members.removeWhere((m) => m.memberId == memberId);
      await dataPersistence.deleteMember(member.id); 
      print('Member deleted.');
    } catch (e) {
      print('Error deleting member: $e');
    }
  }

  String _getValidInput(String prompt) {
    while (true) {
      stdout.write(prompt);
      final input = stdin.readLineSync();
      if (input != null && input.isNotEmpty) {
        return input;
      }
      print('Invalid input. Please try again.');
    }
  }

  DateTime _getValidDateInput(String prompt) {
    while (true) {
      stdout.write(prompt);
      final input = stdin.readLineSync();
      if (input != null && input.isNotEmpty) {
        try {
          return DateTime.parse(input);
        } catch (e) {
          print('Invalid date format. Please use YYYY-MM-DD.');
        }
      } else {
        print('Input cannot be empty. Please try again.');
      }
    }
  }

  

  void viewAuthors() {}

  void viewMembers() {
  if (members.isEmpty) {
    print('No members found.');
    return;
  }

  print('--- Member List ---');
  for (var member in members) {
    print('Name: ${member.name}');
    print('Membership ID: ${member.memberId}');
    print('Borrowed Books: ${member.borrowedBooks.isNotEmpty ? member.borrowedBooks.join(', ') : 'None'}');
    print('-------------------------');
  }
}

}


