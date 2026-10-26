import 'package:app3/core/widget/custom_text_from_feild.dart';
import 'package:app3/features/auth/data/models/book_model.dart';
import 'package:app3/features/presentaion/cubit/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'widgets/book_item.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.verticalSpace,

              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                  10.horizontalSpace,

                  Expanded(
                    child: CustomTextFromFeild(
                      hintText: "Search",
                      autofocus: true,
                      onChanged: (v) {
                        context.read<HomeCubit>().search(v ?? "");
                      },
                    ),
                  ),
                ],
              ),

              20.verticalSpace,

              Expanded(
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state is SearchLoading) {
                      return Skeletonizer(
                        enabled: true,
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: .52,
                                mainAxisSpacing: 14.h,
                                crossAxisSpacing: 18.w,
                              ),
                          itemBuilder:
                              (context, index) => BookItem(
                                products: Products(
                                  name: "name test",
                                  price: "322",
                                  image: "",
                                ),
                              ),
                          itemCount: 8,
                        ),
                      );
                    } else if (state is SearchSuccess) {
                      final products = state.products ?? [];

                      if (products.isEmpty) {
                        return const Center(child: Text("No books found"));
                      }

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: .52,
                          mainAxisSpacing: 14.h,
                          crossAxisSpacing: 18.w,
                        ),
                        itemBuilder:
                            (context, index) =>
                                BookItem(products: products[index]),
                        itemCount: products.length,
                      );
                    } else {
                      return const Center(child: Text("Search for a book"));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
