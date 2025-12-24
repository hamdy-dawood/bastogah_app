import 'package:bastoga/core/helpers/context_extension.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/domain/entities/product_object.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/cubit/products_cubit.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/cubit/products_states.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/widgets/add_product_button.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/widgets/image_picking/product_images_view.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/widgets/product_description_field.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/widgets/product_name_field.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/widgets/product_price_field.dart';
import 'package:bastoga/modules/app_versions/merchant_version/products/presentation/widgets/product_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/components/components.dart';
import '../../../../../../core/dependancy_injection/dependancy_injection.dart';
import '../../../profile/presentation/cubit/merchant_profile_cubit.dart';
import '../widgets/edit_product_button.dart';
import '../widgets/image_picking/dotted_images_container.dart';
import '../widgets/is_product_active.dart';
import '../widgets/is_product_new.dart';
import '../widgets/is_product_popular.dart';

class AddEditProductScreen extends StatelessWidget {
  const AddEditProductScreen({super.key, required this.productObject});

  final ProductObject productObject;

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MerchantProfileCubit>()..getProductCategories(),
      child: BlocProvider.value(
        value: getIt<MerchantProductsCubit>(),
        child: BlocListener<MerchantProfileCubit, MerchantProfileStates>(
          listener: (context, state) {
            if (productObject.isEdit && state is GetProductCategoriesSuccessState) {
              final category =
                  context
                      .read<MerchantProfileCubit>()
                      .productCategories!
                      .where((element) => element.id == productObject.product!.category)
                      .toList();

              if (category.isNotEmpty) {
                ProductType.productTypeController.text = category.first.name;
              }
            }
          },
          child: _AddProductBody(productObject: productObject),
        ),
      ),
    );
  }
}

class _AddProductBody extends StatefulWidget {
  final ProductObject productObject;

  const _AddProductBody({required this.productObject});

  @override
  State<_AddProductBody> createState() => _AddProductBodyState();
}

class _AddProductBodyState extends State<_AddProductBody> {
  @override
  void initState() {
    ProductNameField.productNameController.clear();
    ProductPriceField.productPriceController.clear();
    ProductType.productCategory = '';
    ProductDescriptionField.productDescriptionController.clear();
    IsProductNewView.isSelected = false;
    IsProductPopularView.isSelected = false;
    IsProductActiveView.isSelected = false;

    if (widget.productObject.isEdit) {
      context.read<MerchantProductsCubit>().myProductImages.clear();
      context.read<MerchantProductsCubit>().myProductImages = List.from(
        widget.productObject.product!.images,
      );

      ProductNameField.productNameController.text = widget.productObject.product!.name;
      ProductPriceField.productPriceController.text =
          widget.productObject.product!.price.toString();
      context.read<MerchantProductsCubit>().calculateFinalPrice(
        productObject: widget.productObject,
      );
      ProductType.productCategory = widget.productObject.product!.category ?? '';
      ProductDescriptionField.productDescriptionController.text =
          widget.productObject.product!.desc;
      IsProductNewView.isSelected = widget.productObject.product!.isNew;
      IsProductPopularView.isSelected = widget.productObject.product!.isPopular;
      IsProductActiveView.isSelected = !widget.productObject.product!.isActive;
    }
    super.initState();
  }

  //
  // num getFinalPrice() {
  //   num productPrice = num.parse(ProductPriceField.productPriceController.text);
  //   return productPrice - widget.productObject.product!.discountAmount - widget.productObject.product!.offerDiscount;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            context.pop();
          },
        ),
        title: Text(widget.productObject.isEdit ? 'تعديل المنتج' : 'منتج جديد'),
        actions: [
          widget.productObject.isEdit
              ? EditProductButton(productId: widget.productObject.product!.id)
              : const AddProductButton(),
        ],
      ),
      body: Form(
        key: AddEditProductScreen.formKey,
        child: ListView(
          children: [
            const _PicksImages(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  if (widget.productObject.isEdit) const IsProductActiveView(),
                  const ProductNameField(),
                  ProductPriceField(productObject: widget.productObject),
                  if (widget.productObject.isEdit) ...[
                    if (widget.productObject.product!.discountAmount > 0)
                      DiscountAmountField(
                        discountAmount: widget.productObject.product!.discountAmount.toString(),
                      ),
                    if (widget.productObject.product!.discountAmount > 0)
                      FinalPriceField(finalPrice: widget.productObject.product!.finalPrice),
                  ],
                  const ProductType(),
                  const ProductDescriptionField(),
                  const IsProductNewView(),
                  const IsProductPopularView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PicksImages extends StatelessWidget {
  const _PicksImages();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MerchantProductsCubit, MerchantProductsStates>(
      builder: (context, state) {
        // return const SizedBox();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child:
              context.read<MerchantProductsCubit>().productImages.isEmpty &&
                      context.read<MerchantProductsCubit>().myProductImages.isEmpty
                  ? DottedImagesContainerView(
                    onTap: () => context.read<MerchantProductsCubit>().pickProductImages(),
                  )
                  : const ProductImagesView(),
        );
      },
    );
  }
}

class DiscountAmountField extends StatelessWidget {
  final String discountAmount;

  const DiscountAmountField({super.key, required this.discountAmount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('قيمة الخصم', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          BlocBuilder<MerchantProductsCubit, MerchantProductsStates>(
            builder: (context, state) {
              return CustomTextFormField(
                readOnly: true,
                controller: TextEditingController(text: discountAmount),
                hint: '0',
                keyboardType: TextInputType.number,
                // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                suffixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text("دينار عراقي", style: Theme.of(context).textTheme.bodySmall),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return '';
                  }
                  return null;
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class OfferDiscountField extends StatelessWidget {
  final String offerDiscount;

  const OfferDiscountField({super.key, required this.offerDiscount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('خصم العرض', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          BlocBuilder<MerchantProductsCubit, MerchantProductsStates>(
            builder: (context, state) {
              return CustomTextFormField(
                readOnly: true,
                controller: TextEditingController(text: offerDiscount),
                hint: '0',
                keyboardType: TextInputType.number,
                // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                suffixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text("دينار عراقي", style: Theme.of(context).textTheme.bodySmall),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return '';
                  }
                  return null;
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class FinalPriceField extends StatefulWidget {
  final num finalPrice;

  const FinalPriceField({super.key, required this.finalPrice});

  @override
  State<FinalPriceField> createState() => _FinalPriceFieldState();
}

class _FinalPriceFieldState extends State<FinalPriceField> {
  @override
  void initState() {
    context.read<MerchantProductsCubit>().finalPrice = widget.finalPrice;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('السعر النهائي', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          BlocBuilder<MerchantProductsCubit, MerchantProductsStates>(
            builder: (context, state) {
              return CustomTextFormField(
                readOnly: true,
                controller: TextEditingController(
                  text: context.read<MerchantProductsCubit>().finalPrice.toString(),
                ),
                hint: '0',
                keyboardType: TextInputType.number,
                // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                suffixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text("دينار عراقي", style: Theme.of(context).textTheme.bodySmall),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return '';
                  }
                  return null;
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
