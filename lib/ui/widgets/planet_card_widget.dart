import 'package:flutter/material.dart';
import 'package:weight_planet_calculator/model/planet_model.dart';
import 'package:weight_planet_calculator/ui/common/custom_theme.dart';

class PlanetCard extends StatelessWidget {
  const PlanetCard({
    required this.planet,
    required this.onTap,
    this.isFullWidth = false,
    super.key,
  });

  final Planet planet;
  final VoidCallback onTap;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    return isFullWidth
        ? _EarthCard(planet: planet, onTap: onTap)
        : _HalfCard(planet: planet, onTap: onTap);
  }
}

class _HalfCard extends StatelessWidget {
  const _HalfCard({required this.planet, required this.onTap});

  final Planet planet;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: .circular(16),
        child: Stack(
          fit: .expand,
          children: <Widget>[
            Image.asset(planet.imagePath, fit: .cover),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const .fromLTRB(12, 24, 12, 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: .topCenter,
                    end: .bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: .75),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: .start,
                  children: <Widget>[
                    Text(planet.name, style: AppTextStyles.planetCardName),
                    Text(
                      '↑ ${planet.gravityMs2} m/s²',
                      style: AppTextStyles.cardMeta,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EarthCard extends StatelessWidget {
  const _EarthCard({required this.planet, required this.onTap});

  final Planet planet;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: .circular(16),
        child: SizedBox(
          height: 140,
          child: Stack(
            fit: .expand,
            children: <Widget>[
              Image.asset(planet.imagePath, fit: .cover),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: .centerRight,
                    end: .centerLeft,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: .55),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const .all(16),
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisAlignment: .spaceBetween,
                  children: <Widget>[
                    const _Badge(label: 'Home', color: AppColors.primary),
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      crossAxisAlignment: .end,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: .start,
                          children: <Widget>[
                            Text(
                              planet.name,
                              style: AppTextStyles.earthCardName,
                            ),
                            const Text(
                              'Standard Gravity',
                              style: AppTextStyles.cardSubtitle,
                            ),
                          ],
                        ),
                        _Badge(
                          label: '${planet.gravityMs2} m/s²',
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: .circular(20)),
      child: Text(label, style: AppTextStyles.badgeLabel),
    );
  }
}
