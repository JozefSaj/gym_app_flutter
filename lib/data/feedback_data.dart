import 'package:flutter/foundation.dart';
import '../modules/feedback.dart';
import 'package:flutter/cupertino.dart';

class FeedbackData extends ChangeNotifier{

  List<Feedback> feedbackList = [];


  List<Feedback> getFeedbackList(){
    return feedbackList;
  }

  void addFeedback(String feedback){
    feedbackList.add(Feedback(content: feedback));
    notifyListeners();
  }


}