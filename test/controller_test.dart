import 'package:ikiadim/controller/controller.dart';
import 'package:otp/otp.dart';
import 'package:test/test.dart';

void main() {
  final controller = Controller();
  group("Base32 Validation", () {
    test("is key valid?", () {
      expect(controller.isBase32("ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"), true);
    });
    test("is key valid with lowercase?", () {
      expect(controller.isBase32("abcd===="), true);
    });
    test("is key NOT valid", () {
      expect(controller.isBase32("ÇÖÜĞ0189!="), false);
    });
    test("is a Hacker can hack?", () {
      expect(controller.isBase32("ABCDEFGHI=KLMNOPQRSTUVWXYZ23456!"), false);
    });
    test("is OTP Random Secret Generator valid", () {
      expect(controller.isBase32(OTP.randomSecret()), true);
    });
  });

  group("Algorithm Check", () {
    test("Default algorithym is SHA1", () {
      expect(controller.toAlgorithm("sdf"), Algorithm.SHA1);
    });
    test("SHA1 algorithym is SHA1", () {
      expect(controller.toAlgorithm("SHA1"), Algorithm.SHA1);
    });
    test("SHA256 algorithym is SHA256", () {
      expect(controller.toAlgorithm("SHA256"), Algorithm.SHA256);
    });
    test("SHA512 algorithym is SHA512", () {
      expect(controller.toAlgorithm("SHA512"), Algorithm.SHA512);
    });
  });

  group("Counter Test", () {
    test("is counter value double", () {
      expect(controller.counterValue().runtimeType, double);
    });
    test("is counter great than zero", () {
      expect(controller.counterValue(), greaterThanOrEqualTo(0));
    });
    test("is counter less than 1", () {
      expect(controller.counterValue(), lessThanOrEqualTo(1));
    });
  }, retry: 60);
}
