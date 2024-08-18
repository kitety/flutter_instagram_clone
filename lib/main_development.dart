import 'package:api_repository/api_repository.dart';
import 'package:flutter_instagram_clone/app/view/app.dart';
import 'package:flutter_instagram_clone/bootstrap.dart';
import 'package:flutter_instagram_clone/firebase_options_dev.dart';

void main() {
  const apiRepository = ApiRepository();
  bootstrap(
    (powersyncRepository) => const App(apiRepository: apiRepository),
    options: DefaultFirebaseOptions.currentPlatform,
    isDev: true,
  );
}
