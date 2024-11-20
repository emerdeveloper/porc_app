import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({
    super.key,
    required this.titleText,
    required this.items,
    this.onChanged,
    this.hintText,
    this.value,
    this.isEnable = true,
  });

  final String titleText;
  final List<String> items; // Lista de opciones
  final String? value; // Valor seleccionado
  final void Function(String?)? onChanged; // Callback para cambios
  final String? hintText;
  final bool isEnable;

  @override
  Widget build(BuildContext context) {
    return buildTitle(
      title: titleText,
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: value,
          onChanged: isEnable ? onChanged : null,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          dropdownColor: Colors.white,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: hintText,
            filled: true,
            fillColor: isEnable ? Colors.grey.withOpacity(0.1) : Colors.grey.shade300,
          ),
          style: const TextStyle(fontSize: 16, color: Colors.black),
          icon: const Icon(Icons.arrow_drop_down),
          isExpanded: true, // Hace que el ancho del dropdown se ajuste al contenedor
        ),
      ),
    );
  }

  Widget buildTitle({
    required String title,
    required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          child,
        ],
      );
}
