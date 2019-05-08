library ss_flutter_view_support;

import 'package:flutter/material.dart';
import 'reveal_container.dart';


class LoadingView extends StatefulWidget {
  Widget child;
  Widget loadingView;
  _LoadingView _innerView;

  LoadingView({@required this.child, this.loadingView});

  void loadingComplete() {
    _innerView.loadingComplete();
  }

  @override
  State<StatefulWidget> createState() {
    if (_innerView == null) {
      _innerView = _LoadingView(child, loadingView);
    }
    return _innerView;
  }
}

class _LoadingView extends State<LoadingView> {
  Widget child;
  Widget loadingView;

  _LoadingView(this.child, this.loadingView);

  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    Widget showLoadingView =
        loadingView != null ? loadingView : LoadingHelp.loadingView;
    return Container(
      child: Center(
        child: _isLoading
            ? (showLoadingView == null ? Container() : showLoadingView)
            : RevealAnimationView(child: child,positionType: RevealPositionConfig.CENTER,),
      ),
    );
  }

  void loadingComplete() {
    setState(() {
      _isLoading = false;
    });
  }
}

class LoadingHelp {
  static Widget _loadingView = Container();

  static Widget get loadingView => _loadingView;

  static LoadingHelp initLoadingBaseView(Widget view) {
    _loadingView = view;
  }
}
