import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CvSection extends StatelessWidget {
  const CvSection({super.key});

  final Map<String, dynamic> cvData = const {
    'name': 'John Doe',
    'title': 'Frontend Developer',
    'email': 'john@example.com',
    'phone': '+1 (555) 123-4567',
    'summary': 'Creative and innovative frontend developer with 5+ years of experience building modern web applications.',
    'experience': [
      {'company': 'Tech Corp', 'role': 'Senior Frontend Developer', 'duration': '2020 - Present'},
      {'company': 'Digital Solutions', 'role': 'Frontend Developer', 'duration': '2017 - 2020'}
    ],
    'education': [
      {'institution': 'University of Tech', 'degree': 'BS in Computer Science', 'duration': '2013 - 2017'}
    ],
    'skills': ['React', 'JavaScript', 'TypeScript', 'Tailwind CSS', 'Next.js', 'Node.js', 'GraphQL']
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My CV',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Download or view my resume below',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface.withAlpha((255 * 0.7).round()),
              ),
            ),
            const SizedBox(height: 32),
            Card(
              color: Theme.of(context).colorScheme.surface,
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CvHeader(cvData: cvData),
                  _CvSectionTitle(title: 'Professional Summary'),
                  _CvSummary(cvData: cvData),
                  _CvSectionTitle(title: 'Work Experience'),
                  _CvExperience(cvData: cvData),
                  _CvSectionTitle(title: 'Education'),
                  _CvEducation(cvData: cvData),
                  _CvSectionTitle(title: 'Skills'),
                  _CvSkills(cvData: cvData),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement Download CV functionality
                },
                icon: Icon(Icons.download, color: Theme.of(context).colorScheme.onPrimary, size: 20),
                label: Text(
                  'Download CV (PDF)',
                  style: GoogleFonts.poppins(color: Theme.of(context).colorScheme.onPrimary, fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _CvHeader extends StatelessWidget {
  final Map<String, dynamic> cvData;

  const _CvHeader({required this.cvData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cvData['name'],
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            cvData['title'],
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Theme.of(context).colorScheme.onPrimary.withAlpha((255 * 0.7).round()),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 24.0,
            runSpacing: 12.0,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.email, color: Theme.of(context).colorScheme.onPrimary.withAlpha((255 * 0.7).round()), size: 18),
                  const SizedBox(width: 10),
                  Text(
                    cvData['email'],
                    style: GoogleFonts.poppins(color: Theme.of(context).colorScheme.onPrimary.withAlpha((255 * 0.7).round()), fontSize: 15),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.phone, color: Theme.of(context).colorScheme.onPrimary.withAlpha((255 * 0.7).round()), size: 18),
                  const SizedBox(width: 10),
                  Text(
                    cvData['phone'],
                    style: GoogleFonts.poppins(color: Theme.of(context).colorScheme.onPrimary.withAlpha((255 * 0.7).round()), fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CvSummary extends StatelessWidget {
  final Map<String, dynamic> cvData;

  const _CvSummary({required this.cvData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Text(
        cvData['summary'],
        style: GoogleFonts.poppins(
          fontSize: 15,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          height: 1.6,
        ),
      ),
    );
  }
}

class _CvExperience extends StatelessWidget {
  final Map<String, dynamic> cvData;

  const _CvExperience({required this.cvData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: cvData['experience'].map<Widget>((exp) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exp['role'],
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${exp['company']} | ${exp['duration']}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _CvEducation extends StatelessWidget {
  final Map<String, dynamic> cvData;

  const _CvEducation({required this.cvData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: cvData['education'].map<Widget>((edu) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  edu['degree'],
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${edu['institution']} | ${edu['duration']}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _CvSkills extends StatelessWidget {
  final Map<String, dynamic> cvData;

  const _CvSkills({required this.cvData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: cvData['skills'].map<Widget>((skill) {
              return Chip(
                label: Text(
                  skill,
                  style: GoogleFonts.poppins(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _CvSectionTitle extends StatelessWidget {
  final String title;

  const _CvSectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
