import 'dart:typed_data';

import 'package:crop/crop.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:profile_editor/styles.dart';
import 'package:profile_editor/ui/cropper_js/cropper_screen.dart';
import 'package:profile_editor/utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final controller = CropController();
  Uint8List _croppedProfileImage;
  Uint8List get croppedProfileImage => _croppedProfileImage;
  final double profileImageSizeContainer = 250.0;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  set croppedProfileImage(Uint8List value) {
    _croppedProfileImage = value;
  }

  Future<void> selectImage() async {
    final picker = ImagePicker();
    var pickedFile = await picker.getImage(source: ImageSource.camera);
    if (mounted && pickedFile != null) {
      print('PickedFile: ${pickedFile.path}');
      // var pickedFileUint8List = await pickedFile.readAsBytes();
      // var croppedImage = await Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => CropImageScreen(pickedFileUint8List),
      //     ));
      // setState(() {
      //   croppedProfileImage = croppedImage;
      // });
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CropperScreen(
              pickedFile.path,
            ),
          ));
      if (result != null) {
        croppedProfileImage = await getBlobData(result);
        if (mounted) {
          setState(() {});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 24),
              Center(
                child: Text(
                  croppedProfileImage == null
                      ? 'Please Select Image'
                      : 'Profile Image',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(height: 48),
              croppedProfileImage != null
                  ? ProfileImage(
                      profileImageSizeContainer: profileImageSizeContainer,
                      croppedProfileImage: croppedProfileImage,
                      selectImage: selectImage,
                    )
                  : ProfilePlaceholder(
                      profileImageSizeContainer: profileImageSizeContainer,
                      selectImage: selectImage,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    Key key,
    @required this.profileImageSizeContainer,
    @required this.croppedProfileImage,
    @required this.selectImage,
  })  : assert(profileImageSizeContainer != null),
        assert(croppedProfileImage != null),
        super(key: key);

  final double profileImageSizeContainer;
  final Uint8List croppedProfileImage;
  final Future<void> Function() selectImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          height: profileImageSizeContainer,
          width: profileImageSizeContainer,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.black,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: MemoryImage(
                croppedProfileImage,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: selectImage,
            ),
          ),
        ),
      ],
    );
  }
}

class ProfilePlaceholder extends StatelessWidget {
  const ProfilePlaceholder({
    Key key,
    @required this.profileImageSizeContainer,
    @required this.selectImage,
  })  : assert(profileImageSizeContainer != null),
        super(key: key);

  final double profileImageSizeContainer;
  final Future<void> Function() selectImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.asset(
            'person_placeholder.png',
            height: profileImageSizeContainer,
            width: profileImageSizeContainer,
          ),
        ),
        IgnorePointer(
          child: Container(
            width: 18,
            height: 18,
            child: Icon(
              Icons.add,
              color: primaryColor,
              size: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: selectImage,
            ),
          ),
        ),
      ],
    );
  }
}
