import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pergjigje/src/global/models/post_model.dart';
import 'package:pergjigje/src/global/services/api_services.dart';

class CategoriesPostController extends GetxController {
  var isLoading = false.obs;
  var showBackToTopButton = false.obs;
  var categoryPostsList = <PostModel>[].obs;
  var categoryId = 0;
  int categoryPostItemCount = 10;

  ScrollController categoryPostsScrollController = ScrollController();
  var categoryPostsRefreshKey = GlobalKey<RefreshIndicatorState>();

  Future<void> fetchCategoryPosts({
    int? pageNum = 0,
    int? categoryId,
  }) async {
    try {
      if (categoryPostsList.isEmpty || pageNum == 0) {
        isLoading(true);
        categoryPostsList.clear();
      }

      var posts = await ApiServices.fetchCategoryPosts(
        pageNum: pageNum!.toInt(),
        categoryId: categoryId!.toInt(),
      );

      if (posts.isNotEmpty) {
        categoryPostItemCount += 5;
        categoryPostsList.assignAll(posts);
      }
    } finally {
      isLoading(false);
    }
  }

  _loadMoreCategoryPostsScrollListener() {
    categoryPostsScrollController.addListener(
      () async {
        if (categoryPostsScrollController.position.pixels ==
            categoryPostsScrollController.position.maxScrollExtent) {
          fetchCategoryPosts(
              pageNum: categoryPostItemCount, categoryId: categoryId);
        }
      },
    );
  }

  _showBackToTopButton() {
    categoryPostsScrollController.addListener(
      () {
        if (categoryPostsScrollController.offset >= 400) {
          showBackToTopButton(true); // show the back-to-top button
        } else {
          showBackToTopButton(false); // hide the back-to-top button
        }
      },
    );
  }

  void scrollToTop() {
    categoryPostsScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.linear,
    );
  }

  @override
  void onReady() {
    _loadMoreCategoryPostsScrollListener();
    _showBackToTopButton();
    super.onReady();
  }

  @override
  void onClose() {
    categoryPostsScrollController.removeListener(
      () {
        _loadMoreCategoryPostsScrollListener();
        _showBackToTopButton();
      },
    );
    categoryPostsScrollController.dispose();
    super.onClose();
  }
}
