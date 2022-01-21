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

        private List<Point> _points = new List<Point>();
        private List<Point> _portals = new List<Point>();

        public List<Point> Points {
            get { return _points; }
            set { _points = value; AlignPortals(); Invalidate(); }
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

            foreach (var point in _points) {
                e.Graphics.DrawRectangle(Pens.Red, point.X - 2, point.Y - 2, 4, 4);
            }

            if (_points.Count >= 2) {
                e.Graphics.DrawLines(Pens.Black, _points.ToArray());
            }
            
            foreach (var portal in _portals) {
                e.Graphics.DrawRectangle(Pens.CornflowerBlue, portal.X - 32, portal.Y - 96, 64, 96);
            }
        }

        protected override void OnMouseMove(MouseEventArgs e) {
            if (_draggingPoint) {
                if (_lastDrag.HasValue) {
                    _points[_draggingIndex] = new Point(e.X - _offset.X, e.Y - _offset.Y);
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
                for (int i = 0; i < _points.Count; i++) {
                    var localCursor = e.Location;
                    var localPoint = new Point(_points[i].X + _offset.X, _points[i].Y + _offset.Y);
                    if (IsVicinity(localCursor, localPoint, 5)) {
                        _draggingPoint = true;
                        _draggingIndex = i;
                        break;
                    }
                }
                if (!_draggingPoint) {
                    bool addedBetween = false;
                    int mx = e.Location.X;
                    for (int i = 0; i < _points.Count; i++) {
                        if (i + 1 < _points.Count) {
                            var lpA = new Point(_points[i].X + _offset.X, _points[i].Y + _offset.Y);
                            var lpB = new Point(_points[i + 1].X + _offset.X, _points[i + 1].Y + _offset.Y);
                            if (mx >= lpA.X && mx <= lpB.X) {
                                _points.Insert(i + 1, new Point(e.X - _offset.X, e.Y - _offset.Y));
                                OnPointsChanged(new EventArgs());
                                _draggingPoint = true;
                                _draggingIndex = i + 1;
                                addedBetween = true;
                                break;
                            }
                        }
                    }

                    if (!addedBetween) {
                        _points.Add(new Point(e.X - _offset.X, e.Y - _offset.Y));
                        OnPointsChanged(new EventArgs());
                        _draggingPoint = true;
                        _draggingIndex = _points.Count - 1;
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

        private void deleteToolStripMenuItem_Click(object sender, EventArgs e) {
            var p = (Point)contextMenuStrip1.Tag;
            _points.Remove(p);
            OnPointsChanged(new EventArgs());
            Invalidate();
        }

        private void insertToolStripMenuItem_Click(object sender, EventArgs e) {
            var p = (Point)contextMenuStrip1.Tag;
            int i = _points.FindIndex(a => a == p);
            _points.Insert(i, new Point(p.X - 16, p.Y));
            OnPointsChanged(new EventArgs());
            Invalidate();
        }

        private void noiseToolStripMenuItem_Click(object sender, EventArgs e) {
            var p = (Point)contextMenuStrip1.Tag;
            int i = _points.FindIndex(a => a == p);
            Random r = new Random();

            for (int j = Math.Min(_points.Count - 1, i + 5); j >= Math.Max(0, i - 5); j--) {
                var pp = _points[j];
                pp.X = (int)(pp.X + r.Next(10) - r.Next(10) + Math.Cos((j + r.Next(10) / 1000.0f) / 1000.0f));
                pp.Y = (int)(pp.Y + r.Next(10) - r.Next(10) + Math.Sin((j + r.Next(10) / 1000.0f) / 1000.0f));
                _points[j] = pp;
            }

            OnPointsChanged(new EventArgs());
            Invalidate();
        }

        private void flattenToolStripMenuItem_Click(object sender, EventArgs e) {
            var p = (Point)contextMenuStrip1.Tag;
            int i = _points.FindIndex(a => a == p);
            
            for (int j = Math.Min(_points.Count - 1, i + 1); j >= Math.Max(0, i - 1); j--) {
                var pp = _points[j];
                pp.X = pp.X;
                pp.Y = p.Y;
                _points[j] = pp;
            }

            OnPointsChanged(new EventArgs());
            Invalidate();
        }

        private void tessellateToolStripMenuItem_Click(object sender, EventArgs e) {
            var p = (Point)contextMenuStrip1.Tag;
            int i = _points.FindIndex(a => a == p);

            if (i - 1 >= 0) {
                var lastPoint = _points[i - 1];
                _points.Insert(i, new Point((lastPoint.X + p.X) / 2, (lastPoint.Y + p.Y) / 2));
                i++;
            }
            if (i + 1 < _points.Count) {
                var nextPoint = _points[i + 1];
                _points.Insert(i + 1, new Point((nextPoint.X + p.X) / 2, (nextPoint.Y + p.Y) / 2));
            }
            OnPointsChanged(new EventArgs());
            Invalidate();
        }

        private void stairsLeftToolStripMenuItem_Click(object sender, EventArgs e) {
            var p = (Point)contextMenuStrip1.Tag;
            int i = _points.FindIndex(a => a == p);
            _points.Remove(p);
            _points.Insert(i, new Point(p.X, p.Y));
            _points.Insert(i+1, new Point(p.X, p.Y - 4));
            _points.Insert(i + 2, new Point(p.X + 8, p.Y - 4));

            // REALLY HACKY PLS REMOVE
            var count = sender as int?;
            if (count == null) {
                contextMenuStrip1.Tag = _points[i + 2];
                // OH GOD
                stairsLeftToolStripMenuItem_Click(5, e);
            } else {
                // OOOOOOOOH GOD WHY
                if (count > 0) {
                    contextMenuStrip1.Tag = _points[i + 2];
                    stairsLeftToolStripMenuItem_Click(count - 1, e);
                }
            }
            // i am sorry for this

            OnPointsChanged(new EventArgs());
            Invalidate();
        }

        private void stairsLeftToolStripMenuItem1_Click(object sender, EventArgs e) {
            var p = (Point)contextMenuStrip1.Tag;
            int i = _points.FindIndex(a => a == p);
            _points.Remove(p);
            _points.Insert(i, new Point(p.X, p.Y));
            _points.Insert(i, new Point(p.X, p.Y - 4));
            _points.Insert(i, new Point(p.X - 8, p.Y - 4));

            // REALLY HACKY PLS REMOVE
            var count = sender as int?;
            if (count == null) {
                contextMenuStrip1.Tag = _points[i];
                // OH GOD
                stairsLeftToolStripMenuItem1_Click(5, e);
            } else {
                // OOOOOOOOH GOD WHY
                if (count > 0) {
                    contextMenuStrip1.Tag = _points[i];
                    stairsLeftToolStripMenuItem1_Click(count - 1, e);
                }
            }
            // i am sorry for this

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
            for (int i = 0; i < _points.Count - 1; i++) {
                var p1 = _points[i];
                var p2 = _points[i + 1];
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

        private void stairsDownRightToolStripMenuItem_Click(object sender, EventArgs e) {
            var p = (Point)contextMenuStrip1.Tag;
            int i = _points.FindIndex(a => a == p);
            _points.Remove(p);
            _points.Insert(i, new Point(p.X, p.Y));
            _points.Insert(i + 1, new Point(p.X, p.Y + 4));
            _points.Insert(i + 2, new Point(p.X + 8, p.Y + 4));

            // REALLY HACKY PLS REMOVE
            var count = sender as int?;
            if (count == null) {
                contextMenuStrip1.Tag = _points[i + 2];
                // OH GOD
                stairsDownRightToolStripMenuItem_Click(5, e);
            } else {
                // OOOOOOOOH GOD WHY
                if (count > 0) {
                    contextMenuStrip1.Tag = _points[i + 2];
                    stairsDownRightToolStripMenuItem_Click(count - 1, e);
                }
            }
            // i am sorry for this

            OnPointsChanged(new EventArgs());
            Invalidate();
        }

        private void stairsDownLeftToolStripMenuItem_Click(object sender, EventArgs e) {
            var p = (Point)contextMenuStrip1.Tag;
            int i = _points.FindIndex(a => a == p);
            _points.Remove(p);
            _points.Insert(i, new Point(p.X, p.Y));
            _points.Insert(i, new Point(p.X, p.Y + 4));
            _points.Insert(i, new Point(p.X - 8, p.Y + 4));

            // REALLY HACKY PLS REMOVE
            var count = sender as int?;
            if (count == null) {
                contextMenuStrip1.Tag = _points[i];
                // OH GOD
                stairsDownLeftToolStripMenuItem_Click(5, e);
            } else {
                // OOOOOOOOH GOD WHY
                if (count > 0) {
                    contextMenuStrip1.Tag = _points[i];
                    stairsDownLeftToolStripMenuItem_Click(count - 1, e);
                }
            }
            // i am sorry for this

            OnPointsChanged(new EventArgs());
            Invalidate();
        }

        private void locationToolStripMenuItem_Click(object sender, EventArgs e) {
            var p = (Point)contextMenuStrip1.Tag;
            Clipboard.SetText(p.X.ToString());
        }
    }
}
