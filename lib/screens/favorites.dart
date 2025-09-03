import 'package:flutter/material.dart';
import '../providers/product_provider.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  //final bool? isDarkMode;
  //final VoidCallback? onThemeToggle;

  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context, listen: true);
    final favoriteProducts = productProvider.favoriteProducts;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Favoris'),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      ),
      backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
      body:
          favoriteProducts.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 50, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'Aucun plat favori',
                      style: TextStyle(
                        fontSize: 18,
                        color: isDarkMode ? Colors.white : Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ajoutez des favoris en cliquant sur le cœur',
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: favoriteProducts.length,
                itemBuilder: (ctx, index) {
                  final product = favoriteProducts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    color: isDarkMode ? Colors.grey[700] : Colors.white,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      leading:
                          product.imageUrl.isNotEmpty
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  product.imageUrl,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (ctx, error, stackTrace) => Container(
                                        width: 50,
                                        height: 50,
                                        color: Colors.grey[200],
                                        child: const Icon(Icons.fastfood),
                                      ),
                                ),
                              )
                              : Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey[200],
                                child: const Icon(Icons.fastfood),
                              ),
                      title: Text(
                        product.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        '${product.price.toStringAsFixed(2)} €',
                        style: const TextStyle(color: Colors.orange),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          product.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed:
                            () => productProvider.toggleFavorite(product),
                      ),
                      onTap: () {},
                    ),
                  );
                },
              ),
    );
  }
}
