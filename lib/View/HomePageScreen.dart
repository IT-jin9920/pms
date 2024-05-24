import 'dart:ui';

import 'package:flutter/material.dart';
import '../services/remote_service.dart';
import '../models/product_model.dart';
import 'widgets/CategoryList.dart';
import 'widgets/SearchInput.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product>? products;
  List<Product>? allProducts;
  bool isLoaded = false;
  bool isGridView = false;
  int skip = 0;
  int limit = 10;
  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;
  String searchQuery = '';
  String selectedCategory = 'All';
  String selectedSort = 'None';
  final TextEditingController searchController = TextEditingController();
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    getProducts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !isLoadingMore) {
        loadMore();
      }
    });
    searchController.addListener(() {
      searchProducts(searchController.text);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> getProducts() async {
    try {
      products = await RemoteService().getProducts(skip, limit);
      allProducts = products;
      if (products != null) {
        setState(() {
          isLoaded = true;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load products';
      });
    }
  }

  Future<void> loadMore() async {
    setState(() {
      isLoadingMore = true;
    });
    try {
      skip += limit;
      List<Product> moreProducts = await RemoteService().getProducts(skip, limit);
      setState(() {
        products!.addAll(moreProducts);
        isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load more products';
        isLoadingMore = false;
      });
    }
  }

  void toggleView() {
    setState(() {
      isGridView = !isGridView;
    });
  }

  void searchProducts(String query) {
    final results = allProducts?.where((product) {
      final titleLower = product.title.toLowerCase();
      final descriptionLower = product.description.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower) || descriptionLower.contains(searchLower);
    }).toList();

    setState(() {
      searchQuery = query;
      products = results;
    });
  }

  void sortProducts(String sort) {
    List<Product> sortedList = List.from(products ?? []);
    if (sort == 'Relevance') {
      // Implement relevance sorting logic
    } else if (sort == 'Newest First') {
      // Implement newest first sorting logic
    } else if (sort == 'Popularity') {
      // Implement popularity sorting logic
    } else if (sort == 'Price - High to Low') {
      sortedList.sort((a, b) => b.price.compareTo(a.price));
    } else if (sort == 'Price - Low to High') {
      sortedList.sort((a, b) => a.price.compareTo(b.price));
    } else if (sort == 'A to Z') {
      sortedList.sort((a, b) => a.title.compareTo(b.title));
    }

    setState(() {
      selectedSort = sort;
      products = sortedList;
    });
  }

  void showSortingMenu(BuildContext context) {
    String? selectedSortOption = selectedSort;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    title: Text('Relevance'),
                    value: 'Relevance',
                    groupValue: selectedSortOption,
                    onChanged: (String? value) {
                      setState(() {
                        selectedSortOption = value;
                        sortProducts(value!);
                        Navigator.pop(context);
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('Newest First'),
                    value: 'Newest First',
                    groupValue: selectedSortOption,
                    onChanged: (String? value) {
                      setState(() {
                        selectedSortOption = value;
                        sortProducts(value!);
                        Navigator.pop(context);
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('Popularity'),
                    value: 'Popularity',
                    groupValue: selectedSortOption,
                    onChanged: (String? value) {
                      setState(() {
                        selectedSortOption = value;
                        sortProducts(value!);
                        Navigator.pop(context);
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('Price - High to Low'),
                    value: 'Price - High to Low',
                    groupValue: selectedSortOption,
                    onChanged: (String? value) {
                      setState(() {
                        selectedSortOption = value;
                        sortProducts(value!);
                        Navigator.pop(context);
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('Price - Low to High'),
                    value: 'Price - Low to High',
                    groupValue: selectedSortOption,
                    onChanged: (String? value) {
                      setState(() {
                        selectedSortOption = value;
                        sortProducts(value!);
                        Navigator.pop(context);
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('A to Z'),
                    value: 'A to Z',
                    groupValue: selectedSortOption,
                    onChanged: (String? value) {
                      setState(() {
                        selectedSortOption = value;
                        sortProducts(value!);
                        Navigator.pop(context);
                      });
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  void filterByCategory(String category) {
    List<Product> filteredList;
    if (category == 'All') {
      filteredList = List.from(allProducts ?? []);
    } else {
      filteredList = allProducts?.where((product) => product.category == category).toList() ?? [];
    }

    setState(() {
      selectedCategory = category;
      products = filteredList;
    });
  }

  List<String> getCategories(List<Product> products) {
    Set<String> categories = {'All'};
    for (var product in products) {
      categories.add(product.category);
    }
    return categories.toList();
  }

  @override
  Widget build(BuildContext context) {
    List<String> categories = getCategories(allProducts ?? []);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: RoundedSearchInput(
                textController: searchController,
                hintText: 'Search',
              ),
            ),

            IconButton(
              icon: Icon(Icons.sort),
              onPressed: () {
                showSortingMenu(context);
              },
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Category",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight:FontWeight.w700,

                ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        offset: const Offset(12, 26),
                        blurRadius: 50,
                        spreadRadius: 0,
                        color: Colors.grey.withOpacity(.1)),
                  ]),
                  child: IconButton(
                    icon: Icon(isGridView ? Icons.view_list : Icons.grid_view),
                    onPressed: toggleView,
                  ),
                ),
              ],
            ),
          ),
          CategoriesDropdown(
            categories: categories,
            selectedCategory: selectedCategory,
            onCategoryChanged: filterByCategory,
          ),
          const SizedBox(height: 10,),
          Expanded(
            child: Visibility(
              visible: isLoaded,
              child: RefreshIndicator(
                onRefresh: getProducts,
                child: isGridView ? buildGridView() : buildListView(),
              ),
              replacement: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          if (isLoadingMore)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildListView() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: products?.length ?? 0,
      itemBuilder: (context, index) {
        final product = products![index];
        return ListTile(
          leading: Container(
            child: Image.network(
              product.thumbnail,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            product.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text('\$${product.price.toString()}'),
        );
      },
    );
  }

  Widget buildGridView() {
    return GridView.builder(
      controller: _scrollController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
      ),
      itemCount: products?.length ?? 0,
      itemBuilder: (context, index) {
        final product = products![index];
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Image.network(
                  product.thumbnail,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('\$${product.price.toString()}'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
