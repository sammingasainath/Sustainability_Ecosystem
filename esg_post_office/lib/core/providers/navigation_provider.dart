import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigationProvider =
    StateNotifierProvider<NavigationNotifier, int>((ref) {
  return NavigationNotifier();
});

class NavigationNotifier extends StateNotifier<int> {
  NavigationNotifier() : super(0);

  void setIndex(int index) {
    state = index;
  }

  void reset() {
    state = 0;
  }
}

class BottomNavVisibilityNotifier extends StateNotifier<bool> {
  BottomNavVisibilityNotifier() : super(true);

  void show() {
    state = true;
  }

  void hide() {
    state = false;
  }

  void toggle() {
    state = !state;
  }
}

final bottomNavVisibilityProvider =
    StateNotifierProvider<BottomNavVisibilityNotifier, bool>((ref) {
  return BottomNavVisibilityNotifier();
});
