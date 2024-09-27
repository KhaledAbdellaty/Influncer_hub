abstract class LocalizationKeys {
  static const shared = _Shared();
  static void s() {
    shared.kcontinue;
  }
}

class _Shared {
  const _Shared();
  final kcontinue = "shared.continue";
}
