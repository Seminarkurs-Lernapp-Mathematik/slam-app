// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authLoginHash() => r'b947e33f58e898fb9fc49062724cb9657a99327c';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Auth Login Provider
///
/// Handles login with email and password
///
/// Copied from [authLogin].
@ProviderFor(authLogin)
const authLoginProvider = AuthLoginFamily();

/// Auth Login Provider
///
/// Handles login with email and password
///
/// Copied from [authLogin].
class AuthLoginFamily extends Family<AsyncValue<User>> {
  /// Auth Login Provider
  ///
  /// Handles login with email and password
  ///
  /// Copied from [authLogin].
  const AuthLoginFamily();

  /// Auth Login Provider
  ///
  /// Handles login with email and password
  ///
  /// Copied from [authLogin].
  AuthLoginProvider call(
    Map<String, String> credentials,
  ) {
    return AuthLoginProvider(
      credentials,
    );
  }

  @override
  AuthLoginProvider getProviderOverride(
    covariant AuthLoginProvider provider,
  ) {
    return call(
      provider.credentials,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'authLoginProvider';
}

/// Auth Login Provider
///
/// Handles login with email and password
///
/// Copied from [authLogin].
class AuthLoginProvider extends AutoDisposeFutureProvider<User> {
  /// Auth Login Provider
  ///
  /// Handles login with email and password
  ///
  /// Copied from [authLogin].
  AuthLoginProvider(
    Map<String, String> credentials,
  ) : this._internal(
          (ref) => authLogin(
            ref as AuthLoginRef,
            credentials,
          ),
          from: authLoginProvider,
          name: r'authLoginProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$authLoginHash,
          dependencies: AuthLoginFamily._dependencies,
          allTransitiveDependencies: AuthLoginFamily._allTransitiveDependencies,
          credentials: credentials,
        );

  AuthLoginProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.credentials,
  }) : super.internal();

  final Map<String, String> credentials;

  @override
  Override overrideWith(
    FutureOr<User> Function(AuthLoginRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AuthLoginProvider._internal(
        (ref) => create(ref as AuthLoginRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        credentials: credentials,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<User> createElement() {
    return _AuthLoginProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AuthLoginProvider && other.credentials == credentials;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, credentials.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AuthLoginRef on AutoDisposeFutureProviderRef<User> {
  /// The parameter `credentials` of this provider.
  Map<String, String> get credentials;
}

class _AuthLoginProviderElement extends AutoDisposeFutureProviderElement<User>
    with AuthLoginRef {
  _AuthLoginProviderElement(super.provider);

  @override
  Map<String, String> get credentials =>
      (origin as AuthLoginProvider).credentials;
}

String _$authRegisterHash() => r'a8c093d6693c67a03eb4031eb886712178d2628e';

/// Auth Register Provider
///
/// Handles registration with email, password, and display name
///
/// Copied from [authRegister].
@ProviderFor(authRegister)
const authRegisterProvider = AuthRegisterFamily();

/// Auth Register Provider
///
/// Handles registration with email, password, and display name
///
/// Copied from [authRegister].
class AuthRegisterFamily extends Family<AsyncValue<User>> {
  /// Auth Register Provider
  ///
  /// Handles registration with email, password, and display name
  ///
  /// Copied from [authRegister].
  const AuthRegisterFamily();

  /// Auth Register Provider
  ///
  /// Handles registration with email, password, and display name
  ///
  /// Copied from [authRegister].
  AuthRegisterProvider call(
    Map<String, String> credentials,
  ) {
    return AuthRegisterProvider(
      credentials,
    );
  }

  @override
  AuthRegisterProvider getProviderOverride(
    covariant AuthRegisterProvider provider,
  ) {
    return call(
      provider.credentials,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'authRegisterProvider';
}

/// Auth Register Provider
///
/// Handles registration with email, password, and display name
///
/// Copied from [authRegister].
class AuthRegisterProvider extends AutoDisposeFutureProvider<User> {
  /// Auth Register Provider
  ///
  /// Handles registration with email, password, and display name
  ///
  /// Copied from [authRegister].
  AuthRegisterProvider(
    Map<String, String> credentials,
  ) : this._internal(
          (ref) => authRegister(
            ref as AuthRegisterRef,
            credentials,
          ),
          from: authRegisterProvider,
          name: r'authRegisterProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$authRegisterHash,
          dependencies: AuthRegisterFamily._dependencies,
          allTransitiveDependencies:
              AuthRegisterFamily._allTransitiveDependencies,
          credentials: credentials,
        );

  AuthRegisterProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.credentials,
  }) : super.internal();

  final Map<String, String> credentials;

  @override
  Override overrideWith(
    FutureOr<User> Function(AuthRegisterRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AuthRegisterProvider._internal(
        (ref) => create(ref as AuthRegisterRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        credentials: credentials,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<User> createElement() {
    return _AuthRegisterProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AuthRegisterProvider && other.credentials == credentials;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, credentials.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AuthRegisterRef on AutoDisposeFutureProviderRef<User> {
  /// The parameter `credentials` of this provider.
  Map<String, String> get credentials;
}

class _AuthRegisterProviderElement
    extends AutoDisposeFutureProviderElement<User> with AuthRegisterRef {
  _AuthRegisterProviderElement(super.provider);

  @override
  Map<String, String> get credentials =>
      (origin as AuthRegisterProvider).credentials;
}

String _$authLogoutHash() => r'a7228648e99b6b18566471bfc5eabf8b08933fa5';

/// Auth Logout Provider
///
/// Copied from [authLogout].
@ProviderFor(authLogout)
final authLogoutProvider = AutoDisposeFutureProvider<void>.internal(
  authLogout,
  name: r'authLogoutProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authLogoutHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthLogoutRef = AutoDisposeFutureProviderRef<void>;
String _$isAuthenticatedHash() => r'efcda852561d2e0dc3aced79257b9adc56f957d4';

/// Is Authenticated Provider
///
/// Returns true if user is authenticated and email is verified
///
/// Copied from [isAuthenticated].
@ProviderFor(isAuthenticated)
final isAuthenticatedProvider = AutoDisposeProvider<bool>.internal(
  isAuthenticated,
  name: r'isAuthenticatedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isAuthenticatedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsAuthenticatedRef = AutoDisposeProviderRef<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
