import 'package:envied/envied.dart';

part 'env.prod.g.dart';

/// {@template env}
/// A repository that manage environment variables
/// {@endtemplate}
@Envied(path: '.env.prod', obfuscate: true)
abstract class EnvProd {
  /// Supabase url secret.
  @EnviedField(varName: 'SUPABASE_URL', obfuscate: true)
  static String supabaseUrl = _EnvProd.supabaseUrl;

  /// Supabase anon key secret.
  @EnviedField(varName: 'SUPABASE_ANON_KEY', obfuscate: true)
  static String supabaseAnonKey = _EnvProd.supabaseAnonKey;

  /// PowerSync url secret.
  @EnviedField(varName: 'POWERSYNC_URL', obfuscate: true)
  static String powerSyncUrl = _EnvProd.powerSyncUrl;

  /// iOS client id key secret.
  @EnviedField(varName: 'IOS_CLIENT_ID', obfuscate: true)
  static String iOSClientId = _EnvProd.iOSClientId;

  /// Web client id key secret.
  @EnviedField(varName: 'WEB_CLIENT_ID', obfuscate: true)
  static String webClientId = _EnvProd.webClientId;
}
