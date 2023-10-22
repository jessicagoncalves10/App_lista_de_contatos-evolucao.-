import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_contacts/database/contact_db/contact_dao_impl.dart';
import 'package:my_contacts/main.dart';
import 'package:my_contacts/models/contact.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key, this.contact});

  final Contact? contact;

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  ContactDaoImp contactDaoImp = ContactDaoImp();

  final TextEditingController inputNameController = TextEditingController();
  final TextEditingController inputEmailController = TextEditingController();
  final TextEditingController inputPhoneController = TextEditingController();
  Contact _editedContact = Contact(name: '', email: '', phone: '');
  bool _isEditedContact = false;
  final FocusNode inputNameFocusNode = FocusNode();
  final FocusNode inputEmailFocusNode = FocusNode();
  final FocusNode inputPhoneFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _isEditedContact = true;

      _editedContact = contactDaoImp.fromMap(contactDaoImp.toMap(widget.contact!));

      inputNameController.text = _editedContact.name;
      inputEmailController.text = _editedContact.email;
      inputPhoneController.text = _editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditedContact ? 'Editar contato' : 'Adicionar novo contato'),
          centerTitle: true,
          backgroundColor: darkLightColor,
        ),
        backgroundColor: darkColor,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedContact.name.isNotEmpty) {
              if (_editedContact.email.isNotEmpty || _editedContact.phone.isNotEmpty) {
                Navigator.pop(context, _editedContact);
              } else {
                FocusScope.of(context).requestFocus(inputPhoneFocusNode);
              }
            } else {
              FocusScope.of(context).requestFocus(inputNameFocusNode);
            }
          },
          backgroundColor: mainColor,
          child: const Icon(
            Icons.check_rounded,
            color: darkColor,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () {
                  ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
                    if (value == null) return;
                    setState(() {
                      _editedContact.imageDirectory = value.path;
                    });
                  });
                },
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: _editedContact.imageDirectory != null
                          ? FileImage(File(_editedContact.imageDirectory!))
                          : const AssetImage('images/person.png') as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const Divider(),
              buildTextField('Nome:', TextInputType.name, inputNameController, (String inputValue) {
                setState(() {
                  _editedContact.name = inputValue;
                });
              }, inputNameFocusNode),
              const Divider(),
              buildTextField('E-Mail:', TextInputType.emailAddress, inputEmailController, (String inputValue) {
                setState(() {
                  _editedContact.email = inputValue;
                });
              }, inputEmailFocusNode),
              const Divider(),
              buildTextField('Telefone:', TextInputType.phone, inputPhoneController, (String inputValue) {
                setState(() {
                  _editedContact.phone = inputValue;
                });
              }, inputPhoneFocusNode),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() async {
    if (_isEditedContact) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: darkLightColor,
            titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
            title: const Text('Deseja sair sem salvar?'),
            content: const Text('Se você sair, as alterações serão perdidas.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('SIM'),
              ),
            ],
          );
        },
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  Widget buildTextField(
      String labelText, TextInputType keyboardType, TextEditingController inputController, Function onChange, FocusNode inputFocusNode) {
    return TextField(
      controller: inputController,
      focusNode: inputFocusNode,
      onChanged: (value) {
        onChange(value);
      },
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
