import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_frontend_psychology_app/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key, required this.imageUrl, required this.onUpload});

  final String? imageUrl;
  final void Function(String imageUrl) onUpload;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            width: 150,
            height: 150,
            child: imageUrl != null
                ? Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: Colors.grey,
                    child: const Center(child: Text("Sem imagem")),
                  )),
        const SizedBox(height: 12),
        ElevatedButton(
            onPressed: () async {
              try {
                final ImagePicker picker = ImagePicker();
                final XFile? image =
                    await picker.pickImage(source: ImageSource.gallery);

                if (image == null) {
                  return;
                }

                EasyLoading.show(status: 'Editando foto...');
                final imageExtension = image.path.split('.').last.toLowerCase();

                final imageBytes = await image.readAsBytes();
                final userId = supabase.auth.currentUser!.id;
                final imagePath = '/$userId/profile';

                await supabase.storage.from('profiles').uploadBinary(
                      imagePath,
                      imageBytes,
                      fileOptions: FileOptions(
                        upsert: true,
                        contentType: 'image/$imageExtension',
                      ),
                    );

                String imageUrl =
                    supabase.storage.from('profiles').getPublicUrl(imagePath);

                imageUrl = Uri.parse(imageUrl).replace(queryParameters: {
                  't': DateTime.now().millisecondsSinceEpoch.toString()
                }).toString();

                onUpload(imageUrl);
              } catch (e) {
                EasyLoading.showError(
                  'Erro inesperado, verifique sua conexão com a internet',
                );
                print(e);
              } finally {
                EasyLoading.dismiss();
              }
            },
            child: const Text("Upload"))
      ],
    );
  }
}
