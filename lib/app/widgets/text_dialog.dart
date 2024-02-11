import 'dart:core';

import 'package:flutter/material.dart';
import 'package:hris/app/styles/styles.dart';

class TextDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmButtonText;
  final String? cancelButtonText;
  final Function(String) onConfirm;
  final Function onCancel;
  final TextEditingController controller;

  const TextDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmButtonText,
    this.cancelButtonText,
    required this.onConfirm,
    required this.onCancel,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min, // Set mainAxisSize to min
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Material(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Buttons
                    Column(
                      children: [
                        TextField(
                          controller: controller,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Styles.themeDark),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Styles.themeLight),
                              borderRadius: BorderRadius.circular(9),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: h * 0.02),
                    Row(
                      children: [
                        if (confirmButtonText != null)
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(0, 45),
                                backgroundColor: Styles.themeDark,
                                foregroundColor: const Color(0xFFFFFFFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                String textValue = controller.text;
                                await onConfirm(textValue);
                              },
                              child: Text(
                                confirmButtonText!,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        const SizedBox(width: 10),
                        if (cancelButtonText != null)
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(0, 45),
                                backgroundColor: Styles.themeCancel,
                                foregroundColor: const Color(0xFFFFFFFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await onCancel();
                              },
                              child: Text(
                                cancelButtonText!,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
