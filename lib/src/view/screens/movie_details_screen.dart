import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/src/controller/trailers_controller.dart';
import 'package:movie_app/src/models/movies_model.dart';
import 'package:movie_app/src/network/endpoint.dart';
import 'package:movie_app/src/view/screens/video_player_screen.dart';

class MovieDetails extends StatefulWidget {
  const MovieDetails({Key? key, required this.movie}) : super(key: key);
  final Movie movie;

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {

  final MovieTrailersController movieTrailersController = Get.put(MovieTrailersController());

  @override
  void initState() {
    fetchMovieTrailers();
    super.initState();
  }

  fetchMovieTrailers(){
    movieTrailersController.getMovieTrailers(movieID: widget.movie.id);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('MovieDetail'),
      ),
      body: ListView(
        children: [
          buildTitle(size, widget.movie.title.toString()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildImageYearRatingAndFavoriteButton(size),
                const SizedBox(height: 16,),
                Text('${widget.movie.overview}'),
                const Divider(color: Colors.black87,),
                const Text('Trailers: ', style: TextStyle(fontSize: 18, color: Colors.black54),),
                buildTrailers(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildTitle(Size size, String title){
    return Container(
      height: size.height * 0.18,
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.teal,
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        maxLines: 2,
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),),
    );
  }

  Widget buildImageYearRatingAndFavoriteButton(Size size){
    return Row(
      children: [
        SizedBox(
          height: size.height * 0.35,
          width: size.width * 0.4,
          child: Image.network(Endpoint.thumbUrl(posterPath: widget.movie.posterPath), fit: BoxFit.cover,),
        ),
        const SizedBox(width: 16,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.movie.releaseDate.toString().substring(0, 4),
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                '${widget.movie.voteAverage}/10',
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400),
              ),
              MaterialButton(
                onPressed: (){},
                color: Colors.blue.shade100,
                child: const Text('Make as Favorite'),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget buildTrailers(){
    return GetX<MovieTrailersController>(builder: (controller){
      if(controller.isLoading.value){
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      else if(controller.isLoading.value==false && controller.movieTrailerList.isEmpty){
        return Stack(
          children: [
            ListView(),
            const Center(
              child: Text('No Trailers Found!'),
            )
          ],
        );
      }
      else{
        return ListView.separated(
          separatorBuilder: (context, index) => const Divider(color: Colors.black54, height: 10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.movieTrailerList.length,
          itemBuilder: (context, index){
            return ListTile(
              onTap: (){
                final trailer = controller.movieTrailerList[index];
                Get.to(() => VideoPlayerScreen(
                    title: trailer.name.toString(),
                    videoID: trailer.key.toString()),
                );
              },
              leading: const Icon(Icons.play_arrow, size: 50, color: Colors.black54,),
              title: Text('Trailer ${index + 1}'),
            );
          },
        );
      }
    });
  }
}
