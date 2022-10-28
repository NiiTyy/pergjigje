import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pergjigje/src/global/models/post_model.dart';
import 'package:pergjigje/src/global/widgets/html_title_rendered.dart';
import 'package:pergjigje/src/global/widgets/post_image_widget.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen(
      {Key? key, required this.model, required this.navigateFrom})
      : super(key: key);

  final PostModel model;
  final int navigateFrom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Hero(
          tag: 'appBar1',
          child: Material(
            color: Colors.transparent,
            textStyle: const TextStyle(overflow: TextOverflow.ellipsis),
            child: HtmlTitleRendered(
              post: model,
              color: const Color.fromARGB(255, 255, 255, 255),
              font: 'DMSerifDisplay',
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'postImage${model.id}',
              child: Material(
                child: PostImageWidget(
                  post: model,
                  ctx: context,
                  radius: 0.0,
                ),
              ),
            ),
            Hero(
              tag: 'title${model.id}',
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Material(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HtmlTitleRendered(
                        post: model,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          '${model.author.toString()} - ${model.postedDate.toString()}',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 22.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            contentRendered(model),
          ],
        ),
      ),
    );
  }

  Widget contentRendered(PostModel post) {
    return Html(
      data: (post.postContent).toString(),
      style: {
        "div": Style(
          fontSize: const FontSize(15),
          textAlign: TextAlign.justify,
        ),
      },
      shrinkWrap: true,
    );
  }
}
