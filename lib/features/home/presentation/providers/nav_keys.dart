import 'package:flutter/material.dart';

/// GlobalKey assigned to the Feed screen's avatar widget at runtime.
/// MainNavigation reads this to compute the swoosh-overlay circle origin.
/// LiveFeedScreen assigns this key to the tappable avatar container.
/// Declared here to avoid a circular import between main_navigation ↔ live_feed.
final GlobalKey avatarGlobalKey = GlobalKey();
