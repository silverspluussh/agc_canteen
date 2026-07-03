# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Hardware POS SDKs and JNI bindings
-keep class com.hfteco.** { *; }
-keep class com.mediatek.** { *; }
-keep class com.justouch.** { *; }

# Keep native methods and their classes
-keepclasseswithmembernames class * {
    native <methods>;
}

# Ignore warnings for missing Play Core and Flutter classes that cause R8 to fail
-dontwarn com.google.android.play.core.**
-dontwarn io.flutter.embedding.**
