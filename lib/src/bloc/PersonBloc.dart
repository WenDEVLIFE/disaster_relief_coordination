import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/PersonModel.dart';
import '../model/FamilyMemberModel.dart';
import '../services/UserStatusService.dart';
import '../services/FamilyService.dart';

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

class LoadFamilyMembers extends PersonEvent {
  const LoadFamilyMembers();
}

class AddFamilyMember extends PersonEvent {
  final String memberUserId;
  final String name;
  final String relationship;
  final String? gender;

  const AddFamilyMember(this.memberUserId, this.name, this.relationship, this.gender);

  @override
  List<Object> get props => [memberUserId, name, relationship, gender ?? ''];
}

class RemoveFamilyMember extends PersonEvent {
  final String familyMemberId;

  const RemoveFamilyMember(this.familyMemberId);

  @override
  List<Object> get props => [familyMemberId];
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
  final FamilyService _familyService = FamilyService();

  PersonBloc() : super(const PersonState([])) {
    on<LoadPersons>((event, emit) {
      // Load family members with their status
      _loadFamilyMembersWithStatus(emit);
    });

    on<LoadFamilyMembers>((event, emit) {
      // Load family members with their status
      _loadFamilyMembersWithStatus(emit);
    });

    on<AddCurrentUser>((event, emit) {
      final currentState = state;
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
   });

   on<AddFamilyMember>((event, emit) async {
     try {
       await _familyService.addFamilyMember(
         event.memberUserId,
         event.name,
         event.relationship,
         gender: event.gender,
       );

       // Reload family members after adding
       _loadFamilyMembersWithStatus(emit);
     } catch (e) {
       print('Error adding family member: $e');
       emit(state);
     }
   });

   on<RemoveFamilyMember>((event, emit) async {
     try {
       await _familyService.removeFamilyMember(event.familyMemberId);

       // Reload family members after removing
       _loadFamilyMembersWithStatus(emit);
     } catch (e) {
       print('Error removing family member: $e');
       emit(state);
     }
   });
 }

  void _loadFamilyMembersWithStatus(Emitter<PersonState> emit) async {
    try {
      // Listen to real-time updates from Firebase for family members
      final familyMembersStream = _familyService.getFamilyMembersWithStatus();

      await emit.forEach(
        familyMembersStream,
        onData: (familyMembers) => PersonState(familyMembers),
        onError: (error, stackTrace) {
          print('Error loading family members from Firebase: $error');
          return const PersonState([]);
        },
      );
    } catch (e) {
      print('Error setting up Firebase stream for family members: $e');
      emit(const PersonState([]));
    }
  }
}
