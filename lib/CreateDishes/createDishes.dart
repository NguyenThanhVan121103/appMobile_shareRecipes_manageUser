
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';




class createDishes extends StatefulWidget {
  final String  emailUser;
  const createDishes({Key? key, required this.emailUser}) : super(key: key);

  @override
  _CreateDishes createState() => _CreateDishes();
}

class _CreateDishes extends State<createDishes> {
  bool isButtonActive = true; // trạng thái của nút

  //Nhận dữ liệu của textField
  late TextEditingController nameDiashes;
  late TextEditingController inforDiashes ;
  final TextEditingController Ration = TextEditingController();
  final TextEditingController cookingTime = TextEditingController();
  var ingredient = <TextEditingController>[TextEditingController()];
  var CardIngredient = <Card>[];
  int numberOfIngredients = 1;// khởi tạo textfield
  var step = <TextEditingController>[TextEditingController()];
  var CardStep= <Card>[];
  int numberOfStep= 1;


  @override
  // trạng thái nút
  void initState() {
    super.initState();
 // Gọi hàm fetchData ở đây khi widget được khởi tạo
    nameDiashes = TextEditingController();
    inforDiashes = TextEditingController();
    ingredient[0] = TextEditingController();
    step[0]= TextEditingController();


    void checkTextField(){
      final isTextFieldnameDishes= nameDiashes.text.isNotEmpty;
      final isTextFieldinforDishes= inforDiashes.text.isNotEmpty;
      final isTextFieldingredient= ingredient[0].text.isNotEmpty;
      final isTextFieldstep= step[0].text.isNotEmpty;

      setState(() {
        isButtonActive= isTextFieldinforDishes && isTextFieldnameDishes
            && isTextFieldingredient&& isTextFieldstep;
      });
    }
    nameDiashes.addListener(checkTextField);

    inforDiashes.addListener(checkTextField);


    for(var controlleringredient in ingredient){
      controlleringredient.addListener(checkTextField);
    }
    for(var controllerstep in step){
      controllerstep.addListener(checkTextField);
    }
  }



// nhận dữ liệu của ingredient và step
  void addIngredient(){
    setState(() {
      ingredient.add(TextEditingController());
      numberOfIngredients++;
    });
  }
  void addStep(){
    setState(() {
      step.add(TextEditingController());
      numberOfStep++;
    });
  }

// image
  File? image;// biếng image
  var url;
  final ImagePicker imgpicker = ImagePicker();

// lấy ảnh từ nguồn ảnh
  getImage(ImageSource source) async{
    var img = await imgpicker.pickImage(source: source); // nơi lấy ảnh
    setState(() {
      image = File(img!.path);
    });
  }

  // nguồn ảnh (thử viện/máy ảnh)
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


// xóa ảnh
  void deleteImage(){
    setState(() {
      image = null;
    });
  }

  // lưu dữ liệu
  @override
  void saveData() async{
    CollectionReference collRef= FirebaseFirestore.instance.collection('users');
    if (image == null) {
      // Lấy hình ảnh mặc định từ assets
      ByteData imageData = await rootBundle.load('assets/images/food.jpg');
      Uint8List byteList = imageData.buffer.asUint8List();
      var imagedishes = FirebaseStorage.instance
          .ref()
          .child("image_Dishes")
          .child("/defaulImage ${nameDiashes}.jpg"); // Tên file mặc định (có thể thay đổi)

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
          .child("/${nameDiashes.text}.jpg");

      UploadTask task = imagedishes.putFile(image!);
      TaskSnapshot snapshot = await task;
      url = await snapshot.ref.getDownloadURL();
      setState(() {
        url = url;
      });
    }



      String tenMon = nameDiashes.text;
      String gioiThieuMon = inforDiashes.text;
      String khauPhan = Ration.text;
      String thoiGianNau = cookingTime.text;




// tạo 2 list ingredient và step để lưu dữ liệu ingredient và step
        List<String> ingredientValues = [];
        for (int i = 0; i < numberOfIngredients; i++){
          ingredientValues.add(ingredient[i].text);
        };

        List<String> stepValues = [];
        for (int n = 0; n< numberOfStep; n++){
          stepValues.add(step[n].text);
        }
        final String timeDate= DateTime.timestamp().microsecondsSinceEpoch.toString();
        String Id= widget.emailUser + timeDate;
    collRef.doc(widget.emailUser + timeDate).set({
      'timestamp': FieldValue.serverTimestamp(),
      'EmailUser': widget.emailUser,
      'nameDishes' : tenMon,// data in listDishesOfUser
      'inforDishes' : gioiThieuMon,
      'rationDishes' : khauPhan,
      'timeCooking': thoiGianNau,
      'ingredient': ingredientValues,
      'step': stepValues,
      'url': url,
      'likes': 0
    });
        print("lưu món ăn thành công");





        for(var controller in ingredient)
          controller.clear();
        for (var controller in step){
          controller.clear();
        }
        setState(() {
          image= null;
        });

      nameDiashes.clear();
      inforDiashes.clear();
      Ration.clear();
      cookingTime.clear();

  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        elevation: 0.0,
        title: Text('Món mới',
          style: TextStyle(
            color: Colors.black,
          ),),actions: <Widget>[
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
                    saveData();
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
      body: SingleChildScrollView(
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
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/food.jpg"),
                        fit: BoxFit.fill
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
              controller: nameDiashes,
              keyboardType: TextInputType.text,
              maxLines: null,
              decoration: InputDecoration(
                hintText: "Tên món ăn: Món chiên phô mai",
                icon: const Icon(Icons.restaurant),
              ),
            ),
            TextFormField(
              controller: inforDiashes,
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

            for (int i= 1; i < numberOfIngredients; i++)
              TextFormField(
                controller: ingredient[i],
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(hintText: "200g bột",
                  hintMaxLines: 10,
                  icon: const Icon(Icons.inventory),
                ),
              ),



            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton.icon(
                    onPressed: addIngredient,
                    icon: Icon(Icons.add,
                      color: Colors.black,),
                    label: Text("Nguyên liệu",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white, // Background color
                    ),
                  ),
                  SizedBox(height: 50),

                ],
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

            for (int i= 1; i < numberOfStep; i++)
              TextFormField(
                controller: step[i],
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(hintText: "Đậy kín hỗn hợp lại và để ở nhiệt độ phòng trong vòng 24-36 tiếng",
                  hintMaxLines: 10,
                  icon: const Icon(Icons.list),
                ),
              ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton.icon(
                    onPressed: addStep,
                    icon: Icon(Icons.add,
                      color: Colors.black,),
                    label: Text("Cách làm",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white, // Background color
                    ),
                  ),
                  SizedBox(height: 50),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
