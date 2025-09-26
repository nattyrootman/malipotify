import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/core/constants/constants.dart';

class CategoryListWidgedt extends ConsumerWidget {
  const CategoryListWidgedt({super.key});

  @override
  Widget build(BuildContext context, WidgetRef re) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: SizedBox(
        height: 48,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          separatorBuilder: (_, _) => SizedBox(width: 8),
          itemCount: categories.length,
      
          itemBuilder: (context, int index) {
            final selectIndex = categories[index];
              
            return SizedBox(
               height: 54,
                
                child: Chip(
                  backgroundColor: Theme.of(context).cardColor,
                  label: Text(selectIndex)
                
              ),
            );
          },
        ),
      ),
    );
  }
}
