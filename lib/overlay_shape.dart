import 'package:flutter/material.dart';
import 'package:flutter_camera_overlay/model.dart';

class OverlayShape extends StatelessWidget {
  const OverlayShape(this.model, {Key? key}) : super(key: key);

  final OverlayModel model;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    var size = media.size;
    var ratio = model.ratio as double;
    var wRatio = model.widthRatio as double;

    double width = size.shortestSide * wRatio;
    double height = width / ratio;

    if (model.orientation == OverlayOrientation.landscape) {
      height = size.longestSide * wRatio;
      width = height / ratio;
    }

    double radius =
        model.cornerRadius == null ? 0 : model.cornerRadius! * height;
    return Stack(
      children: [
        Align(
            alignment: Alignment.center,
            child: Container(
              width: width,
              height: height,
              decoration: ShapeDecoration(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radius),
                      side: const BorderSide(width: 1, color: Colors.white))),
            )),
        ColorFiltered(
          colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.srcOut),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(radius)),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
