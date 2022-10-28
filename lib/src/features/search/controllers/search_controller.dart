import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pergjigje/src/global/constants/colors.dart';
import 'package:pergjigje/src/global/models/post_model.dart';
import 'package:pergjigje/src/global/models/search_model.dart';
import 'package:pergjigje/src/global/services/api_services.dart';

class SearchController extends GetxController {
  var isLoading = false.obs;
  var isFilling = false.obs;
  var showBackToTopButton = false.obs;
  var searchList = <PostModel>[].obs;
  var searchItemIdList = <SearchModel>[].obs;

  CancelableOperation? _myCancelableFuture;

  int postItemCount = 4;
  int categoryId = 10;

  ScrollController scrollController = ScrollController();
  ScrollController singleScrollController = ScrollController();
  TextEditingController searchTextController = TextEditingController();
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<List<PostModel>> listFuture(
      {int? pageNum = 0, String? searchText = ''}) async {
    return await ApiServices.fetchPostsFromSearch(
      searchText: searchText.toString(),
      pageNum: pageNum!.toInt(),
    );
  }

  Future<void> fetchPosts({int? pageNum = 0, String? searchText = ''}) async {
    try {
      isFilling(true);
      if (searchList.isEmpty || pageNum == 0) {
        isLoading(true);
        searchList.clear();
      }

      _myCancelableFuture = CancelableOperation.fromFuture(
        listFuture(pageNum: pageNum, searchText: searchText),
        onCancel: () => Get.snackbar(
          'Anulohet',
          'Kerkimi per \'$searchText\' u anulua',
          backgroundColor: AppColors.progresIndicatorColor,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
        ),
      );

      var posts = await _myCancelableFuture?.value;

      if (posts.isNotEmpty) {
        postItemCount += 2;
        searchList.assignAll(posts);
      }
    } finally {
      isFilling(false);
      isLoading(false);
    }
  }

  Future<void> cancelFunction(String name) async {
    await _myCancelableFuture?.cancel();
    isLoading(false);
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
    _showBackToTopButton();
    super.onInit();
  }

  // @override
  // void onReady() {
  //   _showBackToTopButton();
  //   super.onReady();
  // }

  @override
  void onClose() {
    scrollController.removeListener(
      () {
        _showBackToTopButton();
      },
    );
    scrollController.dispose();
    super.onClose();
  }
}
