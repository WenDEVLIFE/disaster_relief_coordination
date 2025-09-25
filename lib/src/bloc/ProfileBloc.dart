import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/PersonModel.dart';

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
  ProfileBloc() : super(const ProfileState()) {
    on<LoadProfile>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      // Simulate loading profile data
      await Future.delayed(const Duration(milliseconds: 500));

      // Load current user profile (in a real app, this would come from authentication/user service)
      final profile = PersonModel(
        id: 'current_user',
        name: 'John Doe',
        status: 'Safe',
        gender: 'Male',
      );

      emit(state.copyWith(profile: profile, isLoading: false));
    });

    on<UpdateProfile>((event, emit) async {
      if (state.profile == null) return;

      emit(state.copyWith(isLoading: true));

      // Simulate updating profile
      await Future.delayed(const Duration(milliseconds: 500));

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
    });

    on<ToggleEditMode>((event, emit) {
      emit(state.copyWith(isEditing: !state.isEditing));
    });
  }
}
