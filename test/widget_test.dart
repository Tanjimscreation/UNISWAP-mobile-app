import 'package:flutter_test/flutter_test.dart';
import 'package:uniswap_flutter/providers/auth_provider.dart';

void main() {
  test('UTM email regex accepts utm.my and graduate.utm.my only', () {
    expect(AuthProvider.isUTMEmail('siti@utm.my'), isTrue);
    expect(AuthProvider.isUTMEmail('siti@graduate.utm.my'), isTrue);
    expect(AuthProvider.isUTMEmail('SITI@UTM.MY'), isTrue);
    expect(AuthProvider.isUTMEmail('siti@gmail.com'), isFalse);
    expect(AuthProvider.isUTMEmail('siti@student.utm.my'), isFalse);
  });
}
