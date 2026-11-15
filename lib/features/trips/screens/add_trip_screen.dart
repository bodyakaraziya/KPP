import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/models/trip.dart';
import '../../../core/models/water_body.dart';
import '../../../core/models/catch_item.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/tackle_card.dart';
import '../../../core/widgets/water_body_card.dart';
import '../providers/trips_provider.dart';
import '../../water_bodies/providers/water_bodies_provider.dart';
import '../../tackle/providers/tackle_provider.dart';
import '../widgets/basic_info_step.dart';
import '../widgets/catch_step.dart';
import '../widgets/notes_step.dart';
import '../widgets/tackle_step.dart';
import '../widgets/weather_step.dart';

class AddTripScreen extends StatefulWidget {
  final Trip? trip;

  const AddTripScreen({super.key, this.trip});

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  String _selectedWaterBody = 'Дніпровська затока';
  String _selectedWeather = 'Сонячно';

  // Вибрані снасті — порожньо за замовчуванням. При редагуванні виїзду
  // заповнюється з даних виїзду (initState), нічого не хардкодиться.
  final Set<String> _selectedTackle = {};

  final List<CatchItem> _catchItems = [];
  String _durationText = '6 год 0 хв';

  late final TextEditingController _dateCtrl;
  late final TextEditingController _startTimeCtrl;
  late final TextEditingController _endTimeCtrl;
  late final TextEditingController _temperatureCtrl;
  late final TextEditingController _windCtrl;
  late final TextEditingController _pressureCtrl;
  late final TextEditingController _notesCtrl;

  @override
  void initState() {
    super.initState();
    _selectedWaterBody = widget.trip?.waterBodyName ?? 'Дніпровська затока';
    _selectedWeather = widget.trip?.weather ?? 'Сонячно';
    _selectedTackle
      ..clear()
      ..addAll(widget.trip?.tackle ?? const <String>[]);
    _catchItems
      ..clear()
      ..addAll(widget.trip?.catchItems ?? []);

    final tripDate = widget.trip?.date;
    _dateCtrl = TextEditingController(
      text: tripDate != null
          ? '${tripDate.day.toString().padLeft(2, '0')}.${tripDate.month.toString().padLeft(2, '0')}.${tripDate.year}'
          : '24.05.2026',
    );
    _startTimeCtrl = TextEditingController(text: widget.trip?.startTime ?? '06:00');
    _endTimeCtrl = TextEditingController(text: widget.trip?.endTime ?? '12:00');
    _temperatureCtrl = TextEditingController(text: widget.trip?.temperature ?? '+18°C');
    _windCtrl = TextEditingController(text: widget.trip?.wind ?? '3 м/с Пн-Зх');
    _pressureCtrl = TextEditingController(text: widget.trip?.pressure ?? '752 мм');
    _notesCtrl = TextEditingController(text: widget.trip?.notes ?? '');

    _startTimeCtrl.addListener(_recomputeDuration);
    _endTimeCtrl.addListener(_recomputeDuration);
    _durationText = widget.trip?.duration ?? _computeDuration(_startTimeCtrl.text, _endTimeCtrl.text);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final names = context
        .read<WaterBodiesProvider>()
        .waterBodies
        .map((wb) => wb.name)
        .toList();
    if (_selectedWaterBody.isNotEmpty && !names.contains(_selectedWaterBody)) {
      _selectedWaterBody = names.isNotEmpty ? names.first : '';
    }
  }

  @override
  void dispose() {
    _startTimeCtrl.removeListener(_recomputeDuration);
    _endTimeCtrl.removeListener(_recomputeDuration);
    _dateCtrl.dispose();
    _startTimeCtrl.dispose();
    _endTimeCtrl.dispose();
    _temperatureCtrl.dispose();
    _windCtrl.dispose();
    _pressureCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _recomputeDuration() {
    setState(() {
      _durationText = _computeDuration(_startTimeCtrl.text, _endTimeCtrl.text);
    });
  }

  void _toggleTackle(String item) {
    setState(() {
      if (_selectedTackle.contains(item)) {
        _selectedTackle.remove(item);
      } else {
        _selectedTackle.add(item);
      }
    });
  }

  DateTime _parseDate(String text) {
    try {
      final parts = text.trim().split('.');
      if (parts.length == 3) {
        return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
      }
    } catch (_) {}
    return DateTime.now();
  }

  String _computeDuration(String start, String end) {
    try {
      final s = start.trim().split(':');
      final e = end.trim().split(':');
      if (s.length == 2 && e.length == 2) {
        final startMins = int.parse(s[0]) * 60 + int.parse(s[1]);
        final endMins = int.parse(e[0]) * 60 + int.parse(e[1]);
        final diff = endMins - startMins;
        if (diff > 0) {
          final h = diff ~/ 60;
          final m = diff % 60;
          return '$h год $m хв';
        }
      }
    } catch (_) {}
    return '0 год 0 хв';
  }

  void _saveTrip() {
    final date = _parseDate(_dateCtrl.text);
    final start = _startTimeCtrl.text.trim();
    final end = _endTimeCtrl.text.trim();

    // brakte: локація та фото беруться з обраної водойми,
    // щоб не зберігати захардкожені дані.
    final waterBody = context.read<WaterBodiesProvider>().allWaterBodies.firstWhere(
      (wb) => wb.name == _selectedWaterBody,
      orElse: () => WaterBody(
        id: '',
        name: _selectedWaterBody,
        type: '',
        location: '',
        notes: '',
        imageUrl:
            'https://images.unsplash.com/photo-1544551763-46a013bb70d5?auto=format&fit=crop&w=900&q=80',
      ),
    );
    final location =
        waterBody.location.isNotEmpty
            ? waterBody.location
            : _selectedWaterBody;

    final trip = Trip(
      id: widget.trip?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      waterBodyName: _selectedWaterBody,
      location: location,
      date: date,
      startTime: start,
      endTime: end,
      duration: _durationText,
      temperature: _temperatureCtrl.text.trim(),
      weather: _selectedWeather,
      wind: _windCtrl.text.trim(),
      pressure: _pressureCtrl.text.trim(),
      imageUrl: waterBody.imageUrl,
      tackle: _selectedTackle.toList(),
      catchItems: List.of(_catchItems),
      notes: _notesCtrl.text.trim(),
    );

    if (widget.trip != null) {
      // Редагування: якщо водойма змінилась — зменшуємо лічильник старої та збільшуємо нову.
      final oldWaterBody = widget.trip?.waterBodyName;
      if (oldWaterBody != null && oldWaterBody != _selectedWaterBody) {
        context.read<WaterBodiesProvider>().decrementTripsCount(oldWaterBody);
      }
      context.read<WaterBodiesProvider>().incrementTripsCount(_selectedWaterBody);

      // Синхронізуємо лічильники виїздів для снастей: зменшуємо ті, що випали з виїзду,
      // та збільшуємо нові.
      final oldTackle = widget.trip?.tackle ?? const <String>[];
      final newTackle = trip.tackle;
      for (final name in oldTackle) {
        if (!newTackle.contains(name)) {
          context.read<TackleProvider>().decrementTripsCount(name);
        }
      }
      for (final name in newTackle) {
        if (!oldTackle.contains(name)) {
          context.read<TackleProvider>().incrementTripsCount(name);
        }
      }

      context.read<TripsProvider>().updateTrip(trip.id, trip);
      showAppSnackBar(
        context,
        message: 'Зміни збережено!',
        isError: false,
      );
    } else {
      context.read<TripsProvider>().addTrip(trip);
      context.read<WaterBodiesProvider>().incrementTripsCount(_selectedWaterBody);
      // Кожна обрана снасть отримує +1 до лічильника виїздів.
      for (final name in trip.tackle) {
        context.read<TackleProvider>().incrementTripsCount(name);
      }
      showAppSnackBar(
        context,
        message: 'Виїзд успішно збережено!',
        isError: false,
      );
    }
    Navigator.pop(context);
  }

  /// Додати нову водойму через форму та обрти нею виїзд.
  Future<void> _onAddWaterBody() async {
    await showWaterBodyFormSheet(
      context,
      onSave: (body) {
        context.read<WaterBodiesProvider>().addWaterBody(body);
        setState(() => _selectedWaterBody = body.name);
      },
    );
  }

  /// Додати нову снасть через форму та відмітити її вибраною.
  Future<void> _onAddTackle() async {
    await showTackleFormSheet(
      context,
      onSave: (item) {
        context.read<TackleProvider>().addTackle(item);
        setState(() => _selectedTackle.add(item.name));
      },
    );
  }

  /// Додати рибу до улову: одразу форма додання позиції (модальний bottom sheet),
  /// фото вибирається всередині форми за бажанням.
  Future<void> _addFish() async {
    final item = await showModalBottomSheet<CatchItem?>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FishItemFormDialog(
        startTime: _startTimeCtrl.text.trim(),
        endTime: _endTimeCtrl.text.trim(),
      ),
    );
    if (mounted && item != null) {
      setState(() => _catchItems.add(item));
    }
  }

  void _removeFish(int index) {
    setState(() => _catchItems.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    final waterBodies = context.watch<WaterBodiesProvider>();
    final tackles = context.watch<TackleProvider>();
    final waterBodyNames = waterBodies.waterBodies.map((wb) => wb.name).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundBottom,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
            stops: [0.0, 0.25],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Основний скрол форми
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Кнопка "< До списку виїздів"
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(8),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.chevron_left,
                              color: AppColors.primaryTeal,
                              size: 20,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'До списку виїздів',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryTeal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.trip != null
                                    ? 'Редагувати виїзд'
                                    : 'Новий виїзд',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Збережіть деталі та спогади про риболовлю',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Картка 1: Основна інформація
                    BasicInfoStep(
                      selectedWaterBody: _selectedWaterBody,
                      waterBodyNames: waterBodyNames,
                      onWaterBodyChanged: (val) =>
                          setState(() => _selectedWaterBody = val),
                      dateCtrl: _dateCtrl,
                      startTimeCtrl: _startTimeCtrl,
                      endTimeCtrl: _endTimeCtrl,
                      durationText: _durationText,
                      onAddWaterBody: _onAddWaterBody,
                    ),
                    const SizedBox(height: 16),

                    // Картка 2: Погода
                    WeatherStep(
                      selectedWeather: _selectedWeather,
                      onWeatherChanged: (val) =>
                          setState(() => _selectedWeather = val),
                      temperatureCtrl: _temperatureCtrl,
                      windCtrl: _windCtrl,
                      pressureCtrl: _pressureCtrl,
                    ),
                    const SizedBox(height: 16),

                    // Картка 3: Спорядження
                    TackleStep(
                      selectedTackle: _selectedTackle,
                      onTackleToggle: _toggleTackle,
                      onAddTackle: _onAddTackle,
                      tackles: tackles.allTackles,
                    ),
                    const SizedBox(height: 16),

                    // Картка 4: Улов
                    CatchStep(
                      catchItems: _catchItems,
                      onAddFish: _addFish,
                      onRemoveFish: _removeFish,
                    ),
                    const SizedBox(height: 16),

                    // Картка 5: Нотатки
                    NotesStep(
                      notesCtrl: _notesCtrl,
                    ),
                  ],
                ),
              ),

              // Фіксована кнопка "Зберегти виїзд" знизу
              Positioned(
                left: 20,
                right: 20,
                bottom: 16,
                child: SizedBox(
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: _saveTrip,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryTeal,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.set_meal_outlined, size: 20),
                    label: Text(
                      widget.trip != null ? 'Зберегти зміни' : 'Зберегти виїзд',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
