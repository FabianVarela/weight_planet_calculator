import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weight_planet_calculator/model/planet_model.dart';
import 'package:weight_planet_calculator/ui/common/custom_theme.dart';
import 'package:weight_planet_calculator/ui/planet_detail_view.dart';
import 'package:weight_planet_calculator/ui/widgets/planet_card_widget.dart';

class PlanetListView extends StatelessWidget {
  const PlanetListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selección de Planeta'),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverPadding(
            padding: const .fromLTRB(16, 0, 16, 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const Text(
                  'Explora el sistema solar para calcular tu peso',
                  style: AppTextStyles.cardSubtitle,
                ),
                const SizedBox(height: 16),
                _PlanetGrid(planets: planets),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanetGrid extends StatelessWidget {
  const _PlanetGrid({required this.planets});

  final List<Planet> planets;

  @override
  Widget build(BuildContext context) {
    final earth = planets.firstWhere((p) => p.isHome);
    final earthIndex = planets.indexOf(earth);

    final before = planets.sublist(0, earthIndex);
    final after = planets.sublist(earthIndex + 1);

    return Column(
      spacing: 8,
      children: <Widget>[
        ...<Widget>[
          for (var i = 0; i < before.length; i += 2)
            _PlanetRow(
              left: before[i],
              right: i + 1 < before.length ? before[i + 1] : null,
            ),
        ],
        PlanetCard(
          planet: earth,
          isFullWidth: true,
          onTap: () => _navigate(context, earth),
        ),
        ...<Widget>[
          for (var i = 0; i < after.length; i += 2)
            _PlanetRow(
              left: after[i],
              right: i + 1 < after.length ? after[i + 1] : null,
            ),
        ],
      ],
    );
  }

  void _navigate(BuildContext context, Planet planet) {
    unawaited(
      Navigator.push<void>(
        context,
        MaterialPageRoute(builder: (_) => PlanetDetailView(planet: planet)),
      ),
    );
  }
}

class _PlanetRow extends StatelessWidget {
  const _PlanetRow({required this.left, this.right});

  final Planet left;
  final Planet? right;

  @override
  Widget build(BuildContext context) {
    final cardSize = (MediaQuery.sizeOf(context).width - 40) / 2;

    return Row(
      spacing: 8,
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: cardSize,
            child: PlanetCard(
              planet: left,
              onTap: () => _navigate(context, left),
            ),
          ),
        ),
        if (right != null)
          Expanded(
            child: SizedBox(
              height: cardSize,
              child: PlanetCard(
                planet: right!,
                onTap: () => _navigate(context, right!),
              ),
            ),
          )
        else
          const Expanded(child: SizedBox.shrink()),
      ],
    );
  }

  void _navigate(BuildContext context, Planet planet) {
    unawaited(
      Navigator.push<void>(
        context,
        MaterialPageRoute(builder: (_) => PlanetDetailView(planet: planet)),
      ),
    );
  }
}
