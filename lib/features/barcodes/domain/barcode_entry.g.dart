// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barcode_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BarcodeEntryImpl _$$BarcodeEntryImplFromJson(Map<String, dynamic> json) =>
    _$BarcodeEntryImpl(
      id: json['id'] as int? ?? -1,
      title: json['title'] as String,
      content: json['content'] as String,
      type: $enumDecode(_$BarcodeTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$$BarcodeEntryImplToJson(_$BarcodeEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'type': _$BarcodeTypeEnumMap[instance.type]!,
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
  BarcodeType.Itf: 'Itf',
};
