import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pergjigje/src/global/models/post_model.dart';
import 'package:pergjigje/src/global/screens/post_detail_screen.dart';
import 'package:pergjigje/src/global/widgets/html_title_rendered.dart';
import 'package:pergjigje/src/global/widgets/post_image_widget.dart';

class PostItemWidget extends StatelessWidget {
  const PostItemWidget({
    Key? key,
    required this.data,
    required this.index,
  }) : super(key: key);

  final PostModel data;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => PostDetailScreen(
            model: data,
            navigateFrom: 0,
          ),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 500),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.all(10.0),
        elevation: 5,
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'postImage${data.id}',
              child: Material(
                child: PostImageWidget(
                  post: data,
                  ctx: context,
                  radius: 20.0,
                ),
              ),
            ),
            Hero(
              tag: 'title${data.id}',
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Material(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HtmlTitleRendered(
                        post: data,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          '${data.author.toString()} - ${data.postedDate.toString()}',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
