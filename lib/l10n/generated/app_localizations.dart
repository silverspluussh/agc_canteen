import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('es'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'AGC Canteen'**
  String get appTitle;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'Android POS canteen system for AGC'**
  String get appDescription;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @pin.
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get pin;

  /// No description provided for @fingerprint.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint'**
  String get fingerprint;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @enterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN'**
  String get enterPin;

  /// No description provided for @placeFinger.
  ///
  /// In en, this message translates to:
  /// **'Place your finger'**
  String get placeFinger;

  /// No description provided for @biometricLogin.
  ///
  /// In en, this message translates to:
  /// **'Login with fingerprint'**
  String get biometricLogin;

  /// No description provided for @pos.
  ///
  /// In en, this message translates to:
  /// **'POS'**
  String get pos;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @inventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventory;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @emptyCart.
  ///
  /// In en, this message translates to:
  /// **'Cart is empty'**
  String get emptyCart;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get addToCart;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get item;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @pay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get pay;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @mobileMoney.
  ///
  /// In en, this message translates to:
  /// **'Mobile Money'**
  String get mobileMoney;

  /// No description provided for @card.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get card;

  /// No description provided for @selectPayment.
  ///
  /// In en, this message translates to:
  /// **'Select payment method'**
  String get selectPayment;

  /// No description provided for @paymentConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Payment confirmed'**
  String get paymentConfirmed;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @printReceipt.
  ///
  /// In en, this message translates to:
  /// **'Print receipt'**
  String get printReceipt;

  /// No description provided for @receipt.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get receipt;

  /// No description provided for @receiptNumber.
  ///
  /// In en, this message translates to:
  /// **'Receipt #'**
  String get receiptNumber;

  /// No description provided for @cashier.
  ///
  /// In en, this message translates to:
  /// **'Cashier'**
  String get cashier;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @sync.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get sync;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get syncNow;

  /// No description provided for @syncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing...'**
  String get syncing;

  /// No description provided for @syncComplete.
  ///
  /// In en, this message translates to:
  /// **'Sync complete'**
  String get syncComplete;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @noOrders.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get noOrders;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'You are offline'**
  String get offline;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change app language'**
  String get changeLanguage;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light mode'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @systemMode.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemMode;

  /// No description provided for @posSettings.
  ///
  /// In en, this message translates to:
  /// **'POS Settings'**
  String get posSettings;

  /// No description provided for @managePosSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage POS devices and configurations'**
  String get managePosSubtitle;

  /// No description provided for @deviceInfo.
  ///
  /// In en, this message translates to:
  /// **'Device Info'**
  String get deviceInfo;

  /// No description provided for @posPeripherals.
  ///
  /// In en, this message translates to:
  /// **'Peripherals'**
  String get posPeripherals;

  /// No description provided for @posRegisteredDevices.
  ///
  /// In en, this message translates to:
  /// **'Registered Devices'**
  String get posRegisteredDevices;

  /// No description provided for @posNoDevicesFound.
  ///
  /// In en, this message translates to:
  /// **'No devices on this terminal'**
  String get posNoDevicesFound;

  /// No description provided for @posAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get posAvailable;

  /// No description provided for @posUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get posUnavailable;

  /// No description provided for @posSynced.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get posSynced;

  /// No description provided for @posPrinter.
  ///
  /// In en, this message translates to:
  /// **'Printer'**
  String get posPrinter;

  /// No description provided for @posFingerprintScanner.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint Scanner'**
  String get posFingerprintScanner;

  /// No description provided for @posBarcodeScanner.
  ///
  /// In en, this message translates to:
  /// **'Barcode Scanner'**
  String get posBarcodeScanner;

  /// No description provided for @posCardReader.
  ///
  /// In en, this message translates to:
  /// **'Card Reader'**
  String get posCardReader;

  /// No description provided for @posFirmwareVersion.
  ///
  /// In en, this message translates to:
  /// **'Firmware Version'**
  String get posFirmwareVersion;

  /// No description provided for @printerSettings.
  ///
  /// In en, this message translates to:
  /// **'Printer settings'**
  String get printerSettings;

  /// No description provided for @connectPrinter.
  ///
  /// In en, this message translates to:
  /// **'Connect printer'**
  String get connectPrinter;

  /// No description provided for @disconnectPrinter.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnectPrinter;

  /// No description provided for @printerConnected.
  ///
  /// In en, this message translates to:
  /// **'Printer connected'**
  String get printerConnected;

  /// No description provided for @printerDisconnected.
  ///
  /// In en, this message translates to:
  /// **'No printer connected'**
  String get printerDisconnected;

  /// No description provided for @scanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning...'**
  String get scanning;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @dailySales.
  ///
  /// In en, this message translates to:
  /// **'Daily sales'**
  String get dailySales;

  /// No description provided for @totalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total revenue'**
  String get totalRevenue;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get exportPdf;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get thisMonth;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @stock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stock;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @addProduct.
  ///
  /// In en, this message translates to:
  /// **'Add product'**
  String get addProduct;

  /// No description provided for @editProduct.
  ///
  /// In en, this message translates to:
  /// **'Edit product'**
  String get editProduct;

  /// No description provided for @deleteProduct.
  ///
  /// In en, this message translates to:
  /// **'Delete product'**
  String get deleteProduct;

  /// No description provided for @lowStock.
  ///
  /// In en, this message translates to:
  /// **'Low stock'**
  String get lowStock;

  /// No description provided for @outOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get outOfStock;

  /// No description provided for @allProducts.
  ///
  /// In en, this message translates to:
  /// **'All products'**
  String get allProducts;

  /// No description provided for @mealType.
  ///
  /// In en, this message translates to:
  /// **'Meal type'**
  String get mealType;

  /// No description provided for @breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get breakfast;

  /// No description provided for @lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get lunch;

  /// No description provided for @snack.
  ///
  /// In en, this message translates to:
  /// **'Snack'**
  String get snack;

  /// No description provided for @beverage.
  ///
  /// In en, this message translates to:
  /// **'Beverage'**
  String get beverage;

  /// No description provided for @invalidPin.
  ///
  /// In en, this message translates to:
  /// **'Invalid PIN'**
  String get invalidPin;

  /// No description provided for @fingerprintFailed.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint verification failed'**
  String get fingerprintFailed;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session expired, please login again'**
  String get sessionExpired;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error'**
  String get networkError;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Please try again'**
  String get tryAgain;

  /// No description provided for @adminPin.
  ///
  /// In en, this message translates to:
  /// **'Admin PIN'**
  String get adminPin;

  /// No description provided for @enterAdminPin.
  ///
  /// In en, this message translates to:
  /// **'Enter admin code to access settings'**
  String get enterAdminPin;

  /// No description provided for @accessGranted.
  ///
  /// In en, this message translates to:
  /// **'Access granted'**
  String get accessGranted;

  /// No description provided for @adminAccountInfo.
  ///
  /// In en, this message translates to:
  /// **'Admin account information'**
  String get adminAccountInfo;

  /// No description provided for @pushPullSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Push & pull records with the server'**
  String get pushPullSubtitle;

  /// No description provided for @viewReportsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View POS orders and overcharges'**
  String get viewReportsSubtitle;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @appearanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Light, dark, or system theme'**
  String get appearanceSubtitle;

  /// No description provided for @appUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update App'**
  String get appUpdate;

  /// No description provided for @checkLatestVersion.
  ///
  /// In en, this message translates to:
  /// **'Check for the latest version'**
  String get checkLatestVersion;

  /// No description provided for @accountInfo.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInfo;

  /// No description provided for @adminRole.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get adminRole;

  /// No description provided for @signOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOutConfirm;

  /// No description provided for @signOutWarning.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out? You will need to log in again.'**
  String get signOutWarning;

  /// No description provided for @chargebacks.
  ///
  /// In en, this message translates to:
  /// **'Chargebacks'**
  String get chargebacks;

  /// No description provided for @filterOrders.
  ///
  /// In en, this message translates to:
  /// **'Filter Orders'**
  String get filterOrders;

  /// No description provided for @filterChargebacks.
  ///
  /// In en, this message translates to:
  /// **'Filter Chargebacks'**
  String get filterChargebacks;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @selectDateRange.
  ///
  /// In en, this message translates to:
  /// **'Select Date Range'**
  String get selectDateRange;

  /// No description provided for @clearDate.
  ///
  /// In en, this message translates to:
  /// **'Clear Date'**
  String get clearDate;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @searchOrderHint.
  ///
  /// In en, this message translates to:
  /// **'Search order, staff, meal…'**
  String get searchOrderHint;

  /// No description provided for @dataSynchronization.
  ///
  /// In en, this message translates to:
  /// **'Data Synchronization'**
  String get dataSynchronization;

  /// No description provided for @systemReady.
  ///
  /// In en, this message translates to:
  /// **'System Ready'**
  String get systemReady;

  /// No description provided for @lastSuccessfulSync.
  ///
  /// In en, this message translates to:
  /// **'Last successful sync'**
  String get lastSuccessfulSync;

  /// No description provided for @never.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get never;

  /// No description provided for @syncResults.
  ///
  /// In en, this message translates to:
  /// **'Sync Results'**
  String get syncResults;

  /// No description provided for @syncErrors.
  ///
  /// In en, this message translates to:
  /// **'Sync Errors'**
  String get syncErrors;

  /// No description provided for @noDataChanges.
  ///
  /// In en, this message translates to:
  /// **'No data changes detected.'**
  String get noDataChanges;

  /// No description provided for @pushedRecords.
  ///
  /// In en, this message translates to:
  /// **'pushed'**
  String get pushedRecords;

  /// No description provided for @pulledRecords.
  ///
  /// In en, this message translates to:
  /// **'pulled'**
  String get pulledRecords;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get dinner;

  /// No description provided for @latestVersion.
  ///
  /// In en, this message translates to:
  /// **'You are on the latest version.'**
  String get latestVersion;

  /// No description provided for @langUpdateMessage.
  ///
  /// In en, this message translates to:
  /// **'Language updated. Restart the app to apply.'**
  String get langUpdateMessage;

  /// No description provided for @adminInfo.
  ///
  /// In en, this message translates to:
  /// **'Admin Information'**
  String get adminInfo;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @data.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @signOutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out of your admin account'**
  String get signOutSubtitle;

  /// No description provided for @staffManagement.
  ///
  /// In en, this message translates to:
  /// **'Staff Management'**
  String get staffManagement;

  /// No description provided for @manageStaffSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Register and remove fingerprints for staff access'**
  String get manageStaffSubtitle;

  /// No description provided for @fingerprintRegistered.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint registered'**
  String get fingerprintRegistered;

  /// No description provided for @noFingerprintRegistered.
  ///
  /// In en, this message translates to:
  /// **'No fingerprint registered'**
  String get noFingerprintRegistered;

  /// No description provided for @addFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Add Fingerprint'**
  String get addFingerprint;

  /// No description provided for @deleteFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Delete Fingerprint'**
  String get deleteFingerprint;

  /// No description provided for @deleteFingerprintConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this fingerprint?'**
  String get deleteFingerprintConfirm;

  /// No description provided for @enrollFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Enroll Fingerprint'**
  String get enrollFingerprint;

  /// No description provided for @placeFingerToEnroll.
  ///
  /// In en, this message translates to:
  /// **'Place your finger on the scanner to enroll'**
  String get placeFingerToEnroll;

  /// No description provided for @mealName.
  ///
  /// In en, this message translates to:
  /// **'Meal Name'**
  String get mealName;

  /// No description provided for @staffName.
  ///
  /// In en, this message translates to:
  /// **'Staff Name'**
  String get staffName;

  /// No description provided for @orderCode.
  ///
  /// In en, this message translates to:
  /// **'Order Code'**
  String get orderCode;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @startingApp.
  ///
  /// In en, this message translates to:
  /// **'Starting Application...'**
  String get startingApp;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInSubtitle;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @adminAccess.
  ///
  /// In en, this message translates to:
  /// **'Admin Access'**
  String get adminAccess;

  /// No description provided for @staffSignIn.
  ///
  /// In en, this message translates to:
  /// **'Staff Sign In'**
  String get staffSignIn;

  /// No description provided for @enter6Digits.
  ///
  /// In en, this message translates to:
  /// **'Please enter all 6 digits.'**
  String get enter6Digits;

  /// No description provided for @incorrectCode.
  ///
  /// In en, this message translates to:
  /// **'Incorrect code. Try again.'**
  String get incorrectCode;

  /// No description provided for @syncData.
  ///
  /// In en, this message translates to:
  /// **'Sync Data'**
  String get syncData;

  /// No description provided for @noChargebacks.
  ///
  /// In en, this message translates to:
  /// **'No chargebacks found'**
  String get noChargebacks;

  /// No description provided for @failedToLoadMeals.
  ///
  /// In en, this message translates to:
  /// **'Failed to load meals: {error}'**
  String failedToLoadMeals(String error);

  /// No description provided for @cancelOrderAndExit.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order & Exit'**
  String get cancelOrderAndExit;

  /// No description provided for @cancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order?'**
  String get cancelOrder;

  /// No description provided for @cancelOrderConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel the current session and return to the login screen?'**
  String get cancelOrderConfirm;

  /// No description provided for @noContinue.
  ///
  /// In en, this message translates to:
  /// **'No, continue'**
  String get noContinue;

  /// No description provided for @yesSignOut.
  ///
  /// In en, this message translates to:
  /// **'Yes, sign out'**
  String get yesSignOut;

  /// No description provided for @selectMeal.
  ///
  /// In en, this message translates to:
  /// **'Select a meal'**
  String get selectMeal;

  /// No description provided for @searchByNameOrType.
  ///
  /// In en, this message translates to:
  /// **'Search by name or type...'**
  String get searchByNameOrType;

  /// No description provided for @noMealsMatch.
  ///
  /// In en, this message translates to:
  /// **'No meals match \"{query}\"'**
  String noMealsMatch(String query);

  /// No description provided for @selectMealToBegin.
  ///
  /// In en, this message translates to:
  /// **'Select a meal to begin order'**
  String get selectMealToBegin;

  /// No description provided for @confirmOrder.
  ///
  /// In en, this message translates to:
  /// **'Confirm Order'**
  String get confirmOrder;

  /// No description provided for @meal.
  ///
  /// In en, this message translates to:
  /// **'Meal'**
  String get meal;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @changeMeal.
  ///
  /// In en, this message translates to:
  /// **'Change Meal'**
  String get changeMeal;

  /// No description provided for @placeOrder.
  ///
  /// In en, this message translates to:
  /// **'Place Order'**
  String get placeOrder;

  /// No description provided for @placing.
  ///
  /// In en, this message translates to:
  /// **'Placing...'**
  String get placing;

  /// No description provided for @orderPlaced.
  ///
  /// In en, this message translates to:
  /// **'Order Placed'**
  String get orderPlaced;

  /// No description provided for @receiptPrinted.
  ///
  /// In en, this message translates to:
  /// **'Receipt printed successfully.'**
  String get receiptPrinted;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @manualPosOrder.
  ///
  /// In en, this message translates to:
  /// **'Manual POS order'**
  String get manualPosOrder;

  /// No description provided for @manualPosOrderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create single and group POS orders'**
  String get manualPosOrderSubtitle;

  /// No description provided for @singleOrder.
  ///
  /// In en, this message translates to:
  /// **'Single Order'**
  String get singleOrder;

  /// No description provided for @groupOrder.
  ///
  /// In en, this message translates to:
  /// **'Group Order'**
  String get groupOrder;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
