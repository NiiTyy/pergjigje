import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pergjigje/src/global/models/post_model.dart';
import 'package:pergjigje/src/global/models/search_model.dart';
import 'package:pergjigje/src/global/services/api_services.dart';

class PostsController extends GetxController {
  var isLoading = false.obs;
  var showBackToTopButton = false.obs;
  var postsList = <PostModel>[].obs;
  var searchList = <PostModel>[].obs;
  var searchItemIdList = <SearchModel>[].obs;

  int _page = 10;
  int categoryId = 10;

  ScrollController scrollController = ScrollController();
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<void> fetchPosts({
    int? pageNum = 0,
  }) async {
    try {
      if (postsList.isEmpty || pageNum == 0) {
        isLoading(true);
        postsList.clear();
      }

      var posts = await ApiServices.fetchPosts(
        pageNum: pageNum!.toInt(),
      );

      if (posts.isNotEmpty) {
        _page += 5;
        postsList.assignAll(posts);
      }
    } finally {
      isLoading(false);
    }
  }

  _loadMoreScrollListener() {
    scrollController.addListener(
      () async {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          fetchPosts(
            pageNum: _page,
          );
        }
      },
    );
  }

  _showBackToTopButton() {
    scrollController.addListener(() {
      if (scrollController.offset >= 400) {
        showBackToTopButton(true); // show the back-to-top button
      } else {
        showBackToTopButton(false); // hide the back-to-top button
      }
    });
  }

  void scrollToTop() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.linear,
    );
  }

  @override
  void onInit() {
    fetchPosts(
      pageNum: _page,
    );

    super.onInit();
  }

  @override
  void onReady() {
    _loadMoreScrollListener();
    _showBackToTopButton();
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.removeListener(
      () {
        _loadMoreScrollListener();
        _showBackToTopButton();
      },
    );
    scrollController.dispose();
    super.onClose();
  }
}
