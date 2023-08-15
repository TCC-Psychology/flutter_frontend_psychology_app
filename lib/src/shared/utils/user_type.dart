enum UserType {
  client,
  psychologist,
}

extension UserTypeExtension on UserType {
  String get name {
    switch (this) {
      case UserType.client:
        return "Cliente";
      case UserType.psychologist:
        return "Psicólogo";
      default:
        return toString().split('.').last;
    }
  }
}
