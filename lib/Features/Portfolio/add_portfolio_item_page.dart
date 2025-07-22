import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_persona/Services/portfolio_storage_service.dart';
import 'package:my_persona/Utils/string_extensions.dart'; // For capitalize extension
import 'dart:io'; // For File operations
import 'package:image_picker/image_picker.dart'; // For image picking
import 'package:file_picker/file_picker.dart'; // For file picking (PDF)
import 'package:intl/intl.dart'; // For date formatting

enum MediaSource { url, localFile }

class AddPortfolioItemPage extends StatefulWidget {
  const AddPortfolioItemPage({super.key});

  @override
  State<AddPortfolioItemPage> createState() => _AddPortfolioItemPageState();
}

class _AddPortfolioItemPageState extends State<AddPortfolioItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _urlController = TextEditingController();
  final _dateController = TextEditingController();

  String? _selectedType;
  String? _selectedCategory;
  DateTime? _selectedDate;
  File? _selectedLocalImageFile;
  File? _selectedLocalVideoFile;
  File? _selectedLocalPdfFile;
  MediaSource? _mediaSource;

  final ImagePicker _picker = ImagePicker();

  final List<String> _itemTypes = ['image', 'video', 'pdf', 'link'];
  final List<Map<String, String>> _categories = const [
    {'key': 'all', 'label': 'All'},
    {'key': 'web', 'label': 'Web Development'},
    {'key': 'design', 'label': 'UI/UX Design'},
    {'key': 'video', 'label': 'Video'},
    {'key': 'document', 'label': 'Documents'},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _savePortfolioItem() async {
    if (_formKey.currentState?.validate() ?? false) {
      String mediaUrl = '';

      if (_selectedType == 'link' || (_mediaSource == MediaSource.url && _selectedType == 'video')) {
        mediaUrl = _urlController.text;
      } else if (_selectedLocalImageFile != null && _selectedType == 'image') {
        mediaUrl = _selectedLocalImageFile!.path;
      } else if (_selectedLocalVideoFile != null && _selectedType == 'video') {
        mediaUrl = _selectedLocalVideoFile!.path;
      } else if (_selectedLocalPdfFile != null && _selectedType == 'pdf') {
        mediaUrl = _selectedLocalPdfFile!.path;
      }

      final newItem = {
        'id': DateTime.now().millisecondsSinceEpoch,
        'title': _titleController.text,
        'description': _descriptionController.text,
        'type': _selectedType ?? '',
        'url': mediaUrl,
        'category': _selectedCategory ?? '',
        'date': _selectedDate?.toIso8601String().substring(0, 10) ?? '',
      };

      final storageService = PortfolioStorageService();
      List<Map<String, dynamic>> currentItems = await storageService.readPortfolioItems();
      currentItems.add(newItem);
      await storageService.writePortfolioItems(currentItems);

      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  // --- Widget Builder Methods ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, top: 24.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Basic Information'),
        TextFormField(
          controller: _titleController,
          decoration: _inputDecoration('Title', 'e.g., My Awesome Project', Icons.title),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },
          style: GoogleFonts.poppins(color: colorScheme.onSurface),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          decoration: _inputDecoration('Description', 'Briefly describe your project...', Icons.description),
          maxLines: 4,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a description';
            }
            return null;
          },
          style: GoogleFonts.poppins(color: colorScheme.onSurface),
        ),
      ],
    );
  }

  Widget _buildMediaTypeSection() {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Media'),
        InputDecorator(
          decoration: _inputDecoration('Select Item Type', null, null).copyWith(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedType,
              hint: Text('Select Type', style: GoogleFonts.poppins(color: colorScheme.onSurfaceVariant.withOpacity(0.7))),
              isExpanded: true,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedType = newValue;
                  _mediaSource = null;
                  _selectedLocalImageFile = null;
                  _selectedLocalVideoFile = null;
                  _selectedLocalPdfFile = null;
                  _urlController.clear();
                });
              },
              items: _itemTypes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value.capitalize(), style: GoogleFonts.poppins(color: colorScheme.onSurface)),
                );
              }).toList(),
            ),
          ),
        ),
        if (_selectedType != null) ...[
          const SizedBox(height: 20),
          _buildMediaInputSection(),
        ]
      ],
    );
  }

  Widget _buildMediaInputSection() {
    switch (_selectedType) {
      case 'image':
        return _buildImagePicker();
      case 'video':
        return _buildVideoPicker();
      case 'pdf':
        return _buildPdfPicker();
      case 'link':
        return _buildLinkInput();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
            if (pickedFile != null) {
              setState(() {
                _selectedLocalImageFile = File(pickedFile.path);
                _mediaSource = MediaSource.localFile;
              });
            }
          },
          icon: const Icon(Icons.image_outlined),
          label: const Text('Pick Image from Gallery'),
          style: _elevatedButtonStyle(),
        ),
        if (_selectedLocalImageFile != null) _buildFilePreview(_selectedLocalImageFile!, isImage: true),
      ],
    );
  }
  
  Widget _buildVideoPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SegmentedButton<MediaSource>(
          segments: const [
            ButtonSegment(value: MediaSource.url, label: Text('URL'), icon: Icon(Icons.link)),
            ButtonSegment(value: MediaSource.localFile, label: Text('File'), icon: Icon(Icons.video_file_outlined)),
          ],
          selected: <MediaSource>{if (_mediaSource != null) _mediaSource!},
          onSelectionChanged: (Set<MediaSource> newSelection) {
            setState(() {
              _mediaSource = newSelection.first;
              _selectedLocalVideoFile = null;
              _urlController.clear();
            });
          },
          style: _segmentedButtonStyle(),
        ),
        const SizedBox(height: 16),
        if (_mediaSource == MediaSource.url)
          TextFormField(
            controller: _urlController,
            decoration: _inputDecoration('Video URL', 'e.g., https://youtube.com/watch?v=...', Icons.link),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a video URL';
              }
              if (!(Uri.tryParse(value)?.hasAbsolutePath ?? false)) {
                return 'Please enter a valid URL';
              }
              return null;
            },
          ),
        if (_mediaSource == MediaSource.localFile)
          ElevatedButton.icon(
            onPressed: () async {
              final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
              if (pickedFile != null) {
                setState(() {
                  _selectedLocalVideoFile = File(pickedFile.path);
                });
              }
            },
            icon: const Icon(Icons.video_library_outlined),
            label: const Text('Pick Video from Gallery'),
            style: _elevatedButtonStyle(),
          ),
        if (_selectedLocalVideoFile != null) _buildFilePreview(_selectedLocalVideoFile!),
      ],
    );
  }

  Widget _buildPdfPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['pdf'],
            );
            if (result != null && result.files.single.path != null) {
              setState(() {
                _selectedLocalPdfFile = File(result.files.single.path!);
                _mediaSource = MediaSource.localFile;
              });
            }
          },
          icon: const Icon(Icons.picture_as_pdf_outlined),
          label: const Text('Pick PDF Document'),
          style: _elevatedButtonStyle(),
        ),
        if (_selectedLocalPdfFile != null) _buildFilePreview(_selectedLocalPdfFile!),
      ],
    );
  }

  Widget _buildLinkInput() {
    return TextFormField(
      controller: _urlController,
      decoration: _inputDecoration('Link URL', 'e.g., https://your-project.com', Icons.link),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a link URL';
        }
        if (!(Uri.tryParse(value)?.hasAbsolutePath ?? false)) {
          return 'Please enter a valid URL';
        }
        return null;
      },
    );
  }

  Widget _buildCategorizationSection() {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Details'),
        InputDecorator(
          decoration: _inputDecoration('Category', null, Icons.folder_open_outlined).copyWith(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCategory,
              hint: Text('Select Category', style: GoogleFonts.poppins(color: colorScheme.onSurfaceVariant.withOpacity(0.7))),
              isExpanded: true,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              items: _categories.map<DropdownMenuItem<String>>((Map<String, String> cat) {
                return DropdownMenuItem<String>(
                  value: cat['key'],
                  child: Text(cat['label']!, style: GoogleFonts.poppins(color: colorScheme.onSurface)),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _dateController,
          readOnly: true,
          decoration: _inputDecoration('Date', 'Select Date', Icons.calendar_today_outlined).copyWith(
            suffixIcon: IconButton(
              icon: Icon(Icons.calendar_today, color: colorScheme.onSurfaceVariant),
              onPressed: () => _selectDate(context),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a date';
            }
            return null;
          },
          onTap: () => _selectDate(context),
          style: GoogleFonts.poppins(color: colorScheme.onSurface),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
      child: Center(
        child: ElevatedButton.icon(
          onPressed: _savePortfolioItem,
          icon: const Icon(Icons.save_alt_outlined),
          label: Text('Save Portfolio Item', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 4,
          ),
        ),
      ),
    );
  }

  Widget _buildFilePreview(File file, {bool isImage = false}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withOpacity(0.5)),
        color: colorScheme.surfaceContainer,
      ),
      child: Column(
        children: [
          if (isImage)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(file, height: 150, width: double.infinity, fit: BoxFit.cover),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(isImage ? Icons.image : Icons.insert_drive_file, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  file.path.split('/').last,
                  style: GoogleFonts.poppins(color: colorScheme.onSurface, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: colorScheme.error, size: 20),
                onPressed: () {
                  setState(() {
                    if (_selectedType == 'image') _selectedLocalImageFile = null;
                    if (_selectedType == 'video') _selectedLocalVideoFile = null;
                    if (_selectedType == 'pdf') _selectedLocalPdfFile = null;
                  });
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  // --- Style Helper Methods ---

  InputDecoration _inputDecoration(String labelText, String? hintText, IconData? icon) {
    final colorScheme = Theme.of(context).colorScheme;
    return InputDecoration(
      labelText: labelText,
      labelStyle: GoogleFonts.poppins(color: colorScheme.onSurfaceVariant),
      hintText: hintText,
      hintStyle: GoogleFonts.poppins(color: colorScheme.onSurfaceVariant.withOpacity(0.7)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      prefixIcon: icon != null ? Icon(icon, color: colorScheme.onSurfaceVariant) : null,
      filled: true,
      fillColor: colorScheme.surfaceContainer,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.3)),
      ),
    );
  }

  ButtonStyle _elevatedButtonStyle() {
    final colorScheme = Theme.of(context).colorScheme;
    return ElevatedButton.styleFrom(
      backgroundColor: colorScheme.secondaryContainer,
      foregroundColor: colorScheme.onSecondaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 16),
      textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
    );
  }

  ButtonStyle _segmentedButtonStyle() {
    final colorScheme = Theme.of(context).colorScheme;
    return SegmentedButton.styleFrom(
      backgroundColor: colorScheme.surfaceContainerHighest,
      foregroundColor: colorScheme.onSurface,
      selectedForegroundColor: colorScheme.onPrimary,
      selectedBackgroundColor: colorScheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Portfolio Item',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 1,
        shadowColor: colorScheme.shadow.withOpacity(0.2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBasicInfoSection(),
              _buildMediaTypeSection(),
              _buildCategorizationSection(),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}
