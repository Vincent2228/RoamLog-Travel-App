/// Holds everything collected across the 3-step registration flow
/// (RegisterScreen -> PreferencesScreen -> LocationScreen). There's no
/// backend yet, so this is just passed along in memory — once you add a
/// real API, this is the object you'd serialize and send on the final step.
class RegistrationData {
  RegistrationData({
    this.fullName = '',
    this.username = '',
    this.email = '',
    this.password = '',
    this.interests = const {},
    this.birthCity = '',
    this.currentCity = '',
  });

  String fullName;
  String username;
  String email;
  String password;
  Set<String> interests;
  String birthCity;
  String currentCity;
}