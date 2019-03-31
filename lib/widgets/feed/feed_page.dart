import 'package:flutter/material.dart';
import 'package:flutter_app2/data/newsresponse.dart';
import 'package:flutter_app2/models/headline.dart';
import 'package:scoped_model/scoped_model.dart';

class FeedPage extends StatefulWidget{
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage>{
  @override
  void initState(){
    super.initState();
    HeadlineModel headlineModel = ScopedModel.of<HeadlineModel>(context);
    headlineModel.fetchNews();
  }

  @override
  Widget build(BuildContext context) {
     return ScopedModelDescendant<HeadlineModel>{
       builder: (context, child, model){
         return Container(
        color: Colors.white,
        child: model.isLoading
        ?Center(
          child: CircularProgressIndicator() ,
          )
          :ListView.builder(
             itemCount: model.newList.length,
            itemBuilder: (BuildContext context, int index){
                return Padding(
                  padding: const EdgeInsets.only(top:20),
                  child: GestureDetector(
                    onTap:(){
                      openDetailPage(model.newsList[index]);
                    },
                    child: NewsCard(model.newsList[index]),
                  ),
                )
            },
          )
         )
       }
     }
  }
}