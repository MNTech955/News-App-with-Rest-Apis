import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news_app_with_apis/model/new_channel_headlines_model.dart';
import 'package:news_app_with_apis/model/categories_news_model.dart';
import 'package:news_app_with_apis/repository/news_repository.dart';
import 'package:news_app_with_apis/view/categories_screen.dart';
import 'package:news_app_with_apis/view/news_details_screen.dart';

enum FilterList {
  bbcNews,
  aryNews,
  independent,
  reuters,
  cnn,
  aljazeera,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NewsRepository _newsRepository = NewsRepository();
  FilterList? selectedMenu;
  final format = DateFormat('MMMM dd, yyyy');
  String channelName = 'bbc-news'; // Default channel name
  String categoryName = 'business'; // Default category name

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategoriesScreen()),
            );
          },
          icon: Image.asset(
            "images/category_icon.png",
            height: 30,
            width: 30,
          ),
        ),
        centerTitle: true,
        title: Text(
          "News",
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        actions: [
          PopupMenuButton<FilterList>(
            initialValue: selectedMenu,
            onSelected: (FilterList item) {
              setState(() {
                selectedMenu = item;
                switch (item) {
                  case FilterList.bbcNews:
                    channelName = "bbc-news";
                    break;
                  case FilterList.aryNews:
                    channelName = "ary-news";
                    break;
                  case FilterList.independent:
                    channelName = "independent";
                    break;
                  case FilterList.reuters:
                    channelName = "reuters";
                    break;
                  case FilterList.cnn:
                    channelName = "cnn";
                    break;
                  case FilterList.aljazeera:
                    channelName = "al-jazeera-english";
                    break;
                }
              });

              // Trigger API call with the selected source
              // fetchNewsChannelHeadlines(channelName);
            },
            itemBuilder: (context) => <PopupMenuEntry<FilterList>>[
              PopupMenuItem<FilterList>(
                value: FilterList.bbcNews,
                child: Text("BBC News"),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.aryNews,
                child: Text("Ary News"),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.independent,
                child: Text("Independent"),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.reuters,
                child: Text("Reuters"),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.cnn,
                child: Text("CNN"),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.aljazeera,
                child: Text("Al Jazeera"),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: height * 0.5,
            width: width,
            child: FutureBuilder<NewsChannelHeadlinesModel>(
              future: _newsRepository.fetchNewsChannelHeadliensApi(channelName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitCircle(
                      size: 50,
                      color: Colors.blue,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error fetching news'),
                  );
                } else if (snapshot.hasData && snapshot.data != null) {
                  return ListView.builder(
                    itemCount: snapshot.data!.articles!.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(
                          snapshot.data!.articles![index].publishedAt.toString());
                      return SizedBox(
                        width: width * 0.9,
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsDetailsScreen(
                              author: snapshot.data!.articles![index].author??'',
                              content: snapshot.data!.articles![index].content??'',
                              description: snapshot.data!.articles![index].description??'',
                              newImage: snapshot.data!.articles![index].urlToImage??'',
                              newsDate: snapshot.data!.articles![index].publishedAt.toString(),
                              newsTitle: snapshot.data!.articles![index].title??'',
                              source: snapshot.data!.articles![index].source!.name??'',
                            )));
                          },
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data!.articles![index]
                                        .urlToImage
                                        .toString(),
                                    height: height * 0.5,
                                    width: width * 0.9,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => spinKit2,
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error_outline,
                                            color: Colors.red),
                                  ),
                                ),
                                Container(
                                  width: width * 0.9,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.7),
                                      ],
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.05, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          snapshot.data!.articles![index].title
                                              .toString(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            snapshot.data!.articles![index]
                                                .source!.name
                                                .toString(),
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            format.format(dateTime),
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text('No data available'),
                  );
                }
              },
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<CategoriesNewsModel>(
              future: _newsRepository.fetchCategoriesNewsApi("General"),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitCircle(
                      size: 50,
                      color: Colors.blue,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error fetching categories news'),
                  );
                } else if (snapshot.hasData && snapshot.data != null) {
                  return ListView.builder(
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(
                          snapshot.data!.articles![index].publishedAt.toString());
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: InkWell(
                            onTap: () {
                              // Handle tap on category news item
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data!.articles![index]
                                        .urlToImage
                                        .toString(),
                                    height: height * 0.18,
                                    width: width * 0.3,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => spinKit2,
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error_outline,
                                            color: Colors.red),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data!.articles![index].title
                                            .toString(),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            snapshot.data!.articles![index]
                                                .source!.name
                                                .toString(),
                                            style: GoogleFonts.poppins(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            format.format(dateTime),
                                            style: GoogleFonts.poppins(
                                              fontSize: 8,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text('No data available'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

const spinKit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);
