import 'status.dart';

import 'values.dart';

class ReferenceTable {
  final List<ReferenceTableEntry> _entries;

  ReferenceTable(this._entries);

  List<ReferenceTableEntry> matchingEntries(CurrentSelection currentSelection) {
    return _entries
        .where((element) => element.isCompatibleWith(currentSelection))
        .toList();
  }

  StoryPoints resolveStoryPoints(CurrentSelection currentSelection) {
    return _entries
            .where((element) => element.matches(currentSelection))
            .firstOrNull
            ?.storyPoints ??
        0;
  }
}

class ReferenceTableEntry {
  final Value _uncertainty;
  final Value _complexity;
  final Value _effort;
  final StoryPoints _storyPoints;

  ReferenceTableEntry(
      this._uncertainty, this._complexity, this._effort, this._storyPoints);

  StoryPoints get storyPoints => _storyPoints;

  Value get complexity => _complexity;

  Value get effort => _effort;

  bool matches(CurrentSelection status) {
    return _uncertainty == status.selectedUncertainty &&
        _complexity == status.selectedComplexity &&
        _effort == status.selectedEffort;
  }

  bool isCompatibleWith(CurrentSelection status) {
    if (status.selectedUncertainty != null &&
        status.selectedUncertainty != _uncertainty) {
      return false;
    }

    if (status.selectedComplexity != null &&
        status.selectedComplexity != _complexity) {
      return false;
    }

    if (status.selectedEffort != null && status.selectedEffort != _effort) {
      return false;
    }

    return true;
  }
}

final table = ReferenceTable([
  ReferenceTableEntry(Value.small, Value.small, Value.small, 1),
  ReferenceTableEntry(Value.small, Value.small, Value.medium, 2),
  ReferenceTableEntry(Value.small, Value.small, Value.large, 5),
  ReferenceTableEntry(Value.small, Value.medium, Value.small, 2),
  ReferenceTableEntry(Value.small, Value.medium, Value.medium, 3),
  ReferenceTableEntry(Value.small, Value.medium, Value.large, 5),
  ReferenceTableEntry(Value.small, Value.large, Value.small, 3),
  ReferenceTableEntry(Value.small, Value.large, Value.medium, 5),
  ReferenceTableEntry(Value.small, Value.large, Value.large, 8),
  ReferenceTableEntry(Value.medium, Value.small, Value.small, 3),
  ReferenceTableEntry(Value.medium, Value.small, Value.large, 8),
  ReferenceTableEntry(Value.medium, Value.medium, Value.small, 5),
  ReferenceTableEntry(Value.medium, Value.medium, Value.medium, 5),
  ReferenceTableEntry(Value.medium, Value.medium, Value.large, 8),
  ReferenceTableEntry(Value.medium, Value.large, Value.small, 5),
  ReferenceTableEntry(Value.medium, Value.large, Value.medium, 8),
  ReferenceTableEntry(Value.large, Value.medium, Value.small, 8),
  ReferenceTableEntry(Value.large, Value.medium, Value.medium, 8),
  ReferenceTableEntry(Value.large, Value.medium, Value.large, 13),
  ReferenceTableEntry(Value.large, Value.large, Value.small, 8),
  ReferenceTableEntry(Value.large, Value.large, Value.medium, 13),
  ReferenceTableEntry(Value.large, Value.large, Value.large, 13)
]);
