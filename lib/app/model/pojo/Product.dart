import 'package:json_annotation/json_annotation.dart';

part 'Product.g.dart';

@JsonSerializable()
class Product{
  String description;
  int rating;
  String image;
  int total;
  String kode;
  String name;




  Product(this.description, this.rating, this.image, this.total, this.kode,
      this.name);

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

}