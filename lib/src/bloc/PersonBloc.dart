import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/PersonModel.dart';

// Person Events
abstract class PersonEvent extends Equatable {
  const PersonEvent();
  @override
  List<Object> get props => [];
}

class LoadPersons extends PersonEvent {
  const LoadPersons();
}

// Person State
class PersonState extends Equatable {
  final List<PersonModel> people;
  const PersonState(this.people);

  @override
  List<Object> get props => [people];
}

// Person Bloc
class PersonBloc extends Bloc<PersonEvent, PersonState> {
  PersonBloc() : super(const PersonState([])) {
    on<LoadPersons>((event, emit) {
      // Replace with your actual data source
      emit(
        PersonState([
          PersonModel(id: '1', name: 'Alice', status: 'Safe', gender: 'Female'),
          PersonModel(id: '2', name: 'Bob', status: 'Unsafe', gender: 'Male'),
          PersonModel(id: '3', name: 'Bob', status: 'Unsafe', gender: 'Male'),
          PersonModel(id: '4', name: 'Bob', status: 'Unsafe', gender: 'Male'),
          PersonModel(id: '5', name: 'Bob', status: 'Unsafe', gender: 'Male'),
          PersonModel(id: '6', name: 'Bob', status: 'Unsafe', gender: 'Male'),
        ]),
      );
    });
  }
}
