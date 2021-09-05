import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:todo_list/data/repository/status_repository.dart';

part 'status_bloc_event.dart';
part 'status_bloc_state.dart';

class StatusBloc extends Bloc<StatusBlocEvent, StatusBlocState> {
  StatusBloc() : super(StatusBlocState(status: 'offline'));

  final statusRepository = new StatusRepository();
  @override
  Stream<StatusBlocState> mapEventToState(
    StatusBlocEvent event,
  ) async* {
    switch (event) {
      case StatusBlocEvent.status:
        final data = await statusRepository.getStatus();
        yield StatusBlocState(status: data);
        break;
      default:
        yield StatusBlocState(status: 'offline');
        break;
    }
  }
}
