// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barcode_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BarcodeEntry _$BarcodeEntryFromJson(Map<String, dynamic> json) =>
    _BarcodeEntry(
      name: json['name'] as String,
      data: json['data'] as String,
      type: $enumDecode(_$BarcodeTypeEnumMap, json['type']),
      comment: json['comment'] as String?,
      id: (json['id'] as num?)?.toInt() ?? -1,
    );

Map<String, dynamic> _$BarcodeEntryToJson(_BarcodeEntry instance) =>
    <String, dynamic>{
      'name': instance.name,
      'data': instance.data,
      'type': _$BarcodeTypeEnumMap[instance.type]!,
      'comment': instance.comment,
      'id': instance.id,
    };

const _$BarcodeTypeEnumMap = {
  BarcodeType.CodeITF16: 'CodeITF16',
  BarcodeType.CodeITF14: 'CodeITF14',
  BarcodeType.CodeEAN13: 'CodeEAN13',
  BarcodeType.CodeEAN8: 'CodeEAN8',
  BarcodeType.CodeEAN5: 'CodeEAN5',
  BarcodeType.CodeEAN2: 'CodeEAN2',
  BarcodeType.CodeISBN: 'CodeISBN',
  BarcodeType.Code39: 'Code39',
  BarcodeType.Code93: 'Code93',
  BarcodeType.CodeUPCA: 'CodeUPCA',
  BarcodeType.CodeUPCE: 'CodeUPCE',
  BarcodeType.Code128: 'Code128',
  BarcodeType.GS128: 'GS128',
  BarcodeType.Telepen: 'Telepen',
  BarcodeType.QrCode: 'QrCode',
  BarcodeType.Codabar: 'Codabar',
  BarcodeType.PDF417: 'PDF417',
  BarcodeType.DataMatrix: 'DataMatrix',
  BarcodeType.Aztec: 'Aztec',
  BarcodeType.Rm4scc: 'Rm4scc',
  BarcodeType.Postnet: 'Postnet',
  BarcodeType.Itf: 'Itf',
};
