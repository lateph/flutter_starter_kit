// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
    json['description'] as String,
    json['rating'] as int,
    json['image'] as String,
    json['total'] as int,
    json['kode'] as String,
    json['name'] as String,
  );
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'description': instance.description,
      'rating': instance.rating,
      'image': instance.image,
      'total': instance.total,
      'kode': instance.kode,
      'name': instance.name,
    };
