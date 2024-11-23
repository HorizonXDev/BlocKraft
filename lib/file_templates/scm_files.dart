import 'dart:convert';

class SCMFiles {
  String authURL;
  int yaVersion;
  String source;
  Map<String, dynamic> properties;
  String name;
  String type;
  int version;
  int uuid;
  String title;
  String packageName;
  String appName;
  String accentColor;

  SCMFiles(
    this.authURL,
    this.yaVersion,
    this.source,
    this.properties,
    this.name,
    this.type,
    this.version,
    this.uuid,
    this.title,
    this.packageName,
    this.appName,
    this.accentColor,
  );

  factory SCMFiles.fromJson(Map<String, dynamic> json) {
    return SCMFiles(
      json['authURL'],
      json['YaVersion'],
      json['Source'],
      json['Properties'],
      json['Properties']['\$Name'],
      json['Properties']['\$Type'],
      json['Properties']['\$Version'],
      json['Properties']['Uuid'],
      json['Properties']['Title'],
      json['Properties']['PackageName'],
      json['Properties']['AppName'],
      json['Properties']['AccentColor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authURL': authURL,
      'YaVersion': yaVersion,
      'Source': source,
      'Properties': {
        '\$Name': name,
        '\$Type': type,
        '\$Version': version,
        'Uuid': uuid,
        'Title': title,
        'PackageName': packageName,
        'AppName': appName,
        'AccentColor': accentColor,
      },
    };
  }

  static SCMFiles parseContent(String content) {
    final jsonString = content.split('\$JSON')[1].split('|#')[0].trim();
    final jsonData = jsonDecode(jsonString);
    return SCMFiles.fromJson(jsonData);
  }
}