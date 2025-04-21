import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'login_screen.dart';

class TelaBoasVindas extends StatefulWidget {
  @override
  _SplashVideoScreenState createState() => _SplashVideoScreenState();
}

class _SplashVideoScreenState extends State<TelaBoasVindas> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse('assets/web/vinheta.mp4'),
      );
    } else {
      _controller = VideoPlayerController.asset('assets/web/vinheta.mp4');
    }

    _controller.initialize().then((_) {
      _controller.setLooping(false);
      _controller.play(); // ✅ Autoplay
      setState(() {});
    });

    _controller.addListener(() {
      if (_controller.value.isInitialized &&
          !_controller.value.isPlaying &&
          _controller.value.position >= _controller.value.duration) {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (context) => TelaLogin()));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _controller.value.isInitialized
              ? SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              )
              : Center(child: CircularProgressIndicator()),
    );
  }
}
