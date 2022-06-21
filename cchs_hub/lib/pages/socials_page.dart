import 'package:flutter/material.dart';
import 'package:cchs_hub/helper_scripts/web_view_container.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialPage extends StatelessWidget {
  // Web Container Variables
  final links = [
    'https://www.instagram.com/cchs165/?hl=en',
    'https://mobile.twitter.com/cchs165',
    'https://www.cchs165.jacksn.k12.il.us/'
  ];
  final icons = [
    FontAwesomeIcons.instagram,
    FontAwesomeIcons.twitter,
    FontAwesomeIcons.school
  ];
  final colors = [Colors.white, Colors.blue, Colors.white];
  final text = ['View the Instagram', 'View the Twitter', 'View the website'];

  SocialPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _topSection(),
              webViewButton(context, 0),
              webViewButton(context, 1),
              webViewButton(context, 2)
            ],
          ),
        ),
      ),
    );
  }

// WEBVIEW BUTTON
  Widget webViewButton(BuildContext context, int index) {
    // Varying Variables
    dynamic faIcon;
    // If Not Instagram
    if (index != 0) {
      faIcon = FaIcon(
        icons[index],
        color: colors[index],
      );
    } else {
      faIcon = const GradientIcon(
        FontAwesomeIcons.instagram,
        30.0,
        LinearGradient(
          colors: <Color>[
            Color(0xffF58529),
            Color(0xffDD2A7B),
            Color(0xff8134AF),
            Color(0xff515BD4),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      );
    }

    return Column(
      children: [
        Card(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: const Color(0xff121212),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            leading: faIcon,
            trailing:
                const Icon(Icons.arrow_forward_rounded, color: Colors.white),
            title: Text.rich(
              TextSpan(
                style: const TextStyle(
                  color: Colors.white,
                ),
                children: [
                  TextSpan(
                    text: text[index],
                  ),
                ],
              ),
            ),
            // Bring the user to the desired link
            onTap: () => _handleURLButtonPress(context, links[index], index),
          ),
        ),
        Divider(
          color: Colors.grey.shade700,
        ),
      ],
    );
  }

  //onPressed: () => _handleURLButtonPress(context, url),
  void _handleURLButtonPress(BuildContext context, String url, int index) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url, index)));
  }
}

// This is for mapping gradients to icons
// this is only used on the instagram icon for now
class GradientIcon extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const GradientIcon(
    this.icon,
    this.size,
    this.gradient,
  );

  final IconData icon;
  final double size;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: SizedBox(
        width: size * 1.2,
        height: size * 1.2,
        child: FaIcon(
          icon,
          size: size,
          color: Colors.white,
        ),
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, size, size);
        return gradient.createShader(rect);
      },
    );
  }
}

// TOP SECTION
// this has the title of the page
_topSection() {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFF222222),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 10),
      ],
    ),
    child: Row(
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 10.0,
          ),
          child: Text(
            "CCHS Socials",
            style: TextStyle(fontSize: 23),
          ),
        ),
      ],
    ),
  );
}
