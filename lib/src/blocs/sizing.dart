import '../models/status.dart';
import 'package:rxdart/rxdart.dart';

class StoryPointSizingBloc {
  final _statusPublisher = PublishSubject<Status>();

  StoryPointSizingBloc() {
    updateCurrentSelection(CurrentSelection.none());
  }

  Stream<Status> get latestStatus => _statusPublisher.stream;

  void updateCurrentSelection(CurrentSelection currentSelection) {
    _statusPublisher.sink.add(_createStatus(currentSelection));
  }

  Status _createStatus(CurrentSelection currentSelection) {
    return Status(currentSelection);
  }
}

final sizingBloc = StoryPointSizingBloc();
