class ProjectProperties {
  String appName;
  String packageName;
  String developerName;

  ProjectProperties(this.appName, this.packageName, this.developerName);

  String getContentForNiotron() {
    return '''
#
#Mon Sep 09 14:49:24 UTC 2024
sizing=Responsive
androidminsdk=19
color.primary.dark=&HFF3700B3
color.primary=&HFF6200EE
color.accent=&HFF1300E8
aname=$appName
cleartextenabled=True
defaultfilescope=App
packagename=$packageName
main=com.niotron.$developerName.$appName.Screen1
androidtargetsdk=34
source=../src
actionbar=True
splashenabled=True
useslocation=False
assets=../assets
build=../build
name=$appName
showlistsasjson=True
theme=Theme.MaterialComponents.Light.DarkActionBar
versioncode=1
versionname=1.0
  ''';
  }
}
