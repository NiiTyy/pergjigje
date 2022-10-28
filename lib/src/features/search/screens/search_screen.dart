import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pergjigje/src/features/search/controllers/search_controller.dart';
import 'package:pergjigje/src/global/constants/colors.dart';
import 'package:pergjigje/src/global/models/post_model.dart';
import 'package:pergjigje/src/global/screens/post_detail_screen.dart';
import 'package:pergjigje/src/global/widgets/costume_progress_indicator.dart';
import 'package:pergjigje/src/global/widgets/html_title_rendered.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  final SearchController searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Scaffold(
          appBar: AppBar(
            // The search area here
            title: Row(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 35,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xff010202),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      controller: searchController.searchTextController,
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                          icon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            searchController.searchList.clear();
                            searchController.fetchPosts(
                              searchText:
                                  searchController.searchTextController.text,
                              pageNum: searchController.postItemCount,
                            );
                          },
                        ),
                        // suffixIcon: GestureDetector(
                        //   onTap: () {
                        //     /* Clear the search field */
                        //     searchController.searchTextController.clear();
                        //     searchController.searchList.clear();
                        //   },
                        //   child: const Icon(
                        //     Icons.clear,
                        //     color: Colors.white,
                        //   ),
                        // ),
                        hintStyle: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        hintText: 'Kërko...',
                        border: InputBorder.none,
                      ),
                      style: GoogleFonts.inter(
                          color: Colors.white, fontSize: 16.0),
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value) {
                        searchController.searchList.clear();
                        searchController.fetchPosts(
                          searchText: value,
                          pageNum: searchController.postItemCount,
                        );
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: searchController.searchList.isNotEmpty ||
                      searchController.isLoading.value == true,
                  child: GestureDetector(
                    onTap: () {
                      searchController.searchTextController.clear();
                      searchController.searchList.clear();
                      searchController.cancelFunction(
                          searchController.searchTextController.text);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        'Anuloni',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: searchController.isLoading.value == true
              ? const CostumeProgressIndicator()
              : searchController.searchList.isEmpty
                  ? Center(
                      child: Text(
                        'A jeni duke kërkuar diqka? \nAtëherë shkruaje lartë atë që po e kërkon.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : ListView(
                      controller: searchController.scrollController,
                      children: [
                        ListView.builder(
                          itemCount: searchController.searchList.length,
                          shrinkWrap: true,
                          // controller: searchController.scrollController,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            PostModel data = searchController.searchList[index];
                            return SearchItemWidget(data: data);
                          },
                        ),
                        searchController.isFilling.value == true
                            ? const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: CostumeProgressIndicator(),
                              )
                            : Offstage(
                                offstage: searchController.searchList.isEmpty,
                                child: GestureDetector(
                                  onTap: () {
                                    searchController.fetchPosts(
                                      searchText: searchController
                                          .searchTextController.text,
                                      pageNum: searchController.postItemCount,
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Më shumë rezultatet',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color:
                                              AppColors.progresIndicatorColor,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        color: AppColors.progresIndicatorColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ],
                    ),
          floatingActionButton:
              searchController.showBackToTopButton.value == false
                  ? null
                  : FloatingActionButton(
                      onPressed: () {
                        searchController.scrollToTop();
                      },
                      child: const Icon(Icons.arrow_upward),
                      backgroundColor: AppColors.mainColor,
                    ),
        );
      },
    );
  }
}

class SearchItemWidget extends StatelessWidget {
  const SearchItemWidget({Key? key, required this.data}) : super(key: key);

  final PostModel data;

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
        child: Row(
          children: [
            Expanded(
              child: Hero(
                tag: 'title${data.id}',
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      HtmlTitleRendered(
                        post: data,
                        fontSize: 16.0,
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
            Hero(
              tag: 'postImage${data.id}',
              child: SizedBox(
                height: 80,
                width: 80,
                child: CachedNetworkImage(
                  imageUrl: data.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const CostumeProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
