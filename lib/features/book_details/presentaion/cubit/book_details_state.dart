part of 'book_details_cubit.dart';

@immutable
sealed class BookDetailsState {}

final class BookDetailsInitial extends BookDetailsState {}

final class GetDetailsLoading extends BookDetailsState {}

final class GetDetailsError extends BookDetailsState {}

final class GetDetailsSuccess extends BookDetailsState {
  final BookDetailsData? detailsData;
  GetDetailsSuccess(this.detailsData);



    

}
