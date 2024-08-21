import 'package:application/models/image.model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FullscreenPage extends ConsumerStatefulWidget {
  final ImageModel data;
  const FullscreenPage({super.key, required this.data});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FullscreenPageState();
}

class _FullscreenPageState extends ConsumerState<FullscreenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: CachedNetworkImage(
        imageUrl: widget.data.urls?.small ?? '',
        fit: BoxFit.contain,
        height: double.infinity,
        width: double.infinity,
        progressIndicatorBuilder: (_, url, prg) => Center(
          child: CircularProgressIndicator(value: prg.progress),
        ),
        errorWidget: (_, url, error) {
          return const Center(child: Icon(Icons.error));
        },
      ),
    );
  }
}
