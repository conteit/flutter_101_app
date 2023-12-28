import 'reference_table.dart';

import 'values.dart';

class CurrentSelection {
  Value? _uncertainty;
  Value? _complexity;
  Value? _effort;

  CurrentSelection(this._uncertainty, this._complexity, this._effort);

  CurrentSelection.none() {
    _uncertainty = null;
    _complexity = null;
    _effort = null;
  }

  Value? get selectedUncertainty => _uncertainty;
  Value? get selectedComplexity => _complexity;
  Value? get selectedEffort => _effort;

  bool isComplete() {
    return _uncertainty != null && _complexity != null && _effort != null;
  }

  CurrentSelection withUncertainty(Value? value) {
    return CurrentSelection(value, _complexity, _effort);
  }

  CurrentSelection withComplexity(Value? value) {
    return CurrentSelection(_uncertainty, value, _effort);
  }

  CurrentSelection withEffort(Value? value) {
    return CurrentSelection(_uncertainty, _complexity, value);
  }
}

class Status {
  CurrentSelection _currentSelection = CurrentSelection.none();

  Status(CurrentSelection currentSelection) {
    _currentSelection = currentSelection;
  }

  CurrentSelection get currentSelection => _currentSelection;

  List<Value> compatibleComplexity() {
    return table
        .matchingEntries(currentSelection.withComplexity(null))
        .map((e) => e.complexity)
        .toSet()
        .toList();
  }

  List<Value> compatibleEffort() {
    return table
        .matchingEntries(currentSelection.withEffort(null))
        .map((e) => e.effort)
        .toSet()
        .toList();
  }
}
