import 'package:barcode_widget/barcode_widget.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'barcode_entry.freezed.dart';
part 'barcode_entry.g.dart';

@freezed
abstract class BarcodeEntry with _$BarcodeEntry {
  const factory BarcodeEntry({
    required String name,
    required String data,
    required BarcodeType type,
    String? comment,
    @Default(-1) int id,
  }) = _BarcodeEntry;

  factory BarcodeEntry.fromJson(Map<String, dynamic> json) => _$BarcodeEntryFromJson(json);
}
