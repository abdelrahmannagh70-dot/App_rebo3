import 'package:json_annotation/json_annotation.dart';

part 'book_details_model.g.dart';

@JsonSerializable()
class BookDetailsModel {
  final BookDetailsData? data;
  final String? message;
  final int? status;

  BookDetailsModel({
    this.data,
    this.message,
    this.status,
  });

  factory BookDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$BookDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookDetailsModelToJson(this);
}

@JsonSerializable()
class BookDetailsData {
  final int? id;
  final String? name;
  final String? description;
  final int? stock;

  @JsonKey(name: 'best_seller')
  final int? bestSeller;

  final String? price;
  final int? discount;

  @JsonKey(name: 'price_after_discount')
  final num? priceAfterDiscount;

  final String? image;
  final String? category;

  BookDetailsData({
    this.id,
    this.name,
    this.description,
    this.stock,
    this.bestSeller,
    this.price,
    this.discount,
    this.priceAfterDiscount,
    this.image,
    this.category,
  });

  factory BookDetailsData.fromJson(Map<String, dynamic> json) =>
      _$BookDetailsDataFromJson(json);

  Map<String, dynamic> toJson() => _$BookDetailsDataToJson(this);
}