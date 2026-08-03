import 'dart:math' as math;
import 'package:flutter/widgets.dart';

/// The car, as a path, and the modules hung off it.
///
/// ## Why it is drawn rather than imported
///
/// A rendered 3D car would be a folder of frames — five to fifteen megabytes
/// for one screen somebody sees once. This is a few hundred bytes of maths
/// that scales to any display, tints itself per act, and can be *drawn
/// progressively* — which is the effect the scan act depends on and which no
/// image sequence can do.
///
/// The three-quarter view is faked with a shear rather than a real projection.
/// At this size the difference is invisible, and a shear is one matrix instead
/// of a camera.
abstract class CarShape {
  /// A saloon in profile, nose to the right, normalised to a 1×1 box.
  static Path outline() {
    final path = Path()
      ..moveTo(0.06, 0.62)
      ..lineTo(0.10, 0.44)
      ..cubicTo(0.16, 0.40, 0.22, 0.39, 0.30, 0.38)
      ..cubicTo(0.36, 0.24, 0.44, 0.17, 0.55, 0.16)
      ..cubicTo(0.68, 0.15, 0.76, 0.22, 0.82, 0.36)
      ..cubicTo(0.89, 0.39, 0.94, 0.44, 0.96, 0.52)
      ..lineTo(0.97, 0.62)
      ..lineTo(0.86, 0.64)
      ..lineTo(0.24, 0.64)
      ..close();

    // The greenhouse — without it the silhouette reads as a shoe.
    path
      ..moveTo(0.34, 0.37)
      ..cubicTo(0.39, 0.26, 0.45, 0.21, 0.54, 0.20)
      ..lineTo(0.54, 0.37)
      ..close()
      ..moveTo(0.58, 0.20)
      ..cubicTo(0.66, 0.21, 0.72, 0.26, 0.77, 0.37)
      ..lineTo(0.58, 0.37)
      ..close();

    return path;
  }

  static const Offset frontWheel = Offset(0.78, 0.64);
  static const Offset rearWheel = Offset(0.26, 0.64);
  static const double wheelRadius = 0.075;

  /// Where the OBD port sits: under the dash, driver's side.
  static const Offset port = Offset(0.44, 0.44);

  /// The modules a scan actually talks to, placed where they live in the car.
  ///
  /// Positions are not decorative. Somebody who has had a car apart will read
  /// the engine module at the front and the body module in the cabin, and that
  /// tiny bit of truth is most of why this reads as a diagnosis rather than as
  /// a loading screen.
  static const List<CarModule> modules = [
    CarModule('ECU', Offset(0.80, 0.42), 'محرك'),
    CarModule('TCM', Offset(0.66, 0.52), 'ناقل حركة'),
    CarModule('ABS', Offset(0.34, 0.55), 'مكابح'),
    CarModule('SRS', Offset(0.50, 0.33), 'وسائد'),
    CarModule('BCM', Offset(0.24, 0.47), 'هيكل'),
    CarModule('EPS', Offset(0.56, 0.45), 'مقود'),
  ];

  /// The three-quarter shear, as a matrix.
  ///
  /// [lean] runs 0 (flat profile) to 1 (turned towards the viewer). Driven by
  /// scroll, it is the whole of the "3D" — and it is enough, because the eye
  /// reads perspective from the *change*, not from the geometry.
  static Matrix4 tilt(double lean) => Matrix4.identity()
    ..setEntry(3, 2, 0.0016)
    ..rotateY(-0.55 * lean)
    ..rotateX(0.20 * lean);

  /// A dashed sweep line for the scan, as a path.
  static Path sweep(Size size, double t) {
    final x = size.width * (0.06 + 0.92 * t);
    final path = Path();

    for (var y = 0.0; y < size.height; y += 14) {
      path
        ..moveTo(x, y)
        ..lineTo(x, math.min(y + 8, size.height));
    }

    return path;
  }
}

/// One control unit on the car, and what to call it.
class CarModule {
  const CarModule(this.code, this.at, this.label);

  final String code;

  /// Normalised to the same 1×1 box as [CarShape.outline].
  final Offset at;

  final String label;
}
