import 'package:barcodes/features/barcodes/data/barcode_repository.dart';
import 'package:barcodes/features/barcodes/domain/barcode_entry.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'barcodes_list_controller.g.dart';

@riverpod
class BarcodesListController extends _$BarcodesListController {
  @override
  FutureOr<void> build() {}

  Future<bool> add(BarcodeEntry entry) async {
    final barcodeRepository = ref.read(barcodeRepositoryProvider);

    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => barcodeRepository.addEntry(entry),
    );

    return state.hasError == false;
  }

  Future<bool> delete(int entryId) async {
    final barcodeRepository = ref.read(barcodeRepositoryProvider);

    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => barcodeRepository.deleteEntry(entryId),
    );

    return state.hasError == false;
  }
}
