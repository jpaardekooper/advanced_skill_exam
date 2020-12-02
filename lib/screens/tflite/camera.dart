import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:tflite/tflite.dart';
import 'dart:math' as math;

import 'models.dart';

typedef void Callback(List<dynamic> list, int h, int w);

class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Callback setRecognitions;
  final String model;

  Camera(this.cameras, this.model, this.setRecognitions);

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController controller;
  bool isDetecting = false;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    if (widget.cameras == null || widget.cameras.isEmpty) {
    } else {
      controller = CameraController(
        widget.cameras[0],
        ResolutionPreset.medium,
      );

      _initializeControllerFuture = controller.initialize().then(
        (value) {
          controller?.startImageStream((CameraImage img) {
            if (!mounted) {
              return;
            }
            if (!isDetecting) {
              isDetecting = true;

              if (widget.model == mobilenet) {
                Tflite.runModelOnFrame(
                        bytesList: img.planes.map((plane) {
                          return plane.bytes;
                        }).toList(),
                        imageHeight: img.height,
                        imageWidth: img.width,
                        numResults: 2,
                        asynch: true)
                    .then((recognitions) {
                  if (!mounted) {
                    return;
                  }

                  widget.setRecognitions(recognitions, img.height, img.width);

                  isDetecting = false;
                });
              } else if (widget.model == posenet) {
                Tflite.runPoseNetOnFrame(
                        bytesList: img.planes.map((plane) {
                          return plane.bytes;
                        }).toList(),
                        imageHeight: img.height,
                        imageWidth: img.width,
                        numResults: 2,
                        asynch: true)
                    .then((recognitions) {
                  if (!mounted) {
                    return;
                  }
                  widget.setRecognitions(recognitions, img.height, img.width);

                  isDetecting = false;
                });
              } else {
                Tflite.detectObjectOnFrame(
                        bytesList: img.planes.map((plane) {
                          return plane.bytes;
                        }).toList(),
                        model: widget.model == yolo ? "YOLO" : "SSDMobileNet",
                        imageHeight: img.height,
                        imageWidth: img.width,
                        imageMean: widget.model == yolo ? 0 : 127.5,
                        imageStd: widget.model == yolo ? 255.0 : 127.5,
                        numResultsPerClass: 1,
                        threshold: widget.model == yolo ? 0.2 : 0.4,
                        asynch: true)
                    .then(
                  (recognitions) {
                    if (!mounted) {
                      return;
                    }
                    widget.setRecognitions(recognitions, img.height, img.width);
                    isDetecting = false;
                  },
                );
              }
            }
          });
        },
      );
    }
  }

  stopCalling() async {
    await controller.stopImageStream().then((_) {
      controller?.dispose();
    });
  }

  @override
  void dispose() {
    stopCalling();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var tmp = MediaQuery.of(context).size;
          var screenH = math.max(tmp.height, tmp.width);
          var screenW = math.min(tmp.height, tmp.width);
          tmp = controller.value.previewSize;
          var previewH = math.max(tmp.height, tmp.width);
          var previewW = math.min(tmp.height, tmp.width);
          var screenRatio = screenH / screenW;
          var previewRatio = previewH / previewW;

          return OverflowBox(
            maxHeight: screenRatio > previewRatio
                ? screenH
                : screenW / previewW * previewH,
            maxWidth: screenRatio > previewRatio
                ? screenH / previewH * previewW
                : screenW,
            child: CameraPreview(controller),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
