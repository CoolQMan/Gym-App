// lib/widgets/diet/diet_card.dart
import 'package:flutter/material.dart';
import '../../models/diet_model.dart';

class DietCard extends StatelessWidget {
  final DietPlan dietPlan;
  final VoidCallback onTap;

  const DietCard({Key? key, required this.dietPlan, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                image: DecorationImage(
                  image: AssetImage('assets/images/diet_placeholder.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dietPlan.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dietPlan.description,
                    style: TextStyle(color: Colors.grey[400]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(children: [_buildTargetBadge(dietPlan.target)]),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.timer, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        dietPlan.duration,
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.restaurant_menu,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${dietPlan.mealCount} meals',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.local_fire_department,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${dietPlan.calories} cal',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (dietPlan.createdBy == '1')
                        _buildBadge('My Plan', Colors.blue)
                      else if (dietPlan.createdBy == '3')
                        _buildBadge('Trainer', Colors.green),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTargetBadge(String target) {
    Color badgeColor;
    switch (target.toLowerCase()) {
      case 'weight loss':
        badgeColor = Colors.red;
        break;
      case 'muscle gain':
        badgeColor = Colors.blue;
        break;
      case 'maintenance':
        badgeColor = Colors.green;
        break;
      default:
        badgeColor = Colors.purple;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: badgeColor.withOpacity(0.5), width: 1),
      ),
      child: Text(
        target,
        style: TextStyle(
          color: badgeColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
