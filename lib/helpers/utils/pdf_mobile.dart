///Dart imports

// ignore: avoid_web_libraries_in_flutter
import 'dart:io';
import 'package:open_file/open_file.dart' as open_file;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:file_selector/file_selector.dart';

///To save the pdf file in the device
Future<void> launchFile(List<int> bytes, String fileName) async {
  String? path;
  if (Platform.isWindows) {
    final FileSaveLocation? result =
        await getSaveLocation(suggestedName: fileName);
    path = result?.path;
    final File file =
        // File(Platform.isWindows ? '$path\\$fileName' : '$path/$fileName');
        File('$path');
    await file.writeAsBytes(bytes, flush: true);
    await Process.run('start', <String>['$path'], runInShell: true);
  }
  if (Platform.isAndroid || Platform.isIOS) {
    Directory directory;
    directory = await path_provider.getTemporaryDirectory();
    final file = File("${directory.absolute.path}/$fileName");
    await file.writeAsBytes(bytes, flush: true);
    await open_file.OpenFile.open(file.path);
  }

  /* if (Platform.isAndroid || Platform.isIOS) {
    //Launch the file (used open_file package)
    await open_file.OpenFile.open('$path/$fileName');
  } else if (Platform.isWindows) {
  } else if (Platform.isMacOS) {
    await Process.run('open', <String>['$path/$fileName'], runInShell: true);
  } else if (Platform.isLinux) {
    await Process.run('xdg-open', <String>['$path/$fileName'],
        runInShell: true);
  }*/
}
