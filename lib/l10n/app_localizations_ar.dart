// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'سائق ديليفرو';

  @override
  String get newOrders => 'طلبات جديدة';

  @override
  String get activeDelivery => 'التوصيل الحالي';

  @override
  String get earnings => 'الأرباح';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get startDelivery => 'بدء التوصيل';

  @override
  String get completeDelivery => 'إتمام التوصيل';
}
