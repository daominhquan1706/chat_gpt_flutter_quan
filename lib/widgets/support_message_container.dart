import 'package:chat_gpt_flutter_quan/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SupportMessageContainerWidgetType {
  search,
  copy,
}

class SupportMessageContainerWidget extends GetWidget<ChatGptContainerWidgetController> {
  const SupportMessageContainerWidget(
    this.controller, {
    super.key,
  });

  @override
  final ChatGptContainerWidgetController controller;

  void onTap(SupportMessageContainerWidgetType type) {}

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.start,
              spacing: 8,
              children: [
                _buildButton(
                  'Search',
                  Image.network(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWMf1IQ1kT_4J8sAYnqYPK78KtKj2NRgKOfw63VKnqahHz6fubmFhi1yDRcbP8hD2NaJs&usqp=CAU',
                    width: 20,
                    height: 20,
                  ),
                  () {
                    controller.searchText();
                  },
                ),
                _buildButton(
                  'Copy',
                  const Icon(
                    Icons.copy,
                    size: 20,
                  ),
                  () {
                    controller.copyText();
                  },
                ),
              ],
            ).paddingSymmetric(horizontal: 16, vertical: 14),
            if (controller.listKeywords.isNotEmpty == true)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 70,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemCount: controller.listKeywords.length,
                  itemBuilder: (context, index) => _buildKeywordItem(index),
                ).paddingSymmetric(horizontal: 16, vertical: 14),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildKeywordItem(int index) {
    var keyword = controller.listKeywords[index];
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      onPressed: () {
        controller.searchKeyWord(keyword);
      },
      child: Row(
        children: [
          Image.network(
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWMf1IQ1kT_4J8sAYnqYPK78KtKj2NRgKOfw63VKnqahHz6fubmFhi1yDRcbP8hD2NaJs&usqp=CAU',
            width: 20,
            height: 20,
          ).paddingOnly(right: 5),
          Text(
            keyword,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    ).paddingOnly(bottom: 5);
  }

  Widget _buildButton(String toolTip, Widget child, Function() onTap) {
    return Tooltip(
      message: toolTip,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey, width: 1),
          ),
          child: child.paddingAll(12),
        ),
      ),
    );
  }
}
