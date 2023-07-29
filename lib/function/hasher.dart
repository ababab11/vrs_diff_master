import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';

class Hasher {
  static String hashStringTo128Bit(String input) {
    var bytes = utf8.encode(input); // 文字列をUTF-8エンコード
    var digest = sha256.convert(bytes); // SHA-256ハッシュ計算

    // ハッシュ値を128ビットとして扱い、16バイトに切り詰める
    var truncatedDigest = digest.bytes.sublist(0, 16);

    // 16バイトのバイナリデータを16進数文字列に変換して返す
    var hashString = hex.encode(truncatedDigest);

    return hashString;
  }
}
