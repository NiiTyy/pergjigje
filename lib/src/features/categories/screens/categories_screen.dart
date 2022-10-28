import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pergjigje/src/features/categories/controllers/categories_comtroller.dart';
import 'package:pergjigje/src/features/categories/controllers/categories_post_controller.dart';
import 'package:pergjigje/src/features/categories/screens/categories_detail_screen.dart';
import 'package:pergjigje/src/global/widgets/costume_progress_indicator.dart';
import 'package:pergjigje/src/global/constants/colors.dart';
import 'package:pergjigje/src/global/constants/styles.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final CategoriesController categoriesController =
      Get.put(CategoriesController());

  final CategoriesPostController categoriesPostController =
      Get.put(CategoriesPostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: 'appBar2',
          child: Material(
            color: Colors.transparent,
            textStyle: const TextStyle(overflow: TextOverflow.ellipsis),
            child: Text(
              'Kategoritë',
              style: AppStyles.dashboardAppBarTextStyle,
            ),
          ),
        ),
      ),
      body: Obx(
        () {
          if (categoriesController.isLoading.value) {
            return const CostumeProgressIndicator();
          } else {
            return RefreshIndicator(
              key: categoriesController.refreshKey,
              color: AppColors.progresIndicatorColor,
              onRefresh: () => categoriesController.fetchCategories(
                pageNum: 20,
              ),
              child: ListView.builder(
                itemCount: categoriesController.categoriesList.length,
                padding: const EdgeInsets.only(right: 5),
                shrinkWrap: true,
                controller: categoriesController.scrollController,
                itemBuilder: (context, index) {
                  var data = categoriesController.categoriesList[index];
                  var offStage = data.tag!.contains(categoriesController
                      .categoriesList[index == 0 ? 12 : index - 1].tag
                      .toString());
                  if (index == categoriesController.categoriesList.length - 1) {
                    return const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: CostumeProgressIndicator(),
                    );
                  } else {
                    return GestureDetector(
                      onTap: () {
                        categoriesPostController.categoryId =
                            data.categoryId!.toInt();
                        categoriesPostController.fetchCategoryPosts(
                          pageNum: 10,
                          categoryId: data.categoryId,
                        );
                        Get.to(() => CategoriesDetailScreen(
                              model: data,
                            ));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Offstage(
                            offstage: offStage,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              color: const Color(0xffF1EDD5),
                              child: Text(
                                data.tag.toString(),
                                textAlign: TextAlign.start,
                                style: AppStyles.textDMSerifDisplay,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Text(
                              data.categoryName.toString(),
                              style: AppStyles.textDMSerifDisplay,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Text(
                              data.count.toString(),
                              style: AppStyles.countTextDMSerifDisplay,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }
}
