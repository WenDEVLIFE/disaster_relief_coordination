import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../helpers/SvgHelpers.dart';
import '../widgets/CustomText.dart';

class AboutView extends StatefulWidget {
  const AboutView({super.key});

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: 'About',
          fontFamily: 'GoogleSansCode-Medium',
          fontSize: 20.0,
          color: Colors.white,
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const _AppHeader(),
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const _AppInfoCard(),
                    const SizedBox(height: 16.0),
                    const _FeaturesOverview(),
                    const SizedBox(height: 16.0),
                    const _DeveloperInfo(),
                    const SizedBox(height: 16.0),
                    const _ContactInfo(),
                    const SizedBox(height: 32.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppHeader extends StatelessWidget {
  const _AppHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32.0),
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 100.0,
            height: 100.0,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.shield, size: 50.0, color: Colors.blue),
          ),
          const SizedBox(height: 16.0),
          const CustomText(
            text: 'Disaster Relief Coordination',
            fontFamily: 'GoogleSansCode-Bold',
            fontSize: 24.0,
            color: Colors.white,
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          const CustomText(
            text: 'Emergency Response & Safety Management',
            fontFamily: 'GoogleSansCode-Regular',
            fontSize: 16.0,
            color: Colors.white70,
            fontWeight: FontWeight.normal,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _AppInfoCard extends StatelessWidget {
  const _AppInfoCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: SvgPicture.asset(
                    SvgHelpers.aboutUs,
                    width: 24.0,
                    height: 24.0,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12.0),
                const CustomText(
                  text: 'App Information',
                  fontFamily: 'GoogleSansCode-Medium',
                  fontSize: 18.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            _buildInfoRow('Version', '1.0.0'),
            _buildInfoRow('Build Number', '1'),
            _buildInfoRow('Release Date', '2024'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: label,
            fontFamily: 'GoogleSansCode-Regular',
            fontSize: 14.0,
            color: Colors.black54,
            fontWeight: FontWeight.normal,
            textAlign: TextAlign.left,
          ),
          CustomText(
            text: value,
            fontFamily: 'GoogleSansCode-Medium',
            fontSize: 14.0,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}

class _FeaturesOverview extends StatelessWidget {
  const _FeaturesOverview();

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        'icon': SvgHelpers.alert,
        'title': 'Emergency Alerts',
        'description': 'Real-time disaster alerts and notifications',
      },
      {
        'icon': SvgHelpers.person,
        'title': 'Profile Management',
        'description': 'Personal information and safety status',
      },
      {
        'icon': SvgHelpers.mapin,
        'title': 'Location Services',
        'description': 'Interactive maps and location tracking',
      },
      {
        'icon': SvgHelpers.notification,
        'title': 'Notifications',
        'description': 'Instant updates and emergency broadcasts',
      },
    ];

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Icon(
                    Icons.star,
                    color: Colors.green,
                    size: 24.0,
                  ),
                ),
                const SizedBox(width: 12.0),
                const CustomText(
                  text: 'Key Features',
                  fontFamily: 'GoogleSansCode-Medium',
                  fontSize: 18.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ...features.map((feature) => _buildFeatureItem(feature)),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(Map<String, String> feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: SvgPicture.asset(
              feature['icon']!,
              width: 20.0,
              height: 20.0,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: feature['title']!,
                  fontFamily: 'GoogleSansCode-Medium',
                  fontSize: 16.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 2.0),
                CustomText(
                  text: feature['description']!,
                  fontFamily: 'GoogleSansCode-Regular',
                  fontSize: 14.0,
                  color: Colors.black54,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DeveloperInfo extends StatelessWidget {
  const _DeveloperInfo();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Icon(
                    Icons.code,
                    color: Colors.purple,
                    size: 24.0,
                  ),
                ),
                const SizedBox(width: 12.0),
                const CustomText(
                  text: 'Developer',
                  fontFamily: 'GoogleSansCode-Medium',
                  fontSize: 18.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const CustomText(
              text: 'Supernova Corp',
              fontFamily: 'GoogleSansCode-Medium',
              fontSize: 16.0,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            const CustomText(
              text: 'Building technology for a safer world',
              fontFamily: 'GoogleSansCode-Regular',
              fontSize: 14.0,
              color: Colors.black54,
              fontWeight: FontWeight.normal,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactInfo extends StatelessWidget {
  const _ContactInfo();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Icon(
                    Icons.contact_mail,
                    color: Colors.orange,
                    size: 24.0,
                  ),
                ),
                const SizedBox(width: 12.0),
                const CustomText(
                  text: 'Contact Us',
                  fontFamily: 'GoogleSansCode-Medium',
                  fontSize: 18.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            _buildContactRow('Email', 'support@supernovacorp.com'),
            _buildContactRow('Website', 'www.supernovacorp.com'),
            _buildContactRow('Support', 'Available 24/7'),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: label,
            fontFamily: 'GoogleSansCode-Regular',
            fontSize: 14.0,
            color: Colors.black54,
            fontWeight: FontWeight.normal,
            textAlign: TextAlign.left,
          ),
          CustomText(
            text: value,
            fontFamily: 'GoogleSansCode-Medium',
            fontSize: 14.0,
            color: Colors.blue,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
