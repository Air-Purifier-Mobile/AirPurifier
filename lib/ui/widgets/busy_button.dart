import 'package:air_purifier/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

/// A button that shows a busy indicator in place of title
class BusyButton extends StatefulWidget {
  final bool busy;
  final String title;
  final Function onPressed;
  final bool enabled;
  final TextStyle textStyle;
  final Image image;
  const BusyButton(
      {@required this.title,
      this.busy = false,
      this.image,
      this.textStyle,
      @required this.onPressed,
      this.enabled = true});

  @override
  _BusyButtonState createState() => _BusyButtonState();
}

class _BusyButtonState extends State<BusyButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: AnimatedContainer(
        height: widget.busy ? 50 : null,
        width: widget.busy ? 50 : null,
        duration: const Duration(milliseconds: 300),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
            horizontal: widget.busy ? 10 : 15, vertical: widget.busy ? 10 : 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: !widget.busy
            ? widget.image != null
                ? Row(
                    children: [
                      widget.image,
                      horizontalSpaceSmall,
                      Text(
                        widget.title,
                        style: widget.textStyle,
                      ),
                    ],
                  )
                : Text(
                    widget.title,
                    style: widget.textStyle,
                  )
            : CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
      ),
    );
  }
}
