import 'package:flutter/material.dart';

class FutureBuilder<T> extends StatelessWidget {
  final Future<T>? future;
  final String messageWhenEmpty;
  final Widget Function(BuildContext, AsyncSnapshot<T>) builder;

  const FutureBuilder({
    Key? key,
    required this.future,
    required this.builder,
    required this.messageWhenEmpty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error.toString());
        } else if (snapshot.hasData) {
          if (_isDataEmpty(snapshot.data)) {
            return Center(child: Text(messageWhenEmpty));
          } else {
            return builder(context, snapshot);
          }
        } else {
          return const Text('No data available');
        }
      },
      messageWhenEmpty: '',
    );
  }

  bool _isDataEmpty(dynamic data) {
    if (data is Iterable) {
      return data.isEmpty;
    }
    return false;
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Text('Error: $error'),
    );
  }
}
