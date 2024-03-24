/*
 * Copyright (C) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:barcode_widget/barcode_widget.dart';

/// Barcode configuration
class BarcodeConf {
  BarcodeConf(this.data, BarcodeType initType) {
    type = initType;
  }
  final String data;

  String get normalizedData {
    if (barcode is BarcodeEan && barcode.name != 'UPC E') {
      // ignore: avoid_as
      final ean = barcode as BarcodeEan;
      return ean.normalize(data);
    }

    return data;
  }

  late Barcode _barcode;

  late String _method;

  late BarcodeType _type;

  /// Size of the font
  double fontSize = 30;

  /// height of the barcode
  double height = 160;

  /// width of the barcode
  double width = 400;

  Barcode get barcode => _barcode;

  String get method => _method;

  /// Barcode type
  BarcodeType get type => _type;

  set type(BarcodeType value) {
    _type = value;

    fontSize = 30;
    height = 160;
    width = 400;

    switch (_type) {
      case BarcodeType.Itf:
        fontSize = 25;
        _method = 'itf(zeroPrepend: true)';
        _barcode = Barcode.itf(zeroPrepend: true);
      case BarcodeType.CodeITF16:
        fontSize = 25;
        height = 140;
        _method = 'itf16()';
        _barcode = Barcode.itf16();
      case BarcodeType.CodeITF14:
        fontSize = 25;
        height = 140;
        _method = 'itf14()';
        _barcode = Barcode.itf14();
      case BarcodeType.CodeEAN13:
        _method = 'ean13(drawEndChar: true)';
        _barcode = Barcode.ean13(drawEndChar: true);
      case BarcodeType.CodeEAN8:
        width = 300;
        _method = 'ean8(drawSpacers: true)';
        _barcode = Barcode.ean8(drawSpacers: true);
      case BarcodeType.CodeEAN5:
        width = 150;
        _method = 'ean5()';
        _barcode = Barcode.ean5();
      case BarcodeType.CodeEAN2:
        width = 100;
        _method = 'ean2()';
        _barcode = Barcode.ean2();
      case BarcodeType.CodeISBN:
        fontSize = 25;
        height = 140;
        _method = 'isbn(drawEndChar: true)';
        _barcode = Barcode.isbn(drawEndChar: true);
      case BarcodeType.Code39:
        _method = 'code39()';
        _barcode = Barcode.code39();
      case BarcodeType.Code93:
        _method = 'code93()';
        _barcode = Barcode.code93();
      case BarcodeType.CodeUPCA:
        _method = 'upcA()';
        _barcode = Barcode.upcA();
      case BarcodeType.CodeUPCE:
        _method = 'upcE()';
        _barcode = Barcode.upcE();
      case BarcodeType.Code128:
        fontSize = 25;
        _method = 'code128(escapes: true)';
        _barcode = Barcode.code128(escapes: true);
      case BarcodeType.GS128:
        _method = 'gs128(useCode128A: false, useCode128B: false)';
        fontSize = 25;
        _barcode = Barcode.gs128(useCode128A: false, useCode128B: false);
      case BarcodeType.Telepen:
        _method = 'telepen()';
        _barcode = Barcode.telepen();
      case BarcodeType.QrCode:
        width = 300;
        height = width;
        _method = 'qrCode()';
        _barcode = Barcode.qrCode();
      case BarcodeType.Codabar:
        _method = 'codabar()';
        _barcode = Barcode.codabar();
      case BarcodeType.PDF417:
        _method = 'pdf417()';
        _barcode = Barcode.pdf417();
      case BarcodeType.DataMatrix:
        width = 300;
        height = width;
        _method = 'dataMatrix()';
        _barcode = Barcode.dataMatrix();
      case BarcodeType.Aztec:
        width = 300;
        height = width;
        _method = 'aztec()';
        _barcode = Barcode.aztec();
      case BarcodeType.Rm4scc:
        height = 60;
        _method = 'rm4scc()';
        _barcode = Barcode.rm4scc();
    }
  }
}
