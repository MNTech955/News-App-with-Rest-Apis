

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NewsDetailsScreen extends StatefulWidget {
final  String newImage,newsTitle,newsDate,author, description,content, source;
 NewsDetailsScreen({super.key,
 required this.author,
 required this.content,
 required this.description,
 required this.newImage,
 required this.newsDate,
 required this.newsTitle,
 required this.source
  });

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  final format = DateFormat('MMMM dd, yyyy');
  @override
  Widget build(BuildContext context) {
     final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;
    DateTime dateTime=DateTime.parse(widget.newsDate);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            height: height*.45,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(40),
              ),
              child: CachedNetworkImage(
                imageUrl: widget.newImage,
                fit: BoxFit.cover,
                placeholder: (context, url)=>Center(child: CircularProgressIndicator(),),
                ),
            ),
          ),
          Container(
            height: height*.6,
            margin: EdgeInsets.only(top: height*.4),
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(40)
              )
            ),
            child: ListView(
              children: [
                Text(widget.newsTitle,
                style: GoogleFonts.poppins(fontSize:20, color:Colors.black87, fontWeight:FontWeight.bold),
                ),
                SizedBox(height: height*.02,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.source,style: GoogleFonts.poppins(fontSize:13, color:Colors.black87, fontWeight:FontWeight.bold) ),
                    Text(format.format(dateTime),style: GoogleFonts.poppins(fontSize:12, color:Colors.black87, fontWeight:FontWeight.bold) ),
                  ],
                ),
                SizedBox(height: height*.03,),
                Text(widget.description,style: GoogleFonts.poppins(fontSize:15, color:Colors.black87, fontWeight:FontWeight.w500) ),

              ],
            ),
          )
        ],
      ),
    );
  }
}