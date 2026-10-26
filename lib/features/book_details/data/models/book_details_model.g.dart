// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookDetailsModel _$BookDetailsModelFromJson(Map<String, dynamic> json) =>
    BookDetailsModel(
      data:
          json['data'] == null
              ? null
              : BookDetailsData.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,

      status: (json['status'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BookDetailsModelToJson(BookDetailsModel instance) =>
    <String, dynamic>{
      'data': instance.data,
      'message': instance.message,

      'status': instance.status,
    };

BookDetailsData _$BookDetailsDataFromJson(Map<String, dynamic> json) =>
    BookDetailsData(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      stock: (json['stock'] as num?)?.toInt(),
      bestSeller: (json['best_seller'] as num?)?.toInt(),
      price: json['price'] as String?,
      discount: (json['discount'] as num?)?.toInt(),
      priceAfterDiscount: json['price_after_discount'] as num?,
      image: json['image'] as String?,
      category: json['category'] as String?,
    );

Map<String, dynamic> _$BookDetailsDataToJson(BookDetailsData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'stock': instance.stock,
      'best_seller': instance.bestSeller,
      'price': instance.price,
      'discount': instance.discount,
      'price_after_discount': instance.priceAfterDiscount,
      'image': instance.image,
      'category': instance.category,
    };
