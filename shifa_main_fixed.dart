import 'package:flutter/material.dart';

void main() {
  runApp(const ShifaApp());
}

class ShifaApp extends StatelessWidget {
  const ShifaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'شفاء - Shifa',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'EG'),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D9488),
          primary: const Color(0xFF0D9488),
          secondary: const Color(0xFF14B8A6),
          surface: const Color(0xFFFFFFFF),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        fontFamily: 'Roboto',
      ),
      home: const ShifaHomePage(),
    );
  }
}

class Medication {
  Medication({
    required this.name,
    required this.dosage,
    required this.time,
    this.isTaken = false,
  });

  final String name;
  final String dosage;
  final String time;
  bool isTaken;
}

class ShifaHomePage extends StatefulWidget {
  const ShifaHomePage({super.key});

  @override
  State<ShifaHomePage> createState() => _ShifaHomePageState();
}

class _ShifaHomePageState extends State<ShifaHomePage> {
  int _selectedIndex = 0;

  final List<Medication> _medications = [
    Medication(
      name: 'بانادول Panadol 500mg',
      dosage: 'قرص واحد بعد الوجبة',
      time: '09:00 ص',
      isTaken: true,
    ),
    Medication(
      name: 'فيتامين د Vitamin D3',
      dosage: 'كبسولة واحدة أسبوعياً',
      time: '02:00 م',
    ),
  ];

  static const _navItems = [
    _NavData('الرئيسية', Icons.home_rounded),
    _NavData('سجلاتي', Icons.assignment_outlined),
    _NavData('مواعيدي', Icons.calendar_month_outlined),
    _NavData('حسابي', Icons.person_outline_rounded),
  ];

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, textDirection: TextDirection.rtl),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _openAssistant() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xFFCCFBF1),
                      child: Icon(Icons.auto_awesome, color: Color(0xFF0D9488)),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'المساعد الصحي الذكي',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  'هذه واجهة تجريبية للمساعد. لم يتم ربطها بخدمة ذكاء اصطناعي أو بنظام طبي.',
                  style: TextStyle(fontSize: 14, height: 1.6),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('حسنًا'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onQuickAction(String title) {
    switch (title) {
      case 'تذكير الدواء':
        _showMessage('يمكنك متابعة الأدوية من قسم «أدويتك اليوم».');
        break;
      case 'استشارة ذكية':
        _openAssistant();
        break;
      case 'الملف الطبي':
        setState(() => _selectedIndex = 1);
        break;
      case 'طوارئ':
        showDialog<void>(
          context: context,
          builder: (context) => Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: const Text('تنبيه الطوارئ'),
              content: const Text(
                'إذا كانت هناك حالة طبية طارئة، اتصل بخدمات الطوارئ المحلية فورًا. هذه الواجهة ليست خدمة طوارئ.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إغلاق'),
                ),
              ],
            ),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: _selectedIndex == 0
              ? _buildDashboard()
              : _buildPlaceholderPage(_selectedIndex),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _openAssistant,
          tooltip: 'المساعد الصحي الذكي',
          backgroundColor: const Color(0xFF0D9488),
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          child: const Icon(Icons.auto_awesome, size: 25),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildDashboard() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
          sliver: SliverToBoxAdapter(child: _buildHeader()),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          sliver: SliverToBoxAdapter(child: _buildHealthSummaryCard()),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          sliver: SliverToBoxAdapter(child: _buildQuickActions()),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          sliver: SliverToBoxAdapter(child: _buildMedicationSection()),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
          sliver: SliverToBoxAdapter(child: _buildAppointmentSection()),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFCCFBF1),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF0D9488).withOpacity(.2),
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.person_rounded,
            color: Color(0xFF0D9488),
            size: 29,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'أهلاً بك، علي 👋',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 3),
              Text(
                'كيف تشعر بصحتك اليوم؟',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'الإشعارات',
          onPressed: () => _showMessage('لا توجد إشعارات جديدة.'),
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: Color(0xFF334155),
          ),
        ),
      ],
    );
  }

  Widget _buildHealthSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D9488), Color(0xFF14B8A6)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D9488).withOpacity(.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'الملخص الصحي اليومي',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'ملخصك الصحي',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'تابع أدويتك ومواعيدك من مكان واحد',
                      style: TextStyle(
                        color: Colors.white.withOpacity(.9),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 68,
                height: 68,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: _medicationProgress,
                      strokeWidth: 6,
                      backgroundColor: Colors.white.withOpacity(.25),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    Text(
                      '${(_medicationProgress * 100).round()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.13),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Expanded(
                  child: _HealthStat(
                    icon: Icons.favorite_rounded,
                    label: 'النبض',
                    value: '72 نبضة/د',
                  ),
                ),
                _StatDivider(),
                Expanded(
                  child: _HealthStat(
                    icon: Icons.water_drop_rounded,
                    label: 'ضغط الدم',
                    value: '120/80',
                  ),
                ),
                _StatDivider(),
                Expanded(
                  child: _HealthStat(
                    icon: Icons.directions_walk_rounded,
                    label: 'الخطوات',
                    value: '6,420',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'قيم تجريبية للعرض وليست قياسات طبية فعلية',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(.85),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  double get _medicationProgress {
    if (_medications.isEmpty) return 0;
    final takenCount = _medications.where((med) => med.isTaken).length;
    return takenCount / _medications.length;
  }

  Widget _buildQuickActions() {
    const actions = [
      _ActionData(
        'الملف الطبي',
        Icons.folder_shared_outlined,
        Color(0xFF0284C7),
      ),
      _ActionData(
        'تذكير الدواء',
        Icons.medication_outlined,
        Color(0xFF0D9488),
      ),
      _ActionData(
        'استشارة ذكية',
        Icons.chat_bubble_outline_rounded,
        Color(0xFF8B5CF6),
      ),
      _ActionData(
        'طوارئ',
        Icons.emergency_outlined,
        Color(0xFFEF4444),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 12) / 2;
        return Wrap(
          spacing: 6,
          runSpacing: 8,
          children: actions.map((action) {
            return SizedBox(
              width: itemWidth,
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                child: InkWell(
                  onTap: () => _onQuickAction(action.title),
                  borderRadius: BorderRadius.circular(18),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 13,
                      horizontal: 6,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: action.color.withOpacity(.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            action.icon,
                            color: action.color,
                            size: 21,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            action.title,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildMedicationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'أدويتك اليوم',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
            TextButton(
              onPressed: () => _showMessage('أنت تشاهد قائمة الأدوية التجريبية.'),
              child: const Text('عرض الكل'),
            ),
          ],
        ),
        const SizedBox(height: 4),
        for (var i = 0; i < _medications.length; i++) ...[
          _buildMedicationCard(i),
          if (i < _medications.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _buildMedicationCard(int index) {
    final medication = _medications[index];
    final taken = medication.isTaken;
    final accent = taken
        ? const Color(0xFF0D9488)
        : const Color(0xFFF59E0B);

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.025),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accent.withOpacity(.1),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              Icons.medication_liquid_rounded,
              color: accent,
              size: 23,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medication.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${medication.dosage} • ${medication.time}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 7),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    onPressed: () {
                      setState(() => medication.isTaken = !medication.isTaken);
                    },
                    child: Text(taken ? 'إلغاء تسجيل التناول' : 'تسجيل التناول'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            decoration: BoxDecoration(
              color: taken
                  ? const Color(0xFFDCFCE7)
                  : const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              taken ? 'تم' : 'قادم',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: taken
                    ? const Color(0xFF15803D)
                    : const Color(0xFFB45309),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'المواعيد القادمة',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.025),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFCCFBF1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.medical_services_outlined,
                  color: Color(0xFF0D9488),
                  size: 27,
                ),
              ),
              const SizedBox(width: 11),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'د. أحمد محمود',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'استشاري أمراض القلب والأوعية',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    SizedBox(height: 7),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 13,
                          color: Color(0xFF0D9488),
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            'غداً، 10:30 صباحاً',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF475569),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'تفاصيل الموعد',
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (context) => Directionality(
                    textDirection: TextDirection.rtl,
                    child: AlertDialog(
                      title: const Text('تفاصيل الموعد'),
                      content: const Text(
                        'الطبيب: د. أحمد محمود\nالتخصص: أمراض القلب والأوعية\nالموعد: غداً، 10:30 صباحاً\n\nهذه بيانات تجريبية.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('إغلاق'),
                        ),
                      ],
                    ),
                  ),
                ),
                icon: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderPage(int index) {
    final item = _navItems[index];
    final descriptions = [
      '',
      'سيظهر هنا الملف الطبي والسجلات الصحية عند إضافتها.',
      'ستظهر هنا مواعيد الطبيب عند ربط التطبيق ببيانات المواعيد.',
      'ستظهر هنا إعدادات وبيانات الحساب عند تنفيذ صفحة الحساب.',
    ];

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 34,
              backgroundColor: const Color(0xFFCCFBF1),
              child: Icon(item.icon, color: const Color(0xFF0D9488), size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              item.label,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              descriptions[index],
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF64748B),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => setState(() => _selectedIndex = 0),
              icon: const Icon(Icons.home_outlined),
              label: const Text('العودة للرئيسية'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      color: Colors.white,
      elevation: 10,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (var i = 0; i < _navItems.length; i++)
              _buildNavItem(i),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final item = _navItems[index];
    final selected = index == _selectedIndex;
    final color = selected
        ? const Color(0xFF0D9488)
        : const Color(0xFF94A3B8);

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedIndex = index),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.icon, color: color, size: 22),
              const SizedBox(height: 2),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavData {
  const _NavData(this.label, this.icon);
  final String label;
  final IconData icon;
}

class _ActionData {
  const _ActionData(this.title, this.icon, this.color);
  final String title;
  final IconData icon;
  final Color color;
}

class _HealthStat extends StatelessWidget {
  const _HealthStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white, size: 16),
        const SizedBox(width: 4),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withOpacity(.8),
                  fontSize: 9,
                ),
              ),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: Colors.white24,
    );
  }
}
