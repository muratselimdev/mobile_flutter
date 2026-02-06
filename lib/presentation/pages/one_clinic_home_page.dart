import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../widgets/app_footer.dart';
import '../../data/models/popular_service.dart';
import '../../data/services/popular_service_api.dart';
import '../../data/models/campaign.dart';
import '../../data/services/campaign_api.dart';
import 'one_clinic_profile_page.dart';

class OneClinicHomePage extends StatefulWidget {
  const OneClinicHomePage({super.key});

  @override
  State<OneClinicHomePage> createState() => _OneClinicHomePageState();
}

class _OneClinicHomePageState extends State<OneClinicHomePage> {
  int _selectedCategoryIndex = 0;
  bool _isDropdownExpanded = true;
  int _currentTabIndex = 0;
  final PopularServiceApi _popularServiceApi = PopularServiceApi();
  final CampaignApi _campaignApi = CampaignApi();
  final List<PopularService> _popularPool = [];
  final List<PopularService> _visiblePopularServices = [];
  final List<_OfferItem> _offers = [];
  Timer? _popularRefreshTimer;
  Timer? _popularShuffleTimer;
  Timer? _campaignRefreshTimer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _fetchCampaigns();
    _fetchPopularServices();
    _popularRefreshTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _fetchPopularServices(),
    );
    _campaignRefreshTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _fetchCampaigns(),
    );
    _popularShuffleTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _shufflePopularServices(),
    );
  }

  @override
  void dispose() {
    _popularRefreshTimer?.cancel();
    _popularShuffleTimer?.cancel();
    _campaignRefreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;

    final categories = <_Category>[
      _Category(
        name: loc.t('categories.names.all'),
        icon: Icons.dashboard_outlined,
        items: loc.list('categories.items.all'),
      ),
      _Category(
        name: loc.t('categories.names.hairTransplant'),
        icon: Icons.content_cut_outlined,
        items: loc.list('categories.items.hairTransplant'),
      ),
      _Category(
        name: loc.t('categories.names.dentalAesthetic'),
        icon: Icons.favorite_outline,
        items: loc.list('categories.items.dentalAesthetic'),
      ),
      _Category(
        name: loc.t('categories.names.skinAesthetic'),
        icon: Icons.spa_outlined,
        items: loc.list('categories.items.skinAesthetic'),
      ),
      _Category(
        name: loc.t('categories.names.eyeSurgery'),
        icon: Icons.visibility_outlined,
        items: loc.list('categories.items.eyeSurgery'),
      ),
      _Category(
        name: loc.t('categories.names.orthopedics'),
        icon: Icons.directions_walk_outlined,
        items: loc.list('categories.items.orthopedics'),
      ),
    ];

    final offers = _offers.isNotEmpty ? _offers : _buildLocalOffers(loc);

    final localPopularServices = _buildLocalPopularServices(loc);
    final popularServices = _visiblePopularServices.isNotEmpty
        ? _visiblePopularServices
        : localPopularServices.take(3).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          loc.t('app.name'),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: Colors.black54),
          ),
          const SizedBox(width: 8),
          const CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xFF16A34A),
            child: Icon(Icons.person, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.black54,
                      ),
                      const SizedBox(width: 6),
                      Text(loc.t('home.location')),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              loc.t('home.greeting'),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              loc.t('home.tagline'),
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: loc.t('home.searchHint'),
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: Container(
                  margin: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFF16A34A),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.tune, color: Colors.white, size: 18),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Category buttons with dropdown
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isActive = _selectedCategoryIndex == index;
                  return GestureDetector(
                    onTap: () {
                      if (index == 0) {
                        // Toggle dropdown when clicking first button
                        setState(() {
                          _isDropdownExpanded = !_isDropdownExpanded;
                        });
                      } else {
                        setState(() {
                          _selectedCategoryIndex = index;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: index == 0
                            ? const Color(0xFF16A34A)
                            : (isActive
                                  ? const Color(0xFF16A34A)
                                  : Colors.white),
                        borderRadius: BorderRadius.circular(24),
                        border: isActive || index == 0
                            ? null
                            : Border.all(color: Colors.black12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            category.icon,
                            size: 18,
                            color: (index == 0 || isActive)
                                ? Colors.white
                                : Colors.black54,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            category.name,
                            style: TextStyle(
                              color: (index == 0 || isActive)
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          if (index == 0) ...[
                            const SizedBox(width: 8),
                            AnimatedRotation(
                              turns: _isDropdownExpanded ? 0.5 : 0,
                              duration: const Duration(milliseconds: 300),
                              child: const Icon(
                                Icons.expand_less,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            // Category items list - toggle with dropdown
            if (_isDropdownExpanded) ...[
              Text(
                categories[_selectedCategoryIndex].name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Column(
                children: categories[_selectedCategoryIndex].items.map((item) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black.withValues(alpha: 0.05),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.grey[400],
                          size: 20,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],
            Text(
              loc.t('home.offersTitle'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: offers.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final item = offers[index];
                  return _OfferCard(item: item);
                },
              ),
            ),
            const SizedBox(height: 24),
            Text(
              loc.t('home.popularTitle'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Column(
              children: popularServices
                  .map((service) => _PopularServiceCard(service: service))
                  .toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppFooter(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          if (index == 3) {
            // Navigate to Profile page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OneClinicProfilePage(),
              ),
            );
          } else {
            setState(() {
              _currentTabIndex = index;
            });
          }
        },
      ),
    );
  }

  List<PopularService> _buildLocalPopularServices(AppLocalizations loc) {
    return loc
        .mapList('popularServices.items')
        .map((item) {
          return PopularService(
            title: item['title']?.toString() ?? '',
            provider: item['provider']?.toString() ?? '',
            rating: 4.8,
            reviews: 85,
            price: item['price']?.toString() ?? '',
            imageUrl:
                item['imageUrl']?.toString() ??
                'https://images.unsplash.com/photo-1526256262350-7da7584cf5eb?auto=format&fit=crop&w=240&q=80',
          );
        })
        .where((service) => service.title.isNotEmpty)
        .toList();
  }

  List<_OfferItem> _buildLocalOffers(AppLocalizations loc) {
    return loc
        .mapList('offers.items')
        .map((item) {
          return _OfferItem(
            description: item['title']?.toString() ?? '',
            title: item['location']?.toString() ?? '',
            discountRate: _parseDiscountRate(item['badge']),
            imageUrl: item['imageUrl']?.toString() ?? '',
          );
        })
        .where((item) => item.description.trim().isNotEmpty)
        .toList();
  }

  int _parseDiscountRate(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    final text = value.toString().replaceAll('%', '').trim();
    return int.tryParse(text) ?? 0;
  }

  Future<void> _fetchCampaigns() async {
    if (!mounted) return;
    final fallback = _buildLocalOffers(context.loc);
    try {
      final remote = await _campaignApi.fetchCampaigns();
      final mapped = remote.map(_mapCampaignToOffer).toList();
      if (!mounted) return;
      _setOffers(mapped.isNotEmpty ? mapped : fallback);
    } catch (_) {
      if (!mounted) return;
      _setOffers(fallback);
    }
  }

  _OfferItem _mapCampaignToOffer(Campaign campaign) {
    return _OfferItem(
      description: campaign.description,
      title: campaign.title,
      discountRate: campaign.discountRate,
      imageUrl: campaign.imageUrl,
    );
  }

  void _setOffers(List<_OfferItem> offers) {
    setState(() {
      _offers
        ..clear()
        ..addAll(offers);
    });
  }

  Future<void> _fetchPopularServices() async {
    if (!mounted) return;
    final localFallback = _buildLocalPopularServices(context.loc);
    try {
      final remote = await _popularServiceApi.fetchPopularServices();
      final pool = remote.isNotEmpty ? remote : localFallback;
      if (!mounted) return;
      _setPopularPool(pool);
    } catch (_) {
      if (!mounted) return;
      _setPopularPool(localFallback);
    }
  }

  void _setPopularPool(List<PopularService> pool) {
    setState(() {
      _popularPool
        ..clear()
        ..addAll(pool.where((item) => item.title.trim().isNotEmpty));
      _visiblePopularServices
        ..clear()
        ..addAll(_pickRandomPopular(_popularPool));
    });
  }

  void _shufflePopularServices() {
    if (!mounted || _popularPool.isEmpty) return;
    setState(() {
      _visiblePopularServices
        ..clear()
        ..addAll(_pickRandomPopular(_popularPool));
    });
  }

  List<PopularService> _pickRandomPopular(List<PopularService> pool) {
    if (pool.isEmpty) return const <PopularService>[];
    final shuffled = List<PopularService>.from(pool)..shuffle(_random);
    final count = shuffled.length < 3 ? shuffled.length : 3;
    return shuffled.take(count).toList();
  }
}

class _OfferItem {
  final String description;
  final String title;
  final int discountRate;
  final String imageUrl;

  const _OfferItem({
    required this.description,
    required this.title,
    required this.discountRate,
    required this.imageUrl,
  });
}

class _Category {
  final String name;
  final IconData icon;
  final List<String> items;

  const _Category({
    required this.name,
    required this.icon,
    required this.items,
  });
}

class _OfferCard extends StatelessWidget {
  final _OfferItem item;

  const _OfferCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final imageUrl = item.imageUrl.isNotEmpty
        ? item.imageUrl
        : 'https://images.unsplash.com/photo-1511174511562-5f7f18b874f8?auto=format&fit=crop&w=800&q=80';
    return Container(
      width: 280,
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.05),
                      Colors.black.withValues(alpha: 0.6),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF16A34A),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  item.discountRate > 0
                      ? '%${item.discountRate} indirim'
                      : 'İndirim',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PopularServiceCard extends StatelessWidget {
  final PopularService service;

  const _PopularServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              service.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        service.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.favorite_border,
                      size: 18,
                      color: Colors.black38,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.verified,
                      size: 14,
                      color: Color(0xFF16A34A),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        service.provider,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Color(0xFFF59E0B)),
                    const SizedBox(width: 4),
                    Text(
                      '${service.rating}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${service.reviews})',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      service.price,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
