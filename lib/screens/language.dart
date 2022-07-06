import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class language{
  final int id;
  final String name;
  final String languagecode;

  language(this.id,this.name,this.languagecode,);
  static List<language> languagelist(){
    return <language> [
      language(1, "English","en",),
      language(2, "عربى","ar",),

    ];
  }

}