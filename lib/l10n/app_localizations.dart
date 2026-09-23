import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('ml'),
    Locale('mr'),
    Locale('ta'),
    Locale('te'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'KarigarSethu'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'AI Virtual Business Manager for Artisans'**
  String get appTagline;

  /// No description provided for @loginWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get loginWelcome;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @registerPrompt.
  ///
  /// In en, this message translates to:
  /// **'New to KarigarSethu?'**
  String get registerPrompt;

  /// No description provided for @registerNow.
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get registerNow;

  /// No description provided for @dashboardHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get dashboardHome;

  /// No description provided for @dashboardMarket.
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get dashboardMarket;

  /// No description provided for @dashboardProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get dashboardProfile;

  /// No description provided for @addNewProduct.
  ///
  /// In en, this message translates to:
  /// **'Add New Product'**
  String get addNewProduct;

  /// No description provided for @businessOverview.
  ///
  /// In en, this message translates to:
  /// **'Business Overview'**
  String get businessOverview;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @enquiries.
  ///
  /// In en, this message translates to:
  /// **'Enquiries'**
  String get enquiries;

  /// No description provided for @totalSales.
  ///
  /// In en, this message translates to:
  /// **'Total Sales (This Month)'**
  String get totalSales;

  /// No description provided for @artisanInsight.
  ///
  /// In en, this message translates to:
  /// **'Artisan Insight'**
  String get artisanInsight;

  /// No description provided for @insightDescription.
  ///
  /// In en, this message translates to:
  /// **'Your Terracotta Vases are receiving 30% more views than last week. Consider adding more clay products to your catalog to boost sales!'**
  String get insightDescription;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBtn;

  /// No description provided for @artisanUser.
  ///
  /// In en, this message translates to:
  /// **'Artisan User'**
  String get artisanUser;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productName;

  /// No description provided for @spokenDescription.
  ///
  /// In en, this message translates to:
  /// **'Spoken Description (Local Language)'**
  String get spokenDescription;

  /// No description provided for @englishDescription.
  ///
  /// In en, this message translates to:
  /// **'Product Description (English)'**
  String get englishDescription;

  /// No description provided for @translateToEnglish.
  ///
  /// In en, this message translates to:
  /// **'Translate to English'**
  String get translateToEnglish;

  /// No description provided for @productPrice.
  ///
  /// In en, this message translates to:
  /// **'Product Price'**
  String get productPrice;

  /// No description provided for @captureImage.
  ///
  /// In en, this message translates to:
  /// **'Capture Image'**
  String get captureImage;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'Listening...'**
  String get listening;

  /// No description provided for @submitProduct.
  ///
  /// In en, this message translates to:
  /// **'Submit Product'**
  String get submitProduct;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @productDescriptionHindi.
  ///
  /// In en, this message translates to:
  /// **'Product Description (Hindi)'**
  String get productDescriptionHindi;

  /// No description provided for @productCategory.
  ///
  /// In en, this message translates to:
  /// **'Product Category'**
  String get productCategory;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @generateCatalog.
  ///
  /// In en, this message translates to:
  /// **'Generate Catalog'**
  String get generateCatalog;

  /// No description provided for @generating.
  ///
  /// In en, this message translates to:
  /// **'Generating...'**
  String get generating;

  /// No description provided for @generateAiPrice.
  ///
  /// In en, this message translates to:
  /// **'✨ Generate AI Price'**
  String get generateAiPrice;

  /// No description provided for @aiPricingEngine.
  ///
  /// In en, this message translates to:
  /// **'AI Pricing Engine'**
  String get aiPricingEngine;

  /// No description provided for @baseCosts.
  ///
  /// In en, this message translates to:
  /// **'1. Base Costs (₹)'**
  String get baseCosts;

  /// No description provided for @rawMaterialCost.
  ///
  /// In en, this message translates to:
  /// **'Raw Material Cost'**
  String get rawMaterialCost;

  /// No description provided for @labourCost.
  ///
  /// In en, this message translates to:
  /// **'Labour Cost'**
  String get labourCost;

  /// No description provided for @packagingCost.
  ///
  /// In en, this message translates to:
  /// **'Packaging Cost'**
  String get packagingCost;

  /// No description provided for @otherCosts.
  ///
  /// In en, this message translates to:
  /// **'Other Costs'**
  String get otherCosts;

  /// No description provided for @calculateOptimalPrice.
  ///
  /// In en, this message translates to:
  /// **'Calculate Optimal Price'**
  String get calculateOptimalPrice;

  /// No description provided for @calculating.
  ///
  /// In en, this message translates to:
  /// **'Calculating...'**
  String get calculating;

  /// No description provided for @competitivePrice.
  ///
  /// In en, this message translates to:
  /// **'Competitive Price'**
  String get competitivePrice;

  /// No description provided for @recommendedPrice.
  ///
  /// In en, this message translates to:
  /// **'Recommended Price'**
  String get recommendedPrice;

  /// No description provided for @applyRecommendedPrice.
  ///
  /// In en, this message translates to:
  /// **'Apply Recommended Price'**
  String get applyRecommendedPrice;

  /// No description provided for @waitingForTranscription.
  ///
  /// In en, this message translates to:
  /// **'Waiting for transcription...'**
  String get waitingForTranscription;

  /// No description provided for @transcribingAudio.
  ///
  /// In en, this message translates to:
  /// **'Transcribing audio...'**
  String get transcribingAudio;

  /// No description provided for @failedToCalculatePrice.
  ///
  /// In en, this message translates to:
  /// **'Failed to calculate AI price. Please try again or check your internet connection.'**
  String get failedToCalculatePrice;

  /// No description provided for @errorGenerating.
  ///
  /// In en, this message translates to:
  /// **'Error generating:'**
  String get errorGenerating;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'en',
    'hi',
    'ml',
    'mr',
    'ta',
    'te',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'ml':
      return AppLocalizationsMl();
    case 'mr':
      return AppLocalizationsMr();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
