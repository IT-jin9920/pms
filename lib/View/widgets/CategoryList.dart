import 'package:flutter/material.dart';

class CategoriesDropdown extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategoryChanged;

  CategoriesDropdown({
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              onCategoryChanged(category);
            },
            child: Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: selectedCategory == category
                    ? Colors.black
                    : Color(0xffebebeb),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.black12,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    color: selectedCategory == category
                        ? Colors.white
                        : Color(0xff999999),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
