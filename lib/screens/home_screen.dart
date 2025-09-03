import 'package:flutter/material.dart';
import 'products_screen.dart';
import 'about_screen.dart';
import 'favorites.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _titleOpacityAnimation;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.easeInOutQuint),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.97, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1, curve: Curves.elasticOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1, curve: Curves.easeOutBack),
      ),
    );

    _titleOpacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.8, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      drawer: _buildDrawer(context),
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(top: size.height * 0.18, bottom: 40),
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      _buildHeroSection(),
                      const SizedBox(height: 30),
                      _buildMenuButton(context),
                      const SizedBox(height: 40),
                      _buildRestaurantInfo(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          _buildDrawerItem(
            icon: Icons.home,
            text: 'Accueil',
            onTap: () => _navigateToHome(context),
          ),
          const Divider(height: 1, thickness: 0.5),
          _buildDrawerItem(
            icon: Icons.restaurant_menu,
            text: 'Menu',
            onTap: () => _navigateToProducts(context),
          ),
          const Divider(height: 1, thickness: 0.5),
          _buildDrawerItem(
            icon: Icons.favorite,
            text: 'Favoris',
            onTap: () => _navigateToFavorites(context),
          ),
          const Divider(height: 1, thickness: 0.5),
          _buildDrawerItem(
            icon: Icons.info,
            text: 'Contact / À propos',
            onTap: () => _navigateToAbout(context),
          ),
          const Divider(height: 1, thickness: 0.5),
          _buildThemeToggleItem(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade700, Colors.orange.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.restaurant, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              'Le Gourmet Marocain',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildThemeToggleItem(bool isDarkMode) {
    return ListTile(
      leading: Icon(
        isDarkMode ? Icons.light_mode : Icons.dark_mode,
        color: Colors.orange,
      ),
      title: Text(
        isDarkMode ? 'Mode clair' : 'Mode sombre',
        style: TextStyle(
          fontSize: 16,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      onTap: () {
        widget.onThemeToggle();
        Navigator.pop(context);
      },
    );
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => HomeScreen(
              isDarkMode: widget.isDarkMode,
              onThemeToggle: widget.onThemeToggle,
            ),
      ),
    );
  }

  void _navigateToProducts(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ProductsScreen(
              isDarkMode: widget.isDarkMode,
              onThemeToggle: widget.onThemeToggle,
            ),
      ),
    );
  }

  void _navigateToFavorites(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => FavoritesScreen(
              //isDarkMode: widget.isDarkMode,
              //onThemeToggle: widget.onThemeToggle,
            ),
      ),
    );
  }

  void _navigateToAbout(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => AboutScreen(
              isDarkMode: widget.isDarkMode,
              onThemeToggle: widget.onThemeToggle,
            ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: AnimatedOpacity(
        opacity: _titleOpacityAnimation.value,
        duration: const Duration(milliseconds: 300),
        child: Text(
          'Le Gourmet Marocain',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.8,
          ),
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(
          icon: Icon(
            widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            color: Colors.white,
          ),
          onPressed: widget.onThemeToggle,
        ),
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withOpacity(0.8), Colors.transparent],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: AspectRatio(
        aspectRatio: 7 / 2,
        child: Hero(
          tag: 'restaurant-hero',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              'assets/images/restaurant.jpg',
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(
                        Icons.restaurant,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutBack,
          height: 64,
          width: _isHovering ? 320 : 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: const LinearGradient(
              colors: [Color(0xFFFFA726), Color(0xFFF57C00)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.deepOrange.withOpacity(_isHovering ? 0.6 : 0.4),
                blurRadius: _isHovering ? 25 : 15,
                spreadRadius: _isHovering ? 3 : 2,
                offset: Offset(0, _isHovering ? 8 : 5),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(32),
            child: InkWell(
              borderRadius: BorderRadius.circular(32),
              highlightColor: Colors.white.withOpacity(0.2),
              splashColor: Colors.white.withOpacity(0.3),
              onTap: () => _navigateToProducts(context),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.menu_book, color: Colors.white, size: 26),
                      const SizedBox(width: 16),
                      Text(
                        'Explorer notre carte',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurantInfo() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Text(
            'Le Gourmet Marocain',
            style: theme.textTheme.displaySmall?.copyWith(
              color: Colors.orange[800],
              fontWeight: FontWeight.bold,
              fontSize: 32,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Bienvenue dans notre restaurant, un lieu convivial où l\'on vous propose des plats populaires, '
              'avec une touche contemporaine, mettant en valeur des produits locaux '
              'et de saison soigneusement sélectionnés.',
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.8,
                color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 36),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildFeatureChip(Icons.star_rounded, 'Ouverture 2025'),
              _buildFeatureChip(Icons.eco_rounded, 'Produits Locaux'),
              _buildFeatureChip(Icons.wine_bar_rounded, 'Cave Sélectionnée'),
              _buildFeatureChip(Icons.people_alt_rounded, 'Équipe Passionnée'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(IconData icon, String label) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Chip(
      avatar: Icon(icon, size: 20, color: Colors.orange[800]),
      label: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isDarkMode ? Colors.white : Colors.grey[800],
        ),
      ),
      backgroundColor:
          isDarkMode
              ? Colors.orange.withOpacity(0.2)
              : Colors.orange.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: Colors.orange.withOpacity(0.3)),
      ),
    );
  }
}
