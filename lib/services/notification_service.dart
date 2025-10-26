import 'package:flutter/material.dart';

class NotificationService {
  void showInAppNotification(
    BuildContext context, {
    required String title,
    required String message,
    IconData? icon,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(message),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor ?? Colors.purple,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void showSaveNotification(BuildContext context, String item) {
    showInAppNotification(
      context,
      title: 'Сохранено',
      message: '$item успешно сохранён',
      icon: Icons.check_circle,
      backgroundColor: Colors.green,
    );
  }

  void showErrorNotification(BuildContext context, String error) {
    showInAppNotification(
      context,
      title: 'Ошибка',
      message: error,
      icon: Icons.error_outline,
      backgroundColor: Colors.red,
    );
  }
}
