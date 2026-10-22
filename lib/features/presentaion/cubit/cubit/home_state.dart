part of 'home_cubit.dart';

@immutable
sealed class HomeState {}
final class HomeInitial extends HomeState {}

final class GetBestSellerLoading extends HomeState {}

final class GetBestSellerError extends HomeState {}

final class GetBestSellerSuccess extends HomeState {
  final List<Products>? products;
  GetBestSellerSuccess(this.products);
}
