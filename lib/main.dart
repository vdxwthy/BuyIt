import 'package:buy_it/core/app/app.dart';
import 'package:buy_it/data/services/supabase_service.dart';
import 'package:buy_it/presentation/providers/catalog_provider.dart';
import 'package:buy_it/presentation/providers/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANONKEY']!,
  );

  GetIt.I.registerSingleton(SupabaseService());

  final wishlistProvider = WishlistProvider();
  wishlistProvider.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CatalogProvider()),
        ChangeNotifierProvider.value(value: wishlistProvider),
      ],
      child: const ChizhikApp(),
    ),
  );
}




