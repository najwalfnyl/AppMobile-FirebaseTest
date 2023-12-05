part of '../main.dart';

class _EditDataSheet extends StatefulWidget {
  const _EditDataSheet({
    Key? key,
    required this.name,
    required this.boolC,
    required this.num,
  }) : super(key: key);
  final String name;
  final bool boolC;
  final int num;

  @override
  State<_EditDataSheet> createState() => __EditDataSheetState();
}

class __EditDataSheetState extends State<_EditDataSheet> {
  TextEditingController? nameController;
  TextEditingController? numController;
  bool boolC = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    boolC = widget.boolC;
    numController = TextEditingController(text: widget.num.toString());
  }

  @override
  void dispose() {
    nameController!.dispose();
    numController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;

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
                label: 'Nama Field'),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              value: boolC,
              items: [true, false].map((bool role) {
                return DropdownMenuItem<bool>(
                  value: role,
                  child: Text(role.toString()),
                );
              }).toList(),
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: InputDecoration(
                labelText: 'Field bool',
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Colors.black12, width: 1)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Colors.black12, width: 1)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue, width: 1)),
              ),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    boolC = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
                controller: numController,
                textInputType: TextInputType.number,
                label: 'Field Num'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final secondDoc = db
                    .collection('first_collection')
                    .doc('second_document')
                    .collection('collection_inside_doc')
                    .doc('Doc A');
                secondDoc.set({
                  'Name': nameController!.text,
                  'test_bool': boolC,
                  'test_num': int.parse(numController!.text),
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
