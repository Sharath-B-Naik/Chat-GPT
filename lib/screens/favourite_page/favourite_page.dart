import 'package:chat_gpt/constants/kcolors.dart';
import 'package:chat_gpt/models/favourite_model.dart';
import 'package:chat_gpt/services/local_storage.dart';
import 'package:chat_gpt/utils/app_utils.dart';
import 'package:chat_gpt/widgets/app_bar.dart';
import 'package:chat_gpt/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  List<FavouriteModel> favourites = [];

  @override
  void initState() {
    super.initState();
    LocalStorage.getfavourites().then((value) {
      favourites = value;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3FB),
      body: Stack(
        children: [
          Builder(builder: (context) {
            if (favourites.isEmpty) {
              return const Center(
                child: AppText(
                  "No saved items found",
                  fontWeight: FontWeight.w400,
                ),
              );
            } else {
              return ListView.separated(
                itemCount: favourites.length,
                padding: topspace(context),
                physics: const BouncingScrollPhysics(),
                separatorBuilder: (a, b) => Divider(
                  color: KColors.dark,
                  height: 30.sm,
                ),
                itemBuilder: (context, index) {
                  final favourite = favourites[index];

                  return _FavouriteCard(
                    favourite: favourite,
                    onDelete: () async {
                      favourites.removeAt(index);
                      setState(() {});
                      await LocalStorage.deletefavourite(favourite);
                    },
                  );
                },
              );
            }
          }),

          ///
          ///
          ///
          ///
          /// Top green part
          ///
          ///
          ///
          ///
          const Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: CustomAppBar(),
          ),
        ],
      ),
    );
  }
}

class _FavouriteCard extends StatelessWidget {
  const _FavouriteCard({
    Key? key,
    required this.favourite,
    required this.onDelete,
  }) : super(key: key);

  final FavouriteModel favourite;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFC0C9CE)),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(15),
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFEDEDED),
            blurRadius: 2,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.sm),
            decoration: const BoxDecoration(
              color: KColors.dark,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: AppText(
              favourite.question,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.sm),
            child: AppText(
              favourite.answer,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          const Divider(),
          Padding(
            padding: EdgeInsets.fromLTRB(10.sm, 0, 10.sm, 10.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppText(
                  DateFormat("hh:ss a\ndd-MM-yyy")
                      .format(DateTime.parse(favourite.createdAt!)),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF747474),
                ),
                const Spacer(),
                Container(
                  height: 40.sm,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(50),
                      topLeft: Radius.circular(50),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: onDelete,
                        splashRadius: 20,
                        tooltip: "Delete",
                        iconSize: 24.sm,
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.delete),
                      ),
                      IconButton(
                        onPressed: () {
                          String toCopy =
                              "${favourite.question}\n\n${favourite.answer}";
                          Clipboard.setData(ClipboardData(text: toCopy)).then(
                            (value) => AppUtils.snackBar(
                                context, "Copied to clipboard"),
                          );
                        },
                        splashRadius: 20,
                        tooltip: "Copy to clipboard",
                        iconSize: 24.sm,
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.file_copy_rounded),
                      ),
                      IconButton(
                        onPressed: () async {
                          String toShare =
                              "${favourite.question}\n\n${favourite.answer}";
                          await Share.share(toShare);
                        },
                        splashRadius: 20,
                        tooltip: "Share",
                        iconSize: 24.sm,
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.share),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
