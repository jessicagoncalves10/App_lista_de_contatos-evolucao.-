import 'package:my_contacts/database/contact_db/contact_dao_impl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;


class ContactConnection {

  static Database? _db; 

  static Future<Database?> db() async {
    if (_db == null) {
     
      final databasesPath = await getDatabasesPath();
      final contactsDbPath = path.join(databasesPath, 'contacts.db');

      _db = await openDatabase(
        contactsDbPath, 
        version: 1, 
        onCreate: (Database db, int version) async {
          await db.execute(ContactDaoImp.sqlTable);
        },
      );
    }

    return _db;
  }
}
