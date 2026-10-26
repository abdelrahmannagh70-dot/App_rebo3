import 'package:app3/core/networking/api_endpoint.dart';
import 'package:app3/core/networking/dio_factory.dart';
import 'package:app3/features/book_details/data/models/book_details_model.dart';

class BookDetailsRepo{
  static getBookDetails(int id)async{
    try{
      final response =await DioFactory.dio?.get("${ApiEndPoint.BookDetails}$id");
      if(response?.statusCode==200){
        BookDetailsModel details =BookDetailsModel.fromJson(response?.data);
        return details;

      }else{
        return null;
      }

    }catch(e){
      return null;

    }
  }
}