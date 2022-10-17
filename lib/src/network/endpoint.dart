class Endpoint{
  static const String _baseUrl = 'http://api.themoviedb.org/3';
  static const String _apiKey = '083a5cd0aef15617a375c3429c1737d2';
  static String popularMovies({required pageNumber}) => '$_baseUrl/movie/popular?api_key=$_apiKey&page=$pageNumber';
  static String thumbUrl({required posterPath}) => 'http://image.tmdb.org/t/p/w185/$posterPath';
  static String movieDetails({required movieID}) => '$_baseUrl/movie/$movieID?api_key=$_apiKey&language=en-US';
  static String movieTrailers({required movieID}) => '$_baseUrl/movie/$movieID/videos?api_key=$_apiKey&language=en-US';
  static String trailer({required trailerKey}) => 'https://www.youtube.com/watch?v=$trailerKey';
}