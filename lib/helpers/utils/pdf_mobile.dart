///Dart imports

// ignore: avoid_web_libraries_in_flutter
import 'dart:io';
import 'package:open_file/open_file.dart' as open_file;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:file_selector/file_selector.dart';

///To save the pdf file in the device
Future<void> launchFile(List<int> bytes, String fileName) async {
  String? path;
  if (Platform.isAndroid ||
      Platform.isIOS ||
      Platform.isLinux ||
      Platform.isWindows) {
    /*final Directory directory =
        await path_provider.getApplicationSupportDirectory();
    path = directory.path;*/
    final FileSaveLocation? result =
        await getSaveLocation(suggestedName: fileName);
    path = result?.path;
  } else {
    path = await PathProviderPlatform.instance.getApplicationSupportPath();
  }
  final File file =
      // File(Platform.isWindows ? '$path\\$fileName' : '$path/$fileName');
      File(Platform.isWindows ? '$path' : '$path');
  await file.writeAsBytes(bytes, flush: true);
  if (Platform.isAndroid || Platform.isIOS) {
    //Launch the file (used open_file package)
    await open_file.OpenFile.open('$path/$fileName');
  } else if (Platform.isWindows) {
    await Process.run('start', <String>['$path'], runInShell: true);
  } else if (Platform.isMacOS) {
    await Process.run('open', <String>['$path/$fileName'], runInShell: true);
  } else if (Platform.isLinux) {
    await Process.run('xdg-open', <String>['$path/$fileName'],
        runInShell: true);
  }
}
