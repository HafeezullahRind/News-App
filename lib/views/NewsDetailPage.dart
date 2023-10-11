import 'package:flutter/material.dart';
import 'package:news_app/model/newsModel.dart';

class NewsDetails extends StatelessWidget {
  NewsDetails({super.key, required this.article});

  final Article article;

  var devwidth;
  var devheight;

  @override
  Widget build(BuildContext context) {
    devwidth = MediaQuery.of(context).size.width;
    devheight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: devwidth,
            height: devheight * 0.5,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(article.urlToImage ?? ''),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    article.author.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    article.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Text(
                      article.description,
                      style: const TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 15),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 10,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
