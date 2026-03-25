import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app_clean_architecture/features/articles/presentation/bloc/article_cubit.dart';
import 'package:news_app_clean_architecture/features/articles/presentation/bloc/article_state.dart';

class CreateArticleScreen extends StatefulWidget {
  const CreateArticleScreen({Key? key}) : super(key: key);

  @override
  State<CreateArticleScreen> createState() => _CreateArticleScreenState();
}

class _CreateArticleScreenState extends State<CreateArticleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contentController = TextEditingController();
  final _authorController = TextEditingController();
  final _sourceController = TextEditingController();

  String _selectedCategory = 'Technology';
  File? _thumbnailFile;

  static const _categories = [
    'Technology',
    'Politics',
    'Sports',
    'Science',
    'Entertainment',
    'Business',
    'Health',
  ];

  static const _bgColor = Color(0xFF1A1A2E);
  static const _accentColor = Color(0xFF6C63FF);
  static const _surfaceColor = Color(0xFF16213E);

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    _authorController.dispose();
    _sourceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) setState(() => _thumbnailFile = File(picked.path));
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<ArticleCubit>().createArticle(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          content: _contentController.text.trim(),
          author: _authorController.text.trim(),
          category: _selectedCategory,
          source: _sourceController.text.trim(),
          thumbnailFile: _thumbnailFile,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ArticleCubit, ArticleState>(
      listener: (context, state) {
        if (state is ArticleCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Article published successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
        if (state is ArticleCreateFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: _bgColor,
        appBar: AppBar(
          backgroundColor: _bgColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'New Article',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocBuilder<ArticleCubit, ArticleState>(
          builder: (context, state) {
            final isLoading = state is ArticleCreating;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildThumbnailPicker(),
                    const SizedBox(height: 24),
                    _buildField(
                        _titleController, 'Title', 'Enter article title',
                        maxLines: 1),
                    const SizedBox(height: 16),
                    _buildField(_descriptionController, 'Description',
                        'Short summary...',
                        maxLines: 2),
                    const SizedBox(height: 16),
                    _buildCategoryDropdown(),
                    const SizedBox(height: 16),
                    _buildField(_authorController, 'Author', 'Your name',
                        maxLines: 1),
                    const SizedBox(height: 16),
                    _buildField(
                        _sourceController, 'Source', 'Publication or outlet',
                        maxLines: 1),
                    const SizedBox(height: 16),
                    _buildField(
                        _contentController, 'Content', 'Write your article...',
                        maxLines: 12),
                    const SizedBox(height: 32),
                    _buildSubmitButton(isLoading),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildThumbnailPicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: _surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _accentColor.withValues(alpha: 0.4)),
          image: _thumbnailFile != null
              ? DecorationImage(
                  image: FileImage(_thumbnailFile!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: _thumbnailFile == null
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined,
                      color: Color(0xFF6C63FF), size: 48),
                  SizedBox(height: 8),
                  Text('Add thumbnail',
                      style: TextStyle(color: Colors.white54)),
                ],
              )
            : Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    radius: 16,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.close,
                          color: Colors.white, size: 16),
                      onPressed: () => setState(() => _thumbnailFile = null),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label,
    String hint, {
    required int maxLines,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 13)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white38),
            filled: true,
            fillColor: _surfaceColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _accentColor),
            ),
          ),
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? '$label is required' : null,
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Category',
            style: TextStyle(color: Colors.white70, fontSize: 13)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: _surfaceColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            // ignore: prefer_const_constructors
            child: DropdownButton<String>(
              value: _selectedCategory,
              dropdownColor: _surfaceColor,
              isExpanded: true,
              style: const TextStyle(color: Colors.white),
              items: _categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedCategory = v!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: _accentColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.white, strokeWidth: 2)
            : const Text(
                'Publish Article',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}