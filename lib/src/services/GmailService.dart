import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
class GmailService {
   String emails ="medinajrfrouen@gmail.com";
   String appPassword ="egka ttul dyfb kmae";


   Future<void> sendEmail(String email, String code) async{
      final smtpServer = gmail(email, appPassword);

      final message = Message()
         ..from = Address(emails, 'Disaster Coordination Verification Code')
         ..recipients.add(email)
         ..subject = 'Disaster Coordination Verification Code'
         ..html = '<h1>Your verification code is: $code</h1>';

      try {
         final sendReport = await send(message, smtpServer);
         print('Email sent successfully: $sendReport');
      } on MailerException catch (e) {
         print('Failed to send email: ${e.message}');
         for (var problem in e.problems) {
            print('Problem: ${problem.code} - ${problem.msg}');
         }
      } catch (e) {
         print('An unexpected error occurred: $e');
      }
   }
}