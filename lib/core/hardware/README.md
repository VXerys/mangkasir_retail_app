# hardware

Folder ini menyimpan abstraksi untuk perangkat keras eksternal yang dipakai kasir, yaitu printer thermal Bluetooth dan barcode scanner. File di sini membungkus library hardware (seperti `flutter_pos_printer_platform` dan `mobile_scanner`) agar BLoC dan UseCase tidak bergantung langsung ke library tersebut.

Contoh file: `printer_service.dart`
