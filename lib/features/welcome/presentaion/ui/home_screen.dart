import 'package:app3/features/auth/data/models/book_model.dart';
import 'package:app3/features/presentaion/cubit/cubit/home_cubit.dart';
import 'package:app3/features/welcome/presentaion/ui/widget/book_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
               BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is GetBestSellerLoading) {
                    return Expanded(
                      child: Skeletonizer(
                        enabled: true,
                        child: GridView.builder(

                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: .52,
                            mainAxisSpacing: 14.h,
                            crossAxisSpacing: 18.w,
                          ),
                          itemBuilder: (context, index) => BookItem(
                            products: Products(
                              name:"name test",
                                price:"322",
                              image: ""
                        
                            )
                          ),
                          itemCount: 8,
                        ),
                      ),
                    );;
                  } else if (state is GetBestSellerSuccess) {
                    return Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: .52,
                          mainAxisSpacing: 14.h,
                          crossAxisSpacing: 18.w,
                        ),
                        itemBuilder: (context, index) => BookItem(
                          products: state.products?[index],
                        ),
                        itemCount: state.products?.length,
                      ),
                    );
                  } else {
                    return Text("error");
                  }
                },
              ),
            
          ],
        ),
      ),
    );
  }
}
