import 'identity.dart';
import 'dni_type.dart';

class GeneratedCodeRecord {
  final Identity identity;
  final DniType type;
  final DateTime generatedAt;

  GeneratedCodeRecord({
    required this.identity,
    required this.type,
    required this.generatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'identity': identity.toJson(),
      'type': type.name,
      'generatedAt': generatedAt.toIso8601String(),
    };
  }

  factory GeneratedCodeRecord.fromJson(Map<String, dynamic> json) {
    return GeneratedCodeRecord(
      identity: Identity.fromJson(json['identity'] as Map<String, dynamic>),
      type: DniType.values.byName(json['type'] as String),
      generatedAt: DateTime.parse(json['generatedAt'] as String),
    );
  }
}
