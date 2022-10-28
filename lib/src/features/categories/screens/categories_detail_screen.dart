import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pergjigje/src/features/categories/controllers/categories_post_controller.dart';
import 'package:pergjigje/src/global/models/category_model.dart';
import 'package:pergjigje/src/global/widgets/costume_progress_indicator.dart';
import 'package:pergjigje/src/global/widgets/post_item_widget.dart';
import 'package:pergjigje/src/global/constants/colors.dart';
import 'package:pergjigje/src/global/constants/styles.dart';

class CategoriesDetailScreen extends StatelessWidget {
  CategoriesDetailScreen({Key? key, required this.model}) : super(key: key);
  final CategoryModel model;
  final CategoriesPostController _categoriesPostController =
      Get.find<CategoriesPostController>();

  @override
  Widget build(BuildContext context) {
    return GetX<CategoriesPostController>(
      init: _categoriesPostController,
      builder: (CategoriesPostController categoriesPostController) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                categoriesPostController.categoryPostsList.clear();
                Get.back();
              },
            ),
            title: Hero(
              tag: 'appBar1',
              child: Material(
                color: Colors.transparent,
                textStyle: const TextStyle(overflow: TextOverflow.ellipsis),
                child: Text(
                  model.categoryName.toString(),
                  style: AppStyles.dashboardAppBarTextStyle,
                ),
              ),
            ),
          ),
          body: categoriesPostController.isLoading.value == true
              ? const CostumeProgressIndicator()
              : RefreshIndicator(
                  key: _categoriesPostController.categoryPostsRefreshKey,
                  color: AppColors.progresIndicatorColor,
                  onRefresh: () => categoriesPostController.fetchCategoryPosts(
                    pageNum: 10,
                    categoryId: model.categoryId,
                  ),
                  child: ListView.builder(
                    itemCount:
                        categoriesPostController.categoryPostsList.length,
                    shrinkWrap: true,
                    controller:
                        _categoriesPostController.categoryPostsScrollController,
                    itemBuilder: (context, index) {
                      var data =
                          categoriesPostController.categoryPostsList[index];
                      if (index ==
                          categoriesPostController.categoryPostsList.length -
                              1) {
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
              categoriesPostController.showBackToTopButton.value == false
                  ? null
                  : FloatingActionButton(
                      onPressed: () {
                        categoriesPostController.scrollToTop();
                      },
                      child: const Icon(Icons.arrow_upward),
                      backgroundColor: AppColors.mainColor,
                    ),
        );
      },
    );
  }
}
