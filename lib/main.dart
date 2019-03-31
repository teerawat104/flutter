import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_app2/data/newsresponse.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

class Todo {
  final String title;
  final String description;

  Todo(this.title, this.description);
}
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'Headlines'),
    );
  }
}

class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState( );
}

class DetailScreen extends StatelessWidget {
  // Declare a field that holds the Todo
  //final Todo todo;
  final News news;

  // In the constructor, require a Todo
  DetailScreen({Key key, @required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create our UI
    return Scaffold(
      appBar: AppBar(
        title: Text(news.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(news.description),
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  List<News> news =List<News>();
  bool _isLoading = false;
  File _image;
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
        setState(() {
          _image = image;
        });
      }
    
      int _counter = 0;
      int _currentIndex = 0;
      void onTabTapped(int index) {
        setState(() {
          _currentIndex = index;
        });
      }
      Future<String> _reload() async {
         setState(() {
           _isLoading =true;
         });
         String result = await Future.delayed(Duration(seconds: 2),()=>"success");
         setState(() {
            _isLoading=false;
         });
        return result;
      }
    
      _fetchNew() async{
        setState(() {
          _isLoading=true;
        });
        final response = await
            http.get('https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=d7c1600e87694bb0be6c509aedfee316');
        var responseJson= json.decode(response.body);
        NewsResponse newsResponse = NewsResponse.fromJson(responseJson);
        setState(() {
          news = newsResponse.articles;
          _isLoading=false;
        });
    
      }
    
      @override
      void initState(){
        _reload();
        super.initState();
    
      }
    
      @override
      Widget build(BuildContext context) {
        // This method is rerun every time setState is called, for instance as done
        // by the _incrementCounter method above.
        //
        // The Flutter framework has been optimized to make rerunning build methods
        // fast, so that you can just rebuild anything that needs updating rather
        // than having to individually change instances of widgets.
        return Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(widget.title),
              centerTitle: true,
            //backgroundColor: Colors.white ,
          ),
         // body:  _isLoading ? _buildLoading():  _buildContent(),
          body: Center(
            child: _image == null
                ? Text('No image selected.')
                : Image.file(_image),
          )
          ,
          floatingActionButton: FloatingActionButton(
            onPressed: getImage,
            tooltip: 'Pick Image',
            child: Icon(Icons.add_a_photo),
          ),
     bottomNavigationBar: BottomNavigationBar(
            onTap: onTabTapped, // new
            currentIndex: _currentIndex, // new
            items: [
              BottomNavigationBarItem(
                icon: new Icon(Icons.assistant),
                title: new Text('My Feed'),
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.work),
                title: new Text('Headlines'),
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.star_border),
                  title: Text('Fav')
              )
            ],
    
          ),
           // floatingActionButton: FloatingActionButton(onPressed: null),
         /* floatingActionButton: FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
          */
    
    
        );
      }
    
      Widget _buildLoading(){
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      Widget _buildContent(){
        return   ListView.builder(
          itemCount: news.length,
          itemBuilder: (context, index) {
    
            return ListTile(
              title: Text(news[index].title),
              // When a user taps on the ListTile, navigate to the DetailScreen.
              // Notice that we're not only creating a DetailScreen, we're
              // also passing the current todo through to it!
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(news: news[index]),
                  ),
                );
              },
            );
    
          },
        );
    
      }
    }
    
    class ImagePicker {
      static pickImage({ImageSource source}) {}
}
