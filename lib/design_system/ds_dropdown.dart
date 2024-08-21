import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'Text/ds_text.dart';
import 'colors.dart';

class DSDropdown extends StatelessWidget {
  final String hintText;
  final List<String> items;
  final String? selectedValue;
  final void Function(String?) onChanged;
  final void Function(String?) onSaved;
  final List<IconData>? icons;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final Color? disabledBorderColor;
  final bool? isHorizontalPadding;

  const DSDropdown({
    super.key,
    required this.hintText,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    required this.onSaved,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.disabledBorderColor,
    this.icons,
    this.isHorizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: DropdownButtonFormField2<String>(
        isExpanded: true,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              vertical: 10, horizontal: isHorizontalPadding == true ? 0 : 8),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: enabledBorderColor ?? DSColors.greyScaleMediumGrey,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: focusedBorderColor ?? DSColors.primaryActionState1,
              width: 1,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: disabledBorderColor ?? DSColors.greyScaleMediumGrey,
              width: 1,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        hint: DSStandardText(
          text: 'Select $hintText',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: DSColors.greyScaleDarkGrey,
          overflow: TextOverflow.ellipsis,
        ),
        value: selectedValue,
        items: items
            .map(
              (item) => DropdownMenuItem<String>(
                value: item,
                child: Row(
                  children: [
                    icons == null
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Icon(icons![0]),
                          ),
                    Expanded(
                      child: DSStandardText(
                        textAlign: TextAlign.start,
                        text: item,
                        fontSize: 16,
                        color: DSColors.primaryTextBlack,
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
        onSaved: onSaved,
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.black45,
          ),
          iconSize: 24,
        ),
        dropdownStyleData: const DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(1),
              topRight: Radius.circular(1),
              bottomRight: Radius.circular(4),
              bottomLeft: Radius.circular(4),
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(160, 84, 160, 0.24),
                offset: Offset(0, 4),
                blurRadius: 8,
                spreadRadius: 0,
              )
            ],
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.only(left: 8, right: 4),
        ),
      ),
    );
  }
}
