using System.Drawing;

namespace LineSketch {
    class PointMath {
        public static Point Middle(Point a, Point b) {
            return new Point(
                (a.X + b.X) / 2,
                (a.Y + b.Y) / 2
            );
        }
    }
}
