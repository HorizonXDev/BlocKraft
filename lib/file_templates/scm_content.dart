class ScmContent {
  final String content;

  ScmContent(String screenName, String appName, String packageName)
      : content = '''
#|
\$JSON
{"authURL":[],"YaVersion":"228","Source":"Form","Properties":{"\$Name":"$screenName","\$Type":"Form","\$Version":"31","Uuid":"0","Title":"$screenName","PackageName":"$packageName","AppName":"$appName","AccentColor":"&HFF1300E8"}}
|#''';
}