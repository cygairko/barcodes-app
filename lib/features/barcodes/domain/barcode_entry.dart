import 'package:barcode_widget/barcode_widget.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'barcode_entry.freezed.dart';
part 'barcode_entry.g.dart';

@freezed
class BarcodeEntry with _$BarcodeEntry {
  const factory BarcodeEntry({
    @Default(-1) int id,
    required String title,
    required String content,
    required BarcodeType type,
  }) = _BarcodeEntry;

  factory BarcodeEntry.fromJson(Map<String, dynamic> json) =>
      _$BarcodeEntryFromJson(json);
}
