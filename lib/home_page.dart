import 'package:flutter/material.dart';
import 'movie.dart';
import 'movie_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isGrid = false;
  String searchText = '';

  // bonus: stored here (in the parent) so every card reads the same value
  int discount = 20;

  void decreaseDiscount() {
    setState(() {
      if (discount > 0) {
        discount--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // filter by title or genre, ignoring case
    final filteredMovies = movies.where((movie) {
      final query = searchText.toLowerCase();
      return movie.title.toLowerCase().contains(query) ||
          movie.genre.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Library'),
        actions: [
          IconButton(
            icon: Icon(isGrid ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                isGrid = !isGrid;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search movies...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            // limit the width so the posters are not stretched on wide screens
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: filteredMovies.isEmpty
                    ? const Center(
                        child: Text(
                          'No movies found',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : isGrid
                        ? GridView.builder(
                            padding: const EdgeInsets.all(8),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.56,
                            ),
                            itemCount: filteredMovies.length,
                            itemBuilder: (context, index) {
                              return MovieCard(
                                movie: filteredMovies[index],
                                discount: discount,
                                onDiscountTap: decreaseDiscount,
                              );
                            },
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: filteredMovies.length,
                            itemBuilder: (context, index) {
                              // height depends on the card width so the poster
                              // keeps a 2:3 ratio and is not cropped
                              return LayoutBuilder(
                                builder: (context, constraints) {
                                  final imageWidth = constraints.maxWidth - 16;
                                  return SizedBox(
                                    height: imageWidth * 1.5 + 76,
                                    child: MovieCard(
                                      movie: filteredMovies[index],
                                      discount: discount,
                                      onDiscountTap: decreaseDiscount,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}