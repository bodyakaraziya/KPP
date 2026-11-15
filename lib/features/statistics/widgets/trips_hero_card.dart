import 'package:flutter/material.dart';

/// Перша велика картка статистики: кількість виїздів та найкращий улов.
class TripsHeroCard extends StatelessWidget {
  final Map<String, dynamic> stats;

  const TripsHeroCard({super.key, required this.stats});

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
          colors: [Color(0xFF0A4D50), Color(0xFF006D73), Color(0xFF08484B)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00676C).withValues(alpha: 0.2),
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
                stats['periodLabel'] as String,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.78),
                ),
              ),
              const SizedBox(height: 10),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  stats['tripsCount'] as String,
                  key: ValueKey(stats['tripsCount']),
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.05,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Найкращий улов: ${stats['bestCatch']}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.78),
                ),
              ),
            ],
          ),
          Positioned(
            right: 4,
            bottom: 0,
            child: Icon(
              Icons.calendar_today_outlined,
              size: 46,
              color: Colors.white.withValues(alpha: 0.55),
            ),
          ),
        ],
      ),
    );
  }
}
