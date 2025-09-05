// import 'dart:typed_data';

// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';

// class EmailService {
//   EmailService._();

//   // TODO: Configure these with your SMTP provider.
//   static String smtpHost = '';
//   static int smtpPort = 587; // 465 for SSL
//   static bool useSsl = false; // true if using port 465
//   static String username = '';
//   static String password = '';
//   static String fromName = 'Invoice Daily';
//   static String fromEmail = '';

//   static Future<void> sendEmail({
//     required String to,
//     required String subject,
//     required String body,
//     required Uint8List attachmentBytes,
//     required String attachmentFileName,
//   }) async {
//     if (smtpHost.isEmpty || username.isEmpty || password.isEmpty || fromEmail.isEmpty) {
//       throw Exception(
//         'Email not configured. Set SMTP host, username, password, and fromEmail in EmailService.',
//       );
//     }

//     final smtp = SmtpServer(
//       smtpHost,
//       port: smtpPort,
//       ssl: useSsl,
//       username: username,
//       password: password,
//     );

//     final message = Message()
//       ..from = Address(fromEmail, fromName)
//       ..recipients.add(to)
//       ..subject = subject
//       ..text = body
//       ..attachments = [
//         Attachment(
//           AttachmentFile(
//             attachmentFileName,
//             data: attachmentBytes,
//             contentType: 'application/pdf',
//           ),
//         ),
//       ];

//     final sendReport = await send(message, smtp);
//     if (sendReport.sent == false) {
//       throw Exception('Failed to send email');
//     }
//   }
// }
