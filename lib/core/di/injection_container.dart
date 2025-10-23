import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
// import 'injection_container.config.dart';

final sl = GetIt.instance;

@InjectableInit()
Future<void> init() async {
  // await sl.init();
  // Manual registration for now
}

@module
abstract class RegisterModule {
  // Register dependencies here if needed
}
