import 'package:app3/features/auth/data/models/book_model.dart';
import 'package:app3/features/book_details/data/models/book_details_model.dart';
import 'package:app3/features/book_details/data/repo/book_details_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'book_details_state.dart';

class BookDetailsCubit extends Cubit<BookDetailsState> {
  BookDetailsCubit() : super(BookDetailsInitial());
  
  
  getDetails(int id)async{
    emit(GetDetailsLoading());
    final data =await BookDetailsRepo.getBookDetails(id);
    if(data is BookDetailsModel){
      emit(GetDetailsSuccess(data.data));
    }else{
      emit(GetDetailsError());
    }
  }
}
