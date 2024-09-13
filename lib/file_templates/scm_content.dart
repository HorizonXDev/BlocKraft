class ScmContent {
  final String content;

  ScmContent(String screenName, String appName)
      : content = '''
    #|
    \$JSON
    {"authURL":[],"YaVersion":"228","Source":"Form","Properties":{"\$Name":"$screenName","\$Type":"Form","\$Version":"31","Uuid":"0","Title":"$screenName","AppName":"$appName","Theme":"AppTheme.Light.DarkActionBar"}}
    |#''';
}