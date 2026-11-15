---
name: fishlog-lab05-fixes
description: Tracking 7 issues from user feedback for fishlog lab05 fixes
metadata:
  type: project
---

1. Customize WaterBodyTypeFilter — convert dropdown to chip-based horizontal filter; apply consistently
2. Fix FishPhotoDialog — "Галерея" button pops without returning a value; photo is square with dark overlay; same bug may exist elsewhere
3. Water body not added when creating trip — pressing "Нова водойма" button does nothing; verify _onAddWaterBody flow
4. Date selection — make date field readOnly so tapping opens calendar date picker instead of keyboard
5. Tackle search — add search field to tackle_screen.dart (already has category filters); add search by name
6. Add catch flow — FishItemFormDialog should be a popup dialog (showDialog) not bottom sheet; fish form appears first, photo is optional within form
7. Trip details show wrong data — date time lost (DateTime(2026,5,24) shows 00:00); location overridden by water body; duplicate temperature chip; verify data integrity

Related files:
- lib/features/water_bodies/widgets/water_body_type_filter.dart
- lib/features/trips/widgets/fish_photo_dialog.dart
- lib/features/trips/screens/add_trip_screen.dart
- lib/features/trips/widgets/basic_info_step.dart
- lib/features/tackle/screens/tackle_screen.dart
- lib/features/trips/widgets/catch_step.dart
- lib/features/trips/screens/trip_detail_screen.dart
- lib/core/widgets/water_body_card.dart (showWaterBodyFormSheet)