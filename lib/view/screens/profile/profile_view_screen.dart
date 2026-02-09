import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/profile_provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_app_bar.dart';
import 'package:sixvalley_vendor_app/view/base/custom_image.dart';
import 'package:sixvalley_vendor_app/view/screens/profile/profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/model/response/seller_info.dart';
import '../../../provider/localization_provider.dart';
import '../../../provider/shop_info_provider.dart';
import 'PdfView.dart';

class ProfileScreenView extends StatefulWidget {
  const ProfileScreenView({Key? key}) : super(key: key);

  @override
  State<ProfileScreenView> createState() => _ProfileScreenViewState();
}

class _ProfileScreenViewState extends State<ProfileScreenView> {
  @override
  void initState() {
    super.initState();
    final profile = Provider.of<ProfileProvider>(context, listen: false);
    if (profile.userInfoModel == null) {
      profile.getSellerInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated('my_profile', context),
        isBackButtonExist: true,
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profile, _) {
          if (profile.userInfoModel == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final user = profile.userInfoModel!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Column(
              children: [
                _profileCard(context, user),
                const SizedBox(height: 16),
                // _servicesCard(context),
                // const SizedBox(height: 16),
                portfolioImageCard(context),
                // profile.userInfoModel?.pdf == null
                //     ? SizedBox.shrink()
                //     :
                portfolioPdfCard(context),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(getTranslated('app_version', context)!),
                    const SizedBox(width: 4),
                    const Text(AppConstants.appVersion),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget portfolioImageCard(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context);
    final List<String> allFiles = profile.userInfoModel?.file ?? [];
    print("ejkjwekje ${allFiles.length}");
    // final List<String> imageFiles = allFiles.where((file) {
    //   final lower = file.toLowerCase();
    //   return lower.endsWith('.png') ||
    //       lower.endsWith('.jpg') ||
    //       lower.endsWith('.jpeg') ||
    //       lower.endsWith('.webp');
    // }).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Works",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (allFiles.isEmpty) const Text("No image files uploaded"),
          if (allFiles.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: allFiles.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final file = allFiles[index];
                final fileUrl =
                    "https://bookaart.developmentalphawizz.com/public/storage/seller/$file";

                return GestureDetector(
                  onTap: () => _openImage(context, fileUrl),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: _imageTile(fileUrl),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget portfolioPdfCard(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context);
    final List<String> pdfFiles = profile.userInfoModel?.pdf ?? [];
    print("asdasdads ${profile.userInfoModel?.pdf}");
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Portfolio Certificate",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (pdfFiles.isEmpty) const Text("No PDF files uploaded"),
          if (pdfFiles.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: pdfFiles.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final fileUrl = pdfFiles[index];

                return GestureDetector(
                  onTap: () => _openPdf(fileUrl),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: _pdfTile(),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _profileCard(BuildContext context, user) {
    const double reviewIconSize = 15;

    final shopProvider = Provider.of<ShopProvider>(context);
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final isLtr =
        Provider.of<LocalizationProvider>(context, listen: false).isLtr;
    print("dasdasdas ${user.availability}");
    String formatDate(String date) {
      final parsedDate = DateTime.parse(date);
      return DateFormat('dd-MM-yyyy').format(parsedDate);
    }

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _cardDecoration(context),
          child: Column(
            children: [
              /// PROFILE INFO
              Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: ClipOval(
                      child: CustomImage(
                        image:
                            '${splashProvider.baseUrls!.sellerImageUrl}/${user.image}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user.fName} ${user.lName ?? ''}',
                          style: robotoBold.copyWith(fontSize: 18),
                        ),
                        const SizedBox(height: 4),
                        Text(user.phone ?? '', style: titilliumRegular),
                        const SizedBox(height: 4),
                        Text(
                          'Artist ID : ${user.uniqueCode}',
                          style: titilliumRegular.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(
                          width: Dimensions.iconSizeSmall,
                          child: Image.asset(Images.star)),
                      const SizedBox(height: 4),
                      Text(
                        shopProvider.shopModel?.ratting?.toStringAsFixed(1) ??
                            '0.0',
                        style: robotoTitleRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraLarge,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                          width: reviewIconSize,
                          child: Image.asset(Images.shopReview)),
                      const SizedBox(height: 4),
                      Text(
                        '${NumberFormat.compact().format(shopProvider.shopModel?.rattingCount ?? 0)} ${getTranslated('reviews', context)}',
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color:
                          user.status == 'approved' ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      user.status == 'approved'
                          ? 'Available Now'
                          : 'Not Available',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.facebook, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Icon(Icons.camera_alt, color: Colors.pink),
                  const SizedBox(width: 8),
                  const Icon(Icons.language, color: Colors.grey),
                ],
              ),
              if (user.availability != null &&
                  user.availability!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Availability',
                    style: robotoBold.copyWith(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 6),
                Column(
                  children: user.availability!.map<Widget>((Availability slot) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 16, color: Colors.black87),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${formatDate(slot.date!)} -> ${slot.from} - ${slot.to}',
                              style: titilliumRegular.copyWith(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                )
              ],
            ],
          ),
        ),
        Align(
          alignment: isLtr ? Alignment.topRight : Alignment.topLeft,
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
              child: SizedBox(
                width: Dimensions.iconSizeLarge,
                child: Image.asset(
                  Images.editProfileIcon,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _servicesCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Services & Rates',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          _ServiceRow('Portrait Painting', '₹3,000', Colors.orange),
          _ServiceRow('Digital Art', '₹2,500', Colors.blue),
          _ServiceRow('Wall Murals', '₹5,000', Colors.red),
        ],
      ),
    );
  }

  Widget _pdfTile() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.picture_as_pdf, color: Colors.red, size: 48),
        SizedBox(height: 8),
        Text("PDF File", style: TextStyle(fontSize: 14)),
      ],
    );
  }

  void _openImage(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: InteractiveViewer(
          child: Image.network(url),
        ),
      ),
    );
  }

  void _openPdf(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfViewScreen(url: url),
      ),
    );
  }

  Widget _imageTile(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 40),
      ),
    );
  }

  Widget _actionButton(BuildContext context, String text, Color color) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () {},
        child: Text(text),
      ),
    );
  }

  BoxDecoration _cardDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 10,
          offset: Offset(0, 6),
        ),
      ],
    );
  }
}

class _ServiceRow extends StatelessWidget {
  final String title;
  final String price;
  final Color color;

  const _ServiceRow(this.title, this.price, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(Icons.circle, size: 10, color: color),
          const SizedBox(width: 8),
          Expanded(child: Text(title)),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _PortfolioImage extends StatelessWidget {
  final String image;
  const _PortfolioImage(this.image);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(image, fit: BoxFit.cover),
    );
  }
}

class _PortfolioPdf extends StatelessWidget {
  final String pdfUrl;

  const _PortfolioPdf(this.pdfUrl);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(pdfUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.red.withOpacity(0.08),
          border: Border.all(color: Colors.red.withOpacity(0.4)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.picture_as_pdf, color: Colors.red, size: 40),
            SizedBox(height: 6),
            Text(
              'PDF',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
