
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenify_app/features/notification/domain/entites/notification.dart' as no;
import 'package:zenify_app/features/notification/presontation/bloc/add_delet_update_notification/add_delet_update_notification_bloc.dart';
import 'package:zenify_app/features/notification/presontation/widgets/Notification_detail_page/form_submit_btn.dart';
import 'package:zenify_app/features/notification/presontation/widgets/Notification_detail_page/text_form_field_widget.dart';



class FormWidget extends StatefulWidget {
  final bool isUpdatePost;
  final no.Notification ? post;
  const FormWidget({
    Key? key,
    required this.isUpdatePost,
    this.post,
  }) : super(key: key);

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();

  @override
  void initState() {
    if (widget.isUpdatePost) {
      _titleController.text = widget.post!.title??"";
      _bodyController.text = widget.post!.message??"";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormFieldWidget(
                name: "Title", multiLines: false, controller: _titleController),
            TextFormFieldWidget(
                name: "Messagge", multiLines: true, controller: _bodyController),
            FormSubmitBtn(
                isUpdatePost: widget.isUpdatePost,
                onPressed: validateFormThenUpdateOrAddPost),
          ]),
    );
  }

  void validateFormThenUpdateOrAddPost() {
    final isValid = _formKey.currentState!.validate();

    // if (isValid) {
      final post = no.Notification(
          id: widget.isUpdatePost ? widget.post!.id : null,
          title: _titleController.text,
          message: _bodyController.text);

      if (widget.isUpdatePost) {
        BlocProvider.of<AddDeletUpdateNotificationBloc>(context)
            .add(UpdateNotificationEvent(notification: post));
      } else {
        BlocProvider.of<AddDeletUpdateNotificationBloc>(context)
            .add(AddNotificationEvent(notification: post));
      }
    // }
  }
}