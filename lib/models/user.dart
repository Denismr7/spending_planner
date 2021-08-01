class User {
  final String id;
  final String login;
  final String? password;
  final String name;
  final List<UserSettings> settings;

  const User({
    required this.id,
    required this.login,
    required this.name,
    required this.settings,
    this.password,
  });
}

class UserSettings {
  final Setting key;
  final dynamic value;
  const UserSettings(this.key, this.value);
}

enum Setting {
  Currency,
  Budget,
  Categories,
}
