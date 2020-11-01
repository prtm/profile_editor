import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:crop/crop.dart';
import 'package:flutter/material.dart';
import 'package:profile_editor/ui/crop/centered_slider_track_shape.dart';

// mobile device support
class CropImageScreen extends StatefulWidget {
  const CropImageScreen(this.pickedFile, {Key key}) : super(key: key);

  final Uint8List pickedFile;

  @override
  _CropImageScreenState createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {
  final controller = CropController();
  CropShape shape = CropShape.box;

  double _rotation = 0;

  void _cropImage() async {
    // https://github.com/flutter/flutter/issues/42767 .toImage issue waiting
    final cropped = await controller.crop(pixelRatio: 1);
    Navigator.pop(context, await _saveScreenShot(cropped));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop Image'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: _cropImage,
            tooltip: 'Crop & Save',
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.black,
              padding: EdgeInsets.all(8),
              child: Crop(
                controller: controller,
                shape: shape,
                child: Image.memory(
                  widget.pickedFile,
                  fit: BoxFit.cover,
                ),
                /* It's very important to set `fit: BoxFit.cover`.
                   Do NOT remove this line.
                   There are a lot of issues on github repo by people who remove this line and their image is not shown correctly.
                */
                foreground: IgnorePointer(
                  child: Container(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'Foreground Object',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                helper: shape == CropShape.box
                    ? Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      )
                    : null,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.undo),
                tooltip: 'Undo',
                onPressed: () {
                  controller.rotation = 0;
                  controller.scale = 1;
                  controller.offset = Offset.zero;
                  setState(() {
                    _rotation = 0;
                  });
                },
              ),
              Expanded(
                child: SliderTheme(
                  data: theme.sliderTheme.copyWith(
                    trackShape: CenteredRectangularSliderTrackShape(),
                  ),
                  child: Slider(
                    divisions: 361,
                    value: _rotation,
                    min: -180,
                    max: 180,
                    label: '$_rotation°',
                    onChanged: (n) {
                      setState(() {
                        _rotation = n.roundToDouble();
                        controller.rotation = _rotation;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// https://github.com/flutter/flutter/issues/42767 .toImage issue waiting
// https://github.com/flutter/flutter/issues/49857
// https://github.com/flutter/flutter/issues/49534 custom clipper issue
// https://github.com/flutter/engine/pull/20750
Future<Uint8List> _saveScreenShot(ui.Image img) async {
  var byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  return byteData.buffer.asUint8List();
}
