import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_camera_overlay/model.dart';
import 'package:flutter_camera_overlay/overlay_shape.dart';

typedef XFileCallback = void Function(XFile file);

class CameraOverlay extends StatefulWidget {
  const CameraOverlay(
    this.controller,
    this.model,
    this.onCapture, {
    Key? key,
    this.enableCaptureButton = true,
    this.label,
    this.info,
    this.loadingWidget,
    this.infoMargin,
  }) : super(key: key);
  final CameraController controller;
  final OverlayModel model;
  final bool enableCaptureButton;
  final XFileCallback onCapture;
  final String? label;
  final String? info;
  final Widget? loadingWidget;
  final EdgeInsets? infoMargin;

  @override
  _FlutterCameraOverlayState createState() => _FlutterCameraOverlayState();
}

class _FlutterCameraOverlayState extends State<CameraOverlay> {
  _FlutterCameraOverlayState();

  @override
  void dispose() {
    this.widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingWidget = widget.loadingWidget ??
        Container(
          color: Colors.white,
          height: double.infinity,
          width: double.infinity,
          child: const Align(
            alignment: Alignment.center,
            child: Text('loading camera'),
          ),
        );

    if (!this.widget.controller.value.isInitialized) {
      return loadingWidget;
    }

    Widget? infoWidget;

    if (widget.label != null || widget.info != null) {
      infoWidget = Align(
        alignment: Alignment.topCenter,
        child: Container(
            margin: widget.infoMargin ??
                const EdgeInsets.only(top: 100, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.label != null)
                  Text(
                    widget.label!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700),
                  ),
                if (widget.info != null)
                  Flexible(
                    child: Text(
                      widget.info!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            )),
      );

      if (this.widget.model.orientation == OverlayOrientation.landscape) {
        infoWidget = new RotatedBox(quarterTurns: 1, child: infoWidget);
      }
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      fit: StackFit.expand,
      children: [
        CameraPreview(this.widget.controller),
        OverlayShape(widget.model),
        if (infoWidget != null) infoWidget!,
        if (widget.enableCaptureButton)
          Align(
            alignment:
                this.widget.model.orientation == OverlayOrientation.landscape
                    ? Alignment.bottomLeft
                    : Alignment.bottomCenter,
            child: Material(
                color: Colors.transparent,
                child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black12,
                      shape: BoxShape.circle,
                    ),
                    margin: this.widget.model.orientation ==
                            OverlayOrientation.landscape
                        ? EdgeInsets.only(bottom: 70, left: 25)
                        : EdgeInsets.all(25),
                    child: IconButton(
                      enableFeedback: true,
                      color: Colors.white,
                      onPressed: () async {
                        for (int i = 10; i > 0; i--) {
                          await HapticFeedback.vibrate();
                        }

                        XFile file = await this.widget.controller.takePicture();
                        widget.onCapture(file);
                      },
                      icon: const Icon(
                        Icons.camera,
                      ),
                      iconSize: 72,
                    ))),
          ),
      ],
    );
  }
}
