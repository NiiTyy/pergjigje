import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pergjigje/src/global/models/category_model.dart';
import 'package:pergjigje/src/global/services/api_services.dart';

class CategoriesController extends GetxController {
  var isLoading = false.obs;
  var isFilling = false.obs;
  var showBackToTopButton = false.obs;
  var categoriesList = <CategoryModel>[].obs;
  int categoryItemCount = 20;

  ScrollController scrollController = ScrollController();
  ScrollController categoryPostsScrollController = ScrollController();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var categoryPostsRefreshKey = GlobalKey<RefreshIndicatorState>();

  Future<void> fetchCategories({
    int? pageNum = 0,
  }) async {
    try {
      isFilling(true);
      if (categoriesList.isEmpty || pageNum == 0) {
        isLoading(true);
        categoriesList.clear();
      }

      var categories =
          await ApiServices.fetchCategories(pageNum: pageNum!.toInt());

      if (categories.isNotEmpty) {
        categoryItemCount += 5;
        categoriesList.assignAll(categories);
      }
    } finally {
      isFilling(false);
      isLoading(false);
    }
  }

  _loadMoreScrollListener() {
    scrollController.addListener(
      () async {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          fetchCategories(
            pageNum: categoryItemCount,
          );
        }
      },
    );
  }

  _showBackToTopButton() {
    scrollController.addListener(
      () {
        if (scrollController.offset >= 400) {
          showBackToTopButton(true); // show the back-to-top button
        } else {
          showBackToTopButton(false); // hide the back-to-top button
        }
      },
    );
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
    fetchCategories(pageNum: categoryItemCount);
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
    categoryPostsScrollController.dispose();
    super.onClose();
  }
}
