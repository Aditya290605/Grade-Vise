import 'package:flutter/material.dart';

class FeedbackCard extends StatelessWidget {
  final String title;
  final String description;
  final String createdAt;
  // Feedback model to hold feedback information

  // Callback functions for view details and delete
  final VoidCallback onViewDetails;
  final VoidCallback onDelete;

  const FeedbackCard({
    super.key,

    required this.createdAt,
    required this.description,
    required this.onDelete,
    required this.onViewDetails,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Feedback Title
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // Feedback Description
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),

            // Action Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // View Details Button
                ElevatedButton(
                  onPressed: onViewDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('View Details'),
                ),

                // Delete Button
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    // Show confirmation dialog before deletion
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('Delete Feedback'),
                            content: const Text(
                              'Are you sure you want to delete this feedback?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  onDelete();
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Feedback model class

// Example usage in a screen
