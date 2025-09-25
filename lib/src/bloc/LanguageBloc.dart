import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/LanguageService.dart';

/// Events for the Language BLoC
abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object?> get props => [];
}

class InitializeLanguage extends LanguageEvent {
  const InitializeLanguage();
}

class ChangeLanguage extends LanguageEvent {
  final SupportedLanguage language;

  const ChangeLanguage(this.language);

  @override
  List<Object?> get props => [language];
}

/// States for the Language BLoC
abstract class LanguageState extends Equatable {
  const LanguageState();

  @override
  List<Object?> get props => [];
}

class LanguageInitial extends LanguageState {
  const LanguageInitial();
}

class LanguageLoading extends LanguageState {
  const LanguageLoading();
}

class LanguageLoaded extends LanguageState {
  final SupportedLanguage currentLanguage;

  const LanguageLoaded(this.currentLanguage);

  @override
  List<Object?> get props => [currentLanguage];
}

class LanguageChanged extends LanguageState {
  final SupportedLanguage newLanguage;

  const LanguageChanged(this.newLanguage);

  @override
  List<Object?> get props => [newLanguage];
}

/// BLoC for managing language state and translations
class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final LanguageService _languageService;

  LanguageBloc({required LanguageService languageService})
    : _languageService = languageService,
      super(const LanguageInitial()) {
    on<InitializeLanguage>(_onInitializeLanguage);
    on<ChangeLanguage>(_onChangeLanguage);
  }

  /// Initialize the language service and load saved language
  Future<void> _onInitializeLanguage(
    InitializeLanguage event,
    Emitter<LanguageState> emit,
  ) async {
    emit(const LanguageLoading());

    try {
      await _languageService.initialize();
      emit(LanguageLoaded(_languageService.currentLanguage));
    } catch (e) {
      // If initialization fails, emit loaded state with default language
      emit(const LanguageLoaded(SupportedLanguage.english));
    }
  }

  /// Change the current language
  Future<void> _onChangeLanguage(
    ChangeLanguage event,
    Emitter<LanguageState> emit,
  ) async {
    try {
      await _languageService.changeLanguage(event.language);
      emit(LanguageChanged(event.language));
      emit(LanguageLoaded(event.language));
    } catch (e) {
      // If language change fails, emit loaded state with current language
      emit(LanguageLoaded(_languageService.currentLanguage));
    }
  }

  /// Get translation for a given key
  String translate(String key) {
    return _languageService.translate(key);
  }

  /// Get the current language
  SupportedLanguage get currentLanguage => _languageService.currentLanguage;

  /// Get all supported languages
  List<SupportedLanguage> getSupportedLanguages() {
    return _languageService.getSupportedLanguages();
  }
}
