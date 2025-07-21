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
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANONKEY']!,
  );
  GetIt.I.registerSingleton(SupabaseService());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          final catalogProvider = CatalogProvider();
          return catalogProvider;
        }),
        ChangeNotifierProvider(create: (_){
          final wishlistProvider = WishlistProvider();
          wishlistProvider.init();
          return wishlistProvider;
        })
      ],
      child: const ChizhikApp(),
    ),
  );
}



