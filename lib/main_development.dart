import 'package:api_repository/api_repository.dart';
import 'package:flutter_instagram_clone/app/view/app.dart';
import 'package:flutter_instagram_clone/bootstrap.dart';

void main() {
  const apiRepository = ApiRepository();
  bootstrap(() => const App(apiRepository: apiRepository));
}
