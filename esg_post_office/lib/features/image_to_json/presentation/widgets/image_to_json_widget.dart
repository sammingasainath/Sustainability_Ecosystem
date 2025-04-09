import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/image_to_json_provider.dart';

class ImageToJsonWidget extends ConsumerStatefulWidget {
  final String customPrompt;
  final void Function(Map<String, dynamic> json)? onJsonResult;

  const ImageToJsonWidget({
    super.key,
    required this.customPrompt,
    this.onJsonResult,
  });

  @override
  ConsumerState<ImageToJsonWidget> createState() => _ImageToJsonWidgetState();
}

class _ImageToJsonWidgetState extends ConsumerState<ImageToJsonWidget> {
  @override
  void didUpdateWidget(ImageToJsonWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      await ref.read(imageToJsonProvider.notifier).processImage(
            imageFile: File(pickedFile.path),
            customPrompt: widget.customPrompt,
          );
      
      final state = ref.read(imageToJsonProvider);
      if (state.result != null && widget.onJsonResult != null) {
        widget.onJsonResult!(state.result!.jsonResponse);
      }
    }
  }

  Widget _buildImageSourceButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    required BuildContext context,
  }) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(imageToJsonProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageSourceButton(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onTap: state.isLoading
                        ? null
                        : () => _pickImage(ImageSource.camera),
                    context: context,
                  ),
                  const SizedBox(width: 16),
                  _buildImageSourceButton(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onTap: state.isLoading
                        ? null
                        : () => _pickImage(ImageSource.gallery),
                    context: context,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (state.isLoading)
            const Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Processing image...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
          else if (state.error != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      state.error!,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else if (state.result != null)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Result',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.result!.jsonResponse.toString(),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
