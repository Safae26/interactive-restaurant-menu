import 'package:flutter/material.dart';
import 'product_form_screen';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import 'favorites.dart';
import 'home_screen.dart';

class ProductsScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const ProductsScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final Map<String, Color> _categoryColors = {
    'Entrées': Colors.green[300]!,
    'Plats Principaux': Colors.orange[300]!,
    'Desserts': Colors.pink[200]!,
    'Boissons': Colors.blue[300]!,
  };

  @override
  void initState() {
    super.initState();
    // Charger les produits initiaux
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    productProvider.loadProducts(_getInitialProducts());
  }

  List<Product> _getInitialProducts() {
    return [
      Product(
        id: '1',
        name: 'Salade Marocaine',
        description:
            'Salade fraîche avec légumes de saison et épices marocaines',
        price: 45.0,
        category: 'Entrées',
        imageUrl: 'assets/images/moroccan_salad.jpg',
      ),
      Product(
        id: '2',
        name: 'Tajine de Poulet',
        description: 'Tajine traditionnel avec poulet, olives et citron confit',
        price: 85.0,
        category: 'Plats Principaux',
        imageUrl: 'assets/images/tajine.jpg',
      ),
      Product(
        id: '3',
        name: 'Couscous Royal',
        description: 'Couscous avec légumes et viandes assorties',
        price: 90.0,
        category: 'Plats Principaux',
        imageUrl: 'assets/images/couscous.jpg',
      ),
      Product(
        id: '4',
        name: 'Thé à la Menthe',
        description: 'Thé vert avec menthe fraîche et sucre',
        price: 20.0,
        category: 'Boissons',
        imageUrl: 'assets/images/tea.jpg',
      ),
      Product(
        id: '5',
        name: 'Jus d\'Orange',
        description: 'Jus d\'orange pressé',
        price: 30.0,
        category: 'Boissons',
        imageUrl: 'assets/images/jus.jpg',
      ),
      Product(
        id: '6',
        name: 'Salade César',
        description: 'Laitue romaine, croûtons, parmesan et sauce césar',
        price: 8.5,
        category: 'Entrées',
        imageUrl: 'assets/images/salad.jpg',
      ),
      Product(
        id: '7',
        name: 'Pizza Margherita',
        description: 'Sauce tomate, mozzarella fraîche et basilic',
        price: 12.9,
        category: 'Plats Principaux',
        imageUrl: 'assets/images/pizza.jpg',
      ),
      Product(
        id: '8',
        name: 'Tiramisu',
        description: 'Dessert italien au café et mascarpone',
        price: 6.5,
        category: 'Desserts',
        imageUrl: 'assets/images/tiramisu.jpg',
      ),
      Product(
        id: '9',
        name: 'Burger Classique',
        description: 'Steak haché, cheddar, salade et sauce maison',
        price: 10.5,
        category: 'Plats Principaux',
        imageUrl: 'assets/images/burger.jpg',
      ),
      Product(
        id: '10',
        name: 'Soupe à l\'oignon',
        description: 'Soupe traditionnelle française avec croûtons et fromage',
        price: 7.5,
        category: 'Entrées',
        imageUrl: 'assets/images/soup.jpg',
      ),
      Product(
        id: '11',
        name: 'Mojito',
        description:
            'Cocktail rafraîchissant à base de rhum, citron vert, menthe, eau gazeuse et sucre',
        price: 8.0,
        category: 'Boissons',
        imageUrl: 'assets/images/mojito.jpg',
      ),
    ];
  }

  void _showAddProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => ProductFormScreen(
            onSubmit: (product) {
              context.read<ProductProvider>().addProduct(product);
              Navigator.of(ctx).pop();
            },
            categoryColors: _categoryColors,
          ),
    );
  }

  void _editProduct(Product product, BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => ProductFormScreen(
            product: product,
            onSubmit: (updatedProduct) {
              context.read<ProductProvider>().updateProduct(updatedProduct);
              Navigator.of(ctx).pop();
            },
            categoryColors: _categoryColors,
          ),
    );
  }

  void _deleteProduct(String id, BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Supprimer le produit'),
            content: const Text(
              'Êtes-vous sûr de vouloir supprimer ce produit ?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () {
                  context.read<ProductProvider>().deleteProduct(id);
                  Navigator.of(ctx).pop();
                },
                child: const Text(
                  'Supprimer',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  void _showProductDetails(Product initialProduct, BuildContext context) {
    final commentController = TextEditingController();
    final userController = TextEditingController(text: 'Client anonyme');
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) {
        Product currentProduct = initialProduct;
        bool _isSavingComment = false;

        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> _submitComment() async {
              if (_isSavingComment) return;

              setState(() => _isSavingComment = true);

              try {
                final commentText = commentController.text.trim();
                final userName = userController.text.trim();

                if (commentText.isNotEmpty && userName.isNotEmpty) {
                  final newComment = Comment(user: userName, text: commentText);

                  final updatedProduct = currentProduct.copyWith(
                    comments: [...currentProduct.comments, newComment],
                  );

                  // Mise à jour locale immédiate
                  setState(() {
                    currentProduct = updatedProduct;
                  });

                  // Mise à jour dans le provider
                  productProvider.updateProduct(updatedProduct);

                  commentController.clear();
                }
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
              } finally {
                setState(() => _isSavingComment = false);
              }
            }

            return AlertDialog(
              backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
              title: Text(
                currentProduct.name,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (currentProduct.imageUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          currentProduct.imageUrl,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Icon(
                                Icons.fastfood,
                                size: 50,
                                color: _categoryColors[currentProduct.category],
                              ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      currentProduct.description,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${currentProduct.price.toStringAsFixed(2)} €',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.thumb_up),
                              color: Colors.green,
                              onPressed: () {
                                final updatedProduct = currentProduct.copyWith(
                                  likes: currentProduct.likes + 1,
                                );
                                productProvider.updateProduct(updatedProduct);
                                setState(() {
                                  currentProduct = updatedProduct;
                                });
                              },
                            ),
                            Text(
                              '${currentProduct.likes}',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 32),
                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.thumb_down),
                              color: Colors.red,
                              onPressed: () {
                                final updatedProduct = currentProduct.copyWith(
                                  dislikes: currentProduct.dislikes + 1,
                                );
                                productProvider.updateProduct(updatedProduct);
                                setState(() {
                                  currentProduct = updatedProduct;
                                });
                              },
                            ),
                            Text(
                              '${currentProduct.dislikes}',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 32),
                        Column(
                          children: [
                            IconButton(
                              icon: Icon(
                                currentProduct.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                final updatedProduct = currentProduct.copyWith(
                                  isFavorite: !currentProduct.isFavorite,
                                );
                                productProvider.updateProduct(updatedProduct);
                                setState(() {
                                  currentProduct = updatedProduct;
                                });
                              },
                            ),
                            Text(
                              'Favori',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(),
                    Text(
                      'Commentaires:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (currentProduct.comments.isEmpty)
                      Text(
                        'Aucun commentaire pour le moment',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      )
                    else
                      ...currentProduct.comments.map(
                        (comment) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comment.user,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                              Text(
                                comment.text,
                                style: TextStyle(
                                  color:
                                      isDarkMode
                                          ? Colors.grey[300]
                                          : Colors.grey[800],
                                ),
                              ),
                              Text(
                                comment.formattedDate,
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      isDarkMode
                                          ? Colors.grey[500]
                                          : Colors.grey[600],
                                ),
                              ),
                              const Divider(height: 16),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: userController,
                      decoration: InputDecoration(
                        labelText: 'Votre nom',
                        labelStyle: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor:
                            isDarkMode
                                ? Colors.grey[800]!.withOpacity(0.5)
                                : Colors.grey[100],
                      ),
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: commentController,
                            decoration: InputDecoration(
                              labelText: 'Ajouter un commentaire',
                              border: const OutlineInputBorder(),
                              filled: true,
                              fillColor:
                                  isDarkMode
                                      ? Colors.grey[800]!.withOpacity(0.5)
                                      : Colors.grey[100],
                            ),
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            maxLines: 3,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _isSavingComment ? null : _submitComment,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(100, 60),
                          ),
                          child:
                              _isSavingComment
                                  ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                    ),
                                  )
                                  : const Text('Publier'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(
                    'Fermer',
                    style: TextStyle(color: Colors.orange[400]),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Entrées':
        return Icons.restaurant;
      case 'Plats Principaux':
        return Icons.restaurant_menu;
      case 'Desserts':
        return Icons.cake;
      case 'Boissons':
        return Icons.local_drink;
      default:
        return Icons.fastfood;
    }
  }

  Widget _buildProductCard(Product product, BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 7,
            child: Container(
              decoration: BoxDecoration(
                image:
                    product.imageUrl.isNotEmpty
                        ? DecorationImage(
                          image: AssetImage(product.imageUrl),
                          fit: BoxFit.cover,
                        )
                        : null,
                color:
                    product.imageUrl.isEmpty
                        ? _categoryColors[product.category]?.withOpacity(0.2)
                        : null,
              ),
              child:
                  product.imageUrl.isEmpty
                      ? Center(
                        child: Icon(
                          Icons.fastfood,
                          size: 50,
                          color: _categoryColors[product.category],
                        ),
                      )
                      : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _categoryColors[product.category],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        product.category,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${product.price.toStringAsFixed(2)} €',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 18),
                          onPressed: () => _editProduct(product, context),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 18),
                          color: Colors.red[300],
                          onPressed: () => _deleteProduct(product.id, context),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    if (productProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final categories =
        productProvider.products.map((p) => p.category).toSet().toList();

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed:
                () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => HomeScreen(
                          isDarkMode: false,
                          onThemeToggle: () => {},
                        ),
                  ),
                  (Route<dynamic> route) => false,
                ),
          ),
          title: Text(
            'Menu du Restaurant',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
          backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
          iconTheme: IconThemeData(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoritesScreen(),
                  ),
                );
              },
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            labelColor: isDarkMode ? Colors.white : Colors.black,
            unselectedLabelColor: isDarkMode ? Colors.grey[400] : Colors.grey,
            indicatorColor: Colors.grey,
            tabs:
                categories.map((category) {
                  return Tab(
                    child: Row(
                      children: [
                        Icon(
                          _getIconForCategory(category),
                          color: _categoryColors[category],
                        ),
                        const SizedBox(width: 8),
                        Text(category),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ),
        body: TabBarView(
          children:
              categories.map((category) {
                final categoryProducts =
                    productProvider.products
                        .where((p) => p.category == category)
                        .toList();
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          MediaQuery.of(context).size.width > 600 ? 4 : 2,
                      childAspectRatio: 0.7,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: categoryProducts.length,
                    itemBuilder:
                        (ctx, index) => GestureDetector(
                          onTap:
                              () => _showProductDetails(
                                categoryProducts[index],
                                context,
                              ),
                          child: _buildProductCard(
                            categoryProducts[index],
                            context,
                          ),
                        ),
                  ),
                );
              }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddProductDialog(context),
          backgroundColor: Colors.orange[400],
          elevation: 4,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
