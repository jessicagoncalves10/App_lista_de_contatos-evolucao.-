import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_contacts/main.dart';
import 'package:my_contacts/models/contact.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({super.key, required this.contact, required this.onTap});

  final Contact contact;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Card(
        color: Color.fromARGB(255, 29, 117, 133),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(  
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: contact.imageDirectory != null
                        ? FileImage(File(contact.imageDirectory!))
                        : const AssetImage('images/foto_perfil.png') as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Nome: ${contact.name}",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text("Email: ${contact.email}",
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text("Telefone: ${contact.phone}",
                      style: const TextStyle(fontSize: 14),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
