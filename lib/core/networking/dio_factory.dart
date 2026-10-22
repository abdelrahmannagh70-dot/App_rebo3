import 'package:app3/core/networking/api_endpoint.dart';
import 'package:dio/dio.dart';
class DioFactory{
static Dio? dio;
static init(){
  dio=Dio(
    BaseOptions(baseUrl:ApiEndPoint.baseUrl)
  );
}

}