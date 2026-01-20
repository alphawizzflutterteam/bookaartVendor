import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:sixvalley_vendor_app/view/screens/addProduct/add_product_screen.dart';

import '../utill/dimensions.dart';

class AppDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final String hintText;
  final IconData hintIcon;
  final ValueChanged<T?> onChanged;
  final EdgeInsetsGeometry? margin;

  const AppDropdown({Key? key,

    required this.items,
    required this.value,
    required this.onChanged,
    this.hintText = 'Select',
    this.hintIcon = Icons.countertops,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: margin ??
          const EdgeInsets.only(
            left: Dimensions.paddingSizeLarge,
            right: Dimensions.paddingSizeLarge,
            bottom: Dimensions.paddingSizeSmall,
            top: Dimensions.paddingSizeSmall,
          ),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).hintColor.withOpacity(.35),
        ),
        borderRadius:
        BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<T>(
          isExpanded: true,
          hint: Row(
            children: [
              Expanded(
                child: Text(
                  hintText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(
                item.toString().capitalize(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
              .toList(),
          value: value,
          onChanged: onChanged,
          iconStyleData: IconStyleData(
            icon: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Icon(
                Icons.arrow_forward_ios_outlined,
                color: Theme.of(context).primaryColor,
              ),
            ),
            iconSize: 14,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 14, right: 14),
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 8,
            scrollbarTheme: ScrollbarThemeData(
              radius: Radius.circular(40),
              thickness: MaterialStatePropertyAll(6),
              thumbVisibility: MaterialStatePropertyAll(true),
            ),
          ),
        ),
      ),
    );
  }
}
