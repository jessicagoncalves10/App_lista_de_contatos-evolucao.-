import 'package:my_contacts/models/contact.dart';

abstract class ContactDao {
  Future<int> saveContact(Contact contact);

  Future<Contact?> getContact(int contactId);

  Future<List<Contact>> getAllContact();

  Future<int> deleteContact(int contactId);

  Future<int> updateContact(Contact contactObj);

  Future<int?> getContactQuantity();

  Future closeDb();

  Contact fromMap(Map<String, dynamic> contactMap);

  Map<String, dynamic> toMap(Contact contactObj);
}
