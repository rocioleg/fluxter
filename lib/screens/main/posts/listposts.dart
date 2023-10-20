import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluxter/models/post.dart';
//import 'package:fluxter/models/user.dart';
import 'package:fluxter/services/posts.dart';
import 'package:fluxter/services/user.dart';

class ListPosts extends StatefulWidget{
  const ListPosts({super.key});

  @override
  _ListPostsState createState() => _ListPostsState();

}

class _ListPostsState extends State<ListPosts>{
UserService userService = UserService(); 
PostService postService = PostService();

@override
Widget build(BuildContext context) {
 double userRating = 0;
 
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Fluxter',
    home: Scaffold(
      body: StreamBuilder<List<PostModel>>(
        
        stream: PostService().getFeed(), // Cambio de getPostsByUser a getFeed
        builder: (context, snapshot) {

          if (snapshot.hasData) {

            return ListView.builder(  
              //Para todos los posts
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
              final post = snapshot.data?[index];

              //print((post?.creator).toString());

              print(post!.img);

                return StreamBuilder(
                  stream: userService.getUserInfo(post?.creator),
                  builder: (context, msnapshot) {
                    return Column(
                      children: [
                        ListTile(
                          title: Row(
                            children: [
                              const Icon(Icons.person, size: 40),
                              const SizedBox(width: 10),
                              Text(post.creator),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                        if (post.img != '')
                          CachedNetworkImage(
                            imageUrl: post.img,
                            width: 100,
                            height: 100,
                            //placeholder: (context, imageUrl) => const CircularProgressIndicator(),
                            //errorWidget: (context, imageUrl, error) => const Icon(Icons.error),
                          ),
                        ListTile(
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(post!.text),
                              const SizedBox(height: 20),
                              RatingBar.builder(
                                initialRating: 0,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 20,
                                itemPadding: const EdgeInsets.symmetric(horizontal: 0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  userRating = rating;
                                },
                              ),
                              const SizedBox(height: 20),
                              Text("Estrellas: ${userRating.toStringAsFixed(1)}"),
                              const SizedBox(height: 20),
                              Text(post.timestamp.toDate().toString()),
                            ],
                          ),
                        ),
                        const Divider(),
                      ],
                    );
                  },
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    ),
  );
}
}



