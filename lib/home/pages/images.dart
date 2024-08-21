import 'dart:convert';

import 'package:application/home/pages/fullscreen.dart';
import 'package:application/models/image.model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;

class ImagesPage extends ConsumerStatefulWidget {
  const ImagesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ImagesPageState();
}

class _ImagesPageState extends ConsumerState<ImagesPage> {
  Future<List<ImageModel>> _fetchImages() async {
    try {
      List<ImageModel> images = [];
      const String url =
          'https://api.unsplash.com/photos/?client_id=G9Dr_pZrsmoMddTOEixELG_JewIA47tlzsLm-ma-zaU';
      final data = await http.get(Uri.parse(url));
      if (data.statusCode != 200) throw data.body;
      final json = jsonDecode(data.body);
      for (var item in json) {
        images.add(ImageModel.fromJson(item));
      }
      return images;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: FutureBuilder<List<ImageModel>>(
        future: _fetchImages(),
        builder: (_, snapshot) {
          final list = snapshot.data;

          if (snapshot.hasError) return const Center(child: Icon(Icons.error));

          if ((list ?? []).isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverQuiltedGridDelegate(
              crossAxisCount: 4,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              repeatPattern: QuiltedGridRepeatPattern.inverted,
              pattern: const [
                QuiltedGridTile(2, 2),
                QuiltedGridTile(1, 1),
                QuiltedGridTile(1, 1),
                QuiltedGridTile(1, 2),
              ],
            ),
            itemCount: list?.length,
            itemBuilder: (_, i) => MaterialButton(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              color: Colors.grey.withOpacity(.5),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FullscreenPage(data: list![i]),
                ),
              ),
              child: CachedNetworkImage(
                imageUrl: list?[i].urls?.small ?? '',
                fit: BoxFit.cover,
                progressIndicatorBuilder: (_, url, prg) => Center(
                  child: CircularProgressIndicator(
                    value: prg.progress,
                    strokeWidth: 1,
                  ),
                ),
                errorWidget: (_, url, error) {
                  return const Center(child: Icon(Icons.error));
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
