import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_local_repository.g.dart';

@riverpod
HomelocalRepository homelocalRepository(Ref ref) {
  return HomelocalRepository();
}

class HomelocalRepository {}
