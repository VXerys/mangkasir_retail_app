import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Supabase.initialize() MUST be called in main() before configureDependencies().
@module
abstract class SupabaseModule {
  @lazySingleton
  SupabaseClient get supabaseClient => Supabase.instance.client;
}
