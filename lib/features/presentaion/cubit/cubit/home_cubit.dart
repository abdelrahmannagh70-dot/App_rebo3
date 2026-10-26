import 'package:app3/features/auth/data/models/book_model.dart';
import 'package:app3/features/welcome/presentaion/home/home-repo.dart';
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
  search(String text)async{
    emit(SearchLoading());
    final data =await HomeRepo.search(text);
    if(data is List<Products>){
      emit(SearchSuccess(data));
    }else{
      emit(SearchError());
    }
  }
}
