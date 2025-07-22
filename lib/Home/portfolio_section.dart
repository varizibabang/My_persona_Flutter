import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io'; // Import for File operations
import 'package:my_persona/Services/portfolio_storage_service.dart'; // Import storage service
import 'package:my_persona/Features/Portfolio/add_portfolio_item_page.dart'; // Import add item page
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

class PortfolioSection extends StatefulWidget {
  const PortfolioSection({super.key});

  @override
  State<PortfolioSection> createState() => _PortfolioSectionState();
}

class _PortfolioSectionState extends State<PortfolioSection> {
  String activeCategory = 'all';
  // Removed isGridView as only list view will be used
  List<Map<String, dynamic>> _portfolioItems = []; // State variable for portfolio items
  final PortfolioStorageService _storageService = PortfolioStorageService();

  final List<Map<String, String>> _categories = const [
    {'key': 'all', 'label': 'All'},
    {'key': 'web', 'label': 'Web Development'},
    {'key': 'design', 'label': 'UI/UX Design'},
    {'key': 'video', 'label': 'Video'},
    {'key': 'document', 'label': 'Documents'},
  ];

  @override
  void initState() {
    super.initState();
    _loadPortfolioItems();
  }

  Future<void> _loadPortfolioItems() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email == 'gaming@gmail.com') {
      final items = await _storageService.readPortfolioItems();
      setState(() {
        _portfolioItems = items;
      });
    } else {
      setState(() {
        _portfolioItems = []; // Clear portfolio items for other users
      });
    }
  }

  List<Map<String, dynamic>> get filteredItems {
    if (activeCategory == 'all') {
      return _portfolioItems; // Use state variable
    } else {
      return _portfolioItems // Use state variable
          .where((item) => item['category'] == activeCategory)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: colorScheme.surface,
          padding: const EdgeInsets.all(12.0), // Reduced padding for mobile
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Work',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Explore my latest projects and creative work',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: colorScheme.onSurface.withAlpha((255 * 0.7).round()),
                ),
              ),
              const SizedBox(height: 24),
              // Category Filters
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ..._categories.map((categoryData) => // Use _categories again
                        _buildCategoryButton(categoryData['key']!, categoryData['label']!)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              filteredItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image,
                            size: 60,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No portfolio items found.',
                            style: TextStyle(
                              fontSize: 18,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        return _buildPortfolioListItem(filteredItems[index]);
                      },
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddItem,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToAddItem() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email == 'gaming@gmail.com') {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddPortfolioItemPage()),
      );

      if (result == true) {
        // If an item was successfully added, refresh the list
        _loadPortfolioItems();
      }
    } else {
      // Optionally, show a message to the user that they cannot add portfolio items
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Portfolio items can only be added by gaming@gmail.com')),
        );
      }
    }
  }

  Widget _buildCategoryButton(String category, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(text, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
        selected: activeCategory == category,
        onSelected: (selected) {
          setState(() {
            activeCategory = category;
          });
        },
        selectedColor: colorScheme.primary,
        labelStyle: GoogleFonts.poppins(
          color: activeCategory == category
              ? colorScheme.onPrimary
              : colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(
            color: activeCategory == category
                ? colorScheme.primary
                : colorScheme.outline,
            width: 1.5,
          ),
        ),
        elevation: activeCategory == category ? 4 : 1,
        pressElevation: 2,
      ),
    );
  }

  // Removed _buildPortfolioGridItem as it's no longer needed.

  Widget _buildPortfolioListItem(Map<String, dynamic> item) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.surface,
      elevation: 8,
      margin: const EdgeInsets.only(bottom: 20.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 120,
                height: 90,
                child: _buildMediaPreview(item),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item['title'],
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildDeleteButton(item['id']),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['description'],
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      _formatDate(item['date']),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaPreview(Map<String, dynamic> item) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (item['type']) {
      case 'image':
        final imageUrl = item['url'];
        if (imageUrl != null && (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'))) {
          return CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              ),
            ),
            errorWidget: (context, url, error) => Icon(
              Icons.image_not_supported,
              size: 50,
              color: colorScheme.onSurfaceVariant,
            ),
          );
        } else if (imageUrl != null && File(imageUrl).existsSync()) {
          return Image.file(
            File(imageUrl),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.broken_image,
              size: 50,
              color: colorScheme.onSurfaceVariant,
            ),
          );
        } else {
          return Icon(
            Icons.image_not_supported,
            size: 50,
            color: colorScheme.onSurfaceVariant,
          );
        }
      case 'video':
        return Container(
          color: colorScheme.surfaceContainerHighest,
          child: Center(
            child: Icon(
              Icons.play_circle_fill,
              size: 60,
              color: colorScheme.onSurface,
            ),
          ),
        );
      case 'pdf':
        return Container(
          color: colorScheme.surfaceContainerHighest,
          child: Center(
            child: Icon(
              Icons.picture_as_pdf,
              size: 60,
              color: colorScheme.error,
            ),
          ),
        );
      case 'link':
        return Container(
          color: colorScheme.primaryContainer,
          child: Center(
            child: Icon(
              Icons.link,
              size: 60,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
        );
      default:
        return const SizedBox.shrink(); // Use SizedBox.shrink() for an empty widget
    }
  }

  Widget _buildDeleteButton(int itemId) {
    final colorScheme = Theme.of(context).colorScheme;
    return IconButton(
      icon: Icon(Icons.delete, color: colorScheme.error),
      onPressed: () => _confirmAndDeleteItem(itemId),
    );
  }

  Future<void> _confirmAndDeleteItem(int itemId) async {
    final bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        final colorScheme = Theme.of(context).colorScheme; // Define colorScheme here
        return AlertDialog(
          title: Text('Delete Portfolio Item', style: GoogleFonts.poppins()),
          content: Text('Are you sure you want to delete this item?', style: GoogleFonts.poppins()),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel', style: GoogleFonts.poppins(color: colorScheme.onSurfaceVariant)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete', style: GoogleFonts.poppins(color: colorScheme.error)),
            ),
          ],
        );
      },
    );

    if (confirm) {
      await _storageService.deletePortfolioItem(itemId);
      _loadPortfolioItems(); // Refresh the list after deletion
      if (!mounted) return; // Ensure the widget is still mounted before showing SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Portfolio item deleted successfully!')),
      );
    }
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${_getMonthAbbreviation(date.month)} ${date.year}';
  }

  String _getMonthAbbreviation(int month) {
    switch (month) {
      case 1: return 'Jan';
      case 2: return 'Feb';
      case 3: return 'Mar';
      case 4: return 'Apr';
      case 5: return 'May';
      case 6: return 'Jun';
      case 7: return 'Jul';
      case 8: return 'Aug';
      case 9: return 'Sep';
      case 10: return 'Oct';
      case 11: return 'Nov';
      case 12: return 'Dec';
      default: return '';
    }
  }
}
