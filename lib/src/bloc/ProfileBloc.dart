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
        final currentUserId = _userStatusService.currentUserId;

        if (userProfile != null && currentUserId != null) {
          final profile = PersonModel(
            id: currentUserId,
            name: userProfile['name'] ?? 'Unknown User',
            status:
                'Safe', // Default status, could be loaded from user_status collection
            gender: userProfile['gender'] ?? 'Other',
          );

          emit(state.copyWith(profile: profile, isLoading: false));
        } else {
          // Fallback for when user is not authenticated or profile doesn't exist
          emit(state.copyWith(isLoading: false));
        }
      } catch (e) {
        print('Error loading profile: $e');
        emit(state.copyWith(isLoading: false));
      }
    });

    on<UpdateProfile>((event, emit) async {
      if (state.profile == null) return;

      emit(state.copyWith(isLoading: true));

      try {
        // Update profile in Firebase using UserStatusService
        await _userStatusService.updateUserProfile(event.name, event.gender);

        final updatedProfile = state.profile!.copyWith(
          name: event.name,
          gender: event.gender,
        );

        emit(
          state.copyWith(
            profile: updatedProfile,
            isLoading: false,
            isEditing: false,
          ),
        );
      } catch (e) {
        print('Error updating profile: $e');
        emit(state.copyWith(isLoading: false));
      }
    });

    on<ToggleEditMode>((event, emit) {
      emit(state.copyWith(isEditing: !state.isEditing));
    });
  }
}
