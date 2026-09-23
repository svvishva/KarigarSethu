import 'dart:io';
import 'dart:convert';

void main() async {
  final Map<String, Map<String, String>> translations = {
    'en': {
      "catHandloomSarees": "Handloom Sarees",
      "catEthnicWear": "Ethnic Wear & Dresses",
      "catHandwovenTextiles": "Handwoven Textiles",
      "catWoodenHandicrafts": "Wooden Handicrafts",
      "catBrassMetalware": "Brass & Bronze Metalware",
      "catTerracotta": "Terracotta & Pottery",
      "catLeatherCrafts": "Leather Crafts",
      "catFootwear": "Footwear",
      "catJewelry": "Handmade Jewelry",
      "catPaintings": "Traditional Paintings",
      "catBamboo": "Bamboo & Cane Products",
      "catHomeDecor": "Home Decor",
      "catOther": "Other"
    },
    'ta': {
      "catHandloomSarees": "கைத்தறி புடவைகள்",
      "catEthnicWear": "பாரம்பரிய உடைகள்",
      "catHandwovenTextiles": "கைத்தறி துணிகள்",
      "catWoodenHandicrafts": "மர கைவினைப்பொருட்கள்",
      "catBrassMetalware": "பித்தளை மற்றும் வெண்கல பொருட்கள்",
      "catTerracotta": "சுடுமண் மற்றும் மட்பாண்டங்கள்",
      "catLeatherCrafts": "தோல் கைவினைப்பொருட்கள்",
      "catFootwear": "காலணிகள்",
      "catJewelry": "கையால் செய்யப்பட்ட நகைகள்",
      "catPaintings": "பாரம்பரிய ஓவியங்கள்",
      "catBamboo": "மூங்கில் மற்றும் பிரம்பு பொருட்கள்",
      "catHomeDecor": "வீட்டு அலங்காரம்",
      "catOther": "மற்றவை"
    },
    'hi': {
      "catHandloomSarees": "हथकरघा साड़ियां",
      "catEthnicWear": "पारंपरिक परिधान",
      "catHandwovenTextiles": "हाथ से बुने वस्त्र",
      "catWoodenHandicrafts": "लकड़ी का हस्तशिल्प",
      "catBrassMetalware": "पीतल और कांस्य धातु",
      "catTerracotta": "टेराकोटा और मिट्टी के बर्तन",
      "catLeatherCrafts": "चमड़े का हस्तशिल्प",
      "catFootwear": "जूते और चप्पल",
      "catJewelry": "हस्तनिर्मित आभूषण",
      "catPaintings": "पारंपरिक पेंटिंग",
      "catBamboo": "बांस और बेंत के उत्पाद",
      "catHomeDecor": "गृह सज्जा",
      "catOther": "अन्य"
    },
    'te': {
      "catHandloomSarees": "చేనేత చీరలు",
      "catEthnicWear": "సాంప్రదాయ దుస్తులు",
      "catHandwovenTextiles": "చేనేత వస్త్రాలు",
      "catWoodenHandicrafts": "చెక్క హస్తకళలు",
      "catBrassMetalware": "ఇత్తడి & కంచు వస్తువులు",
      "catTerracotta": "టెర్రకోట & కుమ్మరి పని",
      "catLeatherCrafts": "తోలు వస్తువులు",
      "catFootwear": "పాదరక్షలు",
      "catJewelry": "చేతితో చేసిన ఆభరణాలు",
      "catPaintings": "సాంప్రదాయ చిత్రలేఖనాలు",
      "catBamboo": "వెదురు & పేము ఉత్పత్తులు",
      "catHomeDecor": "గృహాలంకరణ",
      "catOther": "ఇతర"
    },
    'mr': {
      "catHandloomSarees": "हातमाग साड्या",
      "catEthnicWear": "पारंपारिक कपडे",
      "catHandwovenTextiles": "हातमागाचे कापड",
      "catWoodenHandicrafts": "लाकडी हस्तकला",
      "catBrassMetalware": "पितळ आणि कांस्य वस्तू",
      "catTerracotta": "टेराकोटा आणि मातीची भांडी",
      "catLeatherCrafts": "चामड्याची हस्तकला",
      "catFootwear": "पादत्राणे",
      "catJewelry": "हस्तनिर्मित दागिने",
      "catPaintings": "पारंपारिक चित्रे",
      "catBamboo": "बांबू आणि वेताची उत्पादने",
      "catHomeDecor": "घराची सजावट",
      "catOther": "इतर"
    },
    'ml': {
      "catHandloomSarees": "കൈത്തറി സാരികൾ",
      "catEthnicWear": "പരമ്പരാഗത വസ്ത്രങ്ങൾ",
      "catHandwovenTextiles": "കൈത്തറി തുണിത്തരങ്ങൾ",
      "catWoodenHandicrafts": "മരപ്പണികൾ",
      "catBrassMetalware": "ഓട്, പിച്ചള പാത്രങ്ങൾ",
      "catTerracotta": "മൺപാത്രങ്ങൾ",
      "catLeatherCrafts": "തുകൽ കരകൗശലവസ്തുക്കൾ",
      "catFootwear": "ചെരിപ്പുകൾ",
      "catJewelry": "കൈകൊണ്ട് നിർമ്മിച്ച ആഭരണങ്ങൾ",
      "catPaintings": "പരമ്പരാഗത ചിത്രങ്ങൾ",
      "catBamboo": "മുള, ചൂരൽ ഉൽപ്പന്നങ്ങൾ",
      "catHomeDecor": "ഗൃഹാലങ്കാരം",
      "catOther": "മറ്റുള്ളവ"
    }
  };

  final dir = Directory('c:/KarigarSethu/lib/l10n');
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.arb'));

  for (var file in files) {
    final filename = file.uri.pathSegments.last;
    final lang = filename.replaceAll('app_', '').replaceAll('.arb', '');
    
    if (translations.containsKey(lang)) {
      final content = file.readAsStringSync();
      Map<String, dynamic> json = jsonDecode(content);
      
      // Append translations
      json.addAll(translations[lang]!);
      
      // Format with 2 spaces
      const encoder = JsonEncoder.withIndent('  ');
      file.writeAsStringSync(encoder.convert(json) + '\n');
      print('Updated $filename');
    }
  }
}
