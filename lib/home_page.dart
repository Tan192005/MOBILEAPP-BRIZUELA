import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 760;

    return Scaffold(
      backgroundColor: const Color(0xFFEAE1D9),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFFFFA938),
        foregroundColor: const Color(0xFF171717),
        child: const Icon(Icons.play_arrow_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        height: 76,
        decoration: const BoxDecoration(
          color: Color(0xFF171717),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(26),
            topRight: Radius.circular(26),
          ),
        ),
        child: SafeArea(
          child: Row(
            children: const [
              Expanded(
                child: _BottomNavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  active: true,
                ),
              ),
              Expanded(
                child: _BottomNavItem(
                  icon: Icons.fitness_center_rounded,
                  label: 'Workout',
                ),
              ),
              SizedBox(width: 60),
              Expanded(
                child: _BottomNavItem(
                  icon: Icons.analytics_rounded,
                  label: 'Stats',
                ),
              ),
              Expanded(
                child: _BottomNavItem(
                  icon: Icons.person_rounded,
                  label: 'Profile',
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _HeroSection(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      _SectionTitle(
                        title: 'Popular classes',
                        action: 'View all',
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        height: 258,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: const [
                            _ClassCard(
                              title: 'Strength Lab',
                              subtitle: 'Hiit & power training',
                              duration: '45 min',
                              level: 'Beginner',
                              image:
                                  'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=900&q=80',
                            ),
                            _ClassCard(
                              title: 'Cardio Burn',
                              subtitle: 'Conditioning & endurance',
                              duration: '35 min',
                              level: 'Intermediate',
                              image:
                                  'https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?auto=format&fit=crop&w=900&q=80',
                            ),
                            _ClassCard(
                              title: 'Core Flow',
                              subtitle: 'Mobility & balance',
                              duration: '30 min',
                              level: 'All levels',
                              image:
                                  'https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&w=900&q=80',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      _SectionTitle(
                        title: 'Why choose us',
                        action: 'Learn more',
                      ),
                      const SizedBox(height: 16),
                      if (isMobile)
                        const Column(
                          children: [
                            _FeatureTile(
                              title: 'Expert coaches',
                              subtitle:
                                  'Certified trainers creating focused, motivating programs.',
                              icon: Icons.sports_gymnastics_rounded,
                            ),
                            SizedBox(height: 16),
                            _FeatureTile(
                              title: 'Flexible plans',
                              subtitle:
                                  'Choose from a plan that fits your schedule, goals, and budget.',
                              icon: Icons.calendar_month_rounded,
                            ),
                            SizedBox(height: 16),
                            _FeatureTile(
                              title: 'Results-first approach',
                              subtitle:
                                  'Track performance, nutrition, and progress with a personalized plan.',
                              icon: Icons.trending_up_rounded,
                              fullWidth: true,
                            ),
                          ],
                        )
                      else
                        const Row(
                          children: [
                            Expanded(
                              child: _FeatureTile(
                                title: 'Expert coaches',
                                subtitle:
                                    'Certified trainers creating focused, motivating programs.',
                                icon: Icons.sports_gymnastics_rounded,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _FeatureTile(
                                title: 'Flexible plans',
                                subtitle:
                                    'Choose from a plan that fits your schedule, goals, and budget.',
                                icon: Icons.calendar_month_rounded,
                              ),
                            ),
                          ],
                        ),
                      if (isMobile) const SizedBox(height: 16),
                      if (!isMobile) const SizedBox(height: 16),
                      if (!isMobile)
                        const _FeatureTile(
                          title: 'Results-first approach',
                          subtitle:
                              'Track performance, nutrition, and progress with a personalized plan.',
                          icon: Icons.trending_up_rounded,
                          fullWidth: true,
                        ),
                      const SizedBox(height: 30),
                      _SectionTitle(
                        title: 'Meet our coaches',
                        action: 'View all',
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        height: 260,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: const [
                            _CoachCard(
                              name: 'Maya Ross',
                              role: 'Strength coach',
                              image:
                                  'https://images.unsplash.com/photo-1556157382-97eda2d62296?auto=format&fit=crop&w=900&q=80',
                            ),
                            _CoachCard(
                              name: 'Alex Stone',
                              role: 'Performance trainer',
                              image:
                                  'https://images.unsplash.com/photo-1521119989659-a83eee488004?auto=format&fit=crop&w=900&q=80',
                            ),
                            _CoachCard(
                              name: 'Nina Cole',
                              role: 'Mobility specialist',
                              image:
                                  'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?auto=format&fit=crop&w=900&q=80',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      _SectionTitle(
                        title: 'Success stories',
                        action: 'Read more',
                      ),
                      const SizedBox(height: 16),
                      _StoryCard(
                        name: 'Sarah T.',
                        result: 'Lost 18 kg in 5 months',
                        image:
                            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=900&q=80',
                        description:
                            'The coaching plan helped me build stronger habits and stay consistent without sacrificing my lifestyle.',
                      ),
                      const SizedBox(height: 30),
                      _SectionTitle(
                        title: 'Simple pricing',
                        action: 'Compare plans',
                      ),
                      const SizedBox(height: 18),
                      if (isMobile)
                        const Column(
                          children: [
                            _PriceCard(
                              name: 'Essential',
                              price: '€29',
                              period: '/month',
                              features: [
                                'Gym floor access',
                                '2 classes per week',
                                'Coach support',
                              ],
                              highlighted: false,
                            ),
                            SizedBox(height: 14),
                            _PriceCard(
                              name: 'Pro',
                              price: '€59',
                              period: '/month',
                              features: [
                                'Unlimited classes',
                                'Nutrition guide',
                                'Progress tracking',
                              ],
                              highlighted: true,
                            ),
                          ],
                        )
                      else
                        const Row(
                          children: [
                            Expanded(
                              child: _PriceCard(
                                name: 'Essential',
                                price: '€29',
                                period: '/month',
                                features: [
                                  'Gym floor access',
                                  '2 classes per week',
                                  'Coach support',
                                ],
                                highlighted: false,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _PriceCard(
                                name: 'Pro',
                                price: '€59',
                                period: '/month',
                                features: [
                                  'Unlimited classes',
                                  'Nutrition guide',
                                  'Progress tracking',
                                ],
                                highlighted: true,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 24),
                      _MembershipBanner(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 760;

    return Container(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 20 : 32,
        20,
        isMobile ? 20 : 32,
        30,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF171717), Color(0xFF262626)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            if (!isMobile)
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'FITMAKER',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  _NavLink('Home'),
                  const SizedBox(width: 18),
                  _NavLink('Programs'),
                  const SizedBox(width: 18),
                  _NavLink('Trainers'),
                  const SizedBox(width: 18),
                  _NavLink('Pricing'),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFA938),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'Join now',
                      style: TextStyle(
                        color: Color(0xFF171717),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              )
            else
              Row(
                children: [
                  const Text(
                    'FITMAKER',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFA938),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'Join now',
                      style: TextStyle(
                        color: Color(0xFF171717),
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            SizedBox(height: isMobile ? 30 : 34),
            if (isMobile)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Build your best body',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      height: 0.96,
                      letterSpacing: -1.6,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Train with expert coaches, follow proven routines, and create a stronger, healthier lifestyle every single day.',
                    style: TextStyle(
                      color: Color(0xFFDDD6CF),
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFA938),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'Get started',
                          style: TextStyle(
                            color: Color(0xFF171717),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white24),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'View plans',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: const [
                      _MetricChip(value: '12k+', label: 'members'),
                      _MetricChip(value: '4.9/5', label: 'rating'),
                      _MetricChip(value: '24/7', label: 'support'),
                    ],
                  ),
                  const SizedBox(height: 26),
                  Container(
                    height: 260,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x30000000),
                          blurRadius: 20,
                          offset: Offset(0, 14),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(26),
                      child: Stack(
                        children: [
                          Image.network(
                            'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=900&q=80',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          Positioned(
                            left: 14,
                            right: 14,
                            bottom: 14,
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xCC121212),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: const Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Boost performance',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 17,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Personalized routines built for real results.',
                                          style: TextStyle(
                                            color: Color(0xFFCBC3BB),
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Color(0xFFFFA938),
                                    child: Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Color(0xFF171717),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Build your best body',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 58,
                            fontWeight: FontWeight.w900,
                            height: 0.95,
                            letterSpacing: -2,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Train with expert coaches, follow proven routines, and create a stronger, healthier lifestyle every single day.',
                          style: TextStyle(
                            color: Color(0xFFDDD6CF),
                            fontSize: 18,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 26),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFA938),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: const Text(
                                'Get started',
                                style: TextStyle(
                                  color: Color(0xFF171717),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white24),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: const Text(
                                'View plans',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 18,
                          runSpacing: 12,
                          children: const [
                            _MetricChip(value: '12k+', label: 'happy members'),
                            _MetricChip(value: '4.9/5', label: 'member rating'),
                            _MetricChip(value: '24/7', label: 'support'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 28),
                  Expanded(
                    child: Container(
                      height: 560,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x30000000),
                            blurRadius: 22,
                            offset: Offset(0, 18),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Stack(
                          children: [
                            Image.network(
                              'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=900&q=80',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                            Positioned(
                              left: 18,
                              right: 18,
                              bottom: 18,
                              child: Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: const Color(0xCC121212),
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: const Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Boost performance',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Personalized routines built for real results.',
                                            style: TextStyle(
                                              color: Color(0xFFCBC3BB),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundColor: Color(0xFFFFA938),
                                      child: Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Color(0xFF171717),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.action});

  final String title;
  final String action;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.of(context).size.width <= 390;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: const Color(0xFF171717),
            fontSize: compact ? 22 : 30,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          action,
          style: TextStyle(
            color: const Color(0xFFFFA938),
            fontWeight: FontWeight.w700,
            fontSize: compact ? 12 : 14,
          ),
        ),
      ],
    );
  }
}

class _ClassCard extends StatelessWidget {
  const _ClassCard({
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.level,
    required this.image,
  });

  final String title;
  final String subtitle;
  final String duration;
  final String level;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              image,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF171717),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1D6),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  duration,
                  style: const TextStyle(
                    color: Color(0xFF5B3C00),
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(color: Color(0xFF665D57), fontSize: 13),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                level,
                style: const TextStyle(
                  color: Color(0xFF171717),
                  fontWeight: FontWeight.w700,
                ),
              ),
              Icon(Icons.arrow_forward_rounded, color: const Color(0xFF171717)),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.fullWidth = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1D6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF171717)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF171717),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(color: Color(0xFF665D57), height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  const _StoryCard({
    required this.name,
    required this.result,
    required this.image,
    required this.description,
  });

  final String name;
  final String result;
  final String image;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              image,
              width: 108,
              height: 108,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFF171717),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  result,
                  style: const TextStyle(
                    color: Color(0xFFB76800),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(color: Color(0xFF665D57), height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CoachCard extends StatelessWidget {
  const _CoachCard({
    required this.name,
    required this.role,
    required this.image,
  });

  final String name;
  final String role;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 18),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              image,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              color: Color(0xFF171717),
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            role,
            style: const TextStyle(
              color: Color(0xFF665D57),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceCard extends StatelessWidget {
  const _PriceCard({
    required this.name,
    required this.price,
    required this.period,
    required this.features,
    required this.highlighted,
  });

  final String name;
  final String price;
  final String period;
  final List<String> features;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: highlighted ? const Color(0xFF171717) : Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: highlighted ? Colors.white : const Color(0xFF171717),
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (highlighted)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFA938),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'Popular',
                    style: TextStyle(
                      color: Color(0xFF171717),
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: TextStyle(
                  color: highlighted ? Colors.white : const Color(0xFF171717),
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  period,
                  style: TextStyle(
                    color: highlighted
                        ? const Color(0xFFCCC2BA)
                        : const Color(0xFF665D57),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 18,
                    color: highlighted
                        ? const Color(0xFFFFA938)
                        : const Color(0xFF171717),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      feature,
                      style: TextStyle(
                        color: highlighted
                            ? Colors.white
                            : const Color(0xFF171717),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: highlighted
                  ? const Color(0xFFFFA938)
                  : const Color(0xFFFFF1D6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Choose plan',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: highlighted
                    ? const Color(0xFF171717)
                    : const Color(0xFF171717),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MembershipBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.of(context).size.width <= 390;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Ready to start?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Join a premium gym membership and unlock nutrition planning, coach support, and performance tracking.',
          style: TextStyle(color: Color(0xFFDFCDBE), height: 1.6),
        ),
      ],
    );

    final cta = Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFA938),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Text(
        'Join now',
        style: TextStyle(color: Color(0xFF171717), fontWeight: FontWeight.w800),
      ),
    );

    return Container(
      padding: EdgeInsets.all(compact ? 18 : 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF171717), Color(0xFF2C2927)],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [content, const SizedBox(height: 18), cta],
            )
          : Row(
              children: [
                Expanded(child: content),
                const SizedBox(width: 20),
                cta,
              ],
            ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Color(0xFFCEC3BC), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.label,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: active ? const Color(0xFFFFA938) : const Color(0xFFB9B0A8),
          size: 22,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: active ? const Color(0xFFFFA938) : const Color(0xFFB9B0A8),
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFFCCC2BA),
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
