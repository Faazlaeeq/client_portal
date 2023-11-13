import 'package:flutter/material.dart';

class TextEditingControllerManager {
  Map<String, TextEditingController> controllers = {};

  Widget buildTextFormField(String feildName,
      {InputDecoration? decoration,
      bool autovalidate = true,
      required String? Function(String?) validatorFunc,
      int minlines = 1,
      int maxlines = 1,
      TextInputType inputType = TextInputType.text,
      bool isprice = false}) {
    if (!controllers.containsKey(feildName)) {
      controllers[feildName] = TextEditingController();
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controllers[feildName],
        keyboardType: inputType,
        autovalidateMode: autovalidate
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        minLines: minlines,
        maxLines: maxlines,
        decoration: (decoration != null)
            ? decoration
            : InputDecoration(
                labelText: feildName,
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(),
                suffixText: isprice ? "\$" : ""),
        validator: (value) => validatorFunc(value),
      ),
    );
  }
}
