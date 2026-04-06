class AlertTypeOption {
  const AlertTypeOption({
    required this.code,
    required this.label,
    required this.description,
  });

  final String code;
  final String label;
  final String description;
}

class AlertTypes {
  static const String safe = 'SAFE';
  static const String danger = 'DANGER';
  static const String medical = 'MEDICAL';
  static const String fire = 'FIRE';
  static const String flood = 'FLOOD';
  static const String earthquake = 'EARTHQUAKE';
  static const String violence = 'VIOLENCE';

  static const List<AlertTypeOption> emergencyOptions = [
    AlertTypeOption(
      code: danger,
      label: 'General Emergency',
      description: 'Use when you need urgent help but no specific category fits.',
    ),
    AlertTypeOption(
      code: medical,
      label: 'Medical Emergency',
      description: 'For injury, collapse, breathing issues, or urgent health needs.',
    ),
    AlertTypeOption(
      code: fire,
      label: 'Fire',
      description: 'For smoke, open flames, or evacuation due to fire.',
    ),
    AlertTypeOption(
      code: flood,
      label: 'Flood',
      description: 'For rising water, trapped residents, or unsafe flood conditions.',
    ),
    AlertTypeOption(
      code: earthquake,
      label: 'Earthquake',
      description: 'For structural damage, aftershocks, or quake-related danger.',
    ),
    AlertTypeOption(
      code: violence,
      label: 'Security Threat',
      description: 'For violence, threats, or suspicious activity needing response.',
    ),
  ];

  static const List<String> supported = [
    safe,
    danger,
    medical,
    fire,
    flood,
    earthquake,
    violence,
  ];

  static bool isSupported(String type) => supported.contains(type);

  static String labelFor(String type) {
    if (type == safe) return 'Safe';

    for (final option in emergencyOptions) {
      if (option.code == type) return option.label;
    }

    return 'Emergency';
  }
}
