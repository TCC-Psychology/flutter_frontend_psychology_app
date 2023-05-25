import 'package:json_annotation/json_annotation.dart';
import 'client_model.dart';
import 'psychologist_model.dart';

part 'review_model.g.dart';

@JsonSerializable()
class Review {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String description;
  final int rating;
  final Client client;
  final Psychologist psychologist;

  Review({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.description,
    required this.rating,
    required this.client,
    required this.psychologist,
  });

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}
