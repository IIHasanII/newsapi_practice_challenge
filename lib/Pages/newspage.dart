import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(NewsApp());

class NewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NewsListScreen(),
    );
  }
}

class NewsListScreen extends StatefulWidget {
  @override
  _NewsListScreenState createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  final String apiKey =
      'b35c944014de4ca0b451134e7c0fe4b3'; // Replace with your News API key
  final String apiUrl = 'https://newsapi.org/v2/top-headlines?country=us';

  Future<List<dynamic>> fetchNews() async {
    final response = await http.get(Uri.parse('$apiUrl&apiKey=$apiKey'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['articles'];
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchNews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<dynamic>newsList = snapshot.data!;
            return ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final newsItem = newsList[index];
                return CustomListTile(
                  title: newsItem["title"],
                  description: newsItem["description"],
                  imageUrl: newsItem["urlToImage"],
                );
              },
            );
          }
        },
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String? title;
  final String? description;
  final String? imageUrl;

  CustomListTile({this.title, this.description, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.5),blurRadius: 4.0,),
          
        ]
      ),
      

      child: Column(children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(image: imageUrl!=null ? NetworkImage(imageUrl!):NetworkImage('https://media.istockphoto.com/id/1409329028/vector/no-picture-available-placeholder-thumbnail-icon-illustration-design.jpg?s=612x612&w=0&k=20&c=_zOuJu755g2eEUioiOUdz_mHKJQJn-tDgIAhQzyeKUQ='))
          ),
        ),
        SizedBox(height: 15.0, ),
        Container(
          child: Text(title!, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
        ),
        SizedBox(height: 15.0,),
        Container(child: description!=null ? Text(description!) : Text('Empty'),)
      ]),
    );
    }
    }