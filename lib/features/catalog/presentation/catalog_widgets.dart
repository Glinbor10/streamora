import 'package:material_ui/material_ui.dart';
import 'package:streamora/features/catalog/domain/media.dart';
import 'package:streamora/shared/widgets/layout.dart';

/// Space that keeps content below the transparent app bar.
class TopPad extends StatelessWidget {
  /// Creates the spacer.
  const new({super.key});

  @override
  Widget build(BuildContext context) =>
      SizedBox(height: kToolbarHeight + MediaQuery.paddingOf(context).top);
}

/// Search box shared by the catalog sections.
class SearchField extends StatelessWidget {
  /// Creates the field.
  const new({
    required this.initialText,
    required this.onChanged,
    required this.hint,
    super.key,
  });

  /// Text shown when the widget is first built.
  final String initialText;

  /// Called on every keystroke.
  final ValueChanged<String> onChanged;

  /// Placeholder text.
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: TextFormField(
        initialValue: initialText,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.search),
          isDense: true,
        ),
      ),
    );
  }
}

/// Category chips built from domain categories.
class DomainCategoryChips extends StatelessWidget {
  /// Creates the chips.
  const new({
    required this.categories,
    required this.selectedId,
    required this.onSelected,
    super.key,
  });

  /// Categories of the section.
  final List<MediaCategory> categories;

  /// Selected category id, null for All.
  final int? selectedId;

  /// Called with the new selection.
  final ValueChanged<int?> onSelected;

  @override
  Widget build(BuildContext context) => CategoryChips(
    categories: [for (final c in categories) (id: c.id, name: c.name)],
    selectedId: selectedId,
    onSelected: onSelected,
  );
}

/// Number of grid columns' max extent for poster grids.
const posterGridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
  maxCrossAxisExtent: 170,
  mainAxisSpacing: 16,
  crossAxisSpacing: 12,
  childAspectRatio: 0.52,
);

/// Placeholder movies used while loading (rendered as skeletons).
List<Movie> placeholderMovies([int count = 8]) => [
  for (var i = 0; i < count; i++)
    Movie(id: -i, title: 'Loading title', year: '2024'),
];
