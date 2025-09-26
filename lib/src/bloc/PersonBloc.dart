import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/PersonModel.dart';
import '../services/UserStatusService.dart';

// Person Events
abstract class PersonEvent extends Equatable {
  const PersonEvent();
  @override
  List<Object> get props => [];
}

class LoadPersons extends PersonEvent {
  const LoadPersons();
}

class UpdatePersonStatus extends PersonEvent {
  final String personId;
  final String newStatus;

  const UpdatePersonStatus(this.personId, this.newStatus);

  @override
  List<Object> get props => [personId, newStatus];
}

class AddCurrentUser extends PersonEvent {
  final PersonModel currentUser;

  const AddCurrentUser(this.currentUser);

  @override
  List<Object> get props => [currentUser];
}

class LoadUsersFromFirebase extends PersonEvent {
  const LoadUsersFromFirebase();
}

class UpdateUserStatusInFirebase extends PersonEvent {
  final bool isSafe;

  const UpdateUserStatusInFirebase(this.isSafe);

  @override
  List<Object> get props => [isSafe];
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
  final UserStatusService _userStatusService = UserStatusService();

  PersonBloc() : super(const PersonState([])) {
    on<LoadPersons>((event, emit) {
      // Load initial data from Firebase
      _loadUsersFromFirebase(emit);
    });

    on<UpdatePersonStatus>((event, emit) async {
      try {
        // Update status in Firebase
        await _userStatusService.saveUserStatus(event.newStatus == 'Safe');

        // Reload users from Firebase to get updated data
        _loadUsersFromFirebase(emit);
      } catch (e) {
        print('Error updating person status: $e');
        // Still emit current state if there's an error
        emit(state);
      }
    });

    on<UpdateUserStatusInFirebase>((event, emit) async {
      try {
        // Update current user status in Firebase
        await _userStatusService.saveUserStatus(event.isSafe);

        // Reload users from Firebase to get updated data
        _loadUsersFromFirebase(emit);
      } catch (e) {
        print('Error updating user status in Firebase: $e');
        // Still emit current state if there's an error
        emit(state);
      }
    });

    on<AddCurrentUser>((event, emit) {
      final currentState = state;
      if (currentState is PersonState) {
        final people = currentState.people;
        final currentUserIndex = people.indexWhere(
          (person) => person.id == event.currentUser.id,
        );

        if (currentUserIndex == -1) {
          // Add current user to the list
          final updatedPeople = [...people, event.currentUser];
          emit(PersonState(updatedPeople));
        } else {
          // Update existing current user
          final updatedPeople = people.map((person) {
            if (person.id == event.currentUser.id) {
              return event.currentUser;
            }
            return person;
          }).toList();
          emit(PersonState(updatedPeople));
        }
      }
    });
  }

  void _loadUsersFromFirebase(Emitter<PersonState> emit) async {
    try {
      // Listen to real-time updates from Firebase
      final usersStream = _userStatusService.getAllUserStatuses();

      await emit.forEach(
        usersStream,
        onData: (users) => PersonState(users),
        onError: (error, stackTrace) {
          print('Error loading users from Firebase: $error');
          return const PersonState([]);
        },
      );
    } catch (e) {
      print('Error setting up Firebase stream: $e');
      emit(const PersonState([]));
    }
  }
}
