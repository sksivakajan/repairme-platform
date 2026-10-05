import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

/// Six boxes for a one-time code. Typing moves along by itself and pasting a
/// whole code works. [onChanged] gets the digits entered so far.
class OtpInput extends StatefulWidget {
  const OtpInput({super.key, required this.onChanged, this.autofocus = true, this.enabled = true});

  static const length = 6;

  final ValueChanged<String> onChanged;
  final bool autofocus;
  final bool enabled;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final code = _controller.text;
    return Semantics(
      textField: true,
      child: SizedBox(
        height: 58,
        child: Stack(
          children: [
            // The real input sits underneath and receives the taps.
            Positioned.fill(
              child: Opacity(
                opacity: 0,
                child: TextField(
                  controller: _controller,
                  focusNode: _focus,
                  autofocus: widget.autofocus,
                  enabled: widget.enabled,
                  keyboardType: TextInputType.number,
                  autofillHints: const [AutofillHints.oneTimeCode],
                  enableInteractiveSelection: false,
                  showCursor: false,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(OtpInput.length),
                  ],
                  decoration: const InputDecoration(filled: false, border: InputBorder.none),
                  onChanged: (value) {
                    setState(() {});
                    widget.onChanged(value);
                  },
                ),
              ),
            ),
            IgnorePointer(
              child: Row(
                children: [
                  for (var i = 0; i < OtpInput.length; i++)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: i == 0 ? 0 : 5, right: i == OtpInput.length - 1 ? 0 : 5),
                        child: _Box(
                          digit: i < code.length ? code[i] : '',
                          active: _focus.hasFocus && (i == code.length || (i == OtpInput.length - 1 && code.length == OtpInput.length)),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Box extends StatelessWidget {
  const _Box({required this.digit, required this.active});

  final String digit;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final filled = digit.isNotEmpty;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: filled ? AppColors.ink : (active ? AppColors.yellowDeep : AppColors.line),
          width: filled || active ? 1.6 : 1.2,
        ),
      ),
      child: Text(digit, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
    );
  }
}
