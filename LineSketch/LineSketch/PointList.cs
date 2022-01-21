using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LineSketch {
    enum XDirection {
        Left,
        Right,
    }

    enum YDirection {
        Up,
        Down,
    }

    struct StairCreationParameters {
        public YDirection YD;
        public XDirection XD;
        public int Steps;
    }

    class PointList {
        private List<Point> _points = new List<Point>();

        public List<Point> Points {
            get { return _points; }
            set { _points = value; }
        }

        public void MakeStairs(int where, StairCreationParameters param) {
            int y_offset = param.YD == YDirection.Up ? -4 : 4;
            int x_offset = param.XD == XDirection.Left ? -8 : 8;
            int insert_at = param.XD == XDirection.Left ? where : where + 1;
            Point base_pt = _points[where];

            List<Point> new_points = new List<Point>();
            for (int i = 0; i < param.Steps; ++i) {
                new_points.Add(new Point(base_pt.X, base_pt.Y + y_offset));
                new_points.Add(new Point(base_pt.X + x_offset, base_pt.Y + y_offset));
                // more to go? base off previous point
                if (i < param.Steps - 1) {
                    base_pt = new_points[new_points.Count - 1];
                }
            }
            if (param.XD == XDirection.Left) {
                new_points.Reverse();
            }
            _points.InsertRange(insert_at, new_points);
        }

        public void Tessellate(int where) {
            int left = where - 1;
            int right = where + 1;
            if (left >= 0) {
                _points.Insert(left, PointMath.Middle(_points[left], _points[where]));
            }
            if (right < _points.Count) {
                _points.Insert(right, PointMath.Middle(_points[right], _points[where]));
            }
        }

        public void Flatten(int where) {
            int left = where - 1;
            int right = where + 1;
            if (left >= 0) {
                _points[left] = new Point(_points[left].X, _points[where].Y);
            }
            if (right < _points.Count) {
                _points[right] = new Point(_points[right].X, _points[where].Y);
            }
        }

        public void Noise(int where, Random r) {
            for (int j = Math.Min(Points.Count - 1, where + 5); j >= Math.Max(0, where - 5); --j) {
                var pp = Points[j];
                pp.X = (int)(pp.X + r.Next(10) - r.Next(10) + Math.Cos((j + r.Next(10) / 1000.0f) / 1000.0f));
                pp.Y = (int)(pp.Y + r.Next(10) - r.Next(10) + Math.Sin((j + r.Next(10) / 1000.0f) / 1000.0f));
                Points[j] = pp;
            }
        }

        public void InsertLeft(int where) {
            var p = _points[where];
            _points.Insert(where, new Point(p.X - 16, p.Y));
        }

        public void RemoveAt(int where) {
            _points.RemoveAt(where);
        }
    }
}
