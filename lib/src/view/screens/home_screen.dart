import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/src/controller/movie_controller.dart';
import 'package:movie_app/src/network/endpoint.dart';
import 'package:movie_app/src/view/screens/movie_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final ScrollController _scrollController = ScrollController();
  final MovieController movieController = Get.put(MovieController());
  var pageNumber=Get.find<MovieController>().pageNumber;

  @override
  void initState(){
    scrollIndicator();
    super.initState();
  }

  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }

  void scrollIndicator() {
    _scrollController.addListener(
          () {
        if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
            !_scrollController.position.outOfRange) {
          print('reach to bottom');
          if(!Get.find<MovieController>().loadedCompleted.value){
            ++movieController.pageNumber.value;
            movieController.getMovies();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    double height = 0;
    double width = 0;
    if (!isLandscape){
      height = (size.height - kToolbarHeight - 24) / 2;
      width = size.width / 2;
    }
    if (isLandscape) {
      height = size.height - kToolbarHeight - 24;
      width = size.width / 3;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pop Movies'),
      ),
      body: GetX<MovieController>(builder: (controller){
        if(controller.isLoading.value){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        else if(controller.isLoading.value==false && controller.movieList.isEmpty){
          return Stack(
            children: [
              ListView(),
              const Center(
                child: Text('No Data Found!'),
              )
            ],
          );
        }
        else{
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isLandscape? 3 : 2,
              childAspectRatio: (width / height),
            ),
            controller: _scrollController,
            itemCount: controller.movieList.length+1,
            itemBuilder: (context, index){
              if(index==controller.movieList.length &&
                  !Get.find<MovieController>().loadedCompleted.value){
                return const Center(child: CircularProgressIndicator());
              }
              else if(index==controller.movieList.length &&
                  Get.find<MovieController>().loadedCompleted.value){
                return Container();
              }
              else{
                final posterPath = controller.movieList[index].posterPath;
                final movie = controller.movieList[index];
                return InkWell(
                  onTap: (){
                    Get.to(() => MovieDetails(movie: movie));
                  },
                  child: GridTile(
                    child: Image.network(
                      Endpoint.thumbUrl(posterPath: posterPath),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }
            },
          );
        }
      }),
    );
  }
}
