import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Bilgilendirme"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              SizedBox(height: 32),
              Text(
                "İki Adım tarafından oluşturulan tek seferlik şifreler, iki faktörlü kimlik doğrulama için kullanılır. Geleneksel olarak, bir web sitesi oturum açma sayfası, bildiğiniz bir şeyi, yani şifrenizi kullanarak kimliğinizi doğrulamanızı ister.",
              ),
              SizedBox(height: 16),
              Text(
                "İki faktörlü kimlik doğrulama, sahip olduğunuz bir şeyi (Telefonunuzu veya tek seferlik parolalar oluşturmak için kullandığınız herhangi bir cihazı) kullanarak kimliğinizi doğrulamanızı isteyerek güvenliği artırır.",
              ),
              SizedBox(height: 16),
              Text(
                "İki faktörlü kimlik doğrulamayı ayarladığınızda, bir web sitesi size İki Adım'ın iOS anahtar zincirinde, Android anahtar deposunda güvenli bir şekilde sakladığı bir sır sağlar. Oturum açmak için İki Adım'ı kullandığınızda, benzersiz bir parola oluşturmak için bu sırrı ve geçerli saati kullanır. Bu zamana dayalı şifre, giriş yapmaya çalışan kişinin şu anda sırrı içeren fiziksel cihaza sahip olduğunu web sitesine kanıtlar.",
              ),
              SizedBox(height: 16),
              Text(
                "Sırları diğer cihazlarla senkronize etmek, sahip olma faktörünü geçersiz kılar ve bir saldırganın telefonunuza fiziksel erişimi olmadan sırlarınızı çalma olasılığını ortaya çıkarır. Aynısı bulut tabanlı yedeklemeler için de geçerlidir. Güvenliği sağlamak için sırları fiziksel bir aygıtla sınırlı tutma, anahtar zincirine veya deposuna kaydedilen diğer parolalarla aynı yedekleme kurallarını izler - yalnızca bu yedekleme şifrelenmişse bir yedeklemeye dahil edilirler.",
              ),
              SizedBox(height: 16),
              Text(
                "Sırlarınızın yedeklendiğinden emin olmak için lütfen iTunes'u veya Google One'ı kullanarak telefonunuzun şifreli bir yedeğini alın. Ayrıca, iki faktörlü kimlik doğrulamayı kurduğunuzda her web sitesinin size verdiği kurtarma kodlarını mutlaka bir yere not edin ve bunları güvenli bir yerde saklayın.",
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      );
}
