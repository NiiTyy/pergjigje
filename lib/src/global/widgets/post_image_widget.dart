import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pergjigje/src/global/models/post_model.dart';
import 'package:pergjigje/src/global/constants/colors.dart';

class PostImageWidget extends StatelessWidget {
  const PostImageWidget({
    Key? key,
    required this.post,
    required this.ctx,
    required this.radius,
  }) : super(key: key);

  final PostModel post;
  final BuildContext ctx;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 220,
        child: CachedNetworkImage(
          imageUrl: post.imageUrl,
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
              child: CircularProgressIndicator(
            value: downloadProgress.progress,
            color: AppColors.progresIndicatorColor,
          )),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
