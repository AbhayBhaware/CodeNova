import 'package:flutter/material.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/widgets.dart';

/// Business / IT services offered by CodeNova Tech Solutions.
class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  static const List<_ServiceItem> _services = [
    _ServiceItem(
      icon: Icons.web_rounded,
      title: 'Web Development',
      description:
          'Custom website and web application development for businesses '
          'of all sizes using modern frameworks.',
      tags: ['React', 'Node.js', 'PHP', 'WordPress'],
    ),
    _ServiceItem(
      icon: Icons.phone_android_rounded,
      title: 'Mobile App Development',
      description:
          'Cross-platform and native mobile application development for '
          'Android and iOS platforms.',
      tags: ['Flutter', 'Dart', 'Firebase'],
    ),
    _ServiceItem(
      icon: Icons.bar_chart_rounded,
      title: 'Data Analytics',
      description:
          'Data collection, processing, visualisation, and business '
          'intelligence solutions tailored to your needs.',
      tags: ['Python', 'Power BI', 'SQL', 'Excel'],
    ),
    _ServiceItem(
      icon: Icons.psychology_rounded,
      title: 'AI / ML Solutions',
      description:
          'Machine learning model development and AI integrations to '
          'automate processes and gain competitive insights.',
      tags: ['ML', 'NLP', 'TensorFlow', 'Python'],
    ),
    _ServiceItem(
      icon: Icons.workspace_premium_rounded,
      title: 'IT Training & Workshops',
      description:
          'Corporate training programmes and tech workshops customised '
          'to your team\'s skill requirements.',
      tags: ['Training', 'Workshops', 'Certification'],
    ),
    _ServiceItem(
      icon: Icons.manage_search_rounded,
      title: 'IT Recruitment & Staffing',
      description:
          'Talent acquisition and IT staffing services connecting '
          'companies with skilled developers and engineers.',
      tags: ['Recruitment', 'Staffing', 'Talent'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.navServices)),
      body: ListView(
        padding: AppDimensions.screenPadding,
        children: [
          const SizedBox(height: AppDimensions.spaceMD),
          const SectionHeader(
            title: 'Our Services',
            subtitle:
                'We partner with businesses to deliver technology-driven solutions.',
          ),
          const SizedBox(height: AppDimensions.spaceXL),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppDimensions.spaceMD,
              mainAxisSpacing: AppDimensions.spaceMD,
              childAspectRatio: 0.82,
            ),
            itemCount: _services.length,
            itemBuilder: (context, index) {
              return _ServiceCard(item: _services[index]);
            },
          ),
          const SizedBox(height: AppDimensions.spaceXL),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.item});

  final _ServiceItem item;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return AppCard.glass(
      padding: const EdgeInsets.all(AppDimensions.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: AppColors.brandGradient,
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusMD),
            ),
            child: Icon(
              item.icon,
              color: Colors.white,
              size: AppDimensions.iconMD,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceSM),
          Text(
            item.title,
            style: tt.titleMedium?.copyWith(fontSize: AppTextSizes.body),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppDimensions.spaceXS),
          Expanded(
            child: Text(
              item.description,
              style: tt.bodySmall,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceSM),
          Wrap(
            spacing: AppDimensions.spaceXS,
            runSpacing: AppDimensions.spaceXS,
            children: item.tags
                .take(2)
                .map((t) => AppBadge(label: t, color: AppColors.accent))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _ServiceItem {
  const _ServiceItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.tags,
  });

  final IconData icon;
  final String title;
  final String description;
  final List<String> tags;
}
