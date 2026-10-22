import 'package:app3/core/networking/dio_factory.dart';
import 'package:app3/core/services/local/local_Helper.dart';
import 'package:app3/core/utils/app.constans.dart';
import 'package:dio/dio.dart';

class AuthRepo {


  Future<bool> login({required String email, required String password}) async {
    try {
      final response = await DioFactory.dio?.post(
        'https://codingarabic.eraapro.com/api',
        data: {'email': email, 'password': password},
      );

      if (response?.statusCode == 200) {
        String? token = response?.data["data"]["token"];
        saveToken(token);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
  saveToken(String? token)async{
   await localHelper.prefs?.setString(AppConstans.userToken, token??"");
  }
}
