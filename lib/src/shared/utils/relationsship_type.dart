import '../../models/client_model.dart';

String getReadableRelationshipStatus(RelationshipStatus? status) {
  switch (status) {
    case RelationshipStatus.single:
      return 'Solteiro(a)';
    case RelationshipStatus.married:
      return 'Casado(a)';
    case RelationshipStatus.divorced:
      return 'Divorciado(a)';
    case RelationshipStatus.widowed:
      return 'Viúvo(a)';
    case RelationshipStatus.separated:
      return 'Separado(a)';
    case RelationshipStatus.domesticPartnership:
      return 'Parceria Doméstica';
    case null:
      return '';
    default:
      return '';
  }
}
