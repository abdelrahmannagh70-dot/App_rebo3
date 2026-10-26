import 'package:app3/core/routes/app_route.dart';
import 'package:app3/core/themes/app_colors.dart';
import 'package:app3/features/auth/data/models/book_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookItem extends StatelessWidget {
  final Products? products;
  const BookItem({super.key, this.products});

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: (){
      Navigator.pushNamed(
          context, AppRoutes.bookDetailsScreen,
          arguments: products?.id
      );
    }
      ,child: Container(
        padding: EdgeInsets.all(20.r),
        width: 163.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                //"https://i.pinimg.com/1200x/80/f4/5d/80f45ddc495a78791034deef285a0dde.jpg"
                products?.image??"",
                width: 140,
                height: 175,
                fit: BoxFit.cover,
              ),
            ),
            20.verticalSpace,
      
            Text(products?.name??"",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            8.verticalSpace,
            Row(
              children: [
                Expanded(child: Text(products?.price??"")),
                
                IconButton(
                  onPressed: () {
                    context.setLocale(Locale("en"));
                  },
                  icon: Icon(Icons.shopping_cart),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
