import 'dart:async';

import 'package:flutter/services.dart';

enum DirectoryStructure { FOR_DATE, FOR_EVENT, SINGLE_FILE_FOR_DAY }
enum LogFileExtension { TXT, CSV, LOG, NONE }
enum LogLevel { INFO, WARNING, ERROR, SEVERE }
enum LogType {
  Device,
  Location,
  Notification,
  Network,
  Navigation,
  History,
  Tasks,
  Jobs,
  Errors
}
enum TimeStampFormat {
  DATE_FORMAT_1,
  DATE_FORMAT_2,
  TIME_FORMAT_FULL_JOINED,
  TIME_FORMAT_FULL_1,
  TIME_FORMAT_FULL_2,
  TIME_FORMAT_24_FULL,
  TIME_FORMAT_READABLE,
  TIME_FORMAT_SIMPLE
}

class FlutterLogs {
  static const MethodChannel channel = const MethodChannel('flutter_logs');

  static Future<String> initLogs(
      {List<LogLevel> logLevelsEnabled,
      List<String> logTypesEnabled,
      int logsRetentionPeriodInDays = 14,
      int zipsRetentionPeriodInDays = 3,
      bool autoDeleteZipOnExport = false,
      bool autoClearLogs = true,
      bool autoExportErrors = true,
      bool encryptionEnabled = false,
      String encryptionKey = "",
      DirectoryStructure directoryStructure,
      bool logSystemCrashes = true,
      bool isDebuggable = true,
      bool debugFileOperations = true,
      bool attachTimeStamp = true,
      bool attachNoOfFiles = true,
      TimeStampFormat timeStampFormat,
      LogFileExtension logFileExtension,
      bool zipFilesOnly = false,
      String logsWriteDirectoryName = "",
      String logsExportZipFileName = "",
      String logsExportDirectoryName = "",
      int singleLogFileSize = 2,
      bool enabled = true}) async {
    var directoryStructureString = _getDirectoryStructure(directoryStructure);
    var timeStampFormatString = _getTimeStampFormat(timeStampFormat);
    var logFileExtensionString = _getLogFileExtension(logFileExtension);
    var logLevelsEnabledList = logLevelsEnabled.map((e) => _getLogLevel(e));

    return await channel.invokeMethod('initLogs', <String, dynamic>{
      'logLevelsEnabled': logLevelsEnabledList.join(','),
      'logTypesEnabled': logTypesEnabled.join(','),
      'logsRetentionPeriodInDays': logsRetentionPeriodInDays,
      'zipsRetentionPeriodInDays': zipsRetentionPeriodInDays,
      'autoDeleteZipOnExport': autoDeleteZipOnExport,
      'autoClearLogs': autoClearLogs,
      'autoExportErrors': autoExportErrors,
      'encryptionEnabled': encryptionEnabled,
      'encryptionKey': encryptionKey,
      'directoryStructure': directoryStructureString,
      'logSystemCrashes': logSystemCrashes,
      'isDebuggable': isDebuggable,
      'debugFileOperations': debugFileOperations,
      'attachTimeStamp': attachTimeStamp,
      'attachNoOfFiles': attachNoOfFiles,
      'timeStampFormat': timeStampFormatString,
      'logFileExtension': logFileExtensionString,
      'zipFilesOnly': zipFilesOnly,
      'savePath': logsWriteDirectoryName,
      'zipFileName': logsExportZipFileName,
      'exportPath': logsExportDirectoryName,
      'singleLogFileSize': singleLogFileSize,
      'enabled': enabled,
    });
  }

  static Future<String> initMQTT(
      {String topic = "",
      String brokerUrl = "",
      String certificate = "",
      String clientId = ""}) async {
    final ByteData bytes = await rootBundle.load('assets/$certificate');
    return await channel.invokeMethod('initMQTT', <String, dynamic>{
      'topic': topic,
      'brokerUrl': brokerUrl,
      'certificate': bytes.buffer.asUint8List(),
      'clientId': clientId
    });
  }

  static Future<String> setMetaInfo({
    String appId = "",
    String appName = "",
    String appVersion = "",
    String language = "",
    String deviceId = "",
    String environmentId = "",
    String environmentName = "",
    String organizationId = "",
    String userId = "",
    String userName = "",
    String userEmail = "",
    String deviceSerial = "",
    String deviceBrand = "",
    String deviceName = "",
    String deviceManufacturer = "",
    String deviceModel = "",
    String deviceSdkInt = "",
    String latitude = "",
    String longitude = "",
    String labels = "",
  }) async {
    return await channel.invokeMethod('setMetaInfo', <String, dynamic>{
      'appId': appId,
      'appName': appName,
      'appVersion': appVersion,
      'language': language,
      'deviceId': deviceId,
      'environmentId': environmentId,
      'environmentName': environmentName,
      'organizationId': organizationId,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'deviceSerial': deviceSerial,
      'deviceBrand': deviceBrand,
      'deviceName': deviceName,
      'deviceManufacturer': deviceManufacturer,
      'deviceModel': deviceModel,
      'deviceSdkInt': deviceSdkInt,
      'latitude': latitude,
      'longitude': longitude,
      'labels': labels
    });
  }

  static void logThis(
      {String tag = "",
      String subTag = "",
      String logMessage = "",
      String level = ""}) async {
    await channel.invokeMethod('logThis', <String, dynamic>{
      'tag': tag,
      'subTag': subTag,
      'logMessage': logMessage,
      'level': level
    });
  }

  static String _getDirectoryStructure(DirectoryStructure type) {
    return type.toString().split('.').last;
  }

  static String _getLogFileExtension(LogFileExtension type) {
    return type.toString().split('.').last;
  }

  static String _getLogLevel(LogLevel type) {
    return type.toString().split('.').last;
  }

  static String _getLogType(LogType type) {
    return type.toString().split('.').last;
  }

  static String _getTimeStampFormat(TimeStampFormat type) {
    return type.toString().split('.').last;
  }
}
