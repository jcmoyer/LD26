using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace LineSketch {
    public partial class Form1 : Form {
        public Form1() {
            InitializeComponent();
        }

        private void lineDrawer1_PointsChanged(object sender, EventArgs e) {
            richTextBox1.TextChanged -= richTextBox1_TextChanged;
            richTextBox1.Text = GeneratePointString() + Environment.NewLine + GeneratePortalString();
            richTextBox1.TextChanged += richTextBox1_TextChanged;
        }

        private string GeneratePointString() {
            var builder = new StringBuilder();
            builder.AppendLine("data.lines = {");
            foreach (var point in lineDrawer1.Points) {
                builder.AppendFormat("  {0}, {1},", point.X, point.Y);
                builder.AppendLine();
            }
            return builder.ToString().TrimEnd('\r', '\n', ',') + Environment.NewLine + "}";
        }

        private string GeneratePortalString() {
            var builder = new StringBuilder();
            builder.AppendLine("data.portals = {");
            foreach (var point in lineDrawer1.Portals) {
                builder.AppendFormat("  {{ x = {0}, destination = 'TODO', dx = 0 }},", point.X);
                builder.AppendLine();
            }
            return builder.ToString().TrimEnd('\r', '\n', ',') + Environment.NewLine + "}";
        }

        private List<Point> ParsePoints(string s) {
            Regex r = new Regex(@"^\s*(-?\d+),\s*(-?\d+),?$", RegexOptions.Multiline);
            List<Point> ps = new List<Point>();
            var m = r.Matches(s);

            for (int i = 0; i < m.Count; i++) {
                if (m[i].Groups.Count >= 3) {
                    int x = Int32.Parse(m[i].Groups[1].Value);
                    int y = Int32.Parse(m[i].Groups[2].Value);
                    ps.Add(new Point(x, y));
                }
            }
            return ps;
        }
        private List<Point> ParsePortals(string s) {
            Regex r = new Regex(@"x\s*=\s*(-?\d+).*$", RegexOptions.Multiline);
            List<Point> ps = new List<Point>();
            var m = r.Matches(s);

            for (int i = 0; i < m.Count; i++) {
                if (m[i].Groups.Count >= 2) {
                    int x = Int32.Parse(m[i].Groups[1].Value);
                    ps.Add(new Point(x, 0));
                }
            }
            return ps;
        }

        private void richTextBox1_TextChanged(object sender, EventArgs e) {
            try {
                lineDrawer1.Points = ParsePoints(richTextBox1.Text);
                lineDrawer1.Portals = ParsePortals(richTextBox1.Text);
            } catch {
                // intentional
            }
        }

        private void button1_Click(object sender, EventArgs e) {
            List<Point> ps = new List<Point>(lineDrawer1.Points);
            for (int i = 0; i < ps.Count; i++) {
                ps[i] = new Point(ps[i].X * 2, ps[i].Y);
            }
            lineDrawer1.Points = ps;
        }
    }
}
