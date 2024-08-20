// Haveno Plus extends the features of Haveno, supporting mobile devices and more.
// Copyright (C) 2024 Craig Shave (KewbitXMR)
//
// Contact Email: kewbitxmr@protonmail.com
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.

// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:system_tray/system_tray.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class SystemTrayManager {
  final SystemTray _systemTray = SystemTray();
  final Menu _menu = Menu();
  String _iconPath = '';

  Future<void> initSystemTray() async {
    // Export icon to temporary directory
    await _exportIconToTempDir('app_icon');

    await _systemTray.initSystemTray(iconPath: _iconPath);
    _systemTray.setTitle("Haveno");
    _systemTray.setToolTip("Haveno Status");

    // Register system tray event handler
    _systemTray.registerSystemTrayEventHandler((eventName) {
      debugPrint("eventName: $eventName");
      if (eventName == kSystemTrayEventClick) {
        _showAppWindow();
      } else if (eventName == kSystemTrayEventRightClick) {
        _systemTray.popUpContextMenu();
      }
    });

    await _menu.buildFrom([
      MenuItemLabel(
        label: 'Show Haveno',
        onClicked: (menuItem) => _showAppWindow(),
      ),
      MenuSeparator(),
      MenuItemLabel(
        label: 'Tor Daemon: Running',
        enabled: false,
      ),
      MenuItemLabel(
        label: 'Haveno Daemon: Running',
        enabled: false,
      ),
      MenuItemLabel(
        label: 'Monero Daemon: Running',
        enabled: false,
      ),
      MenuSeparator(),
      MenuItemLabel(
        label: 'Quit Haveno',
        onClicked: (menuItem) => _quitApp(),
      ),
    ]);

    _systemTray.setContextMenu(_menu);
  }

  Future<void> _exportIconToTempDir(String iconName) async {
    final byteData = await rootBundle.load('assets/icon/$iconName.${Platform.isWindows ? 'ico' : 'png'}');
    final buffer = byteData.buffer;
    final tempDir = await getTemporaryDirectory();
    _iconPath = '${tempDir.path}/$iconName.${Platform.isWindows ? 'ico' : 'png'}';
    await File(_iconPath).writeAsBytes(
      buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );
  }

  void _showAppWindow() {
    // This either needs to launch the app, or bring it to the front
  }

  void _quitApp() {
    // Just need to Quit the haveno  app, perhapas this needs to be done via app window title or read PID file
  }

}




