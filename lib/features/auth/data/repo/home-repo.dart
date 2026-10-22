import 'package:app3/core/networking/dio_factory.dart';
import 'package:app3/features/auth/data/models/book_model.dart';
import 'package:dio/dio.dart';
class HomeRepo{


  getBestSellerBox()async{
    try{
      final response= await DioFactory.dio?.get("https://codingarabic.eraapro.com/api/products-bestseller");
      if(response?.statusCode==200){
        BookModel booksModel = BookModel.fromJson(response?.data);
        return booksModel;

      }else{
        return null;
      }

    }catch(e){
      return null;

    }

  }
}