import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class GmailService {
   static const String senderEmail = "medinajrfrouen@gmail.com";
   static const String appPassword = "egka ttul dyfb kmae";

   static Future<bool> sendEmail(String recipientEmail, String code) async {
      final smtpServer = gmail(senderEmail, appPassword);

      final message = Message()
         ..from = Address(senderEmail, 'Disaster Coordination Verification Code')
         ..recipients.add(recipientEmail)
         ..subject = 'Disaster Coordination Verification Code'
         ..html = '<h1>Your verification code is: $code</h1>';

      try {
         await send(message, smtpServer);
         print('Email sent successfully');
         return true;
      } on MailerException catch (e) {
         print('Failed to send email: ${e.message}');
         for (var problem in e.problems) {
            print('Problem: ${problem.code} - ${problem.msg}');
         }
      } catch (e) {
         print('An unexpected error occurred: $e');
      }
      return false;
   }
}