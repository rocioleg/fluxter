import 'package:flutter/material.dart';
import 'package:fluxter/screens/main/posts/listposts.dart';
import 'package:fluxter/services/posts.dart';

class Feed extends StatefulWidget {
  const Feed({ Key? key }) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  get initialData => null;
  PostService postService = PostService();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: ListPosts());
  }
}