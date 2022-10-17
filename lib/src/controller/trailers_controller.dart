import 'dart:convert';
import 'package:get/get.dart';
import 'package:movie_app/src/models/movie_trailers_model.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/src/network/endpoint.dart';
import 'package:movie_app/src/network/network_utils.dart';

class MovieTrailersController extends GetxController{
  var movieTrailerList = <MovieTrailers>[].obs;
  var isLoading = true.obs;

  void getMovieTrailers({required movieID}) async{
    try{
      http.Response response = await Network.getRequest(Endpoint.movieTrailers(movieID: movieID));

      if(response.statusCode >= 200 && response.statusCode <= 210){
        List results = jsonDecode(response.body)['results'];
        movieTrailerList.addAll(results.map((e) => MovieTrailers.fromJson(e)).toList());
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