import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

import '../../utils/fake_ui.dart' if (dart.library.html) 'dart:ui' as ui;

class CropperScreen extends StatefulWidget {
  const CropperScreen(this.imagePath, {Key key}) : super(key: key);
  final String imagePath;

  @override
  _CropperScreenState createState() => _CropperScreenState();
}

class _CropperScreenState extends State<CropperScreen> {
  html.DivElement _element;
  js.JsObject _viewer;
  @override
  void initState() {
    super.initState();
    _element = html.DivElement();
    // hacky
    var css = getCropperCss();
    _element.append(css);

    var _imageElement = html.ImageElement()
      ..src = widget.imagePath
      ..style.maxWidth = '100%'
      ..style.display = 'block';
    _element.append(_imageElement);
    _viewer = js.JsObject(js.context['Cropper'], [
      _imageElement,
      js.JsObject.jsify({
        'aspectRatio': 1,
        'dragMode': 'move',
        'cropBoxResizable': false,
        'toggleDragModeOnDblclick': false,
      })
    ]);
    // https://github.com/flutter/flutter/issues/41563
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry
        .registerViewFactory(widget.imagePath, (int viewId) => _element);
  }

  html.LinkElement getCropperCss() {
    var css = html.LinkElement();
    css.href =
        'https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.5.9/cropper.min.css';
    css.integrity =
        'sha512-w+u2vZqMNUVngx+0GVZYM21Qm093kAexjueWOv9e9nIeYJb1iEfiHC7Y+VvmP/tviQyA5IR32mwN/5hTEJx6Ng==';
    css.crossOrigin = 'anonymous';
    css.rel = 'stylesheet';
    return css;
  }

  Future<html.Blob> result_data() async {
    var result = _viewer.callMethod('getCroppedCanvas') as html.CanvasElement;
    return result.toBlob();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Crop Image'),
        actions: [
          FlatButton.icon(
            icon: Icon(Icons.crop),
            label: Text('Crop'),
            onPressed: () async {
              Navigator.pop(context, await result_data());
            },
          )
        ],
      ),
      body: Center(
        child: HtmlElementView(
          key: ValueKey(widget.imagePath),
          viewType: widget.imagePath,
        ),
      ),
    );
  }
}
