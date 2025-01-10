class GenreModel {

  final int id;
  final String name;

  GenreModel({required this.id, required this.name});

  factory GenreModel.fromJson({required Map<String, dynamic> json}) {
    return GenreModel(
        id: json['id'],
        name: json['name'],
    );
  }

}
