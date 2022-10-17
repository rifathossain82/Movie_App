import 'dart:convert';
import 'package:get/get.dart';
import 'package:movie_app/src/models/movies_model.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/src/network/endpoint.dart';
import 'package:movie_app/src/network/network_utils.dart';

class MovieController extends GetxController{
  var movieList = <Movie>[].obs;
  var isLoading = true.obs;
  var pageNumber = 1.obs;
  var totalPageNumber = 1.obs;
  var loadedCompleted = false.obs;

  @override
  void onInit() {
    getMovies();
    super.onInit();
  }

  void getMovies() async{
    try{
      http.Response response = await Network.getRequest(Endpoint.popularMovies(pageNumber: pageNumber.value));
      if(response.statusCode >= 200 && response.statusCode <= 210){
        var data = jsonDecode(response.body);
        pageNumber.value = data['page'];
        totalPageNumber.value = data['total_pages'];
        pageNumber.value < totalPageNumber.value ? loadedCompleted(false) : loadedCompleted(true);
        List results = data['results'];
        movieList.addAll(results.map((e) => Movie.fromJson(e)).toList());
        isLoading(false);
        print('Success');
      }
      else{
        isLoading(false);
        print('Failed To Load Data');
      }
    }catch(e){
      isLoading(false);
      print('Error');
    }
  }
}