import 'package:flutter/material.dart';

/// Друга велика картка статистики: найкраща водойма та загальний улов.
class BestWaterBodyCard extends StatelessWidget {
  final Map<String, dynamic> stats;

  const BestWaterBodyCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF5A8059), Color(0xFF6E996B)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF436947).withValues(alpha: 0.18),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Найкраща водойма',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 10),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  stats['bestWaterBody'] as String,
                  key: ValueKey(stats['bestWaterBody']),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.15,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Загальний улов: ${stats['totalWeight']}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          Positioned(
            right: 4,
            bottom: 0,
            child: Icon(
              Icons.water_drop_outlined,
              size: 48,
              color: Colors.white.withValues(alpha: 0.65),
            ),
          ),
        ],
      ),
    );
  }
}
