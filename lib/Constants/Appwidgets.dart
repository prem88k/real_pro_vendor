import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

AppBar appBar(context, String text, {Color backgroundColor = Colors.white, double textSize = 16, Color textColor = Colors.black, showBack = true, required List<Widget> actions}) {
  return AppBar(
    title: Text(text, style: TextStyle(color: textColor, fontSize: textSize)),
    backgroundColor: backgroundColor,
    leading: showBack ? IconButton(icon: Icon(Icons.arrow_back, color: textColor), onPressed: () => finish(context)) : null,
    actions: actions,
    automaticallyImplyLeading: true,
  );
}

Widget cachedImage(String url, {required double height, required double width, required BoxFit fit, required AlignmentGeometry alignment, bool usePlaceholderIfUrlEmpty = true, required double radius}) {
  if (url.validate().isEmpty) {
    return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
  } else if (url.validate().startsWith('http')) {
    return Image.network(
        url
    );
  } else {
    return Image.asset(url, height: height, width: width, fit: fit, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? 25);
  }
}

Widget placeHolderWidget({required double height, required double width, required BoxFit fit, required AlignmentGeometry alignment, required double radius}) {
  return Image.asset('assets/placeholder.jpg', height: height, width: width, fit: fit ?? BoxFit.cover, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? 25);
}

class NoChatWidget extends StatelessWidget {
  const NoChatWidget({
    required Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset("assets/no_messages.png", height: 120),
        Text('No Chats', style: boldTextStyle()).center(),
      ],
    );
  }
}

class NoCallLogsWidget extends StatelessWidget {
  const NoCallLogsWidget({
    required Key  key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/no_messages.png", height: 120),
        Text('No Logs', style: boldTextStyle()).center(),
      ],
    );
  }
}
