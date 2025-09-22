sealed class SettingsState {}

final class SettingsInitial extends SettingsState {}

final class SettingsDataLoaded extends SettingsState {}

final class SettingsLoading extends SettingsState {}

final class SettingsError extends SettingsState {
  final String message;
  SettingsError(this.message);
}

final class SettingsSuccess extends SettingsState {}

final class SettingsFloatingScreenState extends SettingsState {}
