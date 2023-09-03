import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/client_model.dart';
import '../../../models/user_model.dart';
import '../../../shared/style/input_decoration.dart';

class UserProfileEdit extends StatefulWidget {
  late UserProfile userProfile;
  late Client client;

  UserProfileEdit({
    required this.userProfile,
    required this.client,
  });

  @override
  _UserProfileEditState createState() => _UserProfileEditState();
}

class _UserProfileEditState extends State<UserProfileEdit> {
  // Controllers for text fields
  TextEditingController nameController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cepController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController religionController = TextEditingController();
  TextEditingController relationshipStatusController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController fatherOccupationController = TextEditingController();
  TextEditingController motherNameController = TextEditingController();
  TextEditingController motherOccupationController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize the controllers with the current values
    nameController.text = widget.userProfile.name;
    cpfController.text = widget.userProfile.cpf;
    phoneController.text = widget.userProfile.phone;
    //birthDateController.text = widget.userProfile.birthDate ?? '';
    cityController.text = widget.userProfile.city ?? '';
    stateController.text = widget.userProfile.state ?? '';
    cepController.text = widget.userProfile.cep ?? '';
    descriptionController.text = widget.userProfile.description ?? '';
    genderController.text = widget.userProfile.gender ?? '';
    religionController.text = widget.client.religion ?? '';
    //relationshipStatusController.text = widget.client.relationshipStatus ?? '';
    fatherNameController.text = widget.client.fatherName ?? '';
    fatherOccupationController.text = widget.client.fatherOccupation ?? '';
    motherNameController.text = widget.client.motherName ?? '';
    motherOccupationController.text = widget.client.motherOccupation ?? '';

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFormField(
              controller: nameController,
              decoration: ProjectInputDecorations.textFieldDecoration(
                labelText: 'Name *',
                prefixIcon: Icons.person,
              ),
            ),
            TextFormField(
              controller: cpfController,
              decoration: ProjectInputDecorations.textFieldDecoration(
                labelText: 'CPF *',
                prefixIcon: Icons.credit_card,
              ),
            ),
            TextFormField(
              controller: phoneController,
              decoration: ProjectInputDecorations.textFieldDecoration(
                labelText: 'Phone *',
                prefixIcon: Icons.phone,
              ),
            ),
            TextFormField(
              controller: birthDateController,
              decoration: ProjectInputDecorations.textFieldDecoration(
                labelText: 'Birth Date',
                prefixIcon: Icons.date_range,
              ),
            ),
            TextFormField(
              controller: cityController,
              decoration: ProjectInputDecorations.textFieldDecoration(
                labelText: 'City',
                prefixIcon: Icons.location_city,
              ),
            ),
            TextFormField(
              controller: stateController,
              decoration: ProjectInputDecorations.textFieldDecoration(
                labelText: 'State',
                prefixIcon: Icons.location_on,
              ),
            ),
            TextFormField(
              controller: cepController,
              decoration: ProjectInputDecorations.textFieldDecoration(
                labelText: 'CEP',
                prefixIcon: Icons.location_searching,
              ),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: ProjectInputDecorations.textFieldDecoration(
                labelText: 'Description',
                prefixIcon: Icons.description,
              ),
            ),
            TextFormField(
              controller: genderController,
              decoration: ProjectInputDecorations.textFieldDecoration(
                labelText: 'Gender',
                prefixIcon: Icons.person_outline,
              ),
            ),
            TextFormField(
              controller: religionController,
              decoration: ProjectInputDecorations.textFieldDecoration(
                labelText: 'Religion',
                prefixIcon: Icons.accessibility_new,
              ),
            ),
            TextFormField(
              controller: relationshipStatusController,
              decoration: ProjectInputDecorations.textFieldDecoration(
                labelText: 'Relationship Status',
                prefixIcon: Icons.favorite,
              ),
            ),
            TextFormField(
              controller: fatherNameController,
              decoration: ProjectInputDecorations.textFieldDecoration(
                labelText: "Father's Name",
                prefixIcon: Icons.person_outline,
              ),
            ),
            TextFormField(
              controller: fatherOccupationController,
              decoration: ProjectInputDecorations.textFieldDecoration(
                labelText: "Father's Occupation",
                prefixIcon: Icons.work,
              ),
            ),
            TextFormField(
              controller: motherNameController,
              decoration: ProjectInputDecorations.textFieldDecoration(
                labelText: "Mother's Name",
                prefixIcon: Icons.person_outline,
              ),
            ),
            TextFormField(
              controller: motherOccupationController,
              decoration: ProjectInputDecorations.textFieldDecoration(
                labelText: "Mother's Occupation",
                prefixIcon: Icons.work,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
