import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoaderNotifier extends StateNotifier<bool> {
  LoaderNotifier() : super(false);

  void setLoading(bool loading) {
    state = loading;
  }
}

final loaderProvider = StateNotifierProvider<LoaderNotifier, bool>((ref) {
  return LoaderNotifier();
});