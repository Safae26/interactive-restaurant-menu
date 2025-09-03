import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';

class AboutScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const AboutScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryColor = Colors.orange.shade700;
    final secondaryColor = Colors.orange.shade400;
    final textColor = isDarkMode ? Colors.white : Colors.grey[800]!;
    final cardColor =
        isDarkMode
            ? Colors.grey[850]!.withOpacity(0.9)
            : Colors.white.withOpacity(0.9);

    return Scaffold(
      body: Stack(
        children: [
          // Image de fond avec effet de flou et opacité
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/restaurant.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(color: Colors.transparent),
          ),

          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 80),
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primaryColor, secondaryColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.4),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.restaurant,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Le Gourmet Marocain',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'L\'art culinaire marocain réinventé',
                        style: TextStyle(
                          color: isDarkMode ? Colors.grey[300] : Colors.white,
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Section contact
                _buildSectionCard(
                  context: context,
                  cardColor: cardColor,
                  primaryColor: primaryColor,
                  title: 'Contact',
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildInfoRow(
                          Icons.location_on,
                          '123 Rue de la Cuisine, Marrakech',
                          textColor,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          Icons.phone,
                          '+212 5 23 45 67 89',
                          textColor,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          Icons.access_time,
                          'Lundi - Dimanche • 9h - 23h',
                          textColor,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: 300,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.map, size: 20),
                            label: const Text('Voir sur Google Maps'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () => _openGoogleMaps(31.6295, -7.9811),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                _buildSectionCard(
                  context: context,
                  cardColor: cardColor,
                  primaryColor: primaryColor,
                  title: 'Localisation',
                  child: Container(
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.map, size: 50, color: primaryColor),
                          const SizedBox(height: 10),
                          Text(
                            'Carte interactive',
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Marrakech, Maroc',
                            style: TextStyle(color: textColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Section à propos
                _buildSectionCard(
                  context: context,
                  cardColor: cardColor,
                  primaryColor: primaryColor,
                  title: 'Notre Histoire',
                  child: Text(
                    'Fondé en 2010, Le Gourmet Marocain réinvente la cuisine traditionnelle avec '
                    'une approche contemporaine. Nos chefs préservent l\'authenticité des saveurs '
                    'tout en créant des présentations innovantes. Nous nous engageons à utiliser '
                    'exclusivement des produits locaux et de saison.',
                    style: TextStyle(color: textColor, height: 1.6),
                  ),
                ),
                const SizedBox(height: 30),

                // Section réseaux sociaux
                _buildSectionCard(
                  context: context,
                  cardColor: cardColor,
                  primaryColor: primaryColor,
                  title: 'Nous suivre',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildSocialButton(
                            Icons.facebook,
                            'Facebook',
                            primaryColor,
                            context,
                          ),
                          _buildSocialButton(
                            Icons.camera_alt,
                            'Instagram',
                            primaryColor,
                            context,
                          ),
                          _buildSocialButton(
                            Icons.star,
                            'Yelp',
                            primaryColor,
                            context,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Suivez-nous pour les dernières actualités',
                        style: TextStyle(
                          color: textColor.withOpacity(0.8),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              title: const Text(''),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              actions: [
                IconButton(
                  icon: Icon(
                    isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: Colors.white,
                  ),
                  onPressed: onThemeToggle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required Color cardColor,
    required Color primaryColor,
    required String title,
    required Widget child,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Card(
        color: cardColor,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openGoogleMaps(double latitude, double longitude) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Impossible d\'ouvrir Google Maps';
    }
  }

  Widget _buildInfoRow(IconData icon, String text, Color textColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.orange.shade700, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(text, style: TextStyle(color: textColor, fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(
    IconData icon,
    String label,
    Color color,
    BuildContext context,
  ) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.3), width: 1),
          ),
          child: IconButton(
            icon: Icon(icon, color: color),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Ouverture de $label'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Theme.of(
              context,
            ).textTheme.bodyLarge?.color?.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
