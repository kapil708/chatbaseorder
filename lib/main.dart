import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:chatbaseorder/AudioProvider.dart';
import 'package:chatbaseorder/notification_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat Order",
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController txtTransportName = TextEditingController();
  TextEditingController txtNote = TextEditingController();
  ScrollController _scrollController = new ScrollController();

  bool loading = true;

  //audio recorder
  Recording _recording;
  bool _isPlayed = true;
  AudioPlayer player = AudioPlayer();
  Widget _buttonIcon = Icon(Icons.do_not_disturb_on);
  bool isLoading = false;

  void _play() async {
    print("Path : ${_recording.path}");
    setState(() {
      _isPlayed = false;
    });
    player.play(_recording.path, isLocal: true);
    player.onPlayerCompletion.listen((data) {
      print("Completed");
      setState(() {
        _isPlayed = true;
      });
    });
  }

  void _stop() {
    //AudioPlayer player = AudioPlayer();
    /*print("Path : ${_recording.path}");
    print("Path New : ${_recordingNew.path}");*/
    player.pause();
    setState(() {
      //stop flag
      _isPlayed = true;
    });
  }

  //end audio recorder

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2), () {
      setState(() {
        step = 1;
        loading = false;
      });
    });
  }

  int step = 0;

  final _picker = ImagePicker();

  var selectedBrand;
  var billAddress;
  var shipAddress;
  String transportName;
  String instructionType;
  String instruction;
  File selectedFile;

  bool editBrand = false;
  bool editShipAddress = false;
  bool editBillAddress = false;
  bool editImage = false;
  bool editTransport = false;
  bool editInstruction = false;

  List brandList = [
    {"Id": "3", "Name": "jignesh"},
    {"Id": "4", "Name": "vipin"},
  ];

  List billAddressList = [
    {
      "Id": "1",
      "Companyname": "Raj Industry",
      "Address": "C484 udhna char rasta, surat gujarat, 394221",
      "Gstnumber": "DKHJ5241525D96"
    },
    {
      "Id": "3",
      "Companyname": "Dharma Testile",
      "Address": "S/5 Radhika App. Opp. Science Center, Mumbai 935214",
      "Gstnumber": "DOEPK6218BG85"
    },
  ];

  List shipAddressList = [
    {
      "Id": "1",
      "Companyname": "Shivam Industry",
      "Address": "C484 udhna char rasta, surat gujarat, 394221",
      "Gstnumber": "DKHJ5241525D96"
    },
    {
      "Id": "3",
      "Companyname": "Ambika Testile",
      "Address": "S/5 Radhika App. Opp. Science Center, Mumbai 935214",
      "Gstnumber": "DOEPK6218BG85"
    },
  ];

  void newStep() {
    setState(() {
      loading = true;
    });
    Timer(Duration(seconds: 1), () {
      setState(() {
        step++;
        loading = false;
      });
      //scroll to end position
      Timer(
        Duration(milliseconds: 300),
        () => _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        ),
      );
    });
  }

  getImage(ImageSource source, index) async {
    this.setState(() {
      loading = true;
    });
    PickedFile image = await _picker.getImage(source: source);
    if (image != null) {
      File cropped = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Image Crop',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));

      this.setState(() {
        selectedFile = cropped;
        loading = false;
        editImage = false;
      });
      if (step == index) newStep();
    } else {
      this.setState(() {
        loading = false;
      });
    }
  }

  //widgets
  Widget brandWidget(chatWidth, index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Material(
          elevation: 3,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Select your brand",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        if (step == index || editBrand)
          Column(
            children: <Widget>[
              Container(
                width: chatWidth,
                child: Wrap(
                  children: <Widget>[
                    ...brandList.map((brand) {
                      return Padding(
                        padding: const EdgeInsets.all(5),
                        child: InkWell(
                          onTap: () {
                            print("brand selection called");
                            print(step);
                            /*if (step == 1) {
                                        setState(() {
                                          selectedBrand = brand;
                                        });
                                        if (step == 1)
                                        newStep();
                                      }*/
                            setState(() {
                              selectedBrand = brand;
                              editBrand = false;
                            });
                            if (step == index) newStep();
                          },
                          child: Material(
                            elevation: 2,
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              child: Text(
                                "${brand["Name"]}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        if (selectedBrand != null)
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: chatWidth,
              child: Material(
                elevation: 3,
                color: Color(0xFFCEDEF8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "${selectedBrand["Name"]}",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            editBrand = true;
                          });
                        },
                        child: Icon(
                          Icons.edit,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget shipAddressWidget(chatWidth, index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Material(
          elevation: 3,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Ship Address",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        if (step == index || editShipAddress)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: chatWidth,
                child: Wrap(
                  children: <Widget>[
                    ...shipAddressList.map((address) {
                      return Padding(
                        padding: const EdgeInsets.all(5),
                        child: InkWell(
                          onTap: () {
                            print("ship address called");
                            print(step);
                            /*if (step == 2) {
                                        setState(() {
                                          shipAddress = address;
                                        });
                                        newStep();
                                      }*/
                            setState(() {
                              shipAddress = address;
                              editShipAddress = false;
                            });
                            if (step == index) newStep();
                          },
                          child: Material(
                            elevation: 2,
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              child: Text(
                                "${address["Companyname"]}, \n${address["Address"]}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: InkWell(
                  onTap: () {
                    print("ship address called");
                    print(step);
                    showAddressBottomSheet(context);
                  },
                  child: Material(
                    elevation: 2,
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: Text(
                        "+ Add New Address",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        if (shipAddress != null)
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: chatWidth,
              child: Material(
                elevation: 3,
                color: Color(0xFFCEDEF8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "${shipAddress["Companyname"]}, \n${shipAddress["Address"]}",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            editShipAddress = true;
                          });
                        },
                        child: Icon(
                          Icons.edit,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget billAddressWidget(chatWidth, index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Material(
          elevation: 3,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Bill Address",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        if (step == index || editBillAddress)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: chatWidth,
                child: Wrap(
                  children: <Widget>[
                    ...billAddressList.map((address) {
                      return Padding(
                        padding: const EdgeInsets.all(5),
                        child: InkWell(
                          onTap: () {
                            print("ship address called");
                            print(step);
                            /*if (step == 3) {
                                        setState(() {
                                          billAddress = address;
                                        });
                                        newStep();
                                      }*/
                            setState(() {
                              billAddress = address;
                              editBillAddress = false;
                            });
                            if (step == index) newStep();
                          },
                          child: Material(
                            elevation: 2,
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              child: Text(
                                "${address["Companyname"]}, \n${address["Address"]}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: InkWell(
                  onTap: () {
                    print("ship address called");
                    print(step);
                    showAddressBottomSheet(context);
                  },
                  child: Material(
                    elevation: 2,
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      child: Text(
                        "+ Add New Address",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        if (billAddress != null)
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: chatWidth,
              child: Material(
                elevation: 3,
                color: Color(0xFFCEDEF8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "${billAddress["Companyname"]}, \n${billAddress["Address"]}",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            editBillAddress = true;
                          });
                        },
                        child: Icon(
                          Icons.edit,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget transportWidget(chatWidth, index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Material(
          elevation: 3,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Transport Name",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ),
        if (step == index || editTransport)
          Container(
            width: MediaQuery.of(context).size.width * 0.70,
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                TextFormField(
                  controller: txtTransportName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    hintText: "Transport Name",
                  ),
                  validator: (val) {
                    if (val.isEmpty)
                      return 'Enter Some Value';
                    else
                      return null;
                  },
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          transportName = "";
                          editTransport = false;
                        });
                        if (step == index) newStep();
                      },
                      child: Material(
                        elevation: 2,
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: (MediaQuery.of(context).size.width * 0.70 - 10) / 2,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: Center(
                            child: Text(
                              "SKIP",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (txtTransportName.text.isNotEmpty) {
                          setState(() {
                            transportName = txtTransportName.text;
                            editTransport = false;
                          });
                          if (step == index) newStep();
                        } else {
                          print("Empty Called");
                        }
                      },
                      child: Material(
                        elevation: 2,
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: (MediaQuery.of(context).size.width * 0.70 - 10) / 2,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: Center(
                            child: Text(
                              "SUBMIT",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        SizedBox(height: 10),
        if (transportName != null)
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: chatWidth,
              child: Material(
                elevation: 3,
                color: Color(0xFFCEDEF8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "${transportName.length > 0 ? transportName : 'SKIPPED'}",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            editTransport = true;
                          });
                        },
                        child: Icon(
                          Icons.edit,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget imageWidget(chatWidth, index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Material(
          elevation: 3,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Upload Order Photo",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5),
              child: InkWell(
                onTap: () {
                  print("Camera called");
                  print(step);
                  /*if (step == 5) {
                                      getImage(ImageSource.camera);
                                    }*/
                  getImage(ImageSource.camera, index);
                },
                child: Material(
                  elevation: 2,
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.photo_camera,
                          color: Colors.white,
                        ),
                        Text(
                          "Camera",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: InkWell(
                onTap: () {
                  print("Audio called");
                  print(step);
                  /*if (step == 5) {
                                      getImage(ImageSource.gallery);
                                    }*/
                  getImage(ImageSource.gallery, index);
                },
                child: Material(
                  elevation: 2,
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.photo,
                          color: Colors.white,
                        ),
                        Text(
                          "Gallery",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: InkWell(
                onTap: () {
                  print("Audio called");
                  print(step);
                  _audioRecording(context);
                },
                child: Material(
                  elevation: 2,
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.mic,
                          color: Colors.white,
                        ),
                        Text(
                          "Audio",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        /*if (step == index || editImage)
          Column(
            children: <Widget>[
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: InkWell(
                      onTap: () {
                        print("Camera called");
                        print(step);
                        *//*if (step == 5) {
                                      getImage(ImageSource.camera);
                                    }*//*
                        getImage(ImageSource.camera, index);
                      },
                      child: Material(
                        elevation: 2,
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.photo_camera,
                                color: Colors.white,
                              ),
                              Text(
                                "Camera",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: InkWell(
                      onTap: () {
                        print("Audio called");
                        print(step);
                        *//*if (step == 5) {
                                      getImage(ImageSource.gallery);
                                    }*//*
                        getImage(ImageSource.gallery, index);
                      },
                      child: Material(
                        elevation: 2,
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.photo,
                                color: Colors.white,
                              ),
                              Text(
                                "Gallery",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: InkWell(
                      onTap: () {
                        print("Audio called");
                        print(step);
                        _audioRecording(context);
                      },
                      child: Material(
                        elevation: 2,
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.mic,
                                color: Colors.white,
                              ),
                              Text(
                                "Audio",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),*/
        if (selectedFile != null)
          Column(
            children: <Widget>[
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        selectedFile,
                        width: 200,
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            selectedFile = null;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete,
                                size: 20,
                                color: Colors.white,
                              ),
                              SizedBox(width: 5),
                              Text("Delete", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600,),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        if(_recording != null)
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              children: [
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.70,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  padding: EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: 50,
                        width: 90,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        child: IconButton(
                          onPressed: () async {
                            setState(() {
                              _recording = null;
                            });;
                          },
                          icon: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.white),
                              SizedBox(width: 5),
                              Text("Delete", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600,),),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        '${_recording != null ? _recording.duration.toString().substring(0, 7) : "-"}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      _recording?.status == RecordingStatus.Stopped
                          ? Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        child: IconButton(
                          onPressed: () {
                            if (_recording != "") {
                              if (_isPlayed == false) {
                                _stop();
                              } else {
                                _play();
                              }
                            }
                          },
                          color: Colors.black,
                          icon: Icon(
                            _isPlayed == true ? Icons.play_arrow : Icons.stop,
                            color: Colors.white,
                          ),
                        ),
                      )
                          : Container(
                        height: 50,
                        width: 50,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget instructionWidget(chatWidth, index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Material(
          elevation: 3,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Instruction / Note",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ),
        if (instructionType != null)
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              child: Material(
                elevation: 3,
                color: Color(0xFFCEDEF8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "$instructionType Instruction",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (step == index || editInstruction)
          Container(
            width: MediaQuery.of(context).size.width * 0.70,
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                TextFormField(
                  controller: txtNote,
                  keyboardType: TextInputType.multiline,
                  maxLines: 2,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    hintText: "Enter Something",
                  ),
                  validator: (val) {
                    if (val.isEmpty)
                      return 'Enter Some Value';
                    else
                      return null;
                  },
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          instruction = "";
                          editInstruction = false;
                        });
                        if (step == index) newStep();
                      },
                      child: Material(
                        elevation: 2,
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: (MediaQuery.of(context).size.width * 0.70 - 10) / 2,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: Center(
                            child: Text(
                              "SKIP",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (txtNote.text.isNotEmpty) {
                          setState(() {
                            instruction = txtNote.text;
                            editInstruction = false;
                          });
                          if (step == index) newStep();
                        } else {
                          print("Empty Called");
                        }
                      },
                      child: Material(
                        elevation: 2,
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: (MediaQuery.of(context).size.width * 0.70 - 10) / 2,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: Center(
                            child: Text(
                              "SUBMIT",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        SizedBox(height: 10),
        if (instruction != null)
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: chatWidth,
              child: Material(
                elevation: 3,
                color: Color(0xFFCEDEF8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "${instruction.length > 0 ? instruction : 'SKIPPED'} ",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            editInstruction = true;
                          });
                        },
                        child: Icon(
                          Icons.edit,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double chatWidth = MediaQuery.of(context).size.width * 0.7;

    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Order"),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //Step 1 Brand Selection
              if (step >= 1)
                brandWidget(chatWidth, 1),
              //Step 2 Upload Image
              if (step >= 2)
                imageWidget(chatWidth, 2),
              //Step 3 Ship Address Selection
              if (step >= 3)
                shipAddressWidget(chatWidth, 3),
              //Step 4 Bill Address Selection
              if (step >= 4)
                billAddressWidget(chatWidth, 4),
              //Step 5 Transport Name
              if (step >= 5)
                transportWidget(chatWidth, 5),
              //Step 6 Instruction
              if (step >= 6)
                instructionWidget(chatWidth, 6),
              //Save Order
              if (step >= 7)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Material(
                      elevation: 3,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(
                          "All Process Done",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Order Saved.'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('Your Order is Saved!'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                RaisedButton(
                                  child: Text('Approve'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Material(
                        elevation: 2,
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: Center(
                            child: Text(
                              "Save Order",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              //loading component
              if (loading)
                Material(
                  elevation: 3,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Image.asset(
                      "assets/typing.gif",
                      height: 15,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  //Address Popup
  void showAddressBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AddAddress(
          onSave: (data) {
            if (data != null) {
              if (data["Type"] == "Shipping")
                setState(() {
                  shipAddressList.add({
                    "Companyname": data["Companyname"],
                    "Gstnumber": data["Gstnumber"],
                    "Address": data["Address"],
                  });
                });
              else if (data["Type"] == "Billing")
                setState(() {
                  billAddressList.add({
                    "Companyname": data["Companyname"],
                    "Gstnumber": data["Gstnumber"],
                    "Address": data["Address"],
                  });
                });
              else {
                setState(() {
                  shipAddressList.add({
                    "Companyname": data["Companyname"],
                    "Gstnumber": data["Gstnumber"],
                    "Address": data["Address"],
                  });
                  billAddressList.add({
                    "Companyname": data["Companyname"],
                    "Gstnumber": data["Gstnumber"],
                    "Address": data["Address"],
                  });
                });
              }
            }
            Navigator.pop(context);
          },
        );
      },
    );
  }

  //audio
  void _audioRecording(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: AudioRecordingPlugin(
            onSave: (val){
              if(val != null){
                setState(() {
                  _recording = val;
                });
                Navigator.pop(context);
                if (step == 2) newStep();
              }
            },
          ),
        );
      },
    );
  }
}

//Address Popup
class AddAddress extends StatefulWidget {
  final ValueChanged<dynamic> onSave;

  const AddAddress({Key key, this.onSave}) : super(key: key);

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtGSTNo = TextEditingController();
  TextEditingController txtAddress = TextEditingController();
  String type = "Shipping";

  var formKey = GlobalKey<FormState>();

  void saveData() {
    var data = {
      "Companyname": txtName.text,
      "Gstnumber": txtGSTNo.text,
      "Address": txtAddress.text,
      "Type": type,
    };

    widget.onSave(data);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 40),
              Text(
                "Add New Address",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: txtName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  hintText: "Company Name",
                ),
                validator: (val) {
                  if (val.isEmpty)
                    return 'Enter Some Value';
                  else
                    return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: txtGSTNo,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  hintText: "GST No",
                ),
                validator: (val) {
                  if (val.isEmpty)
                    return 'Enter Some Value';
                  else
                    return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: txtAddress,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  hintText: "Full Address",
                ),
                validator: (val) {
                  if (val.isEmpty)
                    return 'Enter Some Value';
                  else
                    return null;
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: type,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  hintText: "Full Address",
                ),
                onChanged: (String newValue) {
                  setState(() {
                    type = newValue;
                  });
                },
                items: <String>['Shipping', 'Billing', 'Both']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  if (formKey.currentState.validate()) saveData();
                },
                child: Material(
                  elevation: 2,
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Center(
                      child: Text(
                        "SUBMIT",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//audio
class AudioRecordingPlugin extends StatefulWidget {
  final ValueChanged<Recording> onSave;

  const AudioRecordingPlugin({Key key, this.onSave}) : super(key: key);

  @override
  _AudioRecordingPluginState createState() => _AudioRecordingPluginState();
}

class _AudioRecordingPluginState extends State<AudioRecordingPlugin> {
  //audio recording
  FlutterAudioRecorder _recorder;
  Recording _recording;
  bool _isPlayed = true;
  AudioPlayer player = AudioPlayer();
  Timer _t;
  Widget _buttonIcon = Icon(Icons.do_not_disturb_on);
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _prepare();
    });
  }

  Future _prepare() async {
    var hasPermission = await FlutterAudioRecorder.hasPermissions;
    if (hasPermission) {
      await _init();
      var result = await _recorder.current();
      setState(() {
        _recording = result;
        _buttonIcon = _playerIcon(_recording.status);
      });
    } else {
      alertDialog("Permission Required.", context);
    }
  }

  Future _init() async {
    String customPath = '/vikas_fashion_audio_recorder_';
    Directory appDocDirectory;
    if (Platform.isIOS) {
      appDocDirectory = await getApplicationDocumentsDirectory();
    } else {
      appDocDirectory = await getExternalStorageDirectory();
    }

    // can add extension like ".mp4" ".wav" ".m4a" ".aac"
    customPath = appDocDirectory.path +
        customPath +
        DateTime.now().millisecondsSinceEpoch.toString();

    // .wav <---> AudioFormat.WAV
    // .mp4 .m4a .aac <---> AudioFormat.AAC
    // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.

    //_recorder = FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV, sampleRate: 22050);
    _recorder = FlutterAudioRecorder("${customPath}", sampleRate: 22050);
    await _recorder.initialized;
  }

  Widget _playerIcon(RecordingStatus status) {
    switch (status) {
      case RecordingStatus.Initialized:
        {
          return Icon(
            Icons.settings_voice,
            color: Colors.white,
          );
        }
      case RecordingStatus.Recording:
        {
          return Icon(Icons.stop, color: Colors.white);
        }
      case RecordingStatus.Stopped:
        {
          return Icon(Icons.replay, color: Colors.white);
        }
      default:
        return Icon(Icons.do_not_disturb_on, color: Colors.white);
    }
  }

  Future _startRecording() async {
    await _recorder.start();
    var current = await _recorder.current();
    setState(() {
      _recording = current;
    });

    _t = Timer.periodic(Duration(milliseconds: 10), (Timer t) async {
      var current = await _recorder.current();
      setState(() {
        _recording = current;
        _t = t;
      });
    });
  }

  Future _stopRecording() async {
    var result = await _recorder.stop();
    _t.cancel();

    setState(() {
      _recording = result;
      // _recordingNew = result;
    });
  }

  void _play() async {
    print("Path : ${_recording.path}");
    setState(() {
      _isPlayed = false;
    });
    player.play(_recording.path, isLocal: true);
    player.onPlayerCompletion.listen((data) {
      print("Completed");
      setState(() {
        _isPlayed = true;
      });
    });
  }

  void _stop() {
    //AudioPlayer player = AudioPlayer();
    /*print("Path : ${_recording.path}");
    print("Path New : ${_recordingNew.path}");*/
    player.pause();
    setState(() {
      //stop flag
      _isPlayed = true;
    });
  }

  void audioUploadToServer() async {
    try {
      widget.onSave(_recording);
    } catch (error) {}
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _opt() async {
      switch (_recording.status) {
        case RecordingStatus.Initialized:
          {
            await _startRecording();
            break;
          }
        case RecordingStatus.Recording:
          {
            await _stopRecording();
            break;
          }
        case RecordingStatus.Stopped:
          {
            await _prepare();
            break;
          }

        default:
          break;
      }

      setState(() {
        _buttonIcon = _playerIcon(_recording.status);
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Center(child: Text("Audio Instruction", style: text16SemiBoldPrimary)),
        SizedBox(height: 10),
        Text("record audio instruction for you driver.", style: text14Primary),
        SizedBox(height: 10),
        Container(
          width: MediaQuery.of(context).size.width * 0.95,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          padding: EdgeInsets.all(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                child: IconButton(
                  onPressed: _opt,
                  icon: _buttonIcon,
                ),
              ),
              Text(
                '${_recording != null ? _recording.duration.toString().substring(0, 7) : "-"}',
              ),
              _recording?.status == RecordingStatus.Stopped
                  ? Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                child: IconButton(
                  onPressed: () {
                    if (_recording != "") {
                      if (_isPlayed == false) {
                        _stop();
                      } else {
                        _play();
                      }
                    }
                  },
                  color: Colors.black,
                  icon: Icon(
                    _isPlayed == true ? Icons.play_arrow : Icons.stop,
                    color: Colors.white,
                  ),
                ),
              )
                  : Container(
                height: 50,
                width: 50,
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        if (_recording?.status == RecordingStatus.Stopped && isLoading == false)
          InkWell(
            onTap: () {
              audioUploadToServer();
            },
            child: Material(
              elevation: 2,
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Center(
                  child: Text(
                    "Save Audio",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (isLoading)
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blueAccent,
                  ),
                ),
                SizedBox(width: 10),
                Text("audio is processing...")
              ],
            ),
          ),
      ],
    );
  }
}

TextStyle text16SemiBoldPrimary = new TextStyle(
  //fontFamily: bodyTextFontFamily,
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Colors.blueAccent,
);

TextStyle text14Primary = new TextStyle(
  /*fontFamily: bodyTextFontFamily,
  fontWeight: regular,*/
  fontSize: 14,
  color: Colors.blueAccent,
);