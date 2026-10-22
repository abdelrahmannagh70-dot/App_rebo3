import 'package:app3/features/auth/data/models/book_model.dart';
import 'package:app3/features/auth/data/repo/home-repo.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  getBestSellerBox() async {
    emit(GetBestSellerLoading());
    final response = await HomeRepo().getBestSellerBox();
 
    if (response is BookModel) {
      emit(GetBestSellerSuccess(response.data?.products));
    } else {
      emit(GetBestSellerError());
    }
  }
}
