import 'package:flutter/material.dart';

import '../../../core/widgets/app_filter_dropdown.dart';
import 'trip_form_helpers.dart';

/// Крок 2: Погода.
class WeatherStep extends StatelessWidget {
  final String selectedWeather;
  final ValueChanged<String> onWeatherChanged;
  final TextEditingController temperatureCtrl;
  final TextEditingController windCtrl;
  final TextEditingController pressureCtrl;

  const WeatherStep({
    super.key,
    required this.selectedWeather,
    required this.onWeatherChanged,
    required this.temperatureCtrl,
    required this.windCtrl,
    required this.pressureCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return TripSectionCard(
      stepNumber: '2',
      title: 'Погода',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TripFieldLabel(label: 'Температура'),
          TripInputField(
            controller: temperatureCtrl,
            prefixIcon: Icons.wb_sunny_outlined,
          ),
          const SizedBox(height: 16),

          TripFieldLabel(label: 'Умови'),
          AppFilterDropdown<String>(
            label: null,
            hint: 'Оберіть умови погоди',
            value: selectedWeather.isEmpty ? null : selectedWeather,
            items: const ['Сонячно', 'Хмарно', 'Дощ', 'Вітряно', 'Туман']
                .map((w) => AppFilterItem(value: w, label: w))
                .toList(),
            onChanged: (val) {
              if (val != null) onWeatherChanged(val);
            },
          ),
          const SizedBox(height: 16),

          TripFieldLabel(label: 'Вітер'),
          TripInputField(
            controller: windCtrl,
            prefixIcon: Icons.air,
          ),
          const SizedBox(height: 16),

          TripFieldLabel(label: 'Тиск'),
          TripInputField(controller: pressureCtrl),
        ],
      ),
    );
  }
}
