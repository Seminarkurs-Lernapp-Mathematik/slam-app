import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for the main navigation: which tab is active and whether
/// the profile swoosh-overlay is open.
class MainNavState {
  const MainNavState({this.tabIndex = 0, this.showProfileOverlay = false});

  final int tabIndex;
  final bool showProfileOverlay;

  MainNavState copyWith({int? tabIndex, bool? showProfileOverlay}) =>
      MainNavState(
        tabIndex: tabIndex ?? this.tabIndex,
        showProfileOverlay: showProfileOverlay ?? this.showProfileOverlay,
      );
}

class MainNavNotifier extends StateNotifier<MainNavState> {
  MainNavNotifier() : super(const MainNavState());

  void switchToTab(int index) =>
      state = MainNavState(tabIndex: index, showProfileOverlay: false);

  void openProfile() => state = state.copyWith(showProfileOverlay: true);

  void closeProfile() => state = state.copyWith(showProfileOverlay: false);
}

final mainNavNotifierProvider =
    StateNotifierProvider<MainNavNotifier, MainNavState>(
  (ref) => MainNavNotifier(),
);
