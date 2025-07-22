import 'package:flutter/material.dart';
import 'package:my_persona/Utils/string_extensions.dart'; // Import the new extension
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:my_persona/Services/theme_service.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:my_persona/Auth/auth_service.dart'; // Import AuthService
import 'package:image_picker/image_picker.dart'; // For image picking
import 'package:shared_preferences/shared_preferences.dart'; // For local storage
import 'dart:io'; // For File operations

class ProfileSection extends StatefulWidget {
  final String userTitle; // Keep userTitle as it's static content

  const ProfileSection({
    super.key,
    required this.userTitle,
  });

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadImagePath(); // Load image path on init
  }

  Future<void> _loadImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profile_image_path');
    if (imagePath != null && File(imagePath).existsSync()) {
      setState(() {
        _profileImage = File(imagePath);
      });
    }
  }

  Future<void> _pickImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email == 'gaming@gmail.com') {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        // Save image path locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profile_image_path', imageFile.path);

        setState(() {
          _profileImage = imageFile;
        });
      }
    } else {
      // Optionally, show a message to the user that they cannot change the profile picture
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture can only be changed by gaming@gmail.com')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
      decoration: BoxDecoration(
        color: themeService.darkMode ? Colors.grey[850] : Colors.white,
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: ClipOval(
                    child: _profileImage != null
                        ? Image.file(
                            _profileImage!,
                            fit: BoxFit.cover,
                            width: 160,
                            height: 160,
                          )
                        : Icon(
                            Icons.person,
                            size: 80,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Hello, I\'m',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Consumer<AuthService>(
                builder: (context, authService, child) {
                  final user = FirebaseAuth.instance.currentUser;
                  String currentUserName = 'User'; // Default value
                  if (user != null) {
                    if (user.displayName != null && user.displayName!.isNotEmpty) {
                      currentUserName = user.displayName!;
                    } else if (user.email != null && user.email!.isNotEmpty) {
                      currentUserName = StringExtension(user.email!.split('@')[0]).capitalize();
                    }
                    // The gaming@gmail.com logic is for image, not name, so it's fine to leave it as is.
                  } else {
                    currentUserName = 'Guest';
                  }
                  return Text(
                    currentUserName,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              Text(
                widget.userTitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onSurface,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 20.0,
                runSpacing: 16.0,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement Share Portfolio functionality
                    },
                    icon: Icon(Icons.share, color: Theme.of(context).colorScheme.onPrimary, size: 20),
                    label: Text(
                      'Share Portfolio',
                      style: GoogleFonts.poppins(color: Theme.of(context).colorScheme.onPrimary, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implement Download CV functionality
                    },
                    icon: Icon(Icons.download, color: Theme.of(context).colorScheme.primary, size: 20),
                    label: Text(
                      'Download CV',
                      style: GoogleFonts.poppins(color: Theme.of(context).colorScheme.primary, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
