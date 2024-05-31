import 'package:dailydays/consts/vars.dart';
import 'package:dailydays/models/bookmarks_model.dart';
import 'package:dailydays/providers/bookmarks_provider.dart';
import 'package:dailydays/widgets/drawer_widget.dart';
import 'package:dailydays/widgets/empty_screen.dart';
import 'package:dailydays/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/utils.dart';
import '../widgets/articles_widget.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  Widget build(BuildContext context) {
    // Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).getColor;
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: color),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          'Bookmarks',
          style: GoogleFonts.lobster(
              textStyle:
                  TextStyle(color: color, fontSize: 20, letterSpacing: 0.6)),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder<List<BookmarksModel>>(
              future: Provider.of<BookmarksProvider>(context, listen: false)
                  .fetchBookmarks(),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingWidget(newsType: NewsType.allNews);
                } else if (snapshot.hasError) {
                  return Expanded(
                    child: EmptyNewsWidget(
                      text: "an error occured ${snapshot.error}",
                      imagePath: 'assets/images/no_news.png',
                    ),
                  );
                } else if (snapshot.data == null) {
                  return const EmptyNewsWidget(
                    text: 'You didn\'t add anything yet to your bookmarks',
                    imagePath: "assets/images/bookmark.png",
                  );
                }
                return Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (ctx, index) {
                        return ChangeNotifierProvider.value(
                            value: snapshot.data![index],
                            child: const ArticlesWidget(
                              isBookmark: true,
                            ));
                      }),
                );
              })),
        ],
      ),
    );
  }
}
