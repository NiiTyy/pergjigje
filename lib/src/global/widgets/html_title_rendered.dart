import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pergjigje/src/global/models/post_model.dart';

class HtmlTitleRendered extends StatelessWidget {
  const HtmlTitleRendered(
      {Key? key,
      required this.post,
      required this.color,
      this.font,
      this.fontSize})
      : super(key: key);

  final PostModel post;
  final Color color;
  final String? font;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    String title = '<p>${post.title}</p>';
    return Html(
      data: title,
      style: {
        "p": Style(
          fontSize: FontSize(fontSize ?? 20),
          fontWeight: FontWeight.w600,
          fontFamily: font ?? 'Inter',
          color: color,
        ),
      },
      shrinkWrap: true,
    );
  }
}
