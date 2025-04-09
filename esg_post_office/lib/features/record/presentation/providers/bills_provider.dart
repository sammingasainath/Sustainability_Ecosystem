import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/bills_service.dart';

final billsServiceProvider = Provider<BillsService>((ref) {
  return BillsService();
}); 