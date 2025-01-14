class MovieInfoModel {
  final String homepage;
  final List<ProductionCompaniesModel> production_companies;
  final int runtime;

  MovieInfoModel(
      {required this.homepage,
      required this.production_companies,
      required this.runtime});

  factory MovieInfoModel.fromJson(Map<String, dynamic> json) {
    return MovieInfoModel(
      homepage: json['homepage'],
      production_companies: (json['production_companies'] as List<dynamic>)
          .map((companyJson) => ProductionCompaniesModel.fromJson(companyJson))
          .toList(),
      runtime: json['runtime'],
    );
  }
}

class ProductionCompaniesModel {

  final int id;
  final String logo_path;
  final String name;
  final String origin_country;

  ProductionCompaniesModel({
    required this.id,
    required this.logo_path,
    required this.name,
    required this.origin_country,
  });

  factory ProductionCompaniesModel.fromJson(Map<String, dynamic> json) {
    return ProductionCompaniesModel(
      id: json['id'],
      logo_path: json['logo_path'],
      name: json['name'],
      origin_country: json['origin_country'],
    );
  }
}