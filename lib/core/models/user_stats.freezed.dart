// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserStats {
  int get level;
  int get xp;
  int get xpToNextLevel;
  int get streak;
  int get totalXp;
  String? get lastActiveDate;

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserStatsCopyWith<UserStats> get copyWith =>
      _$UserStatsCopyWithImpl<UserStats>(this as UserStats, _$identity);

  /// Serializes this UserStats to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserStats &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.xp, xp) || other.xp == xp) &&
            (identical(other.xpToNextLevel, xpToNextLevel) ||
                other.xpToNextLevel == xpToNextLevel) &&
            (identical(other.streak, streak) || other.streak == streak) &&
            (identical(other.totalXp, totalXp) || other.totalXp == totalXp) &&
            (identical(other.lastActiveDate, lastActiveDate) ||
                other.lastActiveDate == lastActiveDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, level, xp, xpToNextLevel, streak, totalXp, lastActiveDate);

  @override
  String toString() {
    return 'UserStats(level: $level, xp: $xp, xpToNextLevel: $xpToNextLevel, streak: $streak, totalXp: $totalXp, lastActiveDate: $lastActiveDate)';
  }
}

/// @nodoc
abstract mixin class $UserStatsCopyWith<$Res> {
  factory $UserStatsCopyWith(UserStats value, $Res Function(UserStats) _then) =
      _$UserStatsCopyWithImpl;
  @useResult
  $Res call(
      {int level,
      int xp,
      int xpToNextLevel,
      int streak,
      int totalXp,
      String? lastActiveDate});
}

/// @nodoc
class _$UserStatsCopyWithImpl<$Res> implements $UserStatsCopyWith<$Res> {
  _$UserStatsCopyWithImpl(this._self, this._then);

  final UserStats _self;
  final $Res Function(UserStats) _then;

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
    Object? xp = null,
    Object? xpToNextLevel = null,
    Object? streak = null,
    Object? totalXp = null,
    Object? lastActiveDate = freezed,
  }) {
    return _then(_self.copyWith(
      level: null == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      xp: null == xp
          ? _self.xp
          : xp // ignore: cast_nullable_to_non_nullable
              as int,
      xpToNextLevel: null == xpToNextLevel
          ? _self.xpToNextLevel
          : xpToNextLevel // ignore: cast_nullable_to_non_nullable
              as int,
      streak: null == streak
          ? _self.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as int,
      totalXp: null == totalXp
          ? _self.totalXp
          : totalXp // ignore: cast_nullable_to_non_nullable
              as int,
      lastActiveDate: freezed == lastActiveDate
          ? _self.lastActiveDate
          : lastActiveDate // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _UserStats extends UserStats {
  const _UserStats(
      {this.level = 1,
      this.xp = 0,
      this.xpToNextLevel = 100,
      this.streak = 0,
      this.totalXp = 0,
      this.lastActiveDate})
      : super._();
  factory _UserStats.fromJson(Map<String, dynamic> json) =>
      _$UserStatsFromJson(json);

  @override
  @JsonKey()
  final int level;
  @override
  @JsonKey()
  final int xp;
  @override
  @JsonKey()
  final int xpToNextLevel;
  @override
  @JsonKey()
  final int streak;
  @override
  @JsonKey()
  final int totalXp;
  @override
  final String? lastActiveDate;

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserStatsCopyWith<_UserStats> get copyWith =>
      __$UserStatsCopyWithImpl<_UserStats>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserStatsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserStats &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.xp, xp) || other.xp == xp) &&
            (identical(other.xpToNextLevel, xpToNextLevel) ||
                other.xpToNextLevel == xpToNextLevel) &&
            (identical(other.streak, streak) || other.streak == streak) &&
            (identical(other.totalXp, totalXp) || other.totalXp == totalXp) &&
            (identical(other.lastActiveDate, lastActiveDate) ||
                other.lastActiveDate == lastActiveDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, level, xp, xpToNextLevel, streak, totalXp, lastActiveDate);

  @override
  String toString() {
    return 'UserStats(level: $level, xp: $xp, xpToNextLevel: $xpToNextLevel, streak: $streak, totalXp: $totalXp, lastActiveDate: $lastActiveDate)';
  }
}

/// @nodoc
abstract mixin class _$UserStatsCopyWith<$Res>
    implements $UserStatsCopyWith<$Res> {
  factory _$UserStatsCopyWith(
          _UserStats value, $Res Function(_UserStats) _then) =
      __$UserStatsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int level,
      int xp,
      int xpToNextLevel,
      int streak,
      int totalXp,
      String? lastActiveDate});
}

/// @nodoc
class __$UserStatsCopyWithImpl<$Res> implements _$UserStatsCopyWith<$Res> {
  __$UserStatsCopyWithImpl(this._self, this._then);

  final _UserStats _self;
  final $Res Function(_UserStats) _then;

  /// Create a copy of UserStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? level = null,
    Object? xp = null,
    Object? xpToNextLevel = null,
    Object? streak = null,
    Object? totalXp = null,
    Object? lastActiveDate = freezed,
  }) {
    return _then(_UserStats(
      level: null == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      xp: null == xp
          ? _self.xp
          : xp // ignore: cast_nullable_to_non_nullable
              as int,
      xpToNextLevel: null == xpToNextLevel
          ? _self.xpToNextLevel
          : xpToNextLevel // ignore: cast_nullable_to_non_nullable
              as int,
      streak: null == streak
          ? _self.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as int,
      totalXp: null == totalXp
          ? _self.totalXp
          : totalXp // ignore: cast_nullable_to_non_nullable
              as int,
      lastActiveDate: freezed == lastActiveDate
          ? _self.lastActiveDate
          : lastActiveDate // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
