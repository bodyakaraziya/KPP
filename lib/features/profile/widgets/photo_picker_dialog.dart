import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class PhotoPickerDialog extends StatefulWidget {
  static const List<String> demoPhotos = [
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=600&h=600&q=80&crop=face',
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=600&h=600&q=80&crop=face',
    'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=600&h=600&q=80&crop=face',
    'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=600&h=600&q=80&crop=face',
    'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=600&h=600&q=80&crop=face',
  ];

  final ValueChanged<String?> onSelect;

  const PhotoPickerDialog({super.key, required this.onSelect});

  @override
  State<PhotoPickerDialog> createState() => _PhotoPickerDialogState();
}

class _PhotoPickerDialogState extends State<PhotoPickerDialog> {
  final _urlController = TextEditingController();
  String? _urlError;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _selectCustomUrl() {
    String rawValue = _urlController.text.trim();
    if (rawValue.isEmpty) {
      setState(() => _urlError = 'Введіть посилання на зображення');
      return;
    }

    // Якщо протокол не вказано, використовуємо HTTPS.
    if (!rawValue.contains('://')) rawValue = 'https://$rawValue';

    final uri = Uri.tryParse(rawValue);
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
      setState(() => _urlError = 'Введіть коректне HTTPS-посилання.');
      return;
    }

    widget.onSelect(rawValue);
    Navigator.pop(context);
  }

  Widget _buildUrlPreview() {
    var value = _urlController.text.trim();
    if (!value.contains('://')) value = 'https://$value';
    final uri = Uri.tryParse(value);
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Попередній перегляд',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            value,
            key: ValueKey(value),
            width: 96,
            height: 96,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 96,
              height: 96,
              color: Colors.grey[200],
              alignment: Alignment.center,
              child: const Icon(Icons.broken_image_outlined),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 26, 22, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Вибрати фото',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Виберіть з галереї або вкажіть посилання',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        widget.onSelect(null);
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.lightTealBg,
                        foregroundColor: AppColors.primaryTeal,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text(
                        'Скинути',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        widget.onSelect(PhotoPickerDialog.demoPhotos[0]);
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.lightTealBg,
                        foregroundColor: AppColors.primaryTeal,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.image_outlined, size: 18),
                      label: const Text(
                        'Галерея',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: PhotoPickerDialog.demoPhotos.map((url) {
                  return GestureDetector(
                    onTap: () {
                      widget.onSelect(url);
                      Navigator.pop(context);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        url,
                        width: 82,
                        height: 82,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 82,
                          height: 82,
                          color: Colors.grey[300],
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.image,
                            size: 28,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: _urlController,
                keyboardType: TextInputType.url,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Посилання на власний аватар',
                  hintText: 'example.com/avatar.jpg',
                  prefixIcon: const Icon(Icons.link),
                  errorText: _urlError,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onChanged: (_) {
                  setState(() => _urlError = null);
                },
              ),
              if (_urlController.text.trim().isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildUrlPreview(),
              ],
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _selectCustomUrl,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Встановити аватар'),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Скасувати',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTeal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showPhotoPickerDialog({
  required BuildContext context,
  required ValueChanged<String?> onSelect,
}) {
  return showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.65),
    builder: (ctx) => PhotoPickerDialog(onSelect: onSelect),
  );
}
