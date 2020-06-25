
class Validate {

  String validateStringText(String value) {
    //  String patttern = r'(^[a-zA-Z ]*$)';
    //  RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Please fill the field";
    }
    return null;
  }
}
