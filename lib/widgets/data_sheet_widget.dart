part of '../main.dart';

class _EditSheet extends StatefulWidget {
  const _EditSheet({
    Key? key,
    required this.name,
    required this.id,
    required this.classC,
  }) : super(key: key);
  final String name;
  final String id;
  final String classC;

  @override
  State<_EditSheet> createState() => __EditSheetState();
}

class __EditSheetState extends State<_EditSheet> {
  TextEditingController? nameController;
  TextEditingController? idController;
  TextEditingController? classController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    idController = TextEditingController(text: widget.id);
    classController = TextEditingController(text: widget.classC);
  }

  @override
  void dispose() {
    nameController!.dispose();
    classController!.dispose();
    idController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const Text(
              'Edit data',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            CustomTextField(
                controller: nameController,
                textInputType: TextInputType.name,
                label: 'Nama'),
            const SizedBox(height: 16),
            CustomTextField(
                controller: idController,
                textInputType: TextInputType.number,
                label: 'Nomor identitas'),
            const SizedBox(height: 16),
            CustomTextField(
                controller: classController,
                textInputType: TextInputType.name,
                label: 'Kelas'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final db = FirebaseFirestore.instance;
                final firstDoc =
                    db.collection('first_collection').doc('first_document');
                firstDoc.set({
                  'name': nameController!.text,
                  'id': int.parse(idController!.text),
                  'class': classController!.text,
                }).then((value) => Navigator.of(context).pop());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: const Center(
                  child: Text(
                'Edit data',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
