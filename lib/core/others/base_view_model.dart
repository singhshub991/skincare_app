import 'package:flutter/foundation.dart';
import '../enums/view_state.dart';

class BaseViewModel extends ChangeNotifier {
  bool _disposed = false;
  ViewState _state = ViewState.idle;

  ViewState get state => _state;

  void setState(ViewState state) {
    _state = state;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
