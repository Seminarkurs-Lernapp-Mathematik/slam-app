import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Performance monitoring and optimization utilities

class PerformanceMonitor {
  static final Map<String, Stopwatch> _timers = {};
  static final Map<String, List<int>> _metrics = {};
  static const int _maxMetricsPerOperation = 100;

  /// Start timing an operation
  static void start(String operation) {
    if (!kDebugMode) return;
    
    _timers[operation] = Stopwatch()..start();
  }

  /// End timing an operation and log the result
  static void end(String operation, {Map<String, dynamic>? metadata}) {
    if (!kDebugMode) return;
    
    final timer = _timers[operation];
    if (timer == null) return;
    
    timer.stop();
    final elapsed = timer.elapsedMilliseconds;
    
    // Store metric
    _metrics.putIfAbsent(operation, () => []);
    _metrics[operation]!.add(elapsed);
    
    // Keep only recent metrics
    if (_metrics[operation]!.length > _maxMetricsPerOperation) {
      _metrics[operation]!.removeAt(0);
    }
    
    // Log slow operations
    if (elapsed > 100) {
      developer.log(
        'SLOW OPERATION: $operation took ${elapsed}ms',
        name: 'Performance',
        error: elapsed > 500 ? 'Critical' : 'Warning',
      );
    }
    
    _timers.remove(operation);
  }

  /// Get average time for an operation
  static double? getAverage(String operation) {
    final metrics = _metrics[operation];
    if (metrics == null || metrics.isEmpty) return null;
    
    return metrics.reduce((a, b) => a + b) / metrics.length;
  }

  /// Log all metrics
  static void dumpMetrics() {
    if (!kDebugMode) return;
    
    developer.log('========== PERFORMANCE METRICS ==========', name: 'Performance');
    
    final sortedOps = _metrics.entries.toList()
      ..sort((a, b) => getAverage(b.key)!.compareTo(getAverage(a.key)!));
    
    for (final entry in sortedOps) {
      final avg = getAverage(entry.key);
      final max = entry.value.reduce((a, b) => a > b ? a : b);
      final min = entry.value.reduce((a, b) => a < b ? a : b);
      
      developer.log(
        '${entry.key}: avg=${avg?.toStringAsFixed(2)}ms, min=$max, max=$min (${entry.value.length} samples)',
        name: 'Performance',
      );
    }
    
    developer.log('========================================', name: 'Performance');
  }

  /// Clear all metrics
  static void clear() {
    _timers.clear();
    _metrics.clear();
  }
}

/// Debouncer for throttling expensive operations
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 300)});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void cancel() {
    _timer?.cancel();
  }
}

/// Throttler for limiting operation frequency
class Throttler {
  final Duration interval;
  DateTime? _lastExecution;

  Throttler({this.interval = const Duration(seconds: 1)});

  bool shouldExecute() {
    final now = DateTime.now();
    if (_lastExecution == null || 
        now.difference(_lastExecution!) >= interval) {
      _lastExecution = now;
      return true;
    }
    return false;
  }

  void run(VoidCallback action) {
    if (shouldExecute()) {
      action();
    }
  }
}

/// Widget that logs build times
class BuildMonitor extends StatelessWidget {
  final String name;
  final Widget child;

  const BuildMonitor({
    super.key,
    required this.name,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    PerformanceMonitor.start('build_$name');
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PerformanceMonitor.end('build_$name');
    });
    
    return child;
  }
}

/// Mixin for tracking widget lifecycle performance
mixin PerformanceMixin<T extends StatefulWidget> on State<T> {
  final String _operationName = '${T.toString()}_lifecycle';

  @override
  void initState() {
    PerformanceMonitor.start('${_operationName}_init');
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PerformanceMonitor.end('${_operationName}_init');
    });
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    PerformanceMonitor.start('${_operationName}_update');
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PerformanceMonitor.end('${_operationName}_update');
    });
  }
}

/// Extension for adding performance tracking to Future
extension FuturePerformance<T> on Future<T> {
  Future<T> withPerformanceTracking(String operation) {
    PerformanceMonitor.start(operation);
    return then((result) {
      PerformanceMonitor.end(operation);
      return result;
    }).catchError((error) {
      PerformanceMonitor.end(operation, metadata: {'error': error.toString()});
      throw error;
    });
  }
}
