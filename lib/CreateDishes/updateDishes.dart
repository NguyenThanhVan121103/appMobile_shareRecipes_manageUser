import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_gourmet/CreateDishes/viewDetailDishes.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:readmore/readmore.dart';

class updateDishes extends StatefulWidget {
  final String id, emailUser,passWord;
  const updateDishes({Key? key, required this.id, required this.emailUser, required this.passWord}) : super(key: key);

  @override
  State<updateDishes> createState() => _updateDishesState();
}

class _updateDishesState extends State<updateDishes> {
  late List<Widget> _widgetOptions; // Khai báo danh sách widget này ở đây


  final _formKey = GlobalKey<FormState>();
  late TextEditingController Diashesname = TextEditingController();
  late TextEditingController Diashesinfor = TextEditingController();
  bool isButtonActive = true;


  final TextEditingController Ration = TextEditingController();
  final TextEditingController cookingTime = TextEditingController();
  var ingredient = <TextEditingController>[];
  var ingredientNew = <TextEditingController>[];


  var CardIngredient = <Card>[];
  int numberOfIngredients = 1;// khởi tạo textfield
  var step = <TextEditingController>[];
  var CardStep= <Card>[];
  int numberOfStep= 1;




  // Functions to add new fields dynamically
  // void addIngredientField() {
  //   setState(() {
  //     ingredients.add('');
  //   });
  // }
  //
  // void addStepField() {
  //   setState(() {
  //     steps.add('');
  //   });
  // }

  File? image;// biếng image
  final ImagePicker imgpicker = ImagePicker();

// lấy ảnh từ nguồn ảnh
  getImage(ImageSource source) async{
    var img = await imgpicker.pickImage(source: source); // nơi lấy ảnh
    setState(() {
      image = File(img!.path);
    });
  }

  void deleteImage(){
    setState(() {
      image = null;
    });
  }
  void myAlert(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Vui lòng chọn nguồn ảnh'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(onPressed: (){
                    Navigator.pop(context);
                    getImage(ImageSource.gallery); // lấy nguồn ảnh ở thư viện
                  }, child: Row(// hiển thị thẳng một hàng
                    children: [
                      Icon(Icons.image_rounded),
                      Text("Thư viện"),
                    ],
                  ),
                  ),
                  ElevatedButton(onPressed: (){
                    Navigator.pop(context);
                    getImage(ImageSource.camera); // lấy nguồn ảnh ở thư viện
                  }, child: Row(// hiển thị thẳng một hàng
                    children: [
                      Icon(Icons.camera_alt_outlined),
                      Text("Máy ảnh"),
                    ],
                  ))
                ],
              ),
            ),
          );
        });
  }

  CollectionReference dishes= FirebaseFirestore.instance.collection('users');

  Future<void> updateDishes (id, nameDishes, inforDishes,rationDishes,
      timeCooking, List<String> ingredients, List<String> steps, url) async{

    if (image == null) {
      // Lấy hình ảnh mặc định từ assets
      ByteData imageData = await rootBundle.load('assets/images/food.jpg');
      Uint8List byteList = imageData.buffer.asUint8List();
      var imagedishes = FirebaseStorage.instance
          .ref()
          .child("image_Dishes")
          .child("/defaulImage ${Diashesname}.jpg"); // Tên file mặc định (có thể thay đổi)

      UploadTask task = imagedishes.putData(byteList);
      TaskSnapshot snapshot = await task;
      url = await snapshot.ref.getDownloadURL();
      setState(() {
        url = url;
      });
    } else {
      // Upload hình ảnh đã chọn
      var imagedishes = FirebaseStorage.instance
          .ref()
          .child("image_Dishes")
          .child("/${Diashesname.text}.jpg");

      UploadTask task = imagedishes.putFile(image!);
      TaskSnapshot snapshot = await task;
      url = await snapshot.ref.getDownloadURL();
      setState(() {
        url = url;
      });
    }

    return dishes
        .doc(id)
        .update({'nameDishes': nameDishes,'inforDishes': inforDishes,
      'rationDishes':rationDishes, 'timeCooking':timeCooking,
      'ingredient':ingredients, 'step': steps, 'url': url
    })
        .then((value) => print("Cập nhật thành công"))
        .catchError((error) => print("Có lỗi: $error"));
  }
  @override
  Widget build(BuildContext context) {
    late String url = "" ;


    return Scaffold(
        appBar: AppBar(
          title: Text('Cập nhật món ăn'),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 65),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        onSurface: Colors.grey,
                        primary: Colors.amber,
                        side: BorderSide(color: Colors.amber)
                    ),
                    onPressed:isButtonActive
                        ? (){
                      if (_formKey.currentState!.validate()){
                        updateDishes(
                          widget.id,
                          Diashesname.text,
                          Diashesinfor.text,
                          Ration.text,
                          cookingTime.text,
                          ingredient.map((controller) => controller.text).toList(),
                          step.map((controller) => controller.text).toList(),url
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)
                            => viewDetailDishes(id: widget.id, emailUser: widget.emailUser,passWord: widget.passWord,),
                            ));
                      }
                    }
                        :null,
                    child: Text("Lên sóng",
                      style: TextStyle(
                          color: Colors.blue
                      ),),
                  ),
                ],
              ),
            ),
          ],
        ),
        body:Form(
          key: _formKey,
          child: FutureBuilder<DocumentSnapshot<Map<String,dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('users').doc(widget.id).get(),
            builder: (_, snapshot){
              if(snapshot.hasError){
                print("có lỗi bạn ê");
              }
              if (snapshot.connectionState== ConnectionState.waiting){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasData && snapshot.data != null) {
                var disheDetail = snapshot.data!.data();
                if (disheDetail != null) {
                  Diashesname.text = disheDetail['nameDishes'] ?? '';
                  Diashesinfor.text = disheDetail['inforDishes'] ?? '';
                  cookingTime.text = disheDetail['timeCooking'] ?? '';
                  Ration.text = disheDetail['rationDishes'] ?? '';
                  url= disheDetail['url'];
                  var ingredientValue= disheDetail['ingredient']as List;
                  for (var i= 0; i< ingredientValue.length; i++){
                    var ingredientController = TextEditingController(text: ingredientValue[i]);
                    print('đây là controller${ingredientController}');
                    ingredient.add(ingredientController);
                    print('đây là:${ingredient}');

                  }
                  var stepValue= disheDetail['step']as List;
                  for (var a= 0; a< stepValue.length; a++){
                    var stepController = TextEditingController(text: stepValue[a]);
                    print('đây là controller ${stepController}');
                    step.add(stepController);
                    print('đây là step: ${step}');

                  }
                }
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[


                    image != null
                        ? Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(image!.path),
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                              height: 250,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 20,
                          child: ElevatedButton.icon(
                            onPressed: (){
                              myAlert();
                            },
                            icon: Icon(Icons.camera_alt_outlined,
                              color: Colors.black,),
                            label: Text("Chỉnh sửa|    ",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),),
                        Positioned(
                          right: 16,
                          child:IconButton(
                            icon: Icon(Icons.delete_forever_outlined),
                            onPressed: () {
                              deleteImage();
                            },
                          ),
                        ),
                      ],
                    )
                        : Row(
                      children: [
                        Container(
                          width: 350,
                          height: 250,
                          decoration: BoxDecoration(
                            image: url.isNotEmpty
                                ? DecorationImage(
                              image: NetworkImage(url),
                              fit: BoxFit.cover,
                            )
                                : const DecorationImage(
                              image: AssetImage('assets/images/food.png'), // Hình ảnh mặc định nếu url rỗng
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              myAlert();
                            },
                            icon: Icon(Icons.camera_alt_outlined),
                            label: Text("Đăng hình đại diện món ăn",
                              style:TextStyle(
                                color: Colors.blue.shade300,
                                fontWeight: FontWeight.bold,
                              ) ,),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.transparent, // Đặt màu nền của ElevatedButton là trong suốt
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: Diashesname,
                      keyboardType: TextInputType.text,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Tên món ăn: Món chiên phô mai",
                        icon: const Icon(Icons.restaurant),
                      ),
                    ),
                    TextFormField(
                      controller: Diashesinfor,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Giới thiệu món ăn: Điều gì đó đã truyền "
                            "cảm hứng cho bạn để nấu món này? Tại sao nó đặc biệt? "
                            "Bạn thích thưởng thức nó theo cách nào?",
                        hintMaxLines: 10,
                        icon: const Icon(Icons.tips_and_updates),
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Text(
                          'Khẩu phần: ',
                          style: new TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(width: 70),
                        new Flexible(
                          child: new TextField(
                            controller: Ration,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: "2 người",
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          'Thời gian nấu: ',
                          style: new TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(width: 50),
                        new Flexible(
                          child: new TextField(
                            controller: cookingTime,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: "1 giờ 30 phút",
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 100),

                    Text(
                      "Nguyên liệu",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(width: 15,),
                    TextFormField(
                      controller: ingredient[0],
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(hintText: "100ml nước",
                        hintMaxLines: 10,
                        icon: const Icon(Icons.inventory),
                      ),
                    ),


                    for (int i= 1; i < ingredient.length; i++)
                      TextFormField(
                        controller: ingredient[i],
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(hintText: "200g bột",
                          hintMaxLines: 10,
                          icon: const Icon(Icons.inventory),
                        ),
                      ),
                    SizedBox(height: 50),
                    Text(
                      "Cách làm",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    TextFormField(
                      controller: step[0],
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(hintText: "Trộn bột với nước đến khi đặc lại",
                        hintMaxLines: 10,
                        icon: const Icon(Icons.list),
                      ),
                    ),

                    for (int n= 1; n < step.length; n++)
                      TextFormField(
                        controller: step[n],
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(hintText: "Đậy kín hỗn hợp lại và để ở nhiệt độ phòng trong vòng 24-36 tiếng",
                          hintMaxLines: 10,
                          icon: const Icon(Icons.list),
                        ),
                      ),
                    SizedBox(height: 15,),
                  ],
                ),
              );
            },
          ),


        )
    );
  }
}