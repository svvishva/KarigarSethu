import 'dart:io';
import 'dart:convert';

void main() {
  final Map<String, Map<String, String>> translations = {
    'en': {
      'theme': 'Theme',
      'themeSystem': 'System Default',
      'themeLight': 'Light',
      'themeDark': 'Dark',
    },
    'hi': {
      'theme': 'थीम',
      'themeSystem': 'सिस्टम डिफ़ॉल्ट',
      'themeLight': 'लाइट',
      'themeDark': 'डार्क',
    },
    'mr': {
      'theme': 'थीम',
      'themeSystem': 'सिस्टम डीफॉल्ट',
      'themeLight': 'लाइट',
      'themeDark': 'डार्क',
    },
    'ta': {
      'theme': 'தீம்',
      'themeSystem': 'கணினி இயல்புநிலை',
      'themeLight': 'வெளிர்',
      'themeDark': 'இருள்',
    },
    'te': {
      'theme': 'థీమ్',
      'themeSystem': 'సిస్టమ్ డిఫాల్ట్',
      'themeLight': 'లైట్',
      'themeDark': 'డార్క్',
    },
    'ml': {
      'theme': 'തീം',
      'themeSystem': 'സിസ്റ്റം ഡിഫോൾട്ട്',
      'themeLight': 'ലൈറ്റ്',
      'themeDark': 'ഡാർക്ക്',
    }
  };

  for (var entry in translations.entries) {
    final lang = entry.key;
    final file = File('lib/l10n/app_$lang.arb');
    if (file.existsSync()) {
      var content = file.readAsStringSync();
      var json = jsonDecode(content) as Map<String, dynamic>;
      
      json.addAll(entry.value);
      
      file.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(json));
      print('Updated app_$lang.arb');
    }
  }
}
