class User {
  final String id;
  final String login;
  final String password;
  final String name;
  final List<UserSettings> settings;

  const User({
    required this.id,
    required this.login,
    required this.password,
    required this.name,
    required this.settings,
  });
}

class UserSettings {
  final String key;
  final dynamic value;
  const UserSettings(this.key, this.value);
}
