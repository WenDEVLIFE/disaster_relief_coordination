import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/PersonModel.dart';
import '../services/UserStatusService.dart';

// Profile Events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfile extends ProfileEvent {
  const LoadProfile();
}

class UpdateProfile extends ProfileEvent {
  final String name;
  final String gender;

  const UpdateProfile({required this.name, required this.gender});

  @override
  List<Object> get props => [name, gender];
}

class ToggleEditMode extends ProfileEvent {
  const ToggleEditMode();
}

// Profile State
class ProfileState extends Equatable {
  final PersonModel? profile;
  final bool isEditing;
  final bool isLoading;

  const ProfileState({
    this.profile,
    this.isEditing = false,
    this.isLoading = false,
  });

  ProfileState copyWith({
    PersonModel? profile,
    bool? isEditing,
    bool? isLoading,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isEditing: isEditing ?? this.isEditing,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [profile, isEditing, isLoading];
}

// Profile Bloc
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserStatusService _userStatusService = UserStatusService();

  ProfileBloc() : super(const ProfileState()) {
    on<LoadProfile>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      try {
        // Load current user profile from Firebase
        final userProfile = await _userStatusService.getUserProfile();
        final userStatusData = await _userStatusService
            .getUserStatusWithGender();
        final currentUserId = _userStatusService.currentUserId;

        print('ProfileBloc - Loading profile data:');
        print('User Profile: $userProfile');
        print('User Status Data: $userStatusData');
        print('Current User ID: $currentUserId');

        if (currentUserId != null) {
          // Get name from user profile, fallback to user status data
          final name =
              userProfile?['name'] ?? userStatusData?['name'] ?? 'Unknown User';

          // Get gender from user status data (more current), fallback to user profile
          final gender =
              userStatusData?['gender'] ?? userProfile?['gender'] ?? 'Other';

          // Get status from user status data
          final status = userStatusData?['isSafe'] == true ? 'Safe' : 'Unsafe';

          final profile = PersonModel(
            id: currentUserId,
            name: name,
            status: status,
            gender: gender,
          );

          print('ProfileBloc - Created profile: $profile');
          emit(state.copyWith(profile: profile, isLoading: false));
        } else {
          print('ProfileBloc - No current user ID found');
          // Fallback for when user is not authenticated or profile doesn't exist
          emit(state.copyWith(isLoading: false));
        }
      } catch (e) {
        print('ProfileBloc - Error loading profile: $e');
        emit(state.copyWith(isLoading: false));
      }
    });

    on<UpdateProfile>((event, emit) async {
      if (state.profile == null) return;

      emit(state.copyWith(isLoading: true));

      try {
        print('ProfileBloc - Updating profile:');
        print('New name: ${event.name}');
        print('New gender: ${event.gender}');

        // Update profile in both collections to ensure sync
        await _userStatusService.updateUserProfile(event.name, event.gender);

        // Also update the user_status collection with the new gender
        await _userStatusService.saveUserStatus(
          state.profile!.status == 'Safe',
          gender: event.gender,
        );

        final updatedProfile = state.profile!.copyWith(
          name: event.name,
          gender: event.gender,
        );

        print('ProfileBloc - Profile updated successfully');

        // Trigger a refresh of the status view to reflect gender changes
        // This will update the MyStatusView with the new gender data
        try {
          await _userStatusService.saveUserStatus(
            updatedProfile.status == 'Safe',
            gender: event.gender,
          );
          print('ProfileBloc - User status updated with new gender');
        } catch (e) {
          print('ProfileBloc - Error updating user status: $e');
        }

        emit(
          state.copyWith(
            profile: updatedProfile,
            isLoading: false,
            isEditing: false,
          ),
        );
      } catch (e) {
        print('ProfileBloc - Error updating profile: $e');
        emit(state.copyWith(isLoading: false));
      }
    });

    on<ToggleEditMode>((event, emit) {
      emit(state.copyWith(isEditing: !state.isEditing));
    });
  }
}
