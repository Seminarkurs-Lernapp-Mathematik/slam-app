import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/design_tokens.dart';

/// Horizontal time-scrubber for the Knowledge Graph time-travel feature.
/// Shows a slider from [firstDate] to now.
/// Calls [onTimeSelected] with null when dragged back to the rightmost position (= live).
class TimeScrubber extends StatefulWidget {
  final DateTime firstDate;
  final List<DateTime> activeDays;
  final DateTime? selectedTime;
  final ValueChanged<DateTime?> onTimeSelected;

  const TimeScrubber({
    super.key,
    required this.firstDate,
    required this.activeDays,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  State<TimeScrubber> createState() => _TimeScrubberState();
}

class _TimeScrubberState extends State<TimeScrubber> {
  late double _value; // 0.0 = firstDate, 1.0 = now (live)

  @override
  void initState() {
    super.initState();
    _value = widget.selectedTime == null
        ? 1.0
        : _timeToValue(widget.selectedTime!);
  }

  double _timeToValue(DateTime t) {
    final now = DateTime.now();
    final range =
        now.millisecondsSinceEpoch - widget.firstDate.millisecondsSinceEpoch;
    if (range <= 0) return 1.0;
    final offset =
        t.millisecondsSinceEpoch - widget.firstDate.millisecondsSinceEpoch;
    return (offset / range).clamp(0.0, 1.0);
  }

  DateTime _valueToTime(double v) {
    final now = DateTime.now();
    final range =
        now.millisecondsSinceEpoch - widget.firstDate.millisecondsSinceEpoch;
    final ms = widget.firstDate.millisecondsSinceEpoch + (range * v).round();
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  String _formatDate(DateTime d) {
    return '${d.day}.${d.month}.${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isLive = _value >= 0.99;
    final selectedDate = isLive ? null : _valueToTime(_value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.history, size: 13, color: SlamTokens.textDim),
            const SizedBox(width: 4),
            Text(
              'Zeitreise',
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: SlamTokens.textDim,
                letterSpacing: 0.2,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isLive
                    ? SlamTokens.success.withValues(alpha: 0.12)
                    : SlamTokens.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                isLive ? 'Live' : _formatDate(selectedDate!),
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isLive ? SlamTokens.success : SlamTokens.primary,
                ),
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 2.5,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            activeTrackColor: SlamTokens.primary,
            inactiveTrackColor: SlamTokens.line,
            thumbColor: SlamTokens.primary,
            overlayColor: SlamTokens.primary.withValues(alpha: 0.15),
            tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 1.5),
            activeTickMarkColor: SlamTokens.primary.withValues(alpha: 0.5),
            inactiveTickMarkColor: SlamTokens.line,
          ),
          child: Slider(
            value: _value,
            onChanged: (v) {
              setState(() => _value = v);
            },
            onChangeEnd: (v) {
              final isNow = v >= 0.99;
              widget.onTimeSelected(isNow ? null : _valueToTime(v));
            },
            divisions: widget.activeDays.length > 1
                ? widget.activeDays.length - 1
                : null,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatDate(widget.firstDate),
              style: GoogleFonts.dmSans(
                fontSize: 10,
                color: SlamTokens.textMute,
              ),
            ),
            Text(
              'Jetzt',
              style: GoogleFonts.dmSans(
                fontSize: 10,
                color: SlamTokens.textMute,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
