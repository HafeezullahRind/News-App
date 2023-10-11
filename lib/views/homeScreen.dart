import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/views/NewsDetailPage.dart';

import '../model/newsModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var devwidth;
  var devheight;

  Future<NewsModel?> getApidata() async {
    try {
      var response = await http.get(Uri.parse(
          'https://newsapi.org/v2/everything?q=Apple&from=2023-10-08&sortBy=popularity&apiKey=$your_api_key'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return NewsModel.fromJson(data);
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    devwidth = MediaQuery.of(context).size.width;
    devheight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Image.asset('assets/images/news_logo.png', height: 50),
        actions: const [
          Icon(
            Icons.search,
            color: Colors.black,
            size: 30,
          )
        ],
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<NewsModel?>(
        future: getApidata(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return Column(
              children: [
                SizedBox(
                  height: devheight * 0.4,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data?.articles.length ?? 0,
                    itemBuilder: (context, index) {
                      final article = snapshot.data!.articles[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return NewsDetails(
                                        article:
                                            snapshot.data!.articles[index]);
                                  },
                                ));
                              },
                              child: Container(
                                  width: devwidth * 0.8,
                                  height: devheight * 0.35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          article.urlToImage ?? ''),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          article.title.toString(),
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                  )),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Latest News',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Text('Sort by'),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: snapshot.data?.articles.length ?? 0,
                    itemBuilder: (context, index) {
                      final article = snapshot.data!.articles[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        article.title,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        article.description,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal),
                                      ),
                                      Text(
                                        'Posted at ${article.publishedAt.hour.toString() + "-" + article.publishedAt.minute.toString() + ' ' + article.publishedAt.timeZoneName}',
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          article.urlToImage ?? ''),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('Loading....'));
          }
        },
      ),
    );
  }
}
