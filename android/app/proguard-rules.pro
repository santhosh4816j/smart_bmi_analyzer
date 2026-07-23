# Add project-specific ProGuard rules here.
# Flutter's own rules are applied automatically by the Flutter Gradle plugin.

# Keep Hive generated adapters and model classes (reflection-free, but keep
# names stable in case of future @HiveField reflection usage).
-keep class com.beachweather.smartbmianalyzer.** { *; }
