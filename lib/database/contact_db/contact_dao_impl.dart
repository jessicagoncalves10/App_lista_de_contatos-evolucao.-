import 'package:my_contacts/database/contact_db/contact_dao.dart';
import 'package:my_contacts/database/contact_db/contact_db.dart';
import 'package:my_contacts/models/contact.dart';
import 'package:sqflite/sqflite.dart';


class ContactDaoImp implements ContactDao {
  static const String _tableName = 'contact_table';
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _email = 'email';
  static const String _phone = 'phone';
  static const String _imageDirectory = 'image_directory';
  static const String sqlTable = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY, '
      '$_name TEXT, '
      '$_email TEXT, '
      '$_phone TEXT, '
      '$_imageDirectory TEXT)';

  @override
  Future<int> saveContact(Contact contact) async {
    Database? contactDb = await ContactConnection.db();
    final int newContactId = await contactDb!.insert(_tableName, toMap(contact));

    return newContactId;
  }

  @override
  Future<Contact?> getContact(int contactId) async {
    Database? contactDb = await ContactConnection.db();

    List<Map<String, dynamic>> contactMap = await contactDb!.query(
      _tableName, 
      columns: [_id, _name, _email, _phone, _imageDirectory], 
      where: '$_id = ?', 
      whereArgs: [contactId], 
    );

    if (contactMap.isNotEmpty) {
      return fromMap(contactMap.first);
    } else {
      return null;
    }
  }

  @override
  Future<List<Contact>> getAllContact() async {
    Database? contactDb = await ContactConnection.db();

    List<Map<String, dynamic>> contactsMap = await contactDb!.rawQuery(
      'SELECT * FROM $_tableName', 
    );

    List<Contact> contactsObj = [];

    for (Map<String, dynamic> contact in contactsMap) {
      contactsObj.add(fromMap(contact));
    }

    return contactsObj;
  }

  @override
  Future<int> deleteContact(int contactId) async {
    Database? contactDb = await ContactConnection.db();

    final int deletedContactId = await contactDb!.delete(
      _tableName, 
      where: '$_id = ?', 
      whereArgs: [contactId], 
    );

    return deletedContactId;
  }

  @override
  Future<int> updateContact(Contact contactObj) async {
    Database? contactDb = await ContactConnection.db();

    final int updatedContactId = await contactDb!.update(
      _tableName, 
      toMap(contactObj), 
      where: '$_id = ?', 
      whereArgs: [contactObj.id], 
    );

    return updatedContactId;
  }

  @override
  Future<int?> getContactQuantity() async {
    Database? contactDb = await ContactConnection.db();

    List<Map<String, dynamic>> contactsMap = await contactDb!.rawQuery(
      'SELECT COUNT(*) FROM $_tableName', 
    );

    return Sqflite.firstIntValue(contactsMap);
  }

  @override
  Future closeDb() async {
    Database? contactDb = await ContactConnection.db();
    contactDb!.close();
  }

  @override
  Contact fromMap(Map<String, dynamic> contactMap) {
    final Contact contactObj = Contact(
      id: contactMap[_id],
      name: contactMap[_name],
      email: contactMap[_email],
      phone: contactMap[_phone],
      imageDirectory: contactMap[_imageDirectory],
    );

    return contactObj;
  }

  @override
  Map<String, dynamic> toMap(Contact contactObj) {
    Map<String, dynamic> contactMap = {
      _id: contactObj.id,
      _name: contactObj.name,
      _email: contactObj.email,
      _phone: contactObj.phone,
      _imageDirectory: contactObj.imageDirectory,
    };

    return contactMap;
  }
}
