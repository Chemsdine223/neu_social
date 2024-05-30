import 'package:flutter_bloc/flutter_bloc.dart';

enum BottomSheetStatus { opened, closed }

class BottomSheetNavigationCubit extends Cubit<BottomSheetStatus> {
  BottomSheetNavigationCubit() : super(BottomSheetStatus.closed);

  openSheet() {
    emit(BottomSheetStatus.opened);
  }

  closeSheet() {
    emit(BottomSheetStatus.closed);
  }
}
