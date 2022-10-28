import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pergjigje/src/features/dashboard/controllers/posts_controller.dart';
import 'package:pergjigje/src/global/widgets/costume_progress_indicator.dart';
import 'package:pergjigje/src/global/widgets/post_item_widget.dart';
import 'package:pergjigje/src/global/constants/colors.dart';
import 'package:pergjigje/src/global/constants/styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PostsController _postsController =
      Get.put<PostsController>(PostsController());

  @override
  Widget build(BuildContext context) {
    return GetX<PostsController>(
      init: _postsController,
      builder: (PostsController postsController) {
        return Scaffold(
          appBar: AppBar(
            title: Hero(
              tag: 'appBar1',
              child: Material(
                color: Colors.transparent,
                textStyle: const TextStyle(overflow: TextOverflow.ellipsis),
                child: Text(
                  'Ballina',
                  style: AppStyles.dashboardAppBarTextStyle,
                ),
              ),
            ),
          ),
          body: postsController.isLoading.value == true
              ? const CostumeProgressIndicator()
              : RefreshIndicator(
                  key: _postsController.refreshKey,
                  color: AppColors.progresIndicatorColor,
                  onRefresh: () => postsController.fetchPosts(
                    pageNum: 10,
                  ),
                  child: ListView.builder(
                    itemCount: postsController.postsList.length,
                    shrinkWrap: true,
                    controller: _postsController.scrollController,
                    itemBuilder: (context, index) {
                      var data = postsController.postsList[index];
                      if (index == postsController.postsList.length - 1) {
                        return const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: CostumeProgressIndicator(),
                        );
                      } else {
                        return PostItemWidget(
                          data: data,
                          index: index,
                        );
                      }
                    },
                  ),
                ),
          floatingActionButton:
              postsController.showBackToTopButton.value == false
                  ? null
                  : FloatingActionButton(
                      onPressed: () {
                        postsController.scrollToTop();
                      },
                      child: const Icon(Icons.arrow_upward),
                      backgroundColor: AppColors.mainColor,
                    ),
        );
      },
    );
  }
}
