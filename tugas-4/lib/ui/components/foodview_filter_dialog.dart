import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Model nilai filter sesuai `Components.svg`
class FoodViewFilterSelection {
  final String? distance;
  final String? price;
  final String? hours;

  const FoodViewFilterSelection({
    this.distance,
    this.price,
    this.hours,
  });

  bool get isEmpty => distance == null && price == null && hours == null;

  String get summaryLabel {
    final parts = <String>[
      if (distance != null) distance!,
      if (price != null) price!,
      if (hours != null) hours!,
    ];
    return parts.join(', ');
  }
}

/// Komponen Kartu Filter sesuai `Components.svg`:
/// - Jarak: `<1 km`, `1-2 km`, `2-5 km`, `>5 km`
/// - Harga: `<Rp25.000`, `Rp25.000 - Rp100.000`, `>Rp100.000`
/// - Jam Operasional: `Buka Sekarang`, `24 Jam`
/// - Tombol `Terapkan` berwarna oranye `#F0A04B`
class FoodViewFilterCard extends StatefulWidget {
  final FoodViewFilterSelection initialSelection;
  final ValueChanged<FoodViewFilterSelection> onApply;

  const FoodViewFilterCard({
    super.key,
    this.initialSelection = const FoodViewFilterSelection(),
    required this.onApply,
  });

  @override
  State<FoodViewFilterCard> createState() => _FoodViewFilterCardState();
}

class _FoodViewFilterCardState extends State<FoodViewFilterCard> {
  String? _selectedDistance;
  String? _selectedPrice;
  String? _selectedHours;

  static const List<String> _distances = ['<1 km', '1-2 km', '2-5 km', '>5 km'];
  static const List<String> _prices = [
    '<Rp25.000',
    'Rp25.000 - Rp100.000',
    '>Rp100.000',
  ];
  static const List<String> _hours = ['Buka Sekarang', '24 Jam'];

  @override
  void initState() {
    super.initState();
    _selectedDistance = widget.initialSelection.distance;
    _selectedPrice = widget.initialSelection.price;
    _selectedHours = widget.initialSelection.hours;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryOrange,
                ),
              ),
              if (_selectedDistance != null ||
                  _selectedPrice != null ||
                  _selectedHours != null)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDistance = null;
                      _selectedPrice = null;
                      _selectedHours = null;
                    });
                  },
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textGray,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Jarak',
            style: TextStyle(fontSize: 10.5, color: AppColors.textGray),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _distances
                .map(
                  (d) => FoodViewFilterChip(
                    label: d,
                    selected: _selectedDistance == d,
                    onTap: () => setState(
                      () => _selectedDistance = _selectedDistance == d ? null : d,
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          const Text(
            'Harga',
            style: TextStyle(fontSize: 10.5, color: AppColors.textGray),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _prices
                .map(
                  (p) => FoodViewFilterChip(
                    label: p,
                    selected: _selectedPrice == p,
                    onTap: () => setState(
                      () => _selectedPrice = _selectedPrice == p ? null : p,
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          const Text(
            'Jam Operasional',
            style: TextStyle(fontSize: 10.5, color: AppColors.textGray),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _hours
                .map(
                  (h) => FoodViewFilterChip(
                    label: h,
                    selected: _selectedHours == h,
                    onTap: () => setState(
                      () => _selectedHours = _selectedHours == h ? null : h,
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                widget.onApply(
                  FoodViewFilterSelection(
                    distance: _selectedDistance,
                    price: _selectedPrice,
                    hours: _selectedHours,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Terapkan',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Chip filter individual sesuai komponen `<1 km` (abu-abu `#EFEFEF` vs oranye `#F0A04B`) di `Components.svg`.
class FoodViewFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const FoodViewFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryOrange : AppColors.chipGray,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? Colors.white : AppColors.textDark,
          ),
        ),
      ),
    );
  }
}
