import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';

Future<bool?> showConfirmDeleteDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder:
        (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          title: Text(
            "Delete Product?",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          content: Text(
            "Are you sure you want to delete this product?",
            style: TextStyle(color: Colors.grey[700]),
          ),
          actionsPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          actionsAlignment: MainAxisAlignment.end,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("Cancel", style: TextStyle(color: Colors.grey[700])),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.pop(context, true),
              child: Text("Delete", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
  );
}
