import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:weight_planet_calculator/model/planet_model.dart';
import 'package:weight_planet_calculator/ui/common/custom_theme.dart';
import 'package:weight_planet_calculator/ui/widgets/planet_shader_widget.dart';

class PlanetDetailView extends HookWidget {
  const PlanetDetailView({required this.planet, super.key});

  final Planet planet;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    final weight = useState<double>(75);
    final isKg = useState(true);

    final earthWeightKg = isKg.value ? weight.value : weight.value / 2.20462;
    final planetWeightKg = earthWeightKg * planet.weightGravity;

    final displayWeight = isKg.value
        ? planetWeightKg
        : planetWeightKg * 2.20462;
    final unit = isKg.value ? 'kg' : 'lb';

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          spacing: 8,
          mainAxisSize: .min,
          children: <Widget>[
            Icon(Icons.rocket_launch_outlined, size: 18),
            Text('Peso Cósmico'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                SizedBox.fromSize(
                  size: Size(size.width, size.height * .38),
                  child: PlanetShaderWidget(assetKey: planet.shaderPath),
                ),
                const Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 80,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: .topCenter,
                        end: .bottomCenter,
                        colors: [Colors.transparent, AppColors.background],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const .fromLTRB(20, 0, 20, 30),
              child: Column(
                crossAxisAlignment: .start,
                children: <Widget>[
                  const _SectionTag(label: 'DESTINO ACTUAL'),
                  const SizedBox(height: 4),
                  Text(planet.name, style: AppTextStyles.planetName),
                  const SizedBox(height: 28),
                  const _SectionLabel(text: 'TU PESO EN LA TIERRA'),
                  const SizedBox(height: 12),
                  _WeightStepper(
                    weight: weight.value,
                    onChanged: (v) => weight.value = v,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: .infinity,
                    child: SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(value: true, label: Text('KG')),
                        ButtonSegment(value: false, label: Text('LB')),
                      ],
                      selected: {isKg.value},
                      showSelectedIcon: false,
                      onSelectionChanged: (selection) {
                        if (selection.first == isKg.value) return;
                        weight.value = selection.first
                            ? weight.value / 2.20462
                            : weight.value * 2.20462;
                        isKg.value = selection.first;
                      },
                      style: ButtonStyle(
                        tapTargetSize: .shrinkWrap,
                        padding: .all(const .symmetric(vertical: 14)),
                        backgroundColor: .resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? AppColors.primary
                              : AppColors.surface,
                        ),
                        foregroundColor: .resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                        side: .all(.none),
                        shape: .all(
                          const RoundedRectangleBorder(
                            borderRadius: .all(.circular(12)),
                          ),
                        ),
                        textStyle: .resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? AppTextStyles.toggleActive
                              : AppTextStyles.toggleInactive,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const _SectionLabel(text: 'DESTINO PLANETARIO'),
                  const SizedBox(height: 12),
                  _PlanetInfoCard(planet: planet),
                  const SizedBox(height: 28),
                  _SectionLabel(text: 'PESO EN ${planet.name.toUpperCase()}'),
                  const SizedBox(height: 8),
                  Row(
                    spacing: 8,
                    crossAxisAlignment: .end,
                    children: <Widget>[
                      Text(
                        displayWeight.toStringAsFixed(1),
                        style: AppTextStyles.weightDisplay,
                      ),
                      Padding(
                        padding: const .only(bottom: 8),
                        child: Text(unit, style: AppTextStyles.weightUnit),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Tu peso en ${planet.name}: '
              '${displayWeight.toStringAsFixed(1)} $unit',
            ),
          ),
        ),
        child: const Icon(Icons.share_outlined, color: Colors.white),
      ),
    );
  }
}

class _SectionTag extends StatelessWidget {
  const _SectionTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: .2),
        borderRadius: .circular(4),
      ),
      child: Text(label, style: AppTextStyles.sectionTag),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.sectionLabel);
  }
}

class _WeightStepper extends StatelessWidget {
  const _WeightStepper({required this.weight, required this.onChanged});

  final double weight;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: <Widget>[
        _StepButton(
          icon: Icons.remove,
          onTap: () => onChanged((weight - 1).clamp(1, 999)),
        ),
        Expanded(
          child: Container(
            padding: const .symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: .circular(12),
            ),
            child: Text(
              weight.toStringAsFixed(0),
              textAlign: .center,
              style: AppTextStyles.stepperValue,
            ),
          ),
        ),
        _StepButton(
          icon: Icons.add,
          onTap: () => onChanged((weight + 1).clamp(1, 999)),
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox.square(
        dimension: 54,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: .circular(12),
          ),
          child: Icon(icon, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

class _PlanetInfoCard extends StatelessWidget {
  const _PlanetInfoCard({required this.planet});

  final Planet planet;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: .circular(12),
      ),
      child: Column(
        spacing: 8,
        crossAxisAlignment: .start,
        children: <Widget>[
          Container(
            padding: const .symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              borderRadius: .circular(4),
              color: AppColors.primary.withValues(alpha: .2),
            ),
            child: const Text(
              'SELECCIONADO',
              style: AppTextStyles.cardTagLabel,
            ),
          ),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: <Widget>[
              Text(planet.name, style: AppTextStyles.cardTitle),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.textSecondary,
                  size: 18,
                ),
              ),
            ],
          ),
          Row(
            spacing: 4,
            children: <Widget>[
              const Icon(
                Icons.speed_outlined,
                size: 14,
                color: AppColors.textSecondary,
              ),
              Text(
                '${planet.weightGravity}x Gravedad',
                style: AppTextStyles.cardSubtitle,
              ),
            ],
          ),
          Container(
            padding: const .symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: .circular(20),
              color: Colors.black.withValues(alpha: .3),
            ),
            child: Row(
              spacing: 4,
              mainAxisSize: .min,
              children: <Widget>[
                const Icon(
                  Icons.location_on_outlined,
                  size: 13,
                  color: AppColors.textSecondary,
                ),
                Text(
                  'Un año aquí dura ${_formatYearDays(planet.yearDays)}',
                  style: AppTextStyles.cardMeta,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatYearDays(int days) {
    if (days >= 365 * 2) {
      return '${(days / 365).toStringAsFixed(1)} años terrestres';
    }
    return '$days días';
  }
}
