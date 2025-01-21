import 'dart:math';
import 'package:flutter/material.dart';

class MovieCircularProgressBar extends StatelessWidget {
  const MovieCircularProgressBar({super.key, required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45,
      height: 45,
      child: CustomPaint(
        painter: _CircularProgressPainter(value / 10),
        child: Center(
          child: Text.rich(
              TextSpan(
                  children: [
                    TextSpan(
                      text: value.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                        text: '%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold
                        )
                    )
                  ]
              )
          ),
        ),
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  _CircularProgressPainter(this.percentage);

  final double percentage;

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 4.5; // 진행 바 두께 설정
    double radius = (size.width - strokeWidth) / 2; // 원의 반지름 계산
    Offset center = Offset(size.width / 2, size.height / 2); // 원의 중심 좌표 계산

    // 배경 원을 그리기 위한 Paint 객체 생성
    Paint backgroundPaint = Paint()
      ..color = Colors.grey.shade800 // 배경 원의 색상을 회색으로 설정
      ..style = PaintingStyle.stroke // 배경 원을 선으로만 그리도록 설정
      ..strokeWidth = strokeWidth; // 배경 원의 선 두께 설정

    // 캔버스에 배경 원을 그림
    canvas.drawCircle(center, radius, backgroundPaint);

    // 진행 바를 그리기 위한 Paint 객체 생성
    Paint progressPaint = Paint()
      ..color = const Color(0xFF21D07A)
      ..style = PaintingStyle.stroke // 진행 바를 선으로만 그리도록 설정
      ..strokeCap = StrokeCap.round // 진행 바의 끝을 둥글게 설정
      ..strokeWidth = strokeWidth; // 진행 바의 선 두께 설정

    double sweepAngle = 2 * pi * percentage; // 전체 원에서 진행 바가 차지할 각도를 계산 (0 ~ 2π)

    // 캔버스에 진행 바(호)를 그림
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius), // 그릴 호의 범위 설정
      -pi / 2, // 시작 각도를 12시 방향으로 설정 (기본 3시 방향에서 -90도 회전)
      sweepAngle, // 진행 바가 차지할 각도
      false, // 호가 원 내부를 채우지 않도록 설정
      progressPaint, // 진행 바를 그리기 위한 Paint 객체 전달
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// 진행률이 바뀔 때마다 다시 그리도록 설정
}
