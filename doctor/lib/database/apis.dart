class Apis {
//  static String baseUrl = "https://subset.in/api/";
  static String baseUrl = "http://192.168.43.183/doctor/";

  //----------DOCTOR APIS------------------------
  final String mDoctorLogin = baseUrl + "doctor/login.php";
  final String mDoctorProfile = baseUrl + "doctor/profile.php";
  final String mSubmitCategory = baseUrl + "doctor/updateCategory.php";
  final String mSubmitDays = baseUrl + "doctor/selectDays.php";
  final String mSubmitTime = baseUrl + "doctor/createTimeSlots.php";
  final String mSubmitArea = baseUrl + "doctor/addArea.php";
  final String mTodaysRequests = baseUrl + "doctor/todayRequests.php";

  final String mAllPendingRequests = baseUrl + "doctor/AllPending.php";
  /*
  {
    "id":"514ddc80-b580-11ea-aa3b-45205f061101"
}
   */
  final String mAllRequests = baseUrl + "doctor/allRequests.php";
  final String updateRequest = baseUrl + "doctor/updateRequestStatus.php";

  //----------USER APIS--------------------------
  final String mUserLogin = baseUrl + "user/login.php";
  final String mUserProfile = baseUrl + "user/profile.php";
  final String mFetchDoctorList = baseUrl + "user/fetchDoctorList.php";
  final String mFetchDayList = baseUrl + "user/fetchDayList.php";
  final String mFetchMyPatientsList = baseUrl + "user/fetchPatientsList.php";
  final String mFetchTimeSlots = baseUrl + "user/fetchTimeSlots.php";
  final String mAddPatients = baseUrl + "user/addPatient.php";
  final String mBookAppointment = baseUrl + "user/bookAppointment.php";
  final String mPatientsAppointments =
      baseUrl + "user/fetchPatientsRequest.php";
  final String mAllUserPendingAppointments =
      baseUrl + "user/pendingRequests.php";
  //----------COMMAN APIS-------------------
  final String fetchCategory = baseUrl + "comman/fetchCategory.php";
  final String fetchState = baseUrl + "comman/fetchState.php";
  final String fetchDistrict = baseUrl + "comman/fetchDistrict.php";
  final String fetchArea = baseUrl + "comman/fetchArea.php";

  //------------FETCH IMAGES APIS---------------------------
  final String imagesUrl = baseUrl + "images/";
}
