import '../models/calendar_event_model.dart';

abstract class CalendarDataSource {
 Future<bool> requestPermission();
 Future<bool> hasPermission();
 Future<List<CalendarEventModel>> getDeviceCalendarEvents();
 Future<void> revokePermission();
}

class MockCalendarDataSource implements CalendarDataSource {
 bool _hasPermission = false;

 @override
 Future<bool> requestPermission() async {
 _hasPermission = true;
 return _hasPermission;
 }

 @override
 Future<bool> hasPermission() async {
 return _hasPermission;
 }

 @override
 Future<List<CalendarEventModel>> getDeviceCalendarEvents() async {
 if (!_hasPermission) return [];
 return [
 CalendarEventModel(
 id: 'dev_event_1',
 userId: 'default_user',
 externalId: 'ext_cal_99',
 title: ' Basketball Tournament',
 startDate: DateTime.now().add(const Duration(days: 15)),
 endDate: DateTime.now().add(const Duration(days: 15)),
 source: 'device',
 createdAt: DateTime.now(),
 ),
 ];
 }

 @override
 Future<void> revokePermission() async {
 _hasPermission = false;
 }
}
