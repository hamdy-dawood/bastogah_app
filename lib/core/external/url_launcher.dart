import 'package:url_launcher/url_launcher.dart';

class UrlLaunchers {
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  Future<void> emailLauncher({required String email, String? subject}) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters(<String, String>{
        'subject': subject ?? 'Example Subject & Symbols are allowed!',
      }),
    );

    launchUrl(emailLaunchUri);
  }

  Future<void> smsLauncher({required String phoneNumber, required String smsBody}) async {
    final Uri smsLaunchUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: <String, String>{'body': Uri.encodeComponent(smsBody)},
    );

    launchUrl(smsLaunchUri);
  }

  Future<void> phoneCallLauncher({required String phoneNumber}) async {
    final Uri phoneLauncherUrl = Uri(scheme: 'tel', path: phoneNumber);

    launchUrl(phoneLauncherUrl);
  }

  Future<void> browserLauncher({required String url}) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      // can't launch url, there is some error
      await launchUrl(Uri.parse('https://$url'), mode: LaunchMode.externalApplication);
      // throw "Could not launch $url";
    }
  }
}
