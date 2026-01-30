import 'package:flutter/material.dart';
import '../widgets/app_footer.dart';

class OneClinicHomePage extends StatefulWidget {
  const OneClinicHomePage({super.key});

  @override
  State<OneClinicHomePage> createState() => _OneClinicHomePageState();
}

class _OneClinicHomePageState extends State<OneClinicHomePage> {
  int _selectedCategoryIndex = 0;
  bool _isDropdownExpanded = true;
  int _currentTabIndex = 0;

  final categories = const <_Category>[
    _Category(
      name: 'Tümü',
      icon: Icons.dashboard_outlined,
      items: [
        'Bariatrik Cerrahi',
        'Diş Hekimliği',
        'Diyabet Tedavisi',
        'Göz Cerrahisi',
        'Saç Ekimi',
        'Cilt Estetik',
        'Kardiyoloji',
        'Ortopedi',
      ],
    ),
    _Category(
      name: 'Saç Ekimi',
      icon: Icons.content_cut_outlined,
      items: [
        'Full Paket Saç Ekimi',
        'Saç Ekimi (500 Graft)',
        'Saç Ekimi (1000 Graft)',
        'Saç Transplantasyonu',
        'Saç Yoğunlaştırma',
        'Saç Tasarımı',
      ],
    ),
    _Category(
      name: 'Diş Estetik',
      icon: Icons.favorite_outline,
      items: [
        'Diş Beyazlatma',
        'Diş Hekimliği',
        'Ağız ve Diş Sağlığı',
        'Protez Diş',
        'Implant Diş',
        'Ortodonti',
        'Porselen Veneer',
      ],
    ),
    _Category(
      name: 'Cilt Estetik',
      icon: Icons.spa_outlined,
      items: [
        'Botoks Tedavisi',
        'Dolgu Işlemi',
        'Lazer Cilt Tedavisi',
        'Microdermabrasion',
        'Peeling Tedavisi',
        'Akne Tedavisi',
      ],
    ),
    _Category(
      name: 'Göz Cerrahisi',
      icon: Icons.visibility_outlined,
      items: [
        'LASIK Operasyonu',
        'Göz Cerrahisi',
        'Katarakt Operasyonu',
        'Gözlük Olmadan Görüş',
        'Miyopi Tedavisi',
        'Hipermetropi Tedavisi',
      ],
    ),
    _Category(
      name: 'Ortopedi',
      icon: Icons.directions_walk_outlined,
      items: [
        'Kemik Erimesi',
        'Eklem Ağrısı',
        'Omuz Operasyonu',
        'Diz Operasyonu',
        'Çıkık Tedavisi',
        'Protez Uygulaması',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final offers = const <_OfferItem>[
      _OfferItem(
        badge: '%20 indirim',
        title: 'Full Paket Saç Ekimi',
        location: 'Şişli, İstanbul',
      ),
      _OfferItem(
        badge: '%15 indirim',
        title: 'Saç Ekimi',
        location: 'Kadıköy, İstanbul',
      ),
      _OfferItem(
        badge: '%10 indirim',
        title: 'Diş Estetiği Paketi',
        location: 'Beşiktaş, İstanbul',
      ),
    ];

    final popularServices = const <_PopularService>[
      _PopularService(
        title: 'Lazer Göz Ameliyatı (LASIK)',
        provider: 'Dünya Göz Hastanesi',
        rating: 4.8,
        reviews: 85,
        price: '3.000€',
        imageUrl:
            'https://images.unsplash.com/photo-1580281658629-0ffb0b7d45a1?auto=format&fit=crop&w=240&q=80',
      ),
      _PopularService(
        title: 'Rinoplasti (Burun Estetiği)',
        provider: 'Estetik International',
        rating: 4.8,
        reviews: 85,
        price: '3.000€',
        imageUrl:
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=240&q=80',
      ),
      _PopularService(
        title: 'Zirkonyum Kaplama',
        provider: 'DentGroup İzmir',
        rating: 5.0,
        reviews: 210,
        price: '2.500€',
        imageUrl:
            'https://images.unsplash.com/photo-1526256262350-7da7584cf5eb?auto=format&fit=crop&w=240&q=80',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'One Clinic',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
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
                  child: const Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 6),
                      Text('İstanbul, TR'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Merhaba!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'One Clinic ile sağlıklı bir gelecek.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Tedavi, klinik veya şehir ara...',
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
            const Text(
              'One Clinic Fırsatları',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
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
            const Text(
              'Popüler Hizmetler',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
          setState(() {
            _currentTabIndex = index;
          });
        },
      ),
    );
  }
}

class _OfferItem {
  final String badge;
  final String title;
  final String location;

  const _OfferItem({
    required this.badge,
    required this.title,
    required this.location,
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

class _PopularService {
  final String title;
  final String provider;
  final double rating;
  final int reviews;
  final String price;
  final String imageUrl;

  const _PopularService({
    required this.title,
    required this.provider,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.imageUrl,
  });
}

class _OfferCard extends StatelessWidget {
  final _OfferItem item;

  const _OfferCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF16A34A),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              item.badge,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            item.title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.location,
            style: const TextStyle(color: Colors.black54, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _PopularServiceCard extends StatelessWidget {
  final _PopularService service;

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
