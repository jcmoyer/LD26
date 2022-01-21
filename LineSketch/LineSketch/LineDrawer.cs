using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace LineSketch {
    public partial class LineDrawer : UserControl {
        public event EventHandler PointsChanged;

        private Point _offset = new Point(0, 0);

        private Point? _lastDrag;

        private bool _draggingPoint;
        private int _draggingIndex;

        private bool _isRightDown;

        private PointList _points = new PointList();
        private List<Point> _portals = new List<Point>();

        Random rng = new Random();

        public List<Point> Points {
            get { return _points.Points; }
            set { _points.Points = value; AlignPortals(); Invalidate(); }
        }

        public List<Point> Portals {
            get { return _portals; }
            set { _portals = value; AlignPortals(); Invalidate(); }
        }

        public LineDrawer() {
            InitializeComponent();
        }

        protected override void OnPaint(PaintEventArgs e) {
            e.Graphics.TranslateTransform(_offset.X, _offset.Y);

            foreach (var point in Points) {
                e.Graphics.DrawRectangle(Pens.Red, point.X - 2, point.Y - 2, 4, 4);
            }

            if (Points.Count >= 2) {
                e.Graphics.DrawLines(Pens.Black, Points.ToArray());
            }

            foreach (var portal in _portals) {
                e.Graphics.DrawRectangle(Pens.CornflowerBlue, portal.X - 32, portal.Y - 96, 64, 96);
            }
        }

        protected override void OnMouseMove(MouseEventArgs e) {
            if (_draggingPoint) {
                if (_lastDrag.HasValue) {
                    Points[_draggingIndex] = new Point(e.X - _offset.X, e.Y - _offset.Y);
                    _lastDrag = new Point(e.X, e.Y);
                    Invalidate();
                    OnPointsChanged(new EventArgs());
                } else {
                    _lastDrag = new Point(e.X, e.Y);
                }
            }

            if (_isRightDown) {
                if (_lastDrag.HasValue) {
                    _offset.Offset(e.X - _lastDrag.Value.X, e.Y - _lastDrag.Value.Y);
                    _lastDrag = new Point(e.X, e.Y);
                    Invalidate();
                } else {
                    _lastDrag = new Point(e.X, e.Y);
                }
            }
        }

        protected override void OnMouseDown(MouseEventArgs e) {
            if (e.Button == MouseButtons.Left) {
                for (int i = 0; i < Points.Count; i++) {
                    var localCursor = e.Location;
                    var localPoint = new Point(Points[i].X + _offset.X, Points[i].Y + _offset.Y);
                    if (IsVicinity(localCursor, localPoint, 5)) {
                        _draggingPoint = true;
                        _draggingIndex = i;
                        break;
                    }
                }
                if (!_draggingPoint) {
                    bool addedBetween = false;
                    int mx = e.Location.X;
                    for (int i = 0; i < Points.Count; i++) {
                        if (i + 1 < Points.Count) {
                            var lpA = new Point(Points[i].X + _offset.X, Points[i].Y + _offset.Y);
                            var lpB = new Point(Points[i + 1].X + _offset.X, Points[i + 1].Y + _offset.Y);
                            if (mx >= lpA.X && mx <= lpB.X) {
                                Points.Insert(i + 1, new Point(e.X - _offset.X, e.Y - _offset.Y));
                                OnPointsChanged(new EventArgs());
                                _draggingPoint = true;
                                _draggingIndex = i + 1;
                                addedBetween = true;
                                break;
                            }
                        }
                    }

                    if (!addedBetween) {
                        Points.Add(new Point(e.X - _offset.X, e.Y - _offset.Y));
                        OnPointsChanged(new EventArgs());
                        _draggingPoint = true;
                        _draggingIndex = Points.Count - 1;
                    }
                    Invalidate();
                }
            }
            if (e.Button == MouseButtons.Right) {
                bool showingContextMenu = false;
                foreach (var p in Points) {
                    var localCursor = e.Location;
                    var localPoint = new Point(p.X + _offset.X, p.Y + _offset.Y);
                    if (IsVicinity(localCursor, localPoint, 5)) {
                        contextMenuStrip1.Tag = p;
                        locationToolStripMenuItem.Text = p.ToString();
                        contextMenuStrip1.Show(this, e.Location);
                        showingContextMenu = true;
                        break;
                    }
                }
                if (!showingContextMenu) {
                    _lastDrag = null;
                    _isRightDown = true;
                }
            }
        }

        protected override void OnMouseUp(MouseEventArgs e) {
            if (e.Button == MouseButtons.Left) {
                _draggingPoint = false;
            }
            if (e.Button == MouseButtons.Right) {
                _isRightDown = false;
            }
        }

        private bool IsVicinity(Point a, Point b, double r) {
            var x = b.X - a.X;
            var y = b.Y - a.Y;
            var d = Math.Sqrt(x * x + y * y);
            return d < r;
        }

        protected void OnPointsChanged(EventArgs e) {
            AlignPortals();
            var handler = PointsChanged;
            if (handler != null) {
                handler(this, e);
            }
        }

        private void deleteClick(object sender, EventArgs e) {
            var p = (Point)contextMenuStrip1.Tag;
            int i = Points.FindIndex(a => a == p);
            _points.RemoveAt(i);
            OnPointsChanged(new EventArgs());
            Invalidate();
        }

        private void insertLeftClick(object sender, EventArgs e) {
            var p = (Point)contextMenuStrip1.Tag;
            int i = Points.FindIndex(a => a == p);
            _points.InsertLeft(i);
            OnPointsChanged(new EventArgs());
            Invalidate();
        }

        private void noiseClick(object sender, EventArgs e) {
            var p = (Point)contextMenuStrip1.Tag;
            int i = Points.FindIndex(a => a == p);

            _points.Noise(i, rng);

            OnPointsChanged(new EventArgs());
            Invalidate();
        }

        private void flattenClick(object sender, EventArgs e) {
            var p = (Point)contextMenuStrip1.Tag;
            int i = Points.FindIndex(a => a == p);

            _points.Flatten(i);

            OnPointsChanged(new EventArgs());
            Invalidate();
        }

        private void tessellateClick(object sender, EventArgs e) {
            var p = (Point)contextMenuStrip1.Tag;
            int i = Points.FindIndex(a => a == p);

            _points.Tessellate(i);

            OnPointsChanged(new EventArgs());
            Invalidate();
        }

        private void stairsUpRightClick(object sender, EventArgs e) {
            var p = (Point)contextMenuStrip1.Tag;
            int i = Points.FindIndex(a => a == p);

            _points.MakeStairs(i, new StairCreationParameters {
                Steps = 5,
                XD = XDirection.Right,
                YD = YDirection.Up,
            });

            OnPointsChanged(new EventArgs());
            Invalidate();
        }

        private void stairsUpLeftClick(object sender, EventArgs e) {
            var p = (Point)contextMenuStrip1.Tag;
            int i = Points.FindIndex(a => a == p);

            _points.MakeStairs(i, new StairCreationParameters {
                Steps = 5,
                XD = XDirection.Left,
                YD = YDirection.Up,
            });

            OnPointsChanged(new EventArgs());
            Invalidate();
        }

        private void portalHereToolStripMenuItem_Click(object sender, EventArgs e) {
            var p = (Point)contextMenuStrip1.Tag;
            _portals.Add(p);
            OnPointsChanged(new EventArgs());
            Invalidate();
        }

        private int Y(int x) {
            for (int i = 0; i < Points.Count - 1; i++) {
                var p1 = Points[i];
                var p2 = Points[i + 1];
                if (x >= p1.X && x <= p2.X) {
                    float d = (x - p1.X) / (float)(p2.X - p1.X);
                    float m = (p1.Y - p2.Y) / (float)(p1.X - p2.X);
                    float b = p1.Y + (p2.Y - p1.Y) * d;
                    return (int)(m * d + b);
                }
            }
            return 0;
        }

        private void AlignPortals() {
            for (int i = 0; i < _portals.Count; i++) {
                var p = _portals[i];
                _portals[i] = new Point(p.X, Y(p.X));
            }
        }

        private void stairsDownRightClick(object sender, EventArgs e) {
            var p = (Point)contextMenuStrip1.Tag;
            int i = Points.FindIndex(a => a == p);

            _points.MakeStairs(i, new StairCreationParameters {
                Steps = 5,
                XD = XDirection.Right,
                YD = YDirection.Down,
            });

            OnPointsChanged(new EventArgs());
            Invalidate();
        }

        private void stairsDownLeftClick(object sender, EventArgs e) {
            var p = (Point)contextMenuStrip1.Tag;
            int i = Points.FindIndex(a => a == p);

            _points.MakeStairs(i, new StairCreationParameters {
                Steps = 5,
                XD = XDirection.Left,
                YD = YDirection.Down,
            });

            OnPointsChanged(new EventArgs());
            Invalidate();
        }

        private void locationToolStripMenuItem_Click(object sender, EventArgs e) {
            var p = (Point)contextMenuStrip1.Tag;
            Clipboard.SetText(p.X.ToString());
        }
    }
}
