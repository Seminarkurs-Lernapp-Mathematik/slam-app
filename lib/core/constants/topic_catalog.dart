// Topic Catalog for German Math Curriculum
// Organized by Leitidee > Thema > Unterthema
// Used by Lernplan screen for topic selection

class TopicCatalogEntry {
  final String leitidee;
  final String thema;
  final String unterthema;
  final IconType icon;

  const TopicCatalogEntry({
    required this.leitidee,
    required this.thema,
    required this.unterthema,
    this.icon = IconType.functions,
  });
}

enum IconType {
  functions,
  showChart,
  hexagon,
  barChart,
}

class LeitideeGroup {
  final String name;
  final IconType icon;
  final List<ThemaGroup> themen;

  const LeitideeGroup({
    required this.name,
    required this.icon,
    required this.themen,
  });
}

class ThemaGroup {
  final String name;
  final List<String> unterthemen;

  const ThemaGroup({
    required this.name,
    required this.unterthemen,
  });
}

/// Complete German math curriculum topic catalog
const List<LeitideeGroup> topicCatalog = [
  LeitideeGroup(
    name: 'Algebra',
    icon: IconType.functions,
    themen: [
      ThemaGroup(
        name: 'Gleichungen',
        unterthemen: [
          'Lineare Gleichungen',
          'Quadratische Gleichungen',
          'Gleichungssysteme',
        ],
      ),
      ThemaGroup(
        name: 'Terme und Formeln',
        unterthemen: [
          'Binomische Formeln',
          'Termumformungen',
          'Potenzgesetze',
        ],
      ),
      ThemaGroup(
        name: 'Funktionen',
        unterthemen: [
          'Lineare Funktionen',
          'Quadratische Funktionen',
          'Exponentialfunktionen',
        ],
      ),
    ],
  ),
  LeitideeGroup(
    name: 'Analysis',
    icon: IconType.showChart,
    themen: [
      ThemaGroup(
        name: 'Differentialrechnung',
        unterthemen: [
          'Ableitungsregeln',
          'Kurvendiskussion',
          'Extremwertprobleme',
        ],
      ),
      ThemaGroup(
        name: 'Integralrechnung',
        unterthemen: [
          'Stammfunktionen',
          'Flächenberechnung',
          'Rotationskörper',
        ],
      ),
    ],
  ),
  LeitideeGroup(
    name: 'Geometrie',
    icon: IconType.hexagon,
    themen: [
      ThemaGroup(
        name: 'Trigonometrie',
        unterthemen: [
          'Sinus und Kosinus',
          'Winkelfunktionen',
          'Trigonometrische Gleichungen',
        ],
      ),
      ThemaGroup(
        name: 'Analytische Geometrie',
        unterthemen: [
          'Vektorrechnung',
          'Geraden und Ebenen',
          'Abstandsberechnungen',
        ],
      ),
    ],
  ),
  LeitideeGroup(
    name: 'Stochastik',
    icon: IconType.barChart,
    themen: [
      ThemaGroup(
        name: 'Wahrscheinlichkeit',
        unterthemen: [
          'Wahrscheinlichkeitsrechnung',
          'Bedingte Wahrscheinlichkeit',
          'Kombinatorik',
        ],
      ),
      ThemaGroup(
        name: 'Statistik',
        unterthemen: [
          'Normalverteilung',
          'Hypothesentests',
          'Deskriptive Statistik',
        ],
      ),
    ],
  ),
];
