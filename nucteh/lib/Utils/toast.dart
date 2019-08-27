import 'package:flutter/material.dart';

class Toast {
  static final _alphaInTime = 500;
  static final _alphaOutTime = 500;
  static final _transparent = 0.0;
  static final _opacity = 1.0;
  static final _displayTime = 1500;
  static ToastHolder _toastHolder;

  static show(
      {@required BuildContext context,
        @required String msg,
        AnimationController animationControllerIn,
        AnimationController animationControllerOut,
        Animation animationIn,
        Animation animationOut}) {
    ///1.如果已经有则先dismiss
    _toastHolder?._dismissNow();
    _toastHolder = null;

    ///2.创建类似window的东西
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      return DefaultToastWidget(msg, animationIn, animationOut);
    });

    ///3.创建相关动画
    ///3.1创建动画控制器，控制动画时间
    if (animationControllerIn == null)
      animationControllerIn = AnimationController(
          vsync: overlayState, duration: Duration(milliseconds: _alphaInTime));
    if (animationControllerOut == null)
      animationControllerOut = AnimationController(
          vsync: overlayState, duration: Duration(milliseconds: _alphaOutTime));

    ///3.2创建动画，控制动画开始值和结束值
    if (animationIn == null)
      animationIn = Tween(begin: _transparent, end: _opacity)
          .animate(animationControllerIn);
    if (animationOut == null)
      animationOut = Tween(begin: _opacity, end: _transparent)
          .animate(animationControllerOut);

    ///4.弹出toast
    var toast = ToastHolder(overlayEntry, overlayState, animationControllerIn,
        animationControllerOut);
    _toastHolder = toast;
    toast._show();
  }
}

class ToastHolder {
  OverlayEntry _overlayEntry;
  OverlayState _overlayState;
  bool _isDismiss = true;
  AnimationController _animationControllerIn;
  AnimationController _animationControllerOut;

  ToastHolder(this._overlayEntry, this._overlayState,
      this._animationControllerIn, this._animationControllerOut);

  _show() {
    _overlayState.insert(_overlayEntry);
    _isDismiss = false;

    ///动画开始（正向）
    _animationControllerIn.forward();

    ///延迟一定时间
    Future.delayed(
        Duration(milliseconds: Toast._alphaInTime + Toast._displayTime))
        .then((value) {
      _dismiss();
    });
  }

  _dismiss() {
    if (_isDismiss) return;

    _animationControllerOut.forward();
    Future.delayed(Duration(milliseconds: Toast._alphaOutTime)).then((value) {
      _overlayEntry.remove();
      _isDismiss = true;
    });
  }

  _dismissNow() {
    if (_isDismiss) return;
    _overlayEntry.remove();
    _isDismiss = true;
  }
}

class DefaultToastWidget extends StatelessWidget {
  final String msg;
  final Animation<double> alphaIn;
  final Animation<double> alphaOut;

  DefaultToastWidget(this.msg, this.alphaIn, this.alphaOut);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: alphaIn,
      builder: (context, child) {
        return Opacity(
          ///不透明控件
          opacity: alphaIn.value,
          child: AnimatedBuilder(
            animation: alphaOut,
            builder: (context, child) {
              return Opacity(
                opacity: alphaOut.value,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        msg,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            decoration: TextDecoration.none),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}